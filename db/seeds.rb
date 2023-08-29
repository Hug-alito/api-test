# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

10.times do
  User.create(
    email: Faker::Internet.email,
    password: '123456&'
  )
end

users = User.all  # Collect all users created above

30.times do
  title = Faker::Lorem.sentence
  content = Faker::Lorem.paragraphs(number: rand(3..6)).join("\n\n")
  author = Faker::Name.name
  published_at = Faker::Time.between(from: 1.year.ago, to: Time.current)

  Article.create!(
    title: title,
    content: content,
    user: users.sample  # Assign a random user to the article
  )
end
