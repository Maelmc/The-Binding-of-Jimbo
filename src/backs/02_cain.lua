SMODS.Back {
	key = "cain",
  unlocked = true,
  discovered = true,
	config = { extra = {} },
  loc_vars = function(self, info_queue, back)
    return {vars = {}}
  end,
	pos = { x = 2, y = 0 },
	atlas = "backs",
  calculate = function (self, back, context)
    if context.mod_probability then
      return {
        numerator = context.numerator * 2
      }
    end
  end
}