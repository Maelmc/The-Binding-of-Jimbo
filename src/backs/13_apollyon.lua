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
    if context.selling_card and context.card.ability.set == "Joker" then
      G.GAME.banned_keys[context.card.config.center.key] = true
      return {
        message = localize("tboj_voided")
      }
    end
  end
}