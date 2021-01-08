class GamesController < ApplicationController
  def index
    @games = Game.all
    @new_game = Game.new
  end

  def show
    @game = Game.find(params[:id])
    @game.calculate_total
    @total = @game.total
  end

  def new; end

  def create
    @game =
      Game.create(
        owner: current_user,
        turn: 0,
        value: 2,
        quantity: 0,
        max: params[:game][:max].to_i
      )
    Session.create(game: @game, user: current_user)
    redirect_to game_path(@game)
  end

  def edit; end

  def update
    @game = Game.find(params[:id])
    # reset
    if params[:game][:action] == 'join'
      unless @game.users.include?(current_user)
        Session.create(game: @game, user: current_user)
      end
    end
    if params[:game][:action] == 'reset'
      #
      new_game
    end
    # call bluff

    #filera
    call_bluff if params[:game][:action] == 'call'
    # raise bet
    if params[:game][:action] == 'raise'
      if raised?(params[:game][:quantity], params[:game][:value])
        @game.quantity = params[:game][:quantity]
        @game.value = params[:value]
        next_turn
      end
    end

    @game.save

    render :show
  end

  def destroy
    @game = Game.find(params[:id])
    @game.destroy
    redirect_to games_path
  end

  private

  def roll(total = 5)
    dice = []
    total.times { dice << rand(1..6) }
    return dice
  end

  def raised?(num, val)
    val.to_i < 7 && (num.to_i > @game.quantity || val.to_i > @game.value)
  end

  def new_round
    @game.users.each do |user|
      user.dice = roll(user.dice.count)
      user.save
    end
    @game.quantity = 0
    @game.value = 2
    next_turn
  end

  def new_game
    @game.users.each do |user|
      user.dice = roll(5)
      user.save
    end
    @game.quantity = 0
    @game.value = 2
    @game.calculate_total
  end

  def call_bluff
    @game.calculate_total
    if @game.total[@game.value] >= @game.quantity
      loser = @game.users[@game.turn]
      loser.dice.pop
      loser.save
      # raise
      # return 'under total, safe'
    else
      loser = @game.users[@game.turn - 1]
      loser.dice.pop
      loser.save
      # @turn -= 1
      # return 'over total, bust'
    end

    new_round
  end

  def round_loss(user)
    user.dice.pop
    user.save
  end

  def next_turn
    @game.turn < (@game.rotation.count - 1) ? @game.turn += 1 : @game.turn = 0
  end

  def current_turn_user
    @game.rotation[@game.turn]
  end
end
