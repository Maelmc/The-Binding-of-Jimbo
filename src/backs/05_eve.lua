--[[
SMODS.Back {
	key = "eve",
  unlocked = true,
  discovered = true,
	config = {  },
  loc_vars = function(self, info_queue, center)
  end,
	pos = { x = 5, y = 0 },
	atlas = "backs",
  calculate = function (self, back, context)
    if context.press_play then
      G.GAME.tboj_eve_deck = G.GAME.current_round.hands_left
      G.GAME.current_round.hands_left = 1
    end

    if context.final_scoring_step then
      G.GAME.current_round.hands_left = G.GAME.tboj_eve_deck - 1
      G.GAME.tboj_eve_deck = nil
    end
  end
}
]]