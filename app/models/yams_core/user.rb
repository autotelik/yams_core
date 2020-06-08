# frozen_string_literal: true

module YamsCore
  class User < ApplicationRecord

    has_many :albums, dependent: :destroy
    has_many :tracks, dependent: :destroy

    # TODO - how to mimic and cache styles with ActiveStorage
    has_one_attached :avatar#, styles: { medium: '300x300>', thumb: '100x100>' }, default_url: ':style/missing.png'

    acts_as_taggable

    enum role: %i[user artist admin]

    after_initialize :set_default_role, if: :new_record?

    # TODO validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\z/

    def set_default_role
      self.role ||= :user
    end

    # Include default devise modules. Others available are:
    # :confirmable, :lockable, :timeoutable and :omniauthable
    devise :invitable, :database_authenticatable, :registerable, :confirmable, :recoverable, :rememberable, :trackable, :validatable

    # TODO: tokens - https://github.com/waiting-for-dev/devise-jwt
    # :jwt_authenticatable, jwt_revocation_strategy: Blacklist
    #
    #
  end
end