class Game < ApplicationRecord
  has_many :sessions
  has_many :users, through: :sessions
  belongs_to :owner, class_name: 'User', foreign_key: 'user_id'

  def new_game(state = {})
    count = 1
    users.each do |user|
      state[:"player#{count}"] = [1, 1, 1, 1, 1]
      count += 1
    end
    return state
    raise
  end

  # def show_users()
  #   users.each { |user| user.email }
  # end
end
