class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    # Fetch Current Users Play History
    @recent_plays = current_user.play_histories.includes(:song, song: :artist).order(played_at: :desc).limit(20)

    # Count plays per artist
    @artist_counts = @recent_plays.group_by { |play| play.song.artist.name }
                                  .transform_values(&:count)
                                  .sort_by { |_artist, count | -count }
                                  .to_h
    
  end
end
