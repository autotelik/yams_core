# frozen_string_literal: true
module YamsCore

  class Track::TracksController < ApplicationController

    before_action :set_track,     only: %i[destroy]
    before_action :set_presenter, only: %i[edit update]

    helper YamsAudio::PlayerHelper


    def show
      @track = YamsAudio::TrackPresenter.new(view: view_context, track: YamsCore::Track.for_free.find(params[:id]))

      @list_item_id = params[:list_item_id]

      respond_to do |format|
        format.turbo_stream
        format.html { render :show }

        format.json { 
          render json: { partial: render_to_string(:show, formats: :html, layout: false) }
        }
      end
    end

    def new
      track = Track.new.tap do |t|
        t.availables.build
        t.build_cover
      end

      @track = YamsAudio::TrackPresenter.new(track: track, view: view_context)
    end

    # GET /tracks/1/edit
    def edit
      @track.availables.build if @track.availables.blank?
    end

    # TODO: forms are AJAX by default we should implement error handling etc and then we can remove from form 'local: true'
    def create
      @track = Track.create(track_params.merge(user: current_user))

      @track.audio.attach(track_params[:audio])

      respond_to do |format|
        if @track.save
          available_for_params[:availables].keys.each { |mode| @track.make_available_for(mode) } if available_for_params[:availables].present?

          format.html { redirect_to @track, notice: 'Track was successfully created.' }
          format.json { render :show, status: :created, location: @track }
        else
          format.html do
            # TOFIX - this is currently an issue - perhaps with turbolinks - client URL ends up on the INDEX page, so if they do a refresh we
            @track = YamsAudio::TrackPresenter.new(track: @track, view: view_context)
            render :new, notice: 'Track upload failed.'
          end
          format.json { render json: @track.errors, status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /tracks/1
    # PATCH/PUT /tracks/1.json
    def update
      respond_to do |format|
        if update_track

          #Searchkick::ProcessQueueJob.perform_later(class_name: "YamsCore::Track")

          format.html { redirect_to yams_core.edit_track_path(@track), notice: 'Track was successfully updated.' }
          format.json { render :show, status: :ok, location: @track }
        else
          format.html { render :edit }
          format.json { render json: @track.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /tracks/1
    # DELETE /tracks/1.json
    def destroy
      @track.destroy
      respond_to do |format|
        format.html { redirect_to yams_core.tracks_url, notice: 'Track was successfully removed.' }
        format.json { head :no_content }
        format.js   { render :destroy, notice: 'Track was successfully removed.' }
      end
    end

    private

    def update_track
      ActiveRecord::Base.transaction do
        raise ActiveRecord::Rollback unless @track.update(track_params)

        # params contains only those selected, so first destroy the existing set
        #
        selected = available_for_params[:availables].keys

        #TODO: this will probably be mode dependent e.g setting on radio mode, will not necessarily have price/ccy amount or price will be zero
        #
        YamsCore::Available.modes.keys.each do |m|

          meta_data = {
              price: available_for_params.dig(m, :price) || 0,
              ccy:   available_for_params.dig(m, :ccy)   || YamsCore::Setting.default_ccy
          }

          if selected.include?(m)
            @track.make_available_for(m, meta_data: meta_data)
          else
            @track.remove_available_for(m)
          end
        end
      end

      true
    end

    def set_presenter
      @track = TrackPresenter.new(Track.find(params[:id]), view_context)
    end

    def set_track
      @track = Track.find(params[:id])
    end

    def track_params
      params.require(:track).permit(:album, :audio, :description, :license_id, :release_year, :release_month, :release_day, :title, :user_id, tag_list: [], cover_attributes: %i[id image])
    end

    def available_for_params
      params.permit(:album, availables: YamsCore::Available.modes.keys)
    end

  end
end
