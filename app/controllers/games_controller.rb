class GamesController < ApplicationController
  def index
    @games = Game.all
    @new_game = Game.new
  end

  def show
    @game = Game.find(params[:id])
    respond_to do |format|
      format.html
      format.json { render json: { game: @game } }
    end
    @game.calculate_total
    @total = @game.total
  end

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

  def update
    @game = Game.find(params[:id])
    join_game if params[:game][:action] == 'join'
    new_game if params[:game][:action] == 'reset'
    call_bluff if params[:game][:action] == 'call'
    raise_bet if params[:game][:action] == 'raise'
    start_next if params[:game][:action] == 'next'
  end

  def destroy
    @game = Game.find(params[:id])
    @game.destroy
    redirect_to games_path
  end

  private

  # ----------------------------raise bet method---------------------
  def raise_bet
    if raised?(params[:game][:quantity], params[:game][:value])
      @game.quantity = params[:game][:quantity]
      @game.value = params[:game][:value]
      next_turn
      refresh_dom
    end
  end

  #----------------------------next turn method--------------------
  def next_turn
    if @game.turn < (@game.users.count - 1)
      @game.turn += 1
    else
      @game.turn = 0
    end
    next_turn if @game.users[@game.turn].dice.count < 1
    @game.save
  end

  # ------------------------new round method-----------------------
  def new_round
    @game.users.each do |user|
      user.dice = roll(user.dice.count)
      user.save
    end
    @game.quantity = 0
    @game.value = 2
    @game.save
  end

  # ------------------------new game method-----------------------
  def new_game
    @game.users.each do |user|
      user.dice = roll(5)
      user.save
    end
    @game.quantity = 0
    @game.value = 2
    @game.calculate_total
    refresh_dom
  end

  # ------------------------call bluff method--------------------
  def call_bluff
    @game.calculate_total
    @game.calculate_loser
    render_game('game_result')
    @game.loser.dice.pop
    @game.loser.save
    @game.turn = @game.users.index(@game.loser)
    new_round

    next_turn if @game.users[@game.turn].dice.count < 1
  end

  def start_next
    if @game.users.select { |user| user.dice.count > 0 }.count < 2
      render_game('gameover')
    else
      refresh_dom
    end
  end

  def roll(total = 5)
    dice = []
    total.times { dice << rand(1..6) }
    return dice
  end

  def raised?(num, val)
    val.to_i < 7 && num.to_i > 0 &&
      (
        num.to_i > @game.quantity ||
          (val.to_i > @game.value && num.to_i >= @game.quantity)
      )
  end

  def round_loss(user)
    user.dice.pop
    user.save
  end

  def current_turn_user
    @game.users[@game.turn]
  end

  def join_game
    unless @game.users.include?(current_user)
      Session.create(game: @game, user: current_user)
    end
    refresh_dom
  end

  # -----------------------------channel methods---------------------------
  def render_dice
    @game.users.each do |user|
      GameChannel.broadcast_to(
        @game,
        render_to_string(partial: 'player_dice', locals: { user: user })
      )
    end
  end
  def render_waiting
    GameChannel.broadcast_to(
      @game,
      render_to_string(partial: 'waiting', locals: { user: current_user })
    )
  end
  def render_game(page)
    GameChannel.broadcast_to(
      @game,
      render_to_string(partial: page, locals: { game: @game })
    )
  end
  def refresh_dom
    @game.save
    render_game('current_bet')
    render_dice
    render_waiting
    render_game('action')
  end
end
