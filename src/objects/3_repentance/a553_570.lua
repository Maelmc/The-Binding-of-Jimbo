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
          card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.Xmult_mod * _hands
          SMODS.calculate_effect( { message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.Xmult } } }, card)
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