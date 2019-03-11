# TODO does not seem like a very good root node name
json.saved do

  json.service do
    if current_user # radio stream can be accessed by non signed in visitors
      json.user_token   current_user.id
      json.client_token '0987654321' # TODO: - add tokens to devise
    end
  end

  # not sure we need to bother with these in init  - audio to play comes in via load anyway
  json.audio do
    #json.playlist
    #json.page
    #json.total_pages
    #json.track
    #json.position
  end

  json.waveform_colors do
    json.wave_color 'white'
    json.progress_color 'grey'
    json.cursor_color 'purple'
    json.bar_width 'w-100'
  end
end

json.routes do
  json.save_interval DatashiftAudioEngine::Configuration.call.save_interval

  json.save_url yams_core.player_status_callback_url
end

