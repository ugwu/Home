class PagesController < ApplicationController
  def home
    @array = [1,2,3,4,5,6,7,8]
    @num = @array.object_id
    
  end

  def contact
  end

end
