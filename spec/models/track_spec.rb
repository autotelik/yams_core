# frozen_string_literal: true

require 'rails_helper'

RSpec.describe YamsCore::Track, type: :model do
  let(:album) { create(:album) }

  it 'saves the audio when all params present' do
    expect(create(:track, :with_audio)).to be_valid
  end

  it 'stores an uploaded file as an activestorage attachment (as audio)' do
    track = create(:track, :with_audio_upload_fixture)
    expect(track.audio).to be_a ActiveStorage::Attached::One
    expect(track.audio.filename).to eq 'test.wav'
    expect(track.audio.content_type).to eq 'audio/x-wav'
  end

  it 'returns tracks not assigned to an Album' do
    tracks = create_list(:track, 5, :with_audio)
    YamsCore::AlbumTrack.create(track: tracks.first, album: album)
    expect(YamsCore::Track.no_album.count).to eq 4
    expect(YamsCore::Track.no_album.collect(&:id)).to_not include tracks.first.id
  end

  it 'can attach an optional cover' do
    track = build(:track, :with_audio)

    track.attach_cover(fixture_file('test_image.jpg'))
    expect(track.cover.image).to be_attached
  end

  it 'is not radio friendly by default' do
    track = build(:track)
    expect(track.available_for?(:free)).to eq false
  end

  it 'can be made available_for radio' do
    track = create(:track, :with_audio)

    expect(track.make_available_for(:free)).to be_a YamsCore::Available

    expect(track.reload.available_for?(:free)).to eq true

    expect(YamsCore::Track.for_free.first).to eq track
  end

  it 'can be made available_for any mode' do
    track = create(:track, :with_audio)
    alt = create(:track, :with_audio)

    YamsCore::Available.modes.keys.each do |c|
      expect(track.available_for?(c)).to eq false
      expect(track.make_available_for(c)).to be_a YamsCore::Available
      expect(track.reload.available_for?(c)).to eq true
      expect(alt.available_for?(c)).to eq false
    end
  end

  it 'can be created with available_for any mode' do
    YamsCore::Available.modes.keys.each do |c|
      track = create(:track, :with_audio, availables_attributes: [{ mode: YamsCore::Available.modes[c] }])
      expect(track).to be_valid
      expect(track.availables.size).to eq 1
      expect(track.available_for?(c)).to eq true
    end
  end

  it 'attempting to make available when already available should not cause error' do
    track = create(:track, :with_audio, availables_attributes: [ mode: :download ])

    expect(track.available_for?(:download)).to eq true

    expect { track.make_available_for(:download) }.to_not raise_error

    expect(track.available_for?(:download)).to eq true
  end


  it 'can be made unavailable for any mode' do
    track = create(:track, :with_audio)
    YamsCore::Available.modes.keys.each do |c| track.make_available_for(c) end

    expect(track.available_for?(:free)).to eq true
    expect{track.remove_available_for(:free)}.to change(track.availables, :count).by(-1)
    expect(track.available_for?(:free)).to eq false
  end

  it 'attempting to make unavailable when not available should not cause error' do
    track = create(:track, :with_audio)

    expect(track.available_for?(:free)).to eq false
    expect {track.remove_available_for(:free) }.to_not raise_error

    track.make_available_for(:free)
    expect(track.available_for?(:free)).to eq true

    expect {track.remove_available_for(:free) }.to_not raise_error

    expect(track.available_for?(:free)).to eq false
  end

end
