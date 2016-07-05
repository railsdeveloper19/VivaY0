class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         
  has_many :posts
  has_many :comments
  has_many :user_mappings ,  -> { uniq }
  has_many :photos, :as => :photable
  after_create :user_mapping_with_admin
  
  private
  def user_mapping_with_admin
    admins =  User.where("user_type ='admin'")
    current_user = User.last
    if !admins.blank?
      admins.each do |adm|
        if current_user.id != adm.id
          UserMapping.create(:user_id=>current_user.id ,:join_id=>adm.id)
          UserMapping.create(:user_id=>adm.id ,:join_id=>current_user.id)
        end
      end
    end
  end
  
end
