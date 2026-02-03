SMODS.Scoring_Parameter({
  key = 'tboj_balance_percent',
  default_value = 0,
  juice_on_update = true,
  calculation_keys = { 'tboj_balance_percent' },
  calc_effect = function(self, effect, scored_card, key, amount, from_edition)
    if (key == 'tboj_balance_percent') and amount ~= 0 then
      if effect.card then juice_card(effect.card) end
      local to_percent = amount / 100
      if SMODS.Scoring_Parameters then
        local mult = SMODS.Scoring_Parameters["mult"]
        local chips = SMODS.Scoring_Parameters["chips"]
        local percentage_mult = mult.current * to_percent
        local percentage_chips = chips.current * to_percent
        local balance = (percentage_mult + percentage_chips) / 2
        mult:modify(-percentage_mult + balance)
        chips:modify(-percentage_chips + balance)
      else
        local percentage_mult = mult * to_percent
        local percentage_chips = hand_chips * to_percent
        local balance = (percentage_mult + percentage_chips) / 2
        mult = mult - percentage_mult + balance
        hand_chips = hand_chips - percentage_chips + balance
        update_hand_text({ delay = 0 }, { chips = hand_chips, mult = mult })
      end
      G.E_MANAGER:add_event(Event({
        func = (function()
          -- scored_card:juice_up()
          play_sound('gong', 0.94, 0.3)
          play_sound('gong', 0.94*1.5, 0.2)
          play_sound('tarot1', 1.5)
          ease_colour(G.C.UI_CHIPS, {0.8, 0.45, 0.85, 1})
          ease_colour(G.C.UI_MULT, {0.8, 0.45, 0.85, 1})
          G.E_MANAGER:add_event(Event({
            trigger = 'after',
            blockable = false,
            blocking = false,
            delay =  0.8,
            func = (function() 
              ease_colour(G.C.UI_CHIPS, G.C.BLUE, 0.8)
              ease_colour(G.C.UI_MULT, G.C.RED, 0.8)
              return true
            end)
          }))
          G.E_MANAGER:add_event(Event({
            trigger = 'after',
            blockable = false,
            blocking = false,
            no_delete = true,
            delay =  1.3,
            func = (function() 
              G.C.UI_CHIPS[1], G.C.UI_CHIPS[2], G.C.UI_CHIPS[3], G.C.UI_CHIPS[4] = G.C.BLUE[1], G.C.BLUE[2], G.C.BLUE[3], G.C.BLUE[4]
              G.C.UI_MULT[1], G.C.UI_MULT[2], G.C.UI_MULT[3], G.C.UI_MULT[4] = G.C.RED[1], G.C.RED[2], G.C.RED[3], G.C.RED[4]
              return true
            end)
          }))
          return true
        end)
      }))

      if not effect.remove_default_message then
        if effect.balance_message then
          card_eval_status_text(effect.message_card or effect.juice_card or scored_card or effect.card or effect.focus, 'extra', nil, percent, nil, effect.balance_message)
        else
          card_eval_status_text(effect.message_card or effect.juice_card or scored_card or effect.card or effect.focus, 'extra', nil, percent, nil, {message = localize{type = 'variable', key = 'tboj_percent', vars = { amount }}, colour =  {0.8, 0.45, 0.85, 1}})
        end
      end
      return true
    end
  end,
  modify = function(self, amount, skip)
    if not skip then mult = mod_mult(self.current + amount) end
    self.current = (mult or 0) + (skip or 0)
    update_hand_text({ delay = 0 }, { mult = self.current })
  end
})

SMODS.current_mod.set_debuff = function(card)
   if (G.GAME and G.GAME.blind and G.GAME.blind.name == "bl_tboj_siren" and not G.GAME.blind.disabled) and card.config and card.config.center and card.config.center.familiar then return true end
   return false
end

