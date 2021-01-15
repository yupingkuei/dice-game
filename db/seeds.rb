# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Session.destroy_all
Game.destroy_all
User.destroy_all
player1 =
  User.create!(
    email: 'Player1@gmail.com',
    password: '123456',
    name: 'one',
    dice: [1, 2, 3, 4, 5, 6]
  )
player2 =
  User.create!(
    email: 'Player2@gmail.com',
    password: '123456',
    name: 'two',
    dice: [1, 2, 3, 4, 5, 6]
  )
player3 =
  User.create!(
    email: 'Player3@gmail.com',
    password: '123456',
    name: 'three',
    dice: [1, 2, 3, 4, 5, 6]
  )
player4 =
  User.create!(
    email: 'Player4@gmail.com',
    password: '123456',
    name: 'four',
    dice: [1, 2, 3, 4, 5, 6]
  )

game1 =
  Game.create!(
    owner: player1,
    rotation: %w[
      Player1@gmail.com
      Player2@gmail.com
      Player3@gmail.com
      Player4@gmail.com
    ],
    turn: 0,
    value: 2,
    quantity: 0
  )

Session.create!(user: player1, game: game1)
Session.create!(user: player2, game: game1)
Session.create!(user: player3, game: game1)
Session.create!(user: player4, game: game1)
