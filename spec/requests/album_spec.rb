# frozen_string_literal: true

require 'rails_helper'

describe 'Album', type: :request do

  include Shoulda::Matchers::ActionController

  let(:test_user) { create(:user) }

  context 'GET' do

    before do
      login_as(test_user, scope: :user)
    end

    context 'New' do
      it 'when I click the new album menu option brings up new album form' do
        get '/albums/new'
        expect(response).to render_template('yams_core/album/albums/new')
        expect(response.body).to include('Create Album')
      end

      it 'the new album form contains relevant tracks ready for drag and drop section for track assignment' do
        create(:track, :with_audio, :with_cover, user: test_user, title: 'Expect Me')
        create(:track, :with_audio, :with_cover, title: 'Wrong User')
        get '/albums/new'
        expect(response.body).to match(/<h6.*>Expect Me<\/h6>/)
        expect(response.body).to_not match(/<h6.*>Wrong User<\/h6>/)
      end
    end

    context 'Create' do

      let(:parameters) { { album: attributes_for(:album).merge(published_state: 'draft') } }


      it 'when all params valid - creates a new album' do
        expect { post '/albums', params: parameters }.to change(YamsCore::Album, :count).by(1)

        expect(controller).to set_flash[:notice].to(/successfully created/)
        expect(response).to redirect_to assigns(:album)
      end

      it 'after create displays new album with drag and drop section for track assignment' do
        post '/albums', params: parameters, xhr: true

        expect(response.body).to include('Drag and drop tracks here')
        expect(response.body).to include('target-for-track-drop-insertion-point-1')
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
