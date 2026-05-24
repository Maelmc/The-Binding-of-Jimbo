SMODS.Back {
	key = "apollyon",
  unlocked = true,
  discovered = true,
	config = {  },
  loc_vars = function(self, info_queue, center)
    return {vars = {}}
  end,
	pos = { x = 13, y = 0 },
	atlas = "backs",
  calculate = function (self, back, context)
    if context.selling_card then
      G.GAME.banned_keys[context.card.config.center.key] = true
      return {
        message = localize("tboj_banned")
      }
    end
  end
}

TBOJ.add_remove_deck("b_tboj_keeper", function()
  G.GAME.round_resets.hands = G.GAME.round_resets.hands + 2
  ease_hands_played(2)
end)