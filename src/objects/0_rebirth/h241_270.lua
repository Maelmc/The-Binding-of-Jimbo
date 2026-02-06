-- Proptosis
SMODS.Joker {
  key = "proptosis",
  pos = {x = 6, y = 17},
  config = {extra = {Xmult_multi = 3}},
  loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.Xmult_multi}}
  end,
  rarity = 2,
  cost = 6,
  atlas = "jokers",
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play then
      for k, v in ipairs(G.play.cards) do
        if context.other_card == v and card.ability.extra.Xmult_multi / k ~= 1 then
          return {
            xmult = card.ability.extra.Xmult_multi / k
          }
        end
      end
    end
  end,
  in_pool = function (self, args)
    return TBOJ.in_pool(self, args)
  end
}