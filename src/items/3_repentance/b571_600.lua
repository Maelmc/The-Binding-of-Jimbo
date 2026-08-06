-- Orphan Socks

-- Eye of the Occult
SMODS.Joker {
  key = "eye_of_the_occult",
  pos = {x = 1, y = 38 },
  config = { extra = { Xmult_multi = 1.5 } },
  loc_vars = function(self, info_queue, card)
    return { vars = { localize((G.GAME.current_round.tboj_eye_of_the_occult_card1 or {}).rank or 'Ace', 'ranks'), card.ability.extra.Xmult_multi } }
  end,
  rarity = 2,
  cost = 6,
  atlas = "jokers",
  perishable_compat = true,
  eternal_compat = true,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play and context.other_card:get_id() == G.GAME.current_round.tboj_eye_of_the_occult_card1.id then
      return {
        xmult = card.ability.extra.Xmult_multi
      }
    end
  end,
  attributes = {"rank", "xmult", "tboj_devil"}
}

-- Immaculate Heart
-- Monstrance