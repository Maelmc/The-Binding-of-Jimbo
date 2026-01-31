-- Dull Razor
TBOJ.Active {
  key = "dull_razor",
  pos = { x = 5, y = 32 },
  rarity = "Uncommon",
  cost = 5,
  config = {extra = {max_charge = 2, curr_charge = 2}},
  loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.curr_charge, card.ability.extra.max_charge, card.ability.extra.mult}}
  end,
  calculate = function(self, card, context)
    TBOJ.charge_active(self,card,context)
  end,
  can_use = function(self, card)
    return card.ability.extra.curr_charge >= card.ability.extra.max_charge and G.hand and #G.hand.highlighted > 0
  end,
  use = function(self, card, area, copier)
    SMODS.calculate_context({remove_playing_cards = true, removed = G.hand.highlighted})
  end,
  keep_on_use = function(self, card)
    return true
  end,
  in_pool = function(self)
    return TBOJ.in_pool(self)
  end
}