class Game < ApplicationRecord
  has_many :sessions
  has_many :users, through: :sessions
  belongs_to :owner, class_name: 'User', foreign_key: 'user_id'
  attr_accessor :state
  attr_accessor :bet
  def new_game(state = [])
    users.each { |user| state << { name: user.email, dice: roll(5) } }
    @state = state
    @bet = [0, 0]
    return @state
  end

  def roll(total = 6)
    dice = []
    total.times { dice << rand(1..6) }
    return dice
  end

  def show_all_dice()
    array = []
    state.each { |player| array << player[:dice] }
    return array
  end

  def show_your_dice(user)
    array = []
    state.each do |player|
      if player[:name] == user.email
        array << player[:dice]
      else
        mask_array = []
        player[:dice].length.times { mask_array << '*' }
        array << mask_array
      end
    end
    return array
  end

  def round_loss(user)
    player = state.find { |player| player[:name] == user.email }
    player[:dice].pop
  end

  def new_round
    @bet = [0, 0]
    state.each { |player| player[:dice] = roll(player[:dice].count) }
  end

  def raise(num, val)
    if val < 7 && (num > @bet[0] || val > @bet[1])
      @bet = [num, val]
    else
      return 'invalid!'
    end
  end
end
