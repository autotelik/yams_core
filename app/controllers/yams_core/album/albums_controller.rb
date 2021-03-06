# frozen_string_literal: true

module YamsCore

  class Album::AlbumsController < ApplicationController

    before_action :authenticate_user!

    before_action :set_album, only: %i[show edit destroy]

    before_action :set_presenter, only: %i[edit update]

    include YamsCore::FetchTracks

    helper YamsAudioEngine::PlayerHelper

    def index

      # Technique to generate same list for a certain time - driven by the cookie expire time
      # seed_val = Track.connection.quote(cookies[:rand_seed])
      seed_val = rand
      Album.connection.execute("select setseed(#{seed_val})")
      @albums = Album.includes(cover: { image_attachment: :blob } ).eager_load(:tracks, :user).published.order('random()').page(params[:page]).per(30)

      populate_track_presenters(@albums.first)

      @yams_audio_json = @tracks.present? ? AudioEngineJsonBuilder.call(@tracks, current_user) : ""
    end


    def show
      populate_track_presenters(@album)

      @yams_audio_json = AudioEngineJsonBuilder.call(@tracks, current_user)

      respond_to do |format|
        format.html {}
        format.js {}
        format.json do
          render json: @yams_audio_json
        end
      end
    end

    # GET /albums/new
    def new
      @album = Album.new(user: current_user)

      @tracks = Track.includes(cover: { image_attachment: :blob } ).for_user(current_user)
    end

    # GET /albums/1/edit
    def edit
      @tracks = Track.includes(cover: { image_attachment: :blob } ).for_user(current_user)
    end

    # POST /albums
    # POST /albums.json
    def create
      album = Album.new(album_params).tap { |a| a.user = current_user }

      @album = AlbumPresenter.new(album, view_context)

      respond_to do |format|
        if album.save
          format.html { redirect_to album, notice: 'Album was successfully created.' }
          format.json { render :show, status: :created, location: album }
          format.js   { flash.now[:notice] = 'Album was successfully created.' }
        else
          format.html { render :new }
          format.json { render json: album.errors, status: :unprocessable_entity }
          format.js   { flash.now[:error] = album.errors.full_messages if album.errors.any? }
        end
      end
    end

    # PATCH/PUT /albums/1
    # PATCH/PUT /albums/1.json
    def update
      respond_to do |format|
        if @album.update(album_params)
          format.html { redirect_to edit_album_path(@album), notice: 'Album was successfully updated.' }
          format.json { render :show, status: :ok, location: @album }
        else
          format.html { render :edit }
          format.json { render json: @album.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /albums/1
    # DELETE /albums/1.json
    def destroy
      @album.destroy
      respond_to do |format|
        format.html { redirect_to albums_url, notice: 'Album was successfully removed.' }
        format.json { head :no_content }
        format.js   { flash.now[:notice] = 'Album was successfully removed.' }
      end
    end

    private

    def set_presenter
      @album = AlbumPresenter.new(Album.find(params[:id]), view_context)
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_album
      @album = Album.find(params[:id])

      @album.build_cover unless @album.nil? || @album.cover.present?
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def album_params
      params.require(:album).permit(:title, :description, :published_state, :user_id, tag_list: [], cover_attributes: %i[id image])
    end

    def populate_track_presenters(album)
      @tracks = album ? to_presenters(album.tracks_for_player) : []
    end

  end
end
