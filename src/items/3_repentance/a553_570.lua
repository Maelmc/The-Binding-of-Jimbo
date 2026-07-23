-- Nancy Bombs
-- A Bar of Soap
-- Blood Puppy
SMODS.Joker {
  key = "blood_puppy",
  pos = {x = 0, y = 1},
  config = {extra = {stage = 1, Xmult = 2, Xmult1 = 3, destroy1 = 1, Xmult2 = 4, destroy2 = 3, rounds = 2}},
  loc_vars = function(self, info_queue, card)
    if card.ability.extra.stage == 1 then
      return {vars = {card.ability.extra.Xmult, card.ability.extra.rounds, card.ability.extra.rounds == 1 and "" or "s"}}
    elseif card.ability.extra.stage == 2 then
      return {vars = {card.ability.extra.Xmult1, card.ability.extra.destroy1, card.ability.extra.rounds, card.ability.extra.rounds == 1 and "" or "s"}, key = "j_tboj_blood_puppy_2"}
    else
      return {vars = {card.ability.extra.Xmult2, card.ability.extra.destroy2}, key = "j_tboj_blood_puppy_3"}
    end
  end,
  rarity = 3,
  cost = 8,
  atlas = "multisprites",
  perishable_compat = true,
  eternal_compat = true,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.scoring_hand and context.joker_main then
      if card.ability.extra.stage == 1 then
        return {
          xmult = card.ability.extra.Xmult
        }
      elseif card.ability.extra.stage == 2 then
        return {
          xmult = card.ability.extra.Xmult1
        }
      else
        return {
          xmult = card.ability.extra.Xmult2
        }
      end
    end

    if context.after and card.ability.extra.stage > 1 and #context.full_hand > 0 then
      -- taken from vanilla remade immolate
      local todestroy = card.ability.extra.stage == 2 and card.ability.extra.destroy1 or card.ability.extra.destroy2
      local destroyed_cards = {}
      local temp_hand = {}

      for _, playing_card in ipairs(context.full_hand) do
        if not playing_card.getting_sliced then
          temp_hand[#temp_hand + 1] = playing_card
        end
      end
      table.sort(temp_hand,
        function(a, b)
          return not a.playing_card or not b.playing_card or a.playing_card < b.playing_card
        end
      )

      pseudoshuffle(temp_hand, 'tboj_blood_puppy')

      for i = 1, todestroy do destroyed_cards[#destroyed_cards + 1] = temp_hand[i] end

      G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0.4,
        func = function()
          play_sound('tarot1')
          local target = context.blueprint and context.blueprint_card or card
          target:juice_up(0.3, 0.5)
          return true
        end
      }))
      SMODS.destroy_cards(destroyed_cards)

      return nil, true
    end

    if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
      if G.GAME.current_round.hands_left == 0 and card.ability.extra.stage > 1 then
        G.E_MANAGER:add_event(Event({
          func = function()
            card.ability.extra.stage = card.ability.extra.stage - 1
            card.ability.extra.rounds = 2
            SMODS.calculate_effect({message = localize("tboj_tamed_ex")}, card)
            self:set_sprites(card)
            return true
          end
        }))
      elseif card.ability.extra.stage < 3 then
        if card.ability.extra.rounds == 1 then
          G.E_MANAGER:add_event(Event({
            func = function()
              card.ability.extra.stage = card.ability.extra.stage + 1
              card.ability.extra.rounds = 2
              SMODS.calculate_effect({message = localize("tboj_angry_ex")}, card)
              self:set_sprites(card)
              return true
            end
          }))
        else
          SMODS.calculate_effect({message = localize("tboj_growing_dot")}, card)
          card.ability.extra.rounds = card.ability.extra.rounds - 1
        end
      end

      return nil, true
    end
  end,
  in_pool = function (self, args)
    return TBOJ.in_pool(self, args)
  end,
  set_sprites = function(self,card,front)
    if not (TBOJ.is_in_collection(card) and not card.discovered) then
      card.children.center:set_sprite_pos({x = (card.ability and card.ability.extra and card.ability.extra.stage or 1) - 1, y = 1})
    end
  end,
  attributes = {"tboj_familiar", "tboj_devil", "xmult", "destroy_card"}
}

-- Dream Catcher
SMODS.Joker {
  key = "dream_catcher",
  pos = {x = 10, y = 37},
  config = {extra = {}},
  loc_vars = function(self, info_queue, card)
    if TBOJ.is_in_collection(card) then
      --print("not in game")
      return {vars = {localize("tboj_unknown")}}
    end
    if not TBOJ.table_contains(G.jokers.cards,card) then
      --print("not owned")
      return {vars = {localize("tboj_acquire_to_reveal")}}
    end
    local blind = TBOJ.predict_next_boss()
    if blind then
      return {vars = {localize{type ='name_text', key = blind, set = 'Blind'}}}
    else
      --print("cant find blind")
      return {vars = {localize("tboj_unknown")}}
    end
  end,
  rarity = 1,
  cost = 4,
  atlas = "jokers",
  perishable_compat = true,
  eternal_compat = true,
  blueprint_compat = false,
  calculate = function(self, card, context)
  end,
  in_pool = function (self, args)
    return TBOJ.in_pool(self, args)
  end,
  attributes = {"passive", "boss_blind"},
}

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
  attributes = {"tboj_angel", "hand", "chips", "scaling", "reset"}
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
  attributes = {"tboj_devil", "tboj_familiar", "xmult", "hand", "reset", "scaling"}
}

-- 570