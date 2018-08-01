class UsersAsset < ActiveRecord::Base
  belongs_to :user
  belongs_to :asset
  
end