class UsersController < ApplicationController
  def info
    @user_info = Doorkeeper::UserInfo.new(doorkeeper_token)

    if @user_info.run
      render json: @user_info.data
    else
      render json: { message: @user_info.errors.full_messages.join('. ') }, status: @user_info.error[:status]
    end
  end
end
