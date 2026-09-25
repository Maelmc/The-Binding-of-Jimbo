-- Orphan Socks
SMODS.Joker {
  key = "orphan_socks",
  pos = {x = 0, y = 38 },
  config = {extra = {chips = 0, chip_mod = 6}},
  loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.chip_mod, card.ability.extra.chips}}
  end,
  rarity = 2,
  cost = 6,
  atlas = "jokers",
  perishable_compat = false,
  eternal_compat = true,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.before and not context.blueprint and next(context.poker_hands['Pair']) then
      SMODS.scale_card(card, {
        ref_value = 'chips',
        scalar_value = 'chip_mod',
      })
      return nil, true
    end
    if context.joker_main then
      return {
        chips = card.ability.extra.chips
      }
    end
  end,
  in_pool = function (self, args)
    return TBOJ.in_pool(self, args)
  end,
  attributes = {"chips", "hand_type", "scaling"},
}

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

-- Alabaster Box
-- The Stairway
-- Sol
SMODS.Joker {
  key = "sol",
  pos = {x = 2, y = 39 },
  config = { extra = { Xmult = 1, Xmult_mod = 0.2 } },
  loc_vars = function(self, info_queue, card)
    local _hands = {n = G.UIT.C, config = { align = "m" }, nodes = {}}
    for k, v in pairs(G.GAME.hands) do
      if v.played_this_ante and v.played_this_ante > 0 then
        _hands.nodes[#_hands.nodes+1] = {
          n = G.UIT.R,
          config = { align = "m" },
          nodes = {{
            n = G.UIT.T,
            config = {
              align = "m",
              text = localize(k, 'poker_hands'),
              colour = G.C.FILTER,
              scale = 0.32
            }
          }}
        }
      end
    end
    info_queue[#info_queue+1] = {set = 'Other', key = 'tboj_element', vars = {localize("tboj_hands_played"), elements = {_hands}}}
    return { vars = { card.ability.extra.Xmult_mod, card.ability.extra.Xmult } }
  end,
  rarity = 3,
  cost = 8,
  atlas = "jokers",
  perishable_compat = true,
  eternal_compat = true,
  blueprint_compat = true,
  calculate = function(self, card, context)

    if context.before and G.GAME.hands[context.scoring_name].played_this_ante == 1 and not context.blueprint then
      return {
        message = localize("tboj_unique")
      }
    end

    if context.joker_main then
      return {
        xmult = card.ability.extra.Xmult
      }
    end

    if context.end_of_round and context.beat_boss and context.game_over == false and context.main_eval and not context.blueprint then
      local hands = 0
      for _, v in pairs(G.GAME.hands) do
        if v.played_this_ante and v.played_this_ante > 0 then
          hands = hands + 1
        end
      end

      if hands > 0 then
        SMODS.scale_card(card, {
          ref_value = 'Xmult',
          scalar_value = 'Xmult_mod',
          operation = function(ref_table, ref_value, initial, change)
            ref_table[ref_value] = initial + hands*change
          end,
          message_key = 'a_xmult',
        })
        return nil, true
      end
    end
  end,
  attributes = {"space", "hand_type", "xmult", "boss_blind", "scaling"}
}

-- Luna
SMODS.Joker {
  key = "luna",
  pos = {x = 3, y = 39 },
  config = { extra = { level = 2, hands = {"Five of a Kind", "Flush House", "Flush Five"} } },
  loc_vars = function(self, info_queue, card)
    local vars = {}
    for _, v in ipairs(card.ability.extra.hands) do
      vars[#vars+1] = localize(v, 'poker_hands')
    end
    vars[#vars+1] = card.ability.extra.level

    return { vars = vars }
  end,
  rarity = 3,
  cost = 8,
  atlas = "jokers",
  perishable_compat = true,
  eternal_compat = true,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.before and TBOJ.table_contains(card.ability.extra.hands, context.scoring_name) then
      return {
        level_up = card.ability.extra.level
      }
    end
  end,
  in_pool = function (self, args)
    for _, v in pairs(self.config.extra.hands) do
      if G.GAME.hands[v] and G.GAME.hands[v].played and G.GAME.hands[v].played > 0 then
        return true
      end
    end
    return false
  end,
  attributes = {"space", "hand_type", "hand_level"}
}

-- Mercurius
SMODS.Joker {
  key = "mercurius",
  pos = {x = 4, y = 39 },
  config = { extra = { h_size = 1, per_skip = 1} },
  loc_vars = function(self, info_queue, card)
    return { vars = {card.ability.extra.h_size, card.ability.extra.per_skip, card.ability.extra.h_size} }
  end,
  rarity = 3,
  cost = 8,
  atlas = "jokers",
  perishable_compat = true,
  eternal_compat = true,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.before and context.scoring_name == "Pair" then
      G.hand:change_size(card.ability.extra.h_size)
      G.GAME.round_resets.temp_handsize = (G.GAME.round_resets.temp_handsize or 0) + card.ability.extra.h_size
      return {
        message = localize{type='variable', key='a_handsize', vars={card.ability.extra.h_size}}
      }
    end

    if context.skip_blind and not context.blueprint then
      SMODS.scale_card(card, {
        ref_value = 'h_size',
        scalar_value = 'per_skip',
        message_key = 'a_handsize',
      })
      return nil, true
    end
  end,
  attributes = {"space", "hand_type", "hand_size", "skip", "scaling"}
}

-- Venus
SMODS.Joker {
  key = "venus",
  pos = {x = 5, y = 39 },
  config = { extra = { chips = 30, mult = 7, xmult = 1.5, money = 2} },
  loc_vars = function(self, info_queue, card)
    return { vars = {card.ability.extra.chips, card.ability.extra.xmult, card.ability.extra.mult, card.ability.extra.money} }
  end,
  rarity = 3,
  cost = 8,
  atlas = "jokers",
  perishable_compat = true,
  eternal_compat = true,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play and context.scoring_name == "Three of a Kind" then
      local res = {}

      if context.other_card:is_suit("Spades") then
        res.chips = card.ability.extra.chips
      end

      if context.other_card:is_suit("Hearts") then
        res.xmult = card.ability.extra.xmult
      end

      if context.other_card:is_suit("Clubs") then
        res.mult = card.ability.extra.mult
      end

      if context.other_card:is_suit("Diamonds") then
        res.dollars = card.ability.extra.money
      end

      return res
    end
  end,
  attributes = {"space", "hand_type", "suit", "spades", "hearts", "clubs", "diamonds", "chips", "mult", "xmult", "economy"}
}

-- Terra
-- Mars
-- Jupiter
-- Saturnus
-- Uranus
SMODS.Joker {
  key = "uranus",
  pos = {x = 10, y = 39 },
  config = { extra = { } },
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue + 1] = G.P_CENTERS.m_glass
    return { vars = {} }
  end,
  rarity = 3,
  cost = 8,
  atlas = "jokers",
  perishable_compat = true,
  eternal_compat = true,
  blueprint_compat = false,
  calculate = function(self, card, context)
    if context.destroying_card and context.scoring_name == "Two Pair" and not SMODS.has_enhancement(context.destroying_card,"m_glass") and not context.blueprint then
      return {
        remove = true
      }
    end

    if context.remove_playing_cards and context.removed then
      local _r = context.removed
      G.E_MANAGER:add_event(Event({
      func = function()
        for _, v in ipairs(_r) do
          G.E_MANAGER:add_event(Event({
            func = function()
              if not SMODS.has_enhancement(v,"m_glass") then
                TBOJ.juice_flip_cards({v})
                G.E_MANAGER:add_event(Event({
                  func = function()
                    v:set_ability(G.P_CENTERS.m_glass)
                    return true
                  end
                }))
                TBOJ.juice_flip_cards({v}, nil, true)
              end
              return true
            end
          }))
        end
        return true
      end
    }))
    end
  end,
  attributes = {"space", "hand_type", "glass", "destroy_card"}
}

-- Neptunus
SMODS.Joker {
  key = "neptunus",
  pos = {x = 11, y = 39 },
  config = { extra = { repetitions = 1 } },
  loc_vars = function(self, info_queue, card)
    return { vars = {card.ability.extra.repetitions,
    card.ability.extra.repetitions + (math.max(G.GAME.current_round.hands_left, 1)) - 1,
    (card.ability.extra.repetitions + (math.max(G.GAME.current_round.hands_left, 1)) - 1) == 1 and "" or "s"} }
  end,
  rarity = 3,
  cost = 8,
  atlas = "jokers",
  perishable_compat = true,
  eternal_compat = true,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.repetition and context.cardarea == G.play and context.scoring_name == "Straight Flush" then
      return {
        repetitions = card.ability.extra.repetitions + G.GAME.current_round.hands_left
      }
    end
  end,
  attributes = {"space", "hand_type", "hands", "retrigger"}
}

-- Pluto
SMODS.Joker {
  key = "pluto",
  pos = {x = 12, y = 39 },
  config = { extra = { } },
  loc_vars = function(self, info_queue, card)
    if not G.hand or not G.hand.highlighted or #G.hand.highlighted == 0 then
      return { vars = {1}}
    end

    local _,_,_,_,disp_text = G.FUNCS.get_poker_hand_info(G.hand.highlighted)
    if not disp_text == "High Card" then
      return { vars = {1}}
    end

    local min_rank_pos = 1
    local min_rank = 99999999
    local any_lowest = false
    for i, v in ipairs(G.hand.highlighted) do
      if not SMODS.has_no_rank(v) and v:get_id() < min_rank then
        min_rank = v:get_id()
        min_rank_pos = i
        any_lowest = true
      end
    end

    if any_lowest then
      local tot_chips = 0
      for k, v in pairs(G.hand.highlighted) do
        if k ~= min_rank_pos then
          tot_chips = tot_chips + TBOJ.total_chips(v)
        end
      end
      return { vars = {math.max(tot_chips ^ (1 / 3),1)} }
    end

    return { vars = {1} }
  end,
  rarity = 3,
  cost = 8,
  atlas = "jokers",
  perishable_compat = true,
  eternal_compat = true,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.modify_scoring_hand and context.in_scoring and not context.blueprint_card then
      local _,_,_,_,disp_text = G.FUNCS.get_poker_hand_info(context.full_hand)
      if disp_text == "High Card" then
        local min_rank_pos = 1
        local min_rank = 99999999
        local any_lowest = false
        for i, v in ipairs(context.full_hand) do
          if not SMODS.has_no_rank(v) and v:get_id() < min_rank then
            min_rank = v:get_id()
            min_rank_pos = i
            any_lowest = true
          end
        end

        if any_lowest and context.other_card == context.full_hand[min_rank_pos] then
          context.other_card.tboj_pluto = true
          return {
            add_to_hand = true
          }
        end

        context.other_card.tboj_pluto = nil
        if not SMODS.always_scores(context.other_card) then
          return {
            remove_from_hand = true
          }
        end
      end
    end

    if context.individual and context.cardarea == G.play and context.scoring_name == "High Card" and context.other_card.tboj_pluto then
      local tot_chips = 0
      for _, v in pairs(context.full_hand) do
        if not v.tboj_pluto then
          tot_chips = tot_chips + TBOJ.total_chips(v)
        end
      end

      return {
        xmult = math.max(tot_chips ^ (1 / 3), 1)
      }
    end

    if context.after then
      for _, v in pairs(context.full_hand) do
        v.tboj_pluto = nil
      end
    end
  end,
  attributes = {"space", "hand_type", "hands", "xmult", "passive"}
}

-- Voodoo Head
-- Eye Drops