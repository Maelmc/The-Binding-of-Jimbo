--[[SMODS.current_mod.calculate = function(self, context)
  if context.skipping_booster or context.ending_booster or context.starting_shop then
    G.GAME.tboj_in_shop = true
  end

  if context.ending_shop or context.open_booster then
    G.GAME.tboj_in_shop = false
  end
end]]