# frozen_string_literal: true
require 'rails_helper'

describe YamsCore::User do
  before(:each) { @user = YamsCore::User.new(email: 'users@example.com') }

  subject { @user }

  it { should respond_to(:email) }

  it '#email returns a string' do
    expect(@user.email).to match 'users@example.com'
  end

  it 'generates an event when a user created' do
    event_store = RailsEventStore::Client.new

    user = create(:user)

    #event_store.publish(OrderPlaced.new(data: { order_id: 42 }))

    expect(event_store).to have_published(an_event(YamsEvents::NewUserCreatedEvent))
  end
end
