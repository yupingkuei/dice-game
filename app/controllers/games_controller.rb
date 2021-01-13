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

    # -----------------join game----------------------
    if params[:game][:action] == 'join'
      unless @game.users.include?(current_user)
        Session.create(game: @game, user: current_user)
      end
    end
    # ------------------reset game----------------------
    if params[:game][:action] == 'reset'
      #
      new_game
    end
    # -------------------call bluff---------------------
    call_bluff if params[:game][:action] == 'call'
    # --------------------raise bet--------------------------
    if params[:game][:action] == 'raise'
      if raised?(params[:game][:quantity], params[:value])
        @game.quantity = params[:game][:quantity]
        @game.value = params[:value]
        next_turn
      end
    end
    @game.save
    GameChannel.broadcast_to(
      @game,
      render_to_string(partial: 'current_bet', locals: { game: @game })
    )
    @game.users.each do |user|
      GameChannel.broadcast_to(
        @game,
        render_to_string(partial: 'player_dice', locals: { user: user })
      )
    end
    # if current_user.email == @game.users[@game.turn].email
    #   GameChannel.broadcast_to(
    #     @game,
    #     render_to_string(partial: 'action', locals: { game: @game })
    #   )
    # else
    GameChannel.broadcast_to(
      @game,
      render_to_string(partial: 'waiting', locals: { game: @game })
    )
    # end
    # render :show
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
    val.to_i < 7 &&
      (
        num.to_i > @game.quantity ||
          (val.to_i > @game.value && num.to_i >= @game.quantity)
      )
  end

  def new_round
    @game.users.each do |user|
      user.dice = roll(user.dice.count)
      user.save
    end
    @game.quantity = 0
    @game.value = 2
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
    @game.calculate_loser
    # --------alert here--------------
    @game.round_end = 'true'
    GameChannel.broadcast_to(
      @game,
      render_to_string(partial: 'game_result', locals: { game: @game })
    )
    @game.round_end = 'false'
    sleep(5)
    # if @game.total[@game.value] >= @game.quantity
    #   loser = @game.users[@game.turn]
    #   loser.dice.pop
    #   loser.save
    # else
    #   loser = @game.users[@game.turn - 1]
    #   loser.dice.pop
    #   loser.save
    # end

    @game.loser.dice.pop
    @game.loser.save
    new_round
    next_turn if @game.users[@game.turn].dice.count < 1
  end

  def round_loss(user)
    user.dice.pop
    user.save
  end

  def next_turn
    # rotation = @game.users.select { |user| user.dice.count > 0 }
    if @game.turn < (@game.users.count - 1)
      @game.turn += 1
    else
      @game.turn = 0
    end
    next_turn if @game.users[@game.turn].dice.count < 1
  end

  def current_turn_user
    @game.users[@game.turn]
  end
end
