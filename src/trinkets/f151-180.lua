-- Flat File
-- Telescope Lens
--[[TBOJ.Trinket {
  key = "telescope_lens",
  pos = { x = 1, y = 10 },
  cost = 4,
  config = {extra = {}},
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.hands } }
  end,
  attributes = {"space"}
}]]

-- Mom's Lock
-- Dice Bag
-- Holy Crown
-- Mother's Kiss
TBOJ.Trinket {
  key = "mother_kiss",
  pos = { x = 5, y = 10 },
  cost = 4,
  config = {extra = {hands = 1}},
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.hands } }
  end,
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

-- Torn Card
-- Torn Pocket