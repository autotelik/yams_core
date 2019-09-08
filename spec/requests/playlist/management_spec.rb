# frozen_string_literal: true

require 'rails_helper'

describe 'Album', type: :request do

  include Shoulda::Matchers::ActionController

  let(:test_user) { create(:user) }

  context 'GET' do

    before do
      login_as(test_user, scope: :user)
    end

      let!(:playlist) { create(:playlist) }

    context 'Management' do
      it 'when I click the mange Playlist menu option brings up playlists and available tracks' do
        get '/playlist/management'
        expect(response).to render_template('yams_core/playlist/management/index')
        expect(response.body).to include("<h5 class=\"playlist-track\">#{playlist.name}</h5>")
      end
    end

  end

end
