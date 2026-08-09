-- Godhead
-- Lazarus' Rags
-- The Mind
SMODS.Joker {
  key = "the_mind",
  pos = { x = 2, y = 22 },
  config = { extra = { h_size = 3 } },
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.h_size } }
  end,
  rarity = 3,
  cost = 8,
  atlas = "jokers",
  blueprint_compat = false,
  eternal_compat = true,
  perishable_compat = true,
  add_to_deck = function(self, card, from_debuff)
    G.hand:change_size(card.ability.extra.h_size)
  end,
  remove_from_deck = function(self, card, from_debuff)
    G.hand:change_size(-card.ability.extra.h_size)
  end,
  attributes = {"tboj_angel", "hand_size", "passive"}
}

-- The Body
SMODS.Joker {
  key = "the_body", 
  pos = {x = 3, y = 22},
  config = {extra = {d_size = 3}},
  loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.d_size}}
  end,
  rarity = 3, 
  cost = 8, 
  atlas = "jokers",
  blueprint_compat = false,
  eternal_compat = true,
  perishable_compat = true,
  add_to_deck = function(self, card, from_debuff)
    G.GAME.round_resets.discards = G.GAME.round_resets.discards + card.ability.extra.d_size
    ease_discard(card.ability.extra.d_size)
  end,
  remove_from_deck = function(self, card, from_debuff)
    G.GAME.round_resets.discards = G.GAME.round_resets.discards - card.ability.extra.d_size
    ease_discard(-card.ability.extra.d_size)
  end,
  attributes = {"tboj_angel", "discards", "passive"}
}

-- The Soul
SMODS.Joker {
  key = "the_soul",
  pos = {x = 4, y = 22},
  config = {extra = {hands = 3}},
  loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.hands}}
  end,
  rarity = 3,
  cost = 8,
  atlas = "jokers",
  blueprint_compat = false,
  eternal_compat = true,
  perishable_compat = true,
  add_to_deck = function(self, card, from_debuff)
    G.GAME.round_resets.hands = G.GAME.round_resets.hands + card.ability.extra.hands
    if not from_debuff then
      ease_hands_played(card.ability.extra.hands)
    end
  end,
  remove_from_deck = function(self, card, from_debuff)
    G.GAME.round_resets.hands = G.GAME.round_resets.hands - card.ability.extra.hands
    local to_decrease = math.min(G.GAME.current_round.hands_left - 1, card.ability.extra.hands)
    if to_decrease > 0 then
      ease_hands_played(-to_decrease)
    end
  end,
  attributes = {"tboj_angel", "hands", "passive"}
}

-- Dead Onion
-- Broken Watch
-- The Boomerang
-- Safety Pin
-- Caffeine Pill
-- Torn Photo
-- Blue Cap
-- Latch Key
-- Match Book
-- Synthoil
-- A Snack
SMODS.Joker {
  key = "a_snack",
  pos = {x = 0, y = 23},
  config = {extra = {num = 4, num_mod = 1}},
  loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.num, card.ability.extra.num_mod}}
  end,
  rarity = 2,
  cost = 4,
  atlas = "jokers",
  blueprint_compat = false,
  eternal_compat = false,
  perishable_compat = true,
  calculate = function(self, card, context)
    if context.mod_probability and not context.blueprint then
      return {
        numerator = context.numerator + card.ability.extra.num
      }
    end

    if context.pseudorandom_result and context.result then
      if card.ability.extra.num - card.ability.extra.num_mod <= 0 then
        SMODS.destroy_cards(card, {bypass_eternal = true, pinch_anim = true})
        return {
          message = localize("k_eaten_ex"),
          colour = G.C.GREEN
        }
      else
        card.ability.extra.num = card.ability.extra.num - card.ability.extra.num_mod
        SMODS.calculate_effect({message = localize({
          type = "variable",
          key = "tboj_minus_luck_var",
          vars = { 1 }
        }), colour = G.C.GREEN}, card)
        return nil, true
      end
    end
  end,
  attributes = {"food", "scaling", "passive", "mod_chance"}
}