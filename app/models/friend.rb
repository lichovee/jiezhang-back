class Friend < ApplicationRecord
  belongs_to :target_user, class_name: "User"
end
