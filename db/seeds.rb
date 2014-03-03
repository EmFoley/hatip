require 'faker'

urls = [
        "http://youtu.be/hXlzci1rKNM",
        "http://youtu.be/puSkP3uym5k",
        "http://youtu.be/YPYGeELPpno",
        "http://youtu.be/2IH8tNQAzSs",
        "http://youtu.be/ub26kLEfphw",
        "https://www.youtube.com/watch?v=uXMuWi0dUBc",
        "https://www.youtube.com/watch?v=-Ow8Gut-4XY",
        "https://www.youtube.com/watch?v=wphB0fq4PlA",
        "https://www.youtube.com/watch?v=uue6oJ_jDns",
        "https://www.youtube.com/watch?v=JlfsXd62Qss",
        "https://www.youtube.com/watch?v=szeq1M0_7PQ",
        "https://www.youtube.com/watch?v=rLGpdkYEwrw"
      ]

30.times do
  User.create(
    email: Faker::Internet.email,
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    email: Faker::Internet.email,
    password: "password",
    password_confirmation: "password",
    stage_name: Faker::Name.first_name,
    twitter_handle: Faker::Lorem.word,
    verified: false,
    tagline: Faker::Lorem.sentence,
    city: Faker::Address.city,
    state: Faker::Address.state,
    country: Faker::Address.country,
    category: "acrobatic",
    story: Faker::Lorem.paragraph,
    featured_youtube_url: urls.sample
    )
end

User.all.each do |user|
  4.times do
    user.posts.create(
      title: Faker::Lorem.words(3).join(' '),
      youtube_url: urls.sample,
      description: Faker::Lorem.sentence,
      hype: rand(1..100)
      )
  end
end
