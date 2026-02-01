-- Smelter
TBOJ.Active {
  key = "smelter",
  pos = { x = 13, y = 31 },
  cost = 8,
  config = {extra = {max_charge = 5, curr_charge = 5}},
  loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.curr_charge, card.ability.extra.max_charge}}
  end,
  calculate = function(self, card, context)
    TBOJ.eor_charge(card,context)
  end,
  can_use = function(self, card)
    return card.ability.extra.curr_charge >= card.ability.extra.max_charge and G.trinkets and #G.trinkets.highlighted > 0
  end,
  use = function(self, card, area, copier)
    local target = G.trinkets.highlighted[1]
    target:set_edition("e_negative",true)
    card:juice_up(0.3, 0.5)
  end,
  keep_on_use = function(self, card)
    return true
  end,
  in_pool = function(self)
    return TBOJ.in_pool(self)
  end
}

-- Compost