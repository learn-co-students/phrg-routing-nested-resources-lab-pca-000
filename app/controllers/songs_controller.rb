# frozen_string_literal: true

class SongsController < ApplicationController
  def index
    if params[:artist_id]
      index_assistant
    else
      @songs = Song.all
    end
  end

  def show
    if params[:artist_id]
      show_assistant
    else
      @song = Song.find(params[:id])
    end
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

  def song_params
    params.require(:song).permit(:title, :artist_name)
  end

  def index_assistant
    if Artist.find_by_id(params[:artist_id])
      @songs = Artist.find(params[:artist_id]).songs
    else
      flash[:alert] = "Artist not found."
      redirect_to artists_path
    end
  end

  def show_assistant
    if Song.find_by_id(params[:id])
      @song = Song.find(params[:id])
    else
      @artist = Artist.find_by_id(params[:artist_id])
      flash[:alert] = "Song not found."
      redirect_to artist_songs_path(@artist)
    end
  end
end
