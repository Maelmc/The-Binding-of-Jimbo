-- Technology 2
-- Mutant Spider
-- Chemical Peel
SMODS.Joker {
  key = "chemical_peel",
  pos = {x = 3, y = 10},
  config = {extra = {mult = 15}},
  loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.mult}}
  end,
  rarity = 1,
  cost = 4,
  atlas = "jokers",
  perishable_compat = true,
  eternal_compat = true,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.joker_main and G.GAME.current_round.hands_left % 2 == 1 then
      return {
        mult = card.ability.extra.mult
      }
    end
  end,
  in_pool = function (self, args)
    return TBOJ.in_pool(self, args)
  end,
  attributes = {"hands", "mult"}
}

-- The Peeper
SMODS.Joker {
  key = "the_peeper",
  pos = {x = 4, y = 10},
  config = {extra = {mult = 4}},
  loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.mult}}
  end,
  rarity = 1,
  cost = 5,
  atlas = "jokers",
  perishable_compat = true,
  eternal_compat = true,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.hand and not context.end_of_round and context.other_card:is_face() then
      return {
        mult = card.ability.extra.mult
      }
    end
  end,
  in_pool = function (self, args)
    return TBOJ.in_pool(self, args)
  end,
  attributes = {"face", "tboj_familiar", "mult"}
}

-- Habit
SMODS.Joker {
  key = "habit",
  pos = {x = 5, y = 10 },
  config = {extra = {charge = 1}},
  loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.charge}}
  end,
  rarity = 2,
  cost = 5,
  atlas = "jokers",
  perishable_compat = true,
  eternal_compat = true,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.joker_main and G.GAME.current_round.hands_left == 0 then
      if G.tboj_Actives.cards[1] and G.tboj_Actives.cards[1].ability.extra.curr_charge then
        G.E_MANAGER:add_event(Event({
          trigger = 'after',
          delay = 0.4,
          func = function()
            card:juice_up()
            return true
          end
        }))
        TBOJ.charge_active(G.tboj_Actives.cards[1],card.ability.extra.charge)
      end
    end
  end,
  in_pool = function (self, args)
    return TBOJ.in_pool(self, args)
  end,
  attributes = {"tboj_angel", "hands"}
}

