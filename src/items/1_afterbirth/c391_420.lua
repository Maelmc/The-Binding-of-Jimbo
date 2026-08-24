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
  attributes = {"tboj_devil", "destroy_card"}
}

-- Zodiac
SMODS.Joker {
  key = "zodiac",
  pos = {x = 1, y = 26},
  config = {extra = {triggered = false}},
  loc_vars = function(self, info_queue, card)
    return {vars = {}}
  end,
  rarity = 1,
  cost = 5,
  atlas = "jokers",
  perishable_compat = true,
  eternal_compat = true,
  blueprint_compat = false,
  calculate = function(self, card, context)
    if context.setting_blind and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
      G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
      G.E_MANAGER:add_event(Event({
        func = (function()
          G.E_MANAGER:add_event(Event({
            func = function()
              SMODS.add_card {
                set = 'Planet',
                key_append = 'tboj_zodiac' -- Optional, useful for manipulating the random seed and checking the source of the creation in `in_pool`.
              }
              G.GAME.consumeable_buffer = 0
              return true
            end
          }))
          SMODS.calculate_effect({ message = localize('k_plus_planet'), colour = G.C.BLUE },
            context.blueprint_card or card)
          return true
        end)
      }))
      return nil, true -- This is for Joker retrigger purposes
    end
  end,
  in_pool = function (self, args)
    return TBOJ.in_pool(self, args)
  end,
  attributes = {"planet", "generation", "space"}
}

-- Serpent's Kiss
-- Marked
SMODS.Joker {
  key = "marked",
  pos = {x = 3, y = 26 },
  config = { extra = { chips_mod = 40 } },
  loc_vars = function(self, info_queue, card)
    local targets = {G.GAME.current_round.tboj_marked_card1, G.GAME.current_round.tboj_marked_card2, G.GAME.current_round.tboj_marked_card3}
    table.sort(targets, function(a,b) return a.id > b.id end)
    return { vars = {
      localize((targets[1] or {}).rank or 'Ace', 'ranks'),
      localize((targets[2] or {}).rank or 'King', 'ranks'),
      localize((targets[3] or {}).rank or 'Queen', 'ranks'),
      card.ability.extra.chips_mod
    } }
  end,
  rarity = 1,
  cost = 4,
  atlas = "jokers",
  perishable_compat = true,
  eternal_compat = true,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play and
    (context.other_card:get_id() == G.GAME.current_round.tboj_marked_card1.id or
    context.other_card:get_id() == G.GAME.current_round.tboj_marked_card2.id or
    context.other_card:get_id() == G.GAME.current_round.tboj_marked_card3.id) then
      return {
        chips = card.ability.extra.chips_mod
      }
    end
  end,
  attributes = {"rank", "chips"}
}

-- Tech X
-- Ventricle Razor

-- Fart Baby
-- GB Bug
-- D8
TBOJ.Active {
  key = "d8",
  pos = { x = 0, y = 27 },
  cost = 5,
  config = {extra = {max_charge = 2, curr_charge = 2, min = -2, max = 2}},
  loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.curr_charge, card.ability.extra.max_charge, card.ability.extra.min, card.ability.extra.max}}
  end,
  calculate = function(self, card, context)
    TBOJ.eor_charge(card,context)
  end,
  can_use = function(self, card)
    return card.ability.extra.curr_charge >= card.ability.extra.max_charge
  end,
  use = function(self, card, area, copier)
    local _hands = pseudorandom("tboj_d8", card.ability.extra.min, card.ability.extra.max)
    if _hands + G.GAME.round_resets.hands >= 1 and _hands + G.GAME.current_round.hands_left >= 1 then
      G.GAME.round_resets.hands = G.GAME.round_resets.hands + _hands
      ease_hands_played(_hands)
      if _hands >= 0 then
        SMODS.calculate_effect({message = localize {type = 'variable', key = 'a_hands', vars = { _hands }}, colour = G.C.BLUE}, card)
      else
        SMODS.calculate_effect({message = localize {type = 'variable', key = 'tboj_hands_minus', vars = { _hands * -1 }}, colour = G.C.BLUE}, card)
      end
    else
      SMODS.calculate_effect({message = localize {type = 'variable', key = 'a_hands', vars = { 0 }}, colour = G.C.BLUE}, card)
    end

    local _discards = pseudorandom("tboj_d8", card.ability.extra.min, card.ability.extra.max)
    if _discards + G.GAME.round_resets.discards >= 1 and _discards + G.GAME.current_round.discards_left >= 1 then
      G.GAME.round_resets.discards = G.GAME.round_resets.discards + _discards
      ease_discard(_discards)
      if _discards >= 0 then
        SMODS.calculate_effect({message = localize {type = 'variable', key = 'tboj_discards', vars = { _discards }}, colour = G.C.RED}, card)
      else
        SMODS.calculate_effect({message = localize {type = 'variable', key = 'tboj_discards_minus', vars = { _discards * -1 }}, colour = G.C.RED}, card)
      end
    else
      SMODS.calculate_effect({message = localize {type = 'variable', key = 'tboj_discards', vars = { 0 }}, colour = G.C.RED}, card)
    end

    local _hand_size = pseudorandom("tboj_d8", card.ability.extra.min, card.ability.extra.max)
    if _hand_size + G.hand.config.card_limit >= 1 then
      G.hand:change_size(_hand_size)
      if _hand_size >= 0 then
        SMODS.calculate_effect({message = localize {type = 'variable', key = 'a_handsize', vars = { _hand_size }}}, card)
      else
        SMODS.calculate_effect({message = localize {type = 'variable', key = 'a_handsize_minus', vars = { _hand_size * -1 }}}, card)
      end
    else
      SMODS.calculate_effect({message = localize {type = 'variable', key = 'a_handsize', vars = { 0 }}}, card)
    end
  end,
  keep_on_use = function(self, card)
    return true
  end,
  in_pool = function(self)
    return TBOJ.in_pool(self)
  end,
  attributes = {"hands", "discards", "hand_size"},
  tboj_designer = "hagma1"
}

-- Purity
-- Athame

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
  atlas = "jokers",
  pos = {x = 9, y = 27},
  soul_atlas = "soul_jokers",
  soul_pos = {x = 9, y = 27},
  config = {extra = {Xmult_multi = 2}},
  loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.Xmult_multi}}
  end,
  rarity = 4,
  cost = 20,
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