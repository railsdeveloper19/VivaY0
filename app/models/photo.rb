class Photo < ActiveRecord::Base
  belongs_to :photable, :polymorphic =>true
  #has_attached_file :file, :styles => { :medium => "300x300>", :thumb => "100x100>" }
end
