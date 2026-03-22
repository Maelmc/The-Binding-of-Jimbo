-- Multidimensional Baby
-- Glitter Bomb
-- My Shadow
-- Jar of Flies
TBOJ.Active {
  key = "jar_of_flies",
  pos = { x = 13, y = 28 },
  cost = 5,
  config = {extra = {max_charge = 20, curr_charge = 0}},
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue + 1] = G.P_CENTERS.spiderfly_tboj_pretty_fly
    return {vars = {card.ability.extra.curr_charge, card.ability.extra.max_charge}}
  end,
  calculate = function(self, card, context)
    TBOJ.eor_charge(card,context)
  end,
  can_use = function(self, card)
    return card.ability.extra.curr_charge > 0
  end,
  use = function(self, card, area, copier)
    for _ = 1, card.ability.extra.curr_charge do
      local _card = SMODS.create_card {
        set = "tboj_spiderfly",
        key = "spiderfly_tboj_pretty_fly",
        area = G.flies
      }
      _card:add_to_deck()
      G.flies:emplace(_card)
    end
    SMODS.calculate_effect({message = localize('tboj_flies_ex'),}, card)
  end,
  keep_on_use = function(self, card)
    return true
  end,
  in_pool = function(self)
    return TBOJ.in_pool(self)
  end,
  fly = true,
}