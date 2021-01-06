class Game < ApplicationRecord
  has_many :sessions
  has_many :users, through: :sessions
  belongs_to :owner, class_name: 'User', foreign_key: 'user_id'
  attr_accessor :state
  def new_game(state = [])
    @test = 'test'
    count = 1
    users.each do |user|
      state << { name: user.email, dice: roll(5) }
      count += 1
    end
    @state = state
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
    # player = state.find { |key, hash| hash['name'] == "#{user.email}" }
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
    # player = state.find { |key, hash| hash['name'] == "#{user.email}" }
    return array
  end

  def round_loss(user)
    player = state.find { |player| player[:name] == user.email }
    player[:dice].pop
  end

  def new_round
    state.each { |player| player[:dice] = roll(:dice.count) }
  end
end
