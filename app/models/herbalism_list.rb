class HerbalismList < ActiveRecord::Base
  has_many :herbalism_list_items
  belongs_to :user
end
