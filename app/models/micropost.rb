# == Schema Information
# Schema version: 20101213130020
#
# Table name: microposts
#
#  id         :integer(4)      not null, primary key
#  content    :string(255)
#  user_id    :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

class Micropost < ActiveRecord::Base
  attr_accessible :content
  
  belongs_to :user
  default_scope :order => 'microposts.created_at DESC'
  
  validates :content, :presence => true,
                      :length => {:maximum => 140}
                      
  validates :user_id, :presence => true
  
end
