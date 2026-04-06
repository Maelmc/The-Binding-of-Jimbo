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
  attributes = {"tboj_angel"}
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
  attributes = {"tboj_angel"}
}

-- The Soul
SMODS.Joker {
  key = "the_soul",
  pos = {x = 4, y = 22},
  config = {extra = {hands = 2}},
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
  attributes = {"tboj_angel"}
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