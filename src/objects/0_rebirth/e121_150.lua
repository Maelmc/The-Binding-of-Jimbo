-- A Lump of Coal
SMODS.Joker {
  key = "a_lump_of_coal",
  pos = {x = 11, y = 8 },
  config = {extra = {Xmult_mod = 0.5}},
  loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.Xmult_mod}}
  end,
  rarity = 2,
  cost = 6,
  atlas = "jokers",
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.joker_main then
      return {
        colour = G.C.MULT,
        Xmult = 1 + card.ability.extra.Xmult_mod * #context.scoring_hand,
      }
    end
  end,
  in_pool = function (self, args)
    return TBOJ.in_pool(self, args)
  end,
  devil = true,
}