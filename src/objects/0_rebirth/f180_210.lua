-- The Black Bean
-- White Pony
-- Sacred Heart
SMODS.Joker {
  key = "sacred_heart",
  pos = {x = 2, y = 12},
  config = {extra = {Xmult_multi = 3}},
  loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.Xmult_multi}}
  end,
  rarity = 4,
  cost = 20,
  atlas = "jokers",
  perishable_compat = true,
  eternal_compat = true,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.cardarea == "unscored" and context.individual then
      return {
        colour = G.C.MULT,
        Xmult = card.ability.extra.Xmult_multi
      }
    end
  end,
  in_pool = function (self, args)
    return TBOJ.in_pool(self, args)
  end,
  angel = true
}