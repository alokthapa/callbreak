class User < ActiveRecord::Base
  
  def top_ten?
    User.count(:conditions => "diff > #{diff}") < 10
  end
  
end
