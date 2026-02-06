-- Marrow
-- Slipped Rib
-- Hallowed Ground
SMODS.Joker {
  key = "hallowed_ground",
  pos = {x = 2, y = 36 },
  config = {extra = {Xmult_multi = 1.5}},
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue+1] = G.P_CENTERS.m_tboj_poop
    return {vars = {card.ability.extra.Xmult_multi}}
  end,
  rarity = 3,
  cost = 8,
  atlas = "jokers",
  blueprint_compat = false,
  enhancement_gate = "m_tboj_poop",
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play then
      if not context.end_of_round and not context.before
      and not context.after and not context.other_card.debuff
      and SMODS.has_enhancement(context.other_card, "m_tboj_poop") then
        return {
          Xmult = card.ability.extra.Xmult_multi,
          card = card
        }
      end
    end
  end,
  in_pool = function (self, args)
    return TBOJ.in_pool(self, args)
  end,
  angel = true,
}