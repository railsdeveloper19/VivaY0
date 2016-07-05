class Comment < ActiveRecord::Base
  #attr_accessible :body, :commenter, :post_id, :user_id
  validates :commenter,  :presence => true
  validates :body, :length => { :minimum => 1 }

  belongs_to :post
  belongs_to :user
  #has_many :likes, :as => :likeable
end
