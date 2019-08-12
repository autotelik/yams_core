# frozen_string_literal: true

require 'rails_helper'

describe 'Artist', type: :request do

  include Shoulda::Matchers::ActionController

  let(:me)        { create(:user) }

  context 'GET' do
    context 'show' do

      before do
        login_as(me, scope: :user)

        allow_any_instance_of(ApplicationController).to receive(:current_user) { me }
      end

      before do
        create(:default_cover, kind: :artist)
      end

      let!(:tracks) { create_list(:track, 2, :with_audio, :with_cover, user: me) }

      it 'shows details of the artist when I click an artist link' do
        get yams_core.artist_path(me)

        expect(response).to render_template('yams_core/artists/show')
        expect(response.body).to include(me.name)
        expect(assigns(:tracks).size).to eq 2
        expect(assigns(:tracks).first).to be_a YamsCore::TrackPresenter
      end
    end
  end
end
