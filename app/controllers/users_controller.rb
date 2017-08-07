class UsersController < ApplicationController
  def index
    render plain: params.inspect
  end
end
