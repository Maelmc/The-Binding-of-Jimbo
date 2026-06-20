-- Spelunker Hat
-- Super Bandage
-- The Gamekid
-- Sack of Pennies
-- Robo-Baby
SMODS.Joker {
  key = "robo_baby",
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue + 1] = G.P_CENTERS.m_tboj_laser
    return {vars = {}}
  end,
  rarity = 2,
  cost = 6,
  atlas = "jokers",
  pos = { x = 4, y = 6 },
  calculate = function(self, card, context)
      if context.first_hand_drawn then
          local _card = SMODS.create_card { set = "Base", enhancement = "m_tboj_laser", area = G.discard }
          G.playing_card = (G.playing_card and G.playing_card + 1) or 1
          _card.playing_card = G.playing_card
          table.insert(G.playing_cards, _card)

          G.E_MANAGER:add_event(Event({
              func = function()
                  G.hand:emplace(_card)
                  _card:start_materialize()
                  G.GAME.blind:debuff_card(_card)
                  G.hand:sort()
                  if context.blueprint_card then
                      context.blueprint_card:juice_up()
                  else
                      card:juice_up()
                  end
                  SMODS.calculate_context({ playing_card_added = true, cards = { _card } })
                  save_run()
                  return true
              end
          }))

          return nil, true -- This is for Joker retrigger purposes
      end
  end,
  attributes = {"tboj_familiar", "enhancements", "generation"}
}

-- Little C.H.A.D.
SMODS.Joker {
  key = "little_chad",
  pos = { x = 5, y = 6 },
  config = {extra = {mult_mod = 1}},
  loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.mult_mod}}
  end,
  rarity = 1,
  cost = 5,
  atlas = "jokers",
  perishable_compat = true,
  eternal_compat = true,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play and context.other_card:is_suit("Hearts") then
      return {
        mult = card.ability.extra.mult_mod + card.ability.extra.mult_mod * G.GAME.current_round.hands_left
      }
    end
  end,
  in_pool = function (self, args)
    return TBOJ.in_pool(self, args)
  end,
  attributes = {"tboj_familiar", "mult", "hearts", "hands", "suit"}
}

-- The Book of Sin
TBOJ.Active {
  key = "the_book_of_sin",
  pos = { x = 6, y = 6 },
  cost = 6,
  config = {extra = {max_charge = 1, curr_charge = 1}},
  loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.curr_charge, card.ability.extra.max_charge}}
  end,
  calculate = function(self, card, context)
    TBOJ.eor_charge(card,context)
  end,
  can_use = function(self, card)
    return card.ability.extra.curr_charge >= card.ability.extra.max_charge and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit
  end,
  use = function(self, card, area, copier)
    G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
    G.E_MANAGER:add_event(Event({
      trigger = 'after',
      delay = 0.4,
      func = function()
        G.GAME.consumeable_buffer = 0
        play_sound('timpani')
        SMODS.add_card({ set = 'Loot', key_append = "tboj_the_book_of_sin" })
        SMODS.calculate_effect({message = localize('tboj_plus_loot'), colour = G.C.TBOJ.LOOT}, card)
        return true
      end
    }))
  end,
  keep_on_use = function(self, card)
    return true
  end,
  in_pool = function(self)
    return TBOJ.in_pool(self)
  end,
  attributes = {"tboj_book", "tboj_devil", "tboj_loot", "generation"}
}

-- The Relic
SMODS.Joker {
  key = "the_relic",
  pos = { x = 7, y = 6 },
  config = {extra = {}},
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue + 1] = G.P_CENTERS.c_tboj_soul_heart
    return {vars = {}}
  end,
  rarity = 1,
  cost = 6,
  atlas = "jokers",
  perishable_compat = true,
  eternal_compat = true,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.end_of_round and context.game_over == false and context.main_eval then 
      if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
        G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
        G.E_MANAGER:add_event(Event({
          func = (function()
            G.E_MANAGER:add_event(Event({
              func = (function()
                play_sound('timpani')
                SMODS.add_card({ set = 'Loot', key = "c_tboj_soul_heart" })
                card:juice_up(0.3, 0.5)
                G.GAME.consumeable_buffer = 0
                return true
              end)
            }))
            SMODS.calculate_effect({ message = localize('tboj_plus_loot'), colour = G.C.TBOJ.LOOT }, context.blueprint_card or card)
            return true
          end)
        }))
      end
    end
  end,
  in_pool = function (self, args)
    return TBOJ.in_pool(self, args)
  end,
  attributes = {"tboj_angel", "tboj_familiar", "generation", "tboj_loot"}
}

