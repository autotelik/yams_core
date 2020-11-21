# frozen_string_literal: true

module YamsCore
  class UserPolicy < ApplicationPolicy
    attr_reader :current_user, :model

    def initialize(current_user, model)
      @current_user = current_user
      @user = model
    end

    def index?
      @current_user.admin?
    end

    # Anyone can see other artists profiles
    def show?
     true
    end

    def update?
      @current_user.admin? || @current_user == @user
    end

    def destroy?
      return false if @current_user == @user
      @current_user.admin?
    end

  end
end
