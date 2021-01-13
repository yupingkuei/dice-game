class Game < ApplicationRecord
  has_many :sessions, dependent: :destroy
  has_many :users, through: :sessions
  belongs_to :owner, class_name: 'User', foreign_key: 'user_id'
  attr_accessor :total, :loser, :round_end

  # def new_game(state = [])
  #   users.each { |user| state << { name: user.email, dice: roll(5) } }

  #   @state = state
  #   set_rotation
  #   new_round
  #   @turn = 0
  #   return @state
  # end

  # def roll(total = 6)
  #   dice = []
  #   total.times { dice << rand(1..6) }
  #   return dice
  # end

  # def show_all_dice()
  #   array = []
  #   state.each { |player| array << player[:dice] }
  #   return array
  # end

  # def show_your_dice(user)
  #   array = []
  #   state.each do |player|
  #     if player[:name] == user.email
  #       array << player[:dice]
  #     else
  #       mask_array = []
  #       player[:dice].length.times { mask_array << '*' }
  #       array << mask_array
  #     end
  #   end
  #   return array
  # end

  # def round_loss(user)
  #   player = state.find { |player| player[:name] == user }
  #   player[:dice].pop
  #   new_round
  # end

  # def new_round
  #   @bet = [0, 0]
  #   @total = { 2 => 0, 3 => 0, 4 => 0, 5 => 0, 6 => 0 }
  #   @state.each { |player| player[:dice] = roll(player[:dice].count) }
  #   show_all_dice.each do |player|
  #     player.each do |die|
  #       if die == 1
  #         (2..6).each { |num| @total[num] += 1 }
  #       else
  #         @total[die] += 1
  #       end
  #     end
  #   end
  # end

  # def raise_bet(num, val)
  #   if val < 7 && (num > @bet[0] || val > @bet[1])
  #     @bet = [num, val]
  #     next_turn
  #   else
  #     return 'invalid!'
  #   end
  # end

  # def call_bluff()
  #   if @total[@bet[1]] >= @bet[0]
  #     round_loss(current_player)
  #     return 'under total, safe'
  #   else
  #     round_loss(previous_player)
  #     @turn -= 1
  #     return 'over total, bust'
  #   end
  # end

  # def set_rotation()
  #   @rotation = []
  #   @state.each { |player| @rotation << player[:name] }
  # end

  # def current_player
  #   @rotation[@turn]
  # end

  # def previous_player
  #   @rotation[@turn - 1]
  # end

  # def next_turn
  #   @turn < (@rotation.count - 1) ? @turn += 1 : @turn = 0
  # end

  def calculate_total
    @total = { 2 => 0, 3 => 0, 4 => 0, 5 => 0, 6 => 0 }
    users.each do |user|
      user.dice.each do |die|
        if die == 1
          @total[3] += 1
          @total[4] += 1
          @total[2] += 1
          @total[5] += 1
          @total[6] += 1
        else
          @total[die] += 1
        end
      end
    end
  end

  def calculate_loser
    calculate_total
    if total[value] >= quantity
      @loser = users[turn]
    else
      @loser = users[turn - 1]
    end
  end
end
