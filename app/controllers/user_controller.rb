class UserController < ApplicationController

  def index
    @users = User.find(:all, :order => "diff DESC, name", :limit => 10)
  end
end
