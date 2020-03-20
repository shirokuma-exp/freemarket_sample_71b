class UsersController < ApplicationController
  def edit
    @users=User.all
  end

  def update
  end
end
