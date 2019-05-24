# frozen_string_literal: true

class SongsController < ApplicationController
  def index
    artist = Artist.find_by(id: params[:artist_id])
    @songs = Song.filter_by(artists: artist)

    artist_not_found if params[:artist_id].present? && artist.blank?
  end

  def show
    @song = find_song_for_show

    song_not_found if could_not_find_artist || @song.blank?
  end

  def new
    @song = Song.new
  end

  def create
    @song = Song.new(song_params)

    if @song.save
      redirect_to @song
    else
      render :new
    end
  end

  def edit
    @song = Song.find(params[:id])
  end

  def update
    @song = Song.find(params[:id])

    @song.update(song_params)

    if @song.save
      redirect_to @song
    else
      render :edit
    end
  end

  def destroy
    @song = Song.find(params[:id])
    @song.destroy
    flash[:notice] = "Song deleted."
    redirect_to songs_path
  end

private

  def could_not_find_artist
    artist = Artist.find_by(id: params[:artist_id])
    params[:artist_id].present? && artist.blank?
  end

  def find_song_for_show
    artist = Artist.find_by(id: params[:artist_id])
    if artist.present?
      Song.find_by(artist: artist, id: params[:id])
    else
      Song.find_by(id: params[:id])
    end
  end

  def artist_not_found
    redirect_to artists_path, flash: { alert: "Artist not found." }
  end

  def song_not_found
    redirect_to artist_songs_path(params[:artist_id]),
                flash: { alert: "Song not found." }
  end

  def song_params
    params.require(:song).permit(:title, :artist_name)
  end
end
