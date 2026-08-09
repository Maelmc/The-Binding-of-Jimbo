SMODS.Back {
	key = "judas",
  unlocked = true,
  discovered = true,
	config = { mult = 1, hands = -1 },
  loc_vars = function(self, info_queue, center)
    return {vars = {SMODS.signed(self.config.mult), SMODS.signed(self.config.hands)}}
  end,
	pos = { x = 3, y = 0 },
	atlas = "backs",
  calculate = function (self, back, context)
    if context.before then
      for _, v in ipairs(context.scoring_hand) do
        v.ability.perma_mult = (v.ability.perma_mult or 0) + self.config.mult
        SMODS.calculate_effect({message = localize('k_upgrade_ex')},v)
      end
      return nil, true
    end
  end
}

TBOJ.add_remove_deck("b_tboj_keeper", function()
  G.GAME.round_resets.hands = G.GAME.round_resets.hands + 1
  ease_hands_played(1)
end)