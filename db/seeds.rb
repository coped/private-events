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
    all_others = User.where.not('id = ?', user.id)
    5.times do
        event = user.created_events.create!(name: Faker::Lorem.sentence,
                                            description: Faker::Lorem.paragraph,
                                            location: Faker::Address.full_address,
                                            date: Faker::Time.between(1.year.ago, 1.year.from_now))
        while event.attendees.size < 3 do
            other_user = all_others.order('RANDOM()').first
            event.invitations.create!(event_invitee: other_user, attending: true) if !event.attendees.include?(other_user)
        end
    end
end