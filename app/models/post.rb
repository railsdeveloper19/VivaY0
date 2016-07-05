class Post < ActiveRecord::Base
  #attr_accessible :text, :name, :title, :user_id
  validates :title, :presence => true,
                    :length => { :minimum => 5 }
  belongs_to :user
  has_many :comments
  #has_many :likes, :as => :likeable
  has_many :photos, :as => :photable
  self.per_page = 10
end
