class PlayHistory < ApplicationRecord
  belongs_to :song
  belongs_to :user

  has_one :artist, through: :song

  after_create_commit -> {
    broadcast_prepend_later_to(
      "dashboard_#{user_id}_plays",
      target: "recent_plays",
      partial: "dashboard/play_history",
      locals: { play: self }
    )
  }
end
