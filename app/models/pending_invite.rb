class PendingInvite < ActiveRecord::Base
  belongs_to :town
  belongs_to :user
  belongs_to :invited_by, class_name: "User"
end
