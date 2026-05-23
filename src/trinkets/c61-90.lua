-- Watch Battery
-- Blasting Cap
-- Stud Finder
TBOJ.Trinket {
  key = "stud_finder",
  pos = { x = 13, y = 4 },
  cost = 5,
  config = {extra = {num = 1, den = 5, increase = 1}},
  loc_vars = function(self, info_queue, card)
    local num, den = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.den, "tboj_stud_finder")
    return {vars = {num, den, card.ability.extra.increase}}
  end,
  calculate = function(self, card, context)
    if context.remove_playing_cards then
      local trig = false
      for _, removed_card in ipairs(context.removed) do
        if SMODS.has_enhancement(removed_card,"m_stone") then
          SMODS.scale_card(card, {
            ref_value = 'num',        
            scalar_value = 'increase',
          })
        end
      end
      if trig then
        return nil, true
      end
    end

    if context.starting_shop then
      if SMODS.pseudorandom_probability(card, "tboj_stud_finder", card.ability.extra.num, card.ability.extra.den, "tboj_stud_finder") then
        card.ability.extra.num = 1
        SMODS.add_booster_to_shop()
        return {
          message = localize {type = 'variable', key = 'tboj_pack', vars = { 1, "" }}
        }
      end
    end
  end,
  attributes = {"scaling", "reset", "generation", "chance"},
}

-- Error
-- Poker Chip
TBOJ.Trinket {
  key = "poker_chip",
  pos = { x = 0, y = 5 },
  cost = 4,
  config = {extra = {num = 1, den = 2}},
  loc_vars = function(self, info_queue, card)
    local num, den = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.den, "tboj_poker_chip")
    return {vars = {num, den}}
  end,
  calculate = function(self, card, context)
    if context.open_booster then
      if SMODS.pseudorandom_probability(card, "tboj_poker_chip", card.ability.extra.num, card.ability.extra.den, "tboj_poker_chip") then
        G.E_MANAGER:add_event(Event {
          func = function()
            if #G.pack_cards.cards > 0 then
              SMODS.destroy_cards(G.pack_cards.cards, true, true)
            end
            return true
          end
        })
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
        return nil, true
      else
        G.E_MANAGER:add_event(Event {
          func = function()
            for i = 1, context.card.ability.extra do
              local _card_to_spawn = context.card.config.center.create_card(context.card, context.card, i)
              local card
              if type((_card_to_spawn or {}).is) == 'function' and _card_to_spawn:is(Card) then
                card = _card_to_spawn
              else
                card = SMODS.create_card(_card_to_spawn)
              end
              G.pack_cards:emplace(card)
            end
            return true
          end
        })
        return {
          message = localize("tboj_lucky_ex"),
        }
      end
    end
  end,
  attributes = {"generation", "chance"},
}

-- Blister
-- Second Hand
-- Endless Nameless
TBOJ.Trinket {
  key = "endless_nameless",
  pos = { x = 3, y = 5 },
  cost = 5,
  config = {extra = {num = 1, den = 4}},
  loc_vars = function(self, info_queue, card)
    local num, den = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.den, "tboj_endless_nameless")
    return {vars = {num, den}}
  end,
  calculate = function(self, card, context)
    if context.using_consumeable and not context.consumeable.tboj_endless_nameless_copy then
      if SMODS.pseudorandom_probability(card, "tboj_golden_horse_shoe", card.ability.extra.num, card.ability.extra.den, "tboj_endless_nameless") then
        local used = context.consumeable
        G.E_MANAGER:add_event(Event {
          func = function()
            if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit + (used.edition and used.edition.negative and 1 or 0) then
              local _card = copy_card(used)
              _card.tboj_endless_nameless_copy = true
              _card:add_to_deck()
              G.consumeables:emplace(_card)
            end
            return true
          end
        })
        return nil, true
      end
    end
  end,
  attributes = {"generation", "chance"},
}

-- Black Feather
-- Blind Rage

-- Golden Horse Shoe 82
TBOJ.Trinket {
  key = "golden_horse_shoe",
  pos = { x = 6, y = 5 },
  cost = 4,
  config = {extra = {num = 1, den = 7}},
  loc_vars = function(self, info_queue, card)
    local num, den = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.den, "tboj_golden_horse_shoe")
    return {vars = {num, den}}
  end,
  calculate = function(self, card, context)
    if context.reroll_shop or context.starting_shop then
      if SMODS.pseudorandom_probability(card, "tboj_golden_horse_shoe", card.ability.extra.num, card.ability.extra.den, "tboj_golden_horse_shoe") then
        local _card = SMODS.create_card({set = "Joker", area = G.shop_jokers})
        TBOJ.add_to_shop(_card, localize("tboj_lucky_ex"))
        return nil, true
      end
    end
  end,
  attributes = {"joker", "generation", "chance"},
}

-- NO! 88
TBOJ.Trinket {
  key = "no",
  pos = { x = 12, y = 5 },
  cost = 5,
  config = {extra = {}},
  loc_vars = function(self, info_queue, card)
    return {vars = {}}
  end,
  calculate = function(self, card, context)
  end,
  add_to_deck = function(self, card, from_debuff)
    G.GAME.tboj_active_rate = 0
  end,
  remove_from_deck = function(self, card, from_debuff)
    G.GAME.tboj_active_rate = 4
  end,
  attributes = {"passive"},
}

-- Child Leash 89
TBOJ.Trinket {
  key = "child_leash",
  pos = { x = 13, y = 5 },
  cost = 6,
  config = {extra = {Xmult_multi = 1.2}},
  loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.Xmult_multi}}
  end,
  calculate = function(self, card, context)
    if context.other_joker and context.other_joker:has_attribute("tboj_familiar") then
      return {
        xmult = card.ability.extra.Xmult_multi
      }
    end
  end,
  attributes = {"xmult"},
}

-- Brown Cap 90