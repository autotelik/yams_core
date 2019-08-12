# frozen_string_literal: true

require 'rails_helper'

describe 'Album', type: :request do

  include Shoulda::Matchers::ActionController

  let(:test_user) { create(:user) }

  context 'GET' do

    before do
      login_as(test_user, scope: :user)
    end

    context 'Create' do

      it 'when all params valid - creates a new album' do
        parameters = { album: attributes_for(:album).merge(published_state: 'draft') }

        expect { post '/albums', params: parameters }.to change(YamsCore::Album, :count).by(1)

        expect(controller).to set_flash[:notice].to(/successfully created/)
        expect(response).to redirect_to assigns(:album)
      end

    end

    context 'Edit' do

      before do
        allow_any_instance_of(ApplicationController).to receive(:current_user) { test_user }
      end

      before do
        create(:default_cover, kind: :album)
      end

      let(:album) { create(:album, user: test_user) }
      let!(:tracks) { create_list(:track, 2, :with_audio, :with_cover, user: test_user) }

      it 'shows details of the album when I click edit album link' do
        get yams_core.edit_album_path(album)

        expect(response).to render_template('yams_core/album/albums/edit')
        expect(response.body).to include(album.title)
      end
    end
  end

end
