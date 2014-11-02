class Townsman < ActiveRecord::Base
  belongs_to :town
  belongs_to :user
  belongs_to :herbalism_list

  RANKS = %i(founder member)

  def named_rank
    RANKS[rank]
  end
end
