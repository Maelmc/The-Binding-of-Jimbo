SMODS.Back {
	key = "apollyon", -- yes it's supposed to be appolyon i know im stupid but now that people have played with it on high stakes it's too late
  unlocked = true,
  discovered = true,
	config = {  },
  loc_vars = function(self, info_queue, center)
    return {vars = {}}
  end,
	pos = { x = 13, y = 0 },
	atlas = "backs",
  calculate = function (self, back, context)
    if context.selling_card and context.card.ability.set == "Joker" then
      G.GAME.banned_keys[context.card.config.center.key] = true
      return {
        message = localize("tboj_voided")
      }
    end
  end
}