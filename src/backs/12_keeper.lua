SMODS.Back {
	key = "keeper",
  unlocked = true,
  discovered = true,
	config = { dollars = 16, hands = -2, max_hands = 5, extra_hands = 1, every = 20 },
  loc_vars = function(self, info_queue, center)
    return {vars = {self.config.dollars, SMODS.signed(self.config.hands), SMODS.signed(self.config.extra_hands), self.config.every, SMODS.signed(self.config.max_hands), self.config.max_hands * self.config.every}}
  end,
	pos = { x = 12, y = 0 },
	atlas = "backs",
  calculate = function (self, back, context)
    if context.setting_blind then
      local hands = math.min(self.config.max_hands,math.floor((G.GAME.dollars + (G.GAME.dollar_buffer or 0))/self.config.every))
      if hands >= 1 then
        G.E_MANAGER:add_event(Event({
          func = function()
            ease_hands_played(hands)
            return true
          end
        }))
        return {
          message = localize { type = 'variable', key = 'a_hands', vars = { hands } }
        }
      end
    end
  end
}

TBOJ.add_remove_deck("b_tboj_keeper", function()
  G.GAME.round_resets.hands = G.GAME.round_resets.hands + 2
  ease_hands_played(2)
end)