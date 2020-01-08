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

users = User.all
count = User.count

User.all.each do |user|
    5.times do
        event = user.created_events.create!(date: Faker::Time.between(2.months.ago, 2.months.from_now), description: Faker::Lorem.sentence)
        3.times do
            EventAttending.create!(attended_event: event, event_attendee: users[rand(count)])
        end
    end
end