-- Larynx
TBOJ.Active {
  key = "larynx",
  pos = { x = 10, y = 40 },
  cost = 6,
  config = {extra = {max_charge = 12, curr_charge = 1, battery_charge = 3, Xmult_mod = 1, active = false}},
  loc_vars = function(self, info_queue, card)
    return {vars = {
      card.ability.extra.curr_charge, card.ability.extra.max_charge, card.ability.extra.battery_charge,
      card.ability.extra.Xmult_mod, card.ability.extra.Xmult_mod * card.ability.extra.curr_charge,
      card.ability.extra.active and localize("tboj_active") or localize("tboj_inactive")
    }}
  end,
  calculate = function(self, card, context)
    if context.scoring_hand and context.joker_main then
      if card.ability.extra.active then
        card.ability.extra.active = false
        local tmp = card.ability.extra.curr_charge
        card.ability.extra.curr_charge = 0
        return {
          xmult = card.ability.extra.Xmult_mod * tmp
        }
      end
    end
    TBOJ.eor_charge(card,context)
  end,
  can_use = function(self, card)
    return card.ability.extra.curr_charge >= 0 and not card.ability.extra.active
  end,
  use = function(self, card, area, copier)
    card.ability.extra.active = true
    local eval = function(card) return card.ability.extra.active end
    juice_card_until(card, eval, true)
  end,
  manual_deplete_charges = true,
  keep_on_use = function(self, card)
    return true
  end,
  in_pool = function(self)
    return TBOJ.in_pool(self)
  end
}