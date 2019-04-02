# frozen_string_literal: true

json.tracks YamsCore::AudioEnginePlayListBuilder.call(@tracks, current_user)

if current_user
  json.user_token current_user.id
  json.client_token '0987654321' # TODO: - add tokens to devise
end

json.playlist '0'
json.page '0'
json.total_pages (@tracks.count.to_f / 30).ceil
json.track '0'
json.position '0'

# Render the Track Playlist
json.playlist_partial json.partial! 'yams_core/tracks/playlist.html.erb', locals: { tracks: @tracks }
