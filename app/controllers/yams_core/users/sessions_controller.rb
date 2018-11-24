# frozen_string_literal: true
module YamsCore
  class Users::SessionsController < Devise::SessionsController
    layout 'welcome', only: %i[new create]
  end
end