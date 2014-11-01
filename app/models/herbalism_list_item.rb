class HerbalismListItem < ActiveRecord::Base
  belongs_to :herbalism_list
  belongs_to :herb

  def effects
    Herb.effects
  end

  def first_effect
    effects[first_effect_id]
  end

  def second_effect
    effects[second_effect_id]
  end

  def third_effect
    effects[third_effect_id]
  end

end