-- Little Gish
-- Little Steven
SMODS.Joker {
  key = "little_steven",
  pos = {x = 9, y = 6},
  config = {extra = {mult = 10}},
  loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.mult}}
  end,
  rarity = 1,
  cost = 3,
  atlas = "jokers",
  perishable_compat = true,
  eternal_compat = true,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.joker_main and #context.full_hand > #context.scoring_hand then
      return {
        mult = card.ability.extra.mult,
      }
    end
  end,
  in_pool = function (self, args)
    return TBOJ.in_pool(self, args)
  end,
  attributes = {"mult", "tboj_familiar"}
}

-- The Halo 
SMODS.Joker {
  key = "the_halo",
  pos = { x = 10, y = 6 },
  config = {extra = {chips = 20, mult = 3, money = 1}},
  loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.chips, card.ability.extra.mult, card.ability.extra.money}}
  end,
  rarity = 1,
  cost = 5,
  atlas = "jokers",
  perishable_compat = true,
  eternal_compat = true,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.joker_main then
      return {
        chips = card.ability.extra.chips,
        mult = card.ability.extra.mult,
      }
    end
  end,
  calc_dollar_bonus = function(self, card)
    return card.ability.extra.money
	end,
  in_pool = function (self, args)
    return TBOJ.in_pool(self, args)
  end,
  attributes = {"tboj_angel", "chips", "mult", "economy"}
}

-- Mom's Bottle of Pills
-- The Common Cold
-- The Parasite
-- The D6
TBOJ.Active {
  key = "the_d6",
  pos = { x = 14, y = 6 },
  --rarity = "Common",
  cost = 6,
  config = {extra = {max_charge = 1, curr_charge = 1}},
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue+1] = {set = 'Other', key = 'tboj_reroll'}
    return {vars = {card.ability.extra.curr_charge, card.ability.extra.max_charge}}
  end,
  calculate = function(self, card, context)
    TBOJ.eor_charge(card,context)
  end,
  can_use = function(self, card)
    return card.ability.extra.curr_charge >= card.ability.extra.max_charge and
    ((G.shop_jokers and G.shop_jokers.cards and #G.shop_jokers.cards > 0)
    or (G.pack_cards and G.pack_cards.cards and #G.pack_cards.cards > 0))
  end,
  use = function(self, card, area, copier)
    if G.pack_cards and G.pack_cards.cards and #G.pack_cards.cards > 0 then
      for _, v in pairs(G.pack_cards.cards) do
        if v.ability.set == "Joker" or v.ability.set == "tboj_active" then
          TBOJ.reroll(v,TBOJ.get_random_key({set = v.ability.set, seed = "d6" .. G.GAME.round_resets.ante, target_rarities = {v.config.center.rarity}}))
        end
      end
    else
      for _, v in pairs(G.shop_jokers.cards) do
        if v.ability.set == "Joker" or v.ability.set == "tboj_active" then
          TBOJ.reroll(v,TBOJ.get_random_key({set = v.ability.set, seed = "d6" .. G.GAME.round_resets.ante, target_rarities = {v.config.center.rarity}}))
        end
      end
    end
  end,
  keep_on_use = function(self, card)
    return true
  end,
  in_pool = function(self)
    return TBOJ.in_pool(self)
  end,
  attributes = {"joker"}
}

-- 106
-- 107
-- 108
-- Money = Power
SMODS.Joker {
  key = "money_equal_power",
  pos = {x = 3, y = 7},
  config = {extra = {Xmult = 0.03, money_threshold = 2}},
  loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.Xmult, card.ability.extra.money_threshold, 1 + card.ability.extra.Xmult*math.floor((G.GAME.dollars + (G.GAME.dollar_buffer or 0))/card.ability.extra.money_threshold)}}
  end,
  rarity = 2,
  cost = 7,
  atlas = "jokers",
  perishable_compat = true,
  eternal_compat = true,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.cardarea == G.jokers and context.scoring_hand then
      if context.joker_main then
        local Xmult = 1 + card.ability.extra.Xmult*math.floor((G.GAME.dollars + (G.GAME.dollar_buffer or 0))/card.ability.extra.money_threshold)
        local can_score = nil
        if (SMODS.Mods["Talisman"] or {}).can_load then
          can_score = to_big(Xmult) > to_big(1)
        else
          can_score = Xmult > 1
        end
        if can_score then
          return {
            message = localize{type = 'variable', key = 'a_xmult', vars = {Xmult}}, 
            colour = G.C.MULT,
            Xmult_mod = Xmult
          }
        end
      end
    end
  end,
  in_pool = function (self, args)
    return TBOJ.in_pool(self, args)
  end,
  attributes = {"tboj_devil", "xmult"}
}

