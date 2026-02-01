SMODS.Consumable {
  key = "bomb",
  set = "Loot",
  pos = { x = 1, y = 0 },
  atlas = "consumables",
  cost = 4,
  unlocked = true,
  config = {Xmult = 2},
  loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.Xmult, card.ability.fused and localize("tboj_fused") or localize("tboj_not_fused")}}
  end,
  can_use = function(self, card)
    return not card.ability.fused
  end,
  use = function(self, card, area, copier)
    card.ability.fused = true
  end,
  calculate = function (self, card, context)
    if context.scoring_hand and context.joker_main then
      if card.ability.fused then
        G.E_MANAGER:add_event(Event({
          func = function()
            card:start_dissolve()
            return true
          end
        }))
        return {
          xmult = card.ability.Xmult
        }
      end
    end
  end,
  keep_on_use = function (self, card)
    return true
  end
}

SMODS.Consumable {
  key = "lil_battery",
  set = "Loot",
  pos = { x = 2, y = 0 },
  atlas = "consumables",
  cost = 4,
  unlocked = true,
  config = {Xmult = 2},
  loc_vars = function(self, info_queue, card)
    return {vars = {}}
  end,
  can_use = function(self, card)
    return G.actives and G.actives.highlighted and #G.actives.highlighted == 1
  end,
  use = function(self, card, area, copier)
    TBOJ.charge_active(G.actives.highlighted[1],G.actives.highlighted[1].ability.extra.max_charge)
  end,
}