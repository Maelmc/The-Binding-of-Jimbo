-- Betrayal
SMODS.Joker {
  key = "betrayal",
  pos = {x = 0, y = 26},
  config = {extra = {triggered = false}},
  loc_vars = function(self, info_queue, card)
    return {vars = {}}
  end,
  rarity = 2,
  cost = 6,
  atlas = "jokers",
  perishable_compat = true,
  eternal_compat = true,
  blueprint_compat = false,
  calculate = function(self, card, context)
    if context.destroy_card and not context.blueprint and not card.ability.extra.triggered and G.GAME.current_round.hands_played == 0 then
      local pos = 1
      for k, v in ipairs(context.scoring_hand) do
        if v == context.destroy_card then pos = k break end
      end
      
      if context.scoring_hand[pos+1] and TBOJ.total_chips(context.destroy_card) < TBOJ.total_chips(context.scoring_hand[pos+1]) then
        card.ability.extra.triggered = true
        return {
          remove = true,
          message = localize("tboj_betrayal_ex")
        }
      end
    end

    if context.setting_blind and not context.blueprint then card.ability.extra.triggered = false end
  end,
  in_pool = function (self, args)
    return TBOJ.in_pool(self, args)
  end,
  devil = true,
}

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
        message_colour = G.C.XMULT
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
  devil = true,
}