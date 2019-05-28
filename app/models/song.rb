# frozen_string_literal: true

class Song < ActiveRecord::Base
  belongs_to :artist

  def self.filter_by(artists: nil)
    songs = all
    songs.where(artist: artists) if artists.present?
    songs
  end

  def artist_name
    try(:artist).try(:name)
  end

  def artist_name=(name)
    artist = Artist.find_or_create_by(name: name)
    self.artist = artist
  end
end
