SMODS.Consumable {
  key = "bomb",
  set = "Loot",
  pos = { x = 1, y = 0 },
  atlas = "consumables",
  cost = 4,
  unlocked = true,
  config = { extra = { Xmult = 2 } },
  loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.Xmult, card.ability.extra.fused and localize("tboj_fused") or localize("tboj_not_fused")}}
  end,
  can_use = function(self, card)
    return not card.ability.extra.fused
  end,
  use = function(self, card, area, copier)
    card.ability.extra.fused = true
    local eval = function(card) return card.ability.extra.fused and not G.RESET_JIGGLES end
    juice_card_until(card, eval, true)
  end,
  calculate = function (self, card, context)
    if context.scoring_hand and context.joker_main then
      if card.ability.extra.fused then
        G.E_MANAGER:add_event(Event({
          func = function()
            card:start_dissolve()
            return true
          end
        }))
        return {
          xmult = card.ability.extra.Xmult
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
  config = {},
  loc_vars = function(self, info_queue, card)
    return {vars = {}}
  end,
  can_use = function(self, card)
    return G.actives and G.actives.highlighted and #G.actives.highlighted == 1
  end,
  use = function(self, card, area, copier)
    if G.actives.highlighted[1].ability.extra.battery_charge then
      TBOJ.charge_active(G.actives.highlighted[1],G.actives.highlighted[1].ability.extra.battery_charge)
    else
      TBOJ.charge_active(G.actives.highlighted[1],G.actives.highlighted[1].ability.extra.max_charge)
    end
  end,
}

SMODS.Consumable {
  key = "pill",
  set = "Loot",
  pos = { x = 3, y = 0 },
  atlas = "consumables",
  cost = 4,
  unlocked = true,
  config = { extra = {num = 1, den = 3, increase = 2}},
  loc_vars = function(self, info_queue, card)
    local num, den = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.den, "tboj_pill")
    return {vars = {num, den, card.ability.extra.increase}}
  end,
  can_use = function(self, card)
    return true
  end,
  use = function(self, card, area, copier)
    local _poker_hands = {}
    for k, v in pairs(G.GAME.hands) do
      if v.visible then
        _poker_hands[#_poker_hands+1] = k
      end
    end
    local hand = pseudorandom_element(_poker_hands, "tboj_pill")
    if SMODS.pseudorandom_probability(card, "tboj_pill", card.ability.extra.num, card.ability.extra.den, "tboj_pill") then
      SMODS.smart_level_up_hand(card, hand, false, -card.ability.extra.increase)
    else
      SMODS.smart_level_up_hand(card, hand, false, card.ability.extra.increase)
    end
  end,
}

SMODS.Consumable {
  key = "soul_heart",
  set = "Loot",
  pos = { x = 4, y = 0 },
  atlas = "consumables",
  cost = 4,
  unlocked = true,
  config = { extra = {max_highlighted = 1, chips = 15}},
  loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.chips, card.ability.extra.max_highlighted}}
  end,
  can_use = function(self, card)
    return G.hand and #G.hand.highlighted > 0 and #G.hand.highlighted <= card.ability.extra.max_highlighted
  end,
  use = function(self, card, area, copier)
    for i = 1, math.min(#G.hand.highlighted, card.ability.extra.max_highlighted) do
      local target = G.hand.highlighted[i]
      target.ability.perma_bonus = (target.ability.perma_bonus or 0) + card.ability.extra.chips
      SMODS.calculate_effect({message = localize('k_upgrade_ex'), colour = G.C.CHIPS}, target)
    end
    card:juice_up(0.3, 0.5)
  end,
}