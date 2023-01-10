# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# users = [
#     {:username => 'team_cluck_admin@gmail.com', :password => 'team_cluck_12345!'}
# ]

# users.each do |user|
#     User.create!(user)
# end

User.create(email: 'yourdummycluck@gmail.com', password: 'abc_123!')
User.where(confirmed_at: nil).update_all(confirmed_at: Time.now)
