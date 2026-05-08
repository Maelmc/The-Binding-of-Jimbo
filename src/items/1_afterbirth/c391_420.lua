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