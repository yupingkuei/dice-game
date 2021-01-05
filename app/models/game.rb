class Game < ApplicationRecord
  has_many :sessions
  has_many :users, through: :sessions
  belongs_to :owner, class_name: 'User', foreign_key: 'user_id'
end
