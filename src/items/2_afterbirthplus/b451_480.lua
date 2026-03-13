-- Plan C
-- D1
-- Void
TBOJ.Active {
  key = "void",
  pos = { x = 11, y = 31 },
  cost = 7,
  config = {extra = {max_charge = 3, curr_charge = 3}},
  loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.curr_charge, card.ability.extra.max_charge}}
  end,
  calculate = function(self, card, context)
    TBOJ.eor_charge(card,context)
  end,
  can_use = function(self, card)
    return card.ability.extra.curr_charge >= card.ability.extra.max_charge and G.STATE == G.STATES.SHOP and G.shop_jokers and #G.shop_jokers.cards > 0
  end,
  use = function(self, card, area, copier)
    local to_up = #G.shop_jokers.cards
    for i = 1, #G.shop_jokers.cards do
      local target = G.shop_jokers.cards[i]
      G.GAME.banned_keys[target.config.center.key] = true
      SMODS.destroy_cards(target, true)
    end

    for i = 1, to_up do
      local _poker_hands = {}
      for k, _ in pairs(G.GAME.hands) do
        if SMODS.is_poker_hand_visible(k) then
          _poker_hands[#_poker_hands+1] = k
        end
      end
      local hand = pseudorandom_element(_poker_hands, "tboj_void")
      SMODS.smart_level_up_hand(card, hand, false, 1)
    end
  end,
  keep_on_use = function(self, card)
    return true
  end,
  in_pool = function(self)
    return TBOJ.in_pool(self)
  end,
  devil = true,
  angel = true,
}

-- Pause
-- Smelter
TBOJ.Active {
  key = "smelter",
  pos = { x = 13, y = 31 },
  cost = 8,
  config = {extra = {max_charge = 5, curr_charge = 5}},
  loc_vars = function(self, info_queue, card)
    if not card.edition or (card.edition and not card.edition.negative) then
      info_queue[#info_queue+1] = G.P_CENTERS.e_negative
    end
    return {vars = {card.ability.extra.curr_charge, card.ability.extra.max_charge}}
  end,
  calculate = function(self, card, context)
    TBOJ.eor_charge(card,context)
  end,
  can_use = function(self, card)
    return card.ability.extra.curr_charge >= card.ability.extra.max_charge and G.trinkets and #G.trinkets.highlighted == 1
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