-- Gimpy
-- Black Lotus
-- Piggy Bank
-- Copied from Extra Credit's Hoarder
SMODS.Joker {
  key = "piggy_bank",
  pos = {x = 1, y = 15},
  config = {extra = {money = 1}},
  loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.money}}
  end,
  rarity = 2,
  cost = 3,
  atlas = "jokers",
  perishable_compat = false,
  eternal_compat = true,
  blueprint_compat = false,
  calculate = function(self, card, context)
    if context.money_altered then
      if context.amount > 0 then
        SMODS.scale_card(card, {
          ref_table = card.ability,
          ref_value = "extra_value",
          scalar_table = card.ability.extra,
          scalar_value = "money",
          operation = function(ref_table, ref_value, initial, change)
            ref_table[ref_value] = initial + change
          end,
          scaling_message = {
            message = localize('k_val_up'),
            colour = G.C.MONEY
          }
        })
        card:set_cost()
        return nil, true
      end
    end
  end,
  in_pool = function (self, args)
    return TBOJ.in_pool(self, args)
  end,
  attributes = {"economy", "scaling", "sell_value"},
}

-- Mom's Perfum
-- Monstro's Lung
SMODS.Joker {
  key = "monstro_lung",
  pos = {x = 3, y = 15},
  config = {extra = {min = 1, max = 4}},
  loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.min, card.ability.extra.max}}
  end,
  rarity = 2,
  cost = 5,
  atlas = "jokers",
  perishable_compat = true,
  eternal_compat = true,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.determine_hand then
      local cards_added = {}
      local to_add = pseudorandom('tboj_montro_lung', card.ability.extra.min, card.ability.extra.max)
      for _ = 1, to_add do
        local _card = SMODS.create_card {
          set = "Base",
          seal = SMODS.poll_seal({ mod = 10 }),
          edition = SMODS.poll_edition { key = "tboj_montro_lung", mod = 2, no_negative = true },
          area = G.play
        }
        _card.monstro_target = true
        _card.states.visible = false
        _card:add_to_deck()
        G.deck.config.card_limit = G.deck.config.card_limit + 1
        G.play:emplace(_card)
        G.E_MANAGER:add_event(Event({
          func = function()
            _card:start_materialize()
            if context.blueprint_card then
              context.blueprint_card:juice_up()
            else
              card:juice_up()
            end
            return true
          end
        }))
        table.insert(cards_added,_card)
      end
      SMODS.calculate_context({playing_card_added = true, cards = cards_added})
    end

    if context.destroy_card and not context.blueprint then
      if context.destroy_card.monstro_target then return {remove = true} end
    end
  end,
  in_pool = function (self, args)
    return TBOJ.in_pool(self, args)
  end,
  attributes = {"generation"},
}

-- Abaddon
SMODS.Joker {
  key = "abaddon",
  pos = {x = 4, y = 15},
  config = {extra = {Xmult = 0.25}},
  loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.Xmult, 1 + card.ability.extra.Xmult * (G.GAME and G.GAME.current_round.discards_left or 3)}}
  end,
  rarity = 3,
  cost = 8,
  atlas = "jokers",
  perishable_compat = true,
  eternal_compat = true,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.joker_main then
      return {
        xmult = 1 + card.ability.extra.Xmult * G.GAME.current_round.discards_left
      }
    end
  end,
  in_pool = function (self, args)
    return TBOJ.in_pool(self, args)
  end,
  add_to_deck = function(self, card, from_debuff)
    local diff = G.GAME.round_resets.hands - 1
    G.GAME.round_resets.hands = 1
    ease_hands_played(-diff)
    G.GAME.round_resets.discards = G.GAME.round_resets.discards + diff*2
    ease_discard(diff*2)
  end,
  attributes = {"tboj_devil", "hands", "discards", "xmult"},
}

-- Ball of Tar
-- Stop Watch
SMODS.Joker {
  key = "stop_watch", 
  pos = {x = 6, y = 15},
  config = {extra = {}},
  loc_vars = function(self, info_queue, center)
    return {vars = {}}
  end,
  rarity = 3, 
  cost = 8,
  atlas = "jokers",
  perishable_compat = true,
  eternal_compat = true,
  blueprint_compat = false,
  calculate = function(self, card, context)
  end,
  calc_scaling = function(self, card, scaling_card, initial, scalar_value, args)
    return {
        override_scalar_value = {value = scalar_value * 2}
    }
  end,
  in_pool = function(self)
    return TBOJ.in_pool(self)
  end,
  attributes = {"passive"},
}

-- Tiny Planet
SMODS.Joker {
  key = "tiny_planet", 
  pos = {x = 7, y = 15},
  config = {extra = {}},
  loc_vars = function(self, info_queue, center)
    local _chips, _mult, name
    for k, v in pairs(G.GAME.hands) do
      if v.visible and ((not _chips) or (v.mult * v.chips < _mult * _chips)) then
        _chips = v.chips
        _mult = v.mult
        name = k
      end
    end
    return {vars = {_chips, _mult, localize(name, 'poker_hands'),}}
  end,
  rarity = 1, 
  cost = 6,
  atlas = "jokers",
  perishable_compat = true,
  eternal_compat = true,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.joker_main then
      local _chips, _mult, name
      for k, v in pairs(G.GAME.hands) do
        if v.visible and ((not _chips) or (v.mult * v.chips < _mult * _chips)) then
          _chips = v.chips
          _mult = v.mult
          name = k
        end
      end
      if _chips and _chips * _mult > 0 then
        return {
          chips = _chips,
          mult = _mult,
          remove_default_message = true,
          message = localize(name, 'poker_hands'),
          colour = G.C.FILTER,
        }
      end
    end
  end,
  in_pool = function(self)
    return TBOJ.in_pool(self)
  end,
  attributes = {"chips", "mult", "space"},
}

-- Infestation 2
-- E. Coli
SMODS.Joker {
  key = "e_coli", 
  pos = {x = 10, y = 15},
  config = {extra = {}},
  loc_vars = function(self, info_queue, center)
    info_queue[#info_queue + 1] = G.P_CENTERS.m_tboj_poop
    return {vars = {}}
  end,
  rarity = 2, 
  cost = 5,
  atlas = "jokers",
  perishable_compat = true,
  eternal_compat = true,
  blueprint_compat = false,
  calculate = function(self, card, context)
    if context.before and not context.blueprint then
            local faces = 0
            for _, scored_card in ipairs(context.scoring_hand) do
                if scored_card:is_face() then
                    faces = faces + 1
                    scored_card:set_ability('m_tboj_poop', nil, true)
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            scored_card:juice_up()
                            return true
                        end
                    }))
                end
            end
            if faces > 0 then
                return {
                    message = localize('k_poop'),
                    colour = G.C.TBOJ.POOP
                }
            end
        end
  end,
  in_pool = function(self)
    return TBOJ.in_pool(self)
  end,
  attributes = {"tboj_poop", "enhancements", "modify_card", "face"},
}
