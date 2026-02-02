SMODS.Enhancement {
  key = "laser",
  atlas = "enhancements",
  pos = { x = 1, y = 0 },
  config = { extra = { percent = 1 }},
  loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.percent}}
  end,
  calculate = function(self, card, context)
    if context.main_scoring and context.cardarea == G.play then
      return {
        tboj_balance_percent = card.ability.extra.percent
      }
    end
  end,
  in_pool = function(self, args) return true end,
}