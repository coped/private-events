# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create!(username: "example_user")

25.times do
    User.create!(username: Faker::Internet.user_name)
end

User.all.each do |user|
    all_others = User.where.not('id = ?', user.id)
    5.times do
        date = Faker::Time.between(1.year.ago, 1.year.from_now)
        event = user.created_events.create!(name: Faker::Lorem.sentence,
                                            description: Faker::Lorem.paragraph(20),
                                            location: Faker::Address.full_address,
                                            date: date)
        puts "=====#{event.name}====="
        all_others.each do |other_user|
            random_created_at = (date > Time.now ? Faker::Time.between(2.months.ago, Time.now) : Faker::Time.between(date - 5.months, date))
            random_attending = [true, false, nil].sample
            event.invitations.create!(event_invitee: other_user,
                                      attending: random_attending,
                                      created_at: random_created_at)
        end
    end
end