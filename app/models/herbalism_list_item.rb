class HerbalismListItem < ActiveRecord::Base
  belongs_to :herbalism_list
  belongs_to :herb

  def effects
    ["Unknown effect", "Antidote","Damage hard HP","Damage hard stamina", "Damage soft HP", "Damage soft stamina regen", "Drink/food flavour (spice)", "Flux", "Lowers maximum soft HP (temp)", "Lowers maximum soft stamina (temp)", "Naphtha", "Raise Agi (temp)", "Raise Con (temp)", "Raise Int (temp)", "Raise maximum soft stamina (temp)", "Raise Str (temp)", "Raise Will (temp)", "Restore hard stamina", "Restore soft HP"]
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
