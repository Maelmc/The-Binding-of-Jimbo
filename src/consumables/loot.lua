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
            SMODS.destroy_cards(card,true)
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
  config = {extra = {charge = 6}},
  loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.charge}}
  end,
  can_use = function(self, card)
    local target = TBOJ.leftmost_or_selected_active()
    return target and target.ability.extra.curr_charge
  end,
  use = function(self, card, area, copier)
    local target = TBOJ.leftmost_or_selected_active()
    if target.ability.extra.battery_charge then
      TBOJ.charge_active(target,target.ability.extra.battery_charge)
    else
      TBOJ.charge_active(target,card.ability.extra.charge)
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
    for k, _ in pairs(G.GAME.hands) do
      if SMODS.is_poker_hand_visible(k) then
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

SMODS.Consumable {
  key = "black_heart",
  set = "Loot",
  pos = { x = 8, y = 0 },
  atlas = "consumables",
  cost = 4,
  unlocked = true,
  config = { extra = {max_highlighted = 1, mult= 2}},
  loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.mult, card.ability.extra.max_highlighted}}
  end,
  can_use = function(self, card)
    return G.hand and #G.hand.highlighted > 0 and #G.hand.highlighted <= card.ability.extra.max_highlighted
  end,
  use = function(self, card, area, copier)
    for i = 1, math.min(#G.hand.highlighted, card.ability.extra.max_highlighted) do
      local target = G.hand.highlighted[i]
      target.ability.perma_mult = (target.ability.perma_mult or 0) + card.ability.extra.mult
      SMODS.calculate_effect({message = localize('k_upgrade_ex'), colour = G.C.MULT}, target)
    end
    card:juice_up(0.3, 0.5)
  end,
}

-- Copied from Forager Nonessentials' Graffiti Artist
SMODS.Consumable {
  key = "key",
  set = "Loot",
  pos = { x = 10, y = 0 },
  atlas = "consumables",
  cost = 4,
  unlocked = true,
  config = {extra = {}},
  loc_vars = function(self, info_queue, card)
  end,
  can_use = function(self, card)
    local type = G.GAME.blind:get_type()
    return G.STATE == G.STATES.SELECTING_HAND and G.GAME.round_resets.blind_tags[type]
  end,
  use = function(self, card, area, copier)
    G.E_MANAGER:add_event(Event({
			trigger = "after",
			delay = 0.2,
			func = function()
				play_sound("tarot1")
				local tag = Tag(G.GAME.round_resets.blind_tags[G.GAME.blind:get_type()])
				add_tag(tag)
        local target = copier or card
				target:juice_up(0.8, 0.5)
				return true
			end,
		}))
  end,
  tboj_designer = "hagma1",
}

SMODS.Consumable {
  key = "poop_nugget",
  set = "Loot",
  pos = { x = 11, y = 0 },
  atlas = "consumables",
  cost = 4,
  unlocked = true,
  config = { extra = { max_highlighted = 2 } },
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue + 1] = G.P_CENTERS.m_tboj_poop
    return {vars = {card.ability.extra.max_highlighted}}
  end,
  can_use = function(self, card)
    return G.hand and #G.hand.highlighted > 0 and #G.hand.highlighted <= card.ability.extra.max_highlighted
  end,
  use = function(self, card, area, copier)
    TBOJ.juice_flip_highlighted(card)
    for i = 1, #G.hand.highlighted do
      G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0.1,
        func = function()
          G.hand.highlighted[i]:set_ability("m_tboj_poop")
          return true
        end
      }))
    end 
    TBOJ.juice_flip_highlighted(card, true)
  end,
}