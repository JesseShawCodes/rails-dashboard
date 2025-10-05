# app/jobs/ingest_play_history_job.rb
class IngestPlayHistoryJob
  include Sidekiq::Job

  def perform(user_id)
    user = User.find(user_id)
    apple_music_service = AppleMusicService.new(user)
    plays = apple_music_service.fetch_recent_plays

    plays.each do |play|
      PlayHistory.find_or_create_by!(
        user: user,
        song: Song.find_or_create_by!(name: play[:song_name], artist: Artist.find_or_create_by!(name: play[:artist_name])),
        played_at: play[:played_at]
      )
    end
  end
end
