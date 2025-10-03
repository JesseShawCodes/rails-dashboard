# app/jobs/apple_music_ingest_job.rb
class AppleMusicIngestJob
  include Sidekiq::Job

  def perform(user_id)
    user = User.find(user_id)
    client = AppleMusic::Client.new

    # Example: fetch recently played tracks
    # You need user's Music User Token saved in DB
    recent = client.fetch_recently_played(user_token: user.music_user_token)

    recent[:data].each do |track|
      artist_attrs = track.dig(:attributes, :artistName)
      song_attrs = track.dig(:attributes, :name)
      song_id = track.dig(:id)

      artist = Artist.find_or_create_by!(name: artist_attrs)
      song   = Song.find_or_create_by!(apple_id: song_id, name: song_attrs, artist: artist)

      PlayHistory.create!(
        user: user,
        song: song,
        played_at: track.dig(:attributes, :playParams, :timestamp) || Time.current
      )
    end
  rescue StandardError => e
    Rails.logger.error("AppleMusicIngestJob failed: #{e.message}")
  end
end
