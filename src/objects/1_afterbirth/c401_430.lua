-- Lusty Blood
SMODS.Joker {
  key = "lusty_blood",
  pos = {x = 5, y = 27},
  config = {extra = {Xmult = 1, Xmult_mod = 0.5}},
  loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.Xmult_mod, card.ability.extra.Xmult}}
  end,
  rarity = 2,
  cost = 6,
  atlas = "jokers",
  perishable_compat = true,
  eternal_compat = true,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.remove_playing_cards and not context.blueprint then
      card.ability.extra.Xmult = card.ability.extra.Xmult + #context.removed * card.ability.extra.Xmult_mod
      return { message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.Xmult } } }
    end

    if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
      if context.beat_boss and card.ability.extra.Xmult > 1 then
        card.ability.extra.Xmult = 1
        return {
          message = localize('k_reset'),
          colour = G.C.RED
        }
      end
    end

    if context.joker_main then
      return {
        xmult = card.ability.extra.Xmult,
      }
    end
  end,
  in_pool = function (self, args)
    return TBOJ.in_pool(self, args)
  end,
  devil = true,
}