-- 110
-- 111
-- 112
-- Demon Baby
-- Mom's Knife
-- Ouija Board
SMODS.Joker {
  key = "ouija_board",
  pos = {x = 9, y = 7},
  config = {extra = {used_ranks = {}}},
  loc_vars = function(self, info_queue, card)
    local _ranks = {'','',''}
    for i, v in ipairs(card.ability.extra.used_ranks) do
      local end_string = card.ability.extra.used_ranks[i+1] and ',' or ''
      end_string = end_string..(card.ability.extra.used_ranks[i+1] and math.fmod(i,5) ~= 0 and ' ' or '')
      if i <= 5 then
        _ranks[1] = _ranks[1]..localize(TBOJ.id_to_value(v), "ranks")..end_string
      elseif i <= 10 then
        _ranks[2] = _ranks[2]..localize(TBOJ.id_to_value(v), "ranks")..end_string
      else
        _ranks[3] = _ranks[3]..localize(TBOJ.id_to_value(v), "ranks")..end_string
      end
    end
    info_queue[#info_queue + 1] = {set = 'Other', key = "used_ranks", vars = _ranks}
    return {vars = {}}
  end,
  rarity = 3,
  cost = 8,
  atlas = "jokers",
  perishable_compat = true,
  eternal_compat = true,
  blueprint_compat = false,
  calculate = function(self, card, context)
    if context.destroy_card and not context.blueprint then
      if #context.full_hand == 1 and context.destroy_card == context.full_hand[1] and (not SMODS.has_no_rank(context.full_hand[1])) and (not TBOJ.table_contains(card.ability.extra.used_ranks, context.full_hand[1]:get_id())) and G.GAME.current_round.hands_played == 0 then
        table.insert(card.ability.extra.used_ranks, context.full_hand[1]:get_id())
        table.sort(card.ability.extra.used_ranks, function(a, b) return a < b end)
        if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
          G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
          G.E_MANAGER:add_event(Event({
            func = (function()
              SMODS.add_card {
                set = 'Spectral',
                key_append = 'tboj_ouija_board' -- Optional, useful for manipulating the random seed and checking the source of the creation in `in_pool`.
              }
              G.GAME.consumeable_buffer = 0
              return true
            end)
          }))
          return {
            message = localize('k_plus_spectral'),
            colour = G.C.SECONDARY_SET.Spectral,
            remove = true
          }
        end
        return {
          remove = true
        }
      end
    end
  end,
  in_pool = function (self, args)
    return TBOJ.in_pool(self, args)
  end,
  attributes = {"tboj_devil", "generation", "spectral", "rank", "destroy_card"}
}

-- 116
-- 117
-- Brimstone
SMODS.Joker {
  key = "brimstone",
  atlas = "jokers",
  pos = {x = 12, y = 7},
  soul_atlas = "soul_jokers",
  soul_pos = {x = 12, y = 7},
  config = {extra = {Xmult_mod = 1}},
  loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.Xmult_mod}}
  end,
  rarity = 4,
  cost = 20,
  perishable_compat = true,
  eternal_compat = true,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.joker_main then
      return {
        Xmult = card.ability.extra.Xmult_mod * #context.scoring_hand,
      }
    end
  end,
  in_pool = function (self, args)
    return TBOJ.in_pool(self, args)
  end,
  attributes = {"tboj_devil", "xmult"}
}

-- 119
-- 120