class Herb < ActiveRecord::Base
  def self.effects
    ["Unknown effect", "Antidote","Damage hard HP","Damage hard stamina", "Damage soft HP", "Damage soft stamina regen", "Drink/food flavour (spice)", "Flux", "Lowers maximum soft HP (temp)", "Lowers maximum soft stamina (temp)", "Naphtha", "Raise Agi (temp)", "Raise Con (temp)", "Raise Int (temp)", "Raise maximum soft stamina (temp)", "Raise Str (temp)", "Raise Will (temp)", "Restore hard stamina", "Restore soft HP"]
  end
end
