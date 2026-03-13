-- Paschal Candle
SMODS.Joker {
  key = "paschal_candle",
  pos = {x = 11, y = 37 },
  config = {extra = {chips = 0, chips_mod = 30}},
  loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.chips_mod, card.ability.extra.chips}}
  end,
  rarity = 1,
  cost = 4,
  atlas = "jokers",
  perishable_compat = false,
  eternal_compat = true,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.before and not context.blueprint and card.ability.extra.chips > 0 and G.GAME.current_round.hands_played > 0 then
      card.ability.extra.chips = 0
      return {
        message = localize('k_reset'),
        colour = G.C.BLUE
      }
    end

    if context.joker_main then
      return {
        chips = card.ability.extra.chips,
      }
    end

    if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint and G.GAME.current_round.hands_played == 1 then
      SMODS.scale_card(card, {
        ref_value = 'chips',
        scalar_value = 'chips_mod',
      })
    end
  end,
  in_pool = function (self, args)
    return TBOJ.in_pool(self, args)
  end,
  angel = true,
}

-- 568
-- Blood Oath
SMODS.Joker {
  key = "blood_oath",
  pos = {x = 13, y = 37 },
  config = {extra = {Xmult = 1, Xmult_mod = 1}},
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
    if context.joker_main then
      return {
        xmult = card.ability.extra.Xmult,
      }
    end

    if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint and card.ability.extra.Xmult > 1 then
      card.ability.extra.Xmult = 1
      return {
        message = localize('k_reset'),
        colour = G.C.RED
      }
    end

    if context.setting_blind and not context.blueprint then
      G.E_MANAGER:add_event(Event({
        func = function()
          local _hands = G.GAME.current_round.hands_left-1
          ease_hands_played(-_hands,true)
          SMODS.scale_card(card, {
            ref_value = 'Xmult',
            scalar_value = 'Xmult_mod',
            operation = function(ref_table, ref_value, initial, change)
              ref_table[ref_value] = initial + _hands*change
            end,
            message_key = 'a_xmult',
          })
          return true
        end
      }))
    end
  end,
  in_pool = function (self, args)
    return TBOJ.in_pool(self, args)
  end,
  devil = true,
}

-- 570