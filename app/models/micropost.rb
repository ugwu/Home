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
  
  scope :from_users_followed_by, lambda { |user| followed_by(user) }
  
  validates :content, :presence => true,
                      :length => {:maximum => 140}
                      
  validates :user_id, :presence => true
  
  
   private

      # Return an SQL condition for users followed by the given user.
      # We include the user's own id as well.
      def self.followed_by(user)
        followed_ids = %(SELECT followed_id FROM relationships
                         WHERE follower_id = :user_id)
        where("user_id IN (#{followed_ids}) OR user_id = :user_id",
              { :user_id => user })
      end
  end
 
