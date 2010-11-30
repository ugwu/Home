class HelloworldController < ApplicationController
  
  def index
    @user = "Patrick is the best"
    
    @grades = { "Patrick" => " 100 ",
               "Jim" =>  " 120 ",
               "Billy" => " 58 "
              }
    
    # render :text => "Patrick il é maestro del mondo git test"
  end

  def gen
    @name = "Maestro"
    
  end
  
end