-- Blue Candle
-- Cat-o-nine-tails
-- D20
TBOJ.Active {
  key = "d20",
  pos = {x = 0, y = 11},
  cost = 6,
  config = {extra = {max_charge = 2, curr_charge = 2}},
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue+1] = {set = 'Other', key = 'tboj_reroll'}
    return {vars = {card.ability.extra.curr_charge, card.ability.extra.max_charge}}
  end,
  calculate = function(self, card, context)
    TBOJ.eor_charge(card,context)
  end,
  can_use = function(self, card)
    return card.ability.extra.curr_charge >= card.ability.extra.max_charge and
    ((G.shop_jokers and G.shop_jokers.cards and #G.shop_jokers.cards > 0 and G.STATE == G.STATES.SHOP)
    or (G.pack_cards and G.pack_cards.cards and #G.pack_cards.cards > 0))
  end,
  use = function(self, card, area, copier)
    if G.pack_cards and G.pack_cards.cards and #G.pack_cards.cards > 0 then
      for _, v in pairs(G.pack_cards.cards) do
        if (v.ability.consumeable or v.ability.set == "tboj_Trinket" or v.ability.set == "Booster") and TBOJ.can_reroll(v) then
          local _k = SMODS.poll_object({type = v.ability.set, seed = "d20" .. G.GAME.round_resets.ante})
          TBOJ.reroll(v, _k)
        end
      end
    else
      for _, v in pairs(G.shop_jokers.cards) do
        if (v.ability.consumeable or v.ability.set == "tboj_Trinket" or v.ability.set == "Booster") and TBOJ.can_reroll(v) then
          local _k = SMODS.poll_object({type = v.ability.set, seed = "d20" .. G.GAME.round_resets.ante})
          TBOJ.reroll(v, _k)
        end
      end

      for _, v in pairs(G.shop_booster.cards) do
        if (v.ability.consumeable or v.ability.set == "tboj_Trinket" or v.ability.set == "Booster") and TBOJ.can_reroll(v) then
          local _k = SMODS.poll_object({type = v.ability.set, seed = "d20" .. G.GAME.round_resets.ante})
          TBOJ.reroll(v, _k)
        else
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
  attributes = {"consumable", "booster", "tboj_dice"}
}

-- Harlequin Baby
-- Epic Fetus

-- Stem Cells
-- Portable Slot
TBOJ.Active {
  key = "portable_slot",
  pos = {x = 11, y = 11},
  cost = 2,
  config = {extra = { cost = 1 }},
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue + 1] = G.P_CENTERS.spiderfly_tboj_pretty_fly
    if not card.edition or (card.edition and not card.edition.negative) then
      info_queue[#info_queue+1] = G.P_CENTERS.e_negative
    end
    info_queue[#info_queue + 1] = G.P_CENTERS.j_tboj_a_dollar
    return {vars = {card.ability.extra.cost}}
  end,
  can_use = function(self, card)
    return (G.GAME.dollars - G.GAME.bankrupt_at) >= card.ability.extra.cost
  end,
  use = function(self, card, area, copier)
    G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) - card.ability.extra.cost
    G.E_MANAGER:add_event(Event({
      func = function()
          G.GAME.dollar_buffer = 0
          card:juice_up(0.3, 0.5)
          ease_dollars(-1, true)
          return true
      end
    }))
    local _rand = pseudorandom("tboj_portable_slot",1,200)
    if _rand > 180 and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then -- 10% planet
      G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
      G.E_MANAGER:add_event(Event({
        func = (function()
          G.E_MANAGER:add_event(Event({
            func = function()
              SMODS.add_card {
                set = 'Planet',
                key_append = 'tboj_portable_slot'
              }
              G.GAME.consumeable_buffer = 0
              return true
            end
          }))
          SMODS.calculate_effect({ message = localize('k_plus_planet'), colour = G.C.BLUE }, card)
          return true
        end)
      }))

    elseif _rand > 160 and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then -- 10% tarot
      G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
      G.E_MANAGER:add_event(Event({
        func = (function()
          G.E_MANAGER:add_event(Event({
            func = function()
              SMODS.add_card {
                set = 'Tarot',
                key_append = 'tboj_portable_slot'
              }
              G.GAME.consumeable_buffer = 0
              return true
            end
          }))
          SMODS.calculate_effect({ message = localize('k_plus_tarot'), colour = G.C.TAROT }, card)
          return true
        end)
      }))

    elseif _rand > 140 and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then -- 10% loot
      G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
      G.E_MANAGER:add_event(Event({
        func = (function()
          G.E_MANAGER:add_event(Event({
            func = function()
              SMODS.add_card {
                set = 'tboj_Loot',
                key_append = 'tboj_portable_slot'
              }
              G.GAME.consumeable_buffer = 0
              return true
            end
          }))
          SMODS.calculate_effect({ message = localize('tboj_plus_loot'), colour = G.C.TBOJ.LOOT }, card)
          return true
        end)
      }))

    elseif _rand > 101 then -- 19.5% 1-3 Pretty Flies
      for _ = 1, pseudorandom("tboj_portable_slot",1,3) do
        local _card = SMODS.create_card {
          set = "tboj_spiderfly",
          key = "spiderfly_tboj_pretty_fly",
          area = G.tboj_flies
        }
        _card:add_to_deck()
        G.tboj_flies:emplace(_card)
      end
      SMODS.calculate_effect({message = localize('tboj_flies_ex'),}, card)

    elseif _rand == 100 then -- 0.5% A Dollar
      SMODS.add_card{ area = G.jokers, set = "Joker", key = "j_tboj_a_dollar", edition = "e_negative" }
      SMODS.calculate_effect({ message = localize('tboj_jackpot_ex'), colour = G.C.FILTER }, card)

    else -- 50% Nothing
      G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4,
        func = function()
          attention_text({
            text = localize('k_nope_ex'),
            scale = 1.3,
            hold = 1.4,
            major = card,
            backdrop_colour = G.C.SECONDARY_SET.Tarot,
            align = (G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK or G.STATE == G.STATES.SMODS_BOOSTER_OPENED) and 'tm' or 'cm',
            silent = true
          })
          G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.06*G.SETTINGS.GAMESPEED, blockable = false, blocking = false, func = function()
              play_sound('tarot2', 0.76, 0.4);return true end}))
          play_sound('tarot2', 1, 0.4)
          card:juice_up(0.3, 0.5)
          return true
        end
      }))
    end

    G.E_MANAGER:add_event(Event({
      func = function()
        card:highlight(true)
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
  attributes = {"consumable", "lose_economy", "generation"},
  tboj_designer = "Norman"
}

-- Holy Water
SMODS.Joker {
  key = "holy_water",
  pos = {x = 12, y = 11},
  config = {extra = {chips = 4}},
  loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.chips}}
  end,
  rarity = 2,
  cost = 5,
  atlas = "jokers",
  perishable_compat = true,
  eternal_compat = true,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.hand and not context.end_of_round then
      context.other_card.ability.perma_bonus = (context.other_card.ability.perma_bonus or 0) + card.ability.extra.chips
      return {
        message = localize('k_upgrade_ex')
      }
    end
  end,
  in_pool = function (self, args)
    return TBOJ.in_pool(self, args)
  end,
  attributes = {"tboj_angel", "tboj_familiar", "modify_card", "perma_bonus", "chips"}
}

-- Fate
-- The Black Bean