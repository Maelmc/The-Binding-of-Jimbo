-- 121
-- Whore of Babylon
SMODS.Joker {
  key = "whore_of_babylon",
  pos = {x = 1, y = 8},
  config = {extra = {mult = 25}},
  loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.mult}}
  end,
  rarity = 1,
  cost = 6,
  atlas = "jokers",
  perishable_compat = true,
  eternal_compat = true,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.joker_main and G.GAME.current_round.hands_left == 0 then
      return {
        mult = card.ability.extra.mult
      }
    end
  end,
  in_pool = function (self, args)
    return TBOJ.in_pool(self, args)
  end,
  attributes = {"tboj_devil", "mult", "hands"}
}

-- Razor Blade
-- Forget Me Now
-- Forever Alone
SMODS.Joker {
  key = "forever_alone",
  pos = {x = 7, y = 8},
  config = {extra = {chips = 60}},
  loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.chips}}
  end,
  rarity = 1,
  cost = 4,
  atlas = "jokers",
  perishable_compat = true,
  eternal_compat = true,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play then
      if context.other_card == context.scoring_hand[5] then
        return {
          chips = card.ability.extra.chips,
        }
      end
    end
  end,
  in_pool = function (self, args)
    return TBOJ.in_pool(self, args)
  end,
  attributes = {"tboj_familiar", "tboj_fly", "chips"}
}

-- Bucket of Lard
-- A Pony

-- A Lump of Coal
SMODS.Joker {
  key = "a_lump_of_coal",
  pos = {x = 11, y = 8},
  config = {extra = {Xmult_mod = 0.5}},
  loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.Xmult_mod}}
  end,
  rarity = 2,
  cost = 6,
  atlas = "jokers",
  perishable_compat = true,
  eternal_compat = true,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.joker_main then
      return {
        colour = G.C.MULT,
        Xmult = 1 + card.ability.extra.Xmult_mod * #context.scoring_hand,
      }
    end
  end,
  in_pool = function (self, args)
    return TBOJ.in_pool(self, args)
  end,
  attributes = {"tboj_devil", "xmult"}
}

-- Guppy's Paw
TBOJ.Active {
  key = "guppy_paw",
  pos = { x = 12, y = 8 },
  cost = 5,
  config = {extra = {req_hand = 2, hand = 1, discard = 2}},
  loc_vars = function(self, info_queue, card)
    return {vars = {
      card.ability.extra.req_hand, card.ability.extra.hand, card.ability.extra.discard
    }}
  end,
  can_use = function(self, card)
    return G.GAME.round_resets.hands >= card.ability.extra.req_hand and G.GAME.current_round.hands_left >= card.ability.extra.req_hand
  end,
  use = function(self, card, area, copier)
    G.GAME.round_resets.hands = G.GAME.round_resets.hands - card.ability.extra.hand
    ease_hands_played(-card.ability.extra.hand)
    G.GAME.round_resets.discards = G.GAME.round_resets.discards + card.ability.extra.discard
    ease_discard(card.ability.extra.discard)
  end,
  keep_on_use = function(self, card)
    return true
  end,
  in_pool = function(self)
    return TBOJ.in_pool(self)
  end,
  attributes = {"hands", "discards", "tboj_guppy", "tboj_devil"}
}