# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create!(username: "example_user")

15.times do
    User.create!(username: Faker::Internet.user_name)
end

User.all.each do |user|
    5.times do
        user.created_events.create!(description: Faker::Lorem.sentence)
    end
end