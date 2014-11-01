class Townsman < ActiveRecord::Base
  belongs_to :town
  belongs_to :user

  RANKS = %i(founder member)

  def named_rank
    RANKS[rank]
  end
end
