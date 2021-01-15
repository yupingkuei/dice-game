class Game < ApplicationRecord
  has_many :sessions, dependent: :destroy
  has_many :users, through: :sessions
  belongs_to :owner, class_name: 'User', foreign_key: 'user_id'
  attr_accessor :total, :loser, :prev

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

  def previous_player
    if users[turn - @prev].dice.count > 0
      loser = users[turn - @prev]
    else
      @prev += 1
      previous_player
    end
    loser
  end

  def calculate_loser
    calculate_total
    if total[value] >= quantity
      @loser = users[turn]
    else
      @prev = 1
      previous_player
      @loser = previous_player
    end
    return @loser
  end
end
