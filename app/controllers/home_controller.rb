class HomeController < ApplicationController
  layout 'application'

  def index
    if user_signed_in?
      redirect_to posts_path
    end
  end
  
  def about
  end
  
  def service
  end
  
  def contact
  end
end
