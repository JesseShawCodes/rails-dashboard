require "faker"

NUM_USERS = 5
NUM_ARTISTS = 10
SONGS_PER_ARTIST = 5
PLAYS_PER_USER = 20

puts "Seeding users..."

users = NUM_USERS.times.map do
  User.create!(
    email: Faker::Internet.unique.email,
    name: Faker::Name.name,
    password: "password123",
    password_confirmation: "password123",
    music_user_token: Faker::Alphanumeric.alphanumeric(number: 32)
  )
end

puts "Created #{users.count} users."

puts "Seeding artists and songs..."

artists = NUM_ARTISTS.times.map do
  Artist.create!(
    name: Faker::Music.band
  )
end

songs = artists.flat_map do |artist|
  SONGS_PER_ARTIST.times.map do
    Song.create!(
      name: Faker::Music::RockBand.song,
      artist: artist,
      apple_id: Faker::Alphanumeric.alphanumeric(number: 12)
    )
  end
end

puts "Created #{artists.count} artists and #{songs.count} songs."

puts "Seeding play history..."

users.each do |user|
  PLAYS_PER_USER.times do
    song = songs.sample
    PlayHistory.create!(
      user: user,
      song: song,
      played_at: Faker::Time.backward(days: 14)
    )
  end
end

puts "Seeding complete! Total play history records: #{PlayHistory.count}"
