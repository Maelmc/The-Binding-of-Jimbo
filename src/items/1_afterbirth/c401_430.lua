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
      SMODS.scale_card(card, {
        ref_value = 'Xmult',
        scalar_value = 'Xmult_mod',
        operation = function(ref_table, ref_value, initial, change)
          ref_table[ref_value] = initial + #context.removed*change
        end,
        message_key = 'a_xmult',
      })
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
  attributes = {"tboj_devil", "xmult", "scaling", "boos_blind", "reset"}
}

-- Cambion Conception
-- Immaculate Conception
-- More Options
-- Crown of Light
SMODS.Joker {
  key = "crown_of_light",
  pos = {x = 9, y = 27},
  config = {extra = {Xmult_multi = 2}},
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
    if context.first_hand_drawn and not context.blueprint then
      local eval = function() return G.GAME.current_round.hands_played == 0 and not G.RESET_JIGGLES end
      juice_card_until(card, eval, true)
    end

    if context.individual and context.cardarea == G.play and G.GAME.current_round.hands_played == 0 then
      return {
        xmult = card.ability.extra.Xmult_multi
      }
    end
  end,
  in_pool = function (self, args)
    return TBOJ.in_pool(self, args)
  end,
  attributes = {"tboj_angel", "xmult", "hands"}
}