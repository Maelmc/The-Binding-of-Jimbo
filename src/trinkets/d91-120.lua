-- Crow Heart
TBOJ.Trinket {
  key = "crow_heart",
  pos = { x = 1, y = 7 },
  cost = 6,
  config = {extra = {hands = 1, discards = 1}},
  loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.hands, card.ability.extra.discards}}
  end,
  calculate = function(self, card, context)
    if context.before and G.GAME.current_round.discards_left > 0 then
      ease_hands_played(card.ability.extra.hands)
      ease_discard(-card.ability.extra.discards)
      return {
        message = localize("tboj_drain")
      }
    end
  end,
}