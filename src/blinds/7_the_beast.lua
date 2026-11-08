SMODS.Rarity{
  key = "the_beast",
  default_weight = 0,
  badge_colour = HEX("9E0B0F"),
  pools = {["Joker"] = true},
  get_weight = function(self, weight, object_type)
    return weight
  end,
}

SMODS.Joker {
  key = "ultra_famine",
  pos = {x = 0, y = 0},
  config = {card_limit = 1, extra = {money = 3}},
  loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.money}}
  end,
  rarity = "tboj_the_beast",
  cost = 0,
  atlas = "the_beast",
  no_collection = true,
  perishable_compat = false,
  eternal_compat = true,
  blueprint_compat = false,
  rental_compat = false,
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play then
      G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) - card.ability.extra.money
      return {
        dollars = -card.ability.extra.money,
        func = function() -- This is for timing purposes, this goes after the dollar modification
          G.E_MANAGER:add_event(Event({
            func = function()
              G.GAME.dollar_buffer = 0
              return true
            end
          }))
        end
      }
    end
  end,
  in_pool = function (self, args)
    return false
  end
}

SMODS.Joker {
  key = "ultra_pestilence",
  pos = {x = 1, y = 0},
  config = {card_limit = 1, extra = {levels = 5}},
  loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.levels}}
  end,
  rarity = "tboj_the_beast",
  cost = 0,
  atlas = "the_beast",
  no_collection = true,
  perishable_compat = false,
  eternal_compat = true,
  blueprint_compat = false,
  rental_compat = false,
  calculate = function(self, card, context)
    if context.before then
      -- VanillaRemade Black Hole
      update_hand_text({ sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3 },
          { handname = localize('k_all_hands'), chips = '...', mult = '...', level = '' })
      G.E_MANAGER:add_event(Event({
          trigger = 'after',
          delay = 0.2,
          func = function()
              play_sound('tarot1')
              card:juice_up(0.8, 0.5)
              G.TAROT_INTERRUPT_PULSE = true
              return true
          end
      }))
      update_hand_text({ delay = 0 }, { mult = '-', StatusText = true })
      G.E_MANAGER:add_event(Event({
          trigger = 'after',
          delay = 0.9,
          func = function()
              play_sound('tarot1')
              card:juice_up(0.8, 0.5)
              return true
          end
      }))
      update_hand_text({ delay = 0 }, { chips = '-', StatusText = true })
      G.E_MANAGER:add_event(Event({
          trigger = 'after',
          delay = 0.9,
          func = function()
              play_sound('tarot1')
              card:juice_up(0.8, 0.5)
              G.TAROT_INTERRUPT_PULSE = nil
              return true
          end
      }))
      update_hand_text({ sound = 'button', volume = 0.7, pitch = 0.9, delay = 0 }, { level = -card.ability.extra.levels })
      delay(1.3)
      SMODS.upgrade_poker_hands({ instant = true, from = card, level_up = -card.ability.extra.levels })
      update_hand_text({ sound = 'button', volume = 0.7, pitch = 1.1, delay = 0 },
          { mult = 0, chips = 0, handname = '', level = '' })
    end
  end,
  in_pool = function (self, args)
    return false
  end
}

SMODS.Joker {
  key = "ultra_war",
  pos = {x = 2, y = 0},
  config = {card_limit = 1, extra = {Xmult = 0.25}},
  loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.Xmult}}
  end,
  rarity = "tboj_the_beast",
  cost = 0,
  atlas = "the_beast",
  no_collection = true,
  perishable_compat = false,
  eternal_compat = true,
  blueprint_compat = false,
  rental_compat = false,
  calculate = function(self, card, context)
    if context.joker_main then
      return {
        xmult = card.ability.extra.Xmult
      }
    end
  end,
  in_pool = function (self, args)
    return false
  end
}

SMODS.Joker {
  key = "ultra_death",
  pos = {x = 3, y = 0},
  config = {card_limit = 1, extra = {Xmult_mod = 0.95}},
  loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.Xmult_mod, card.ability.extra.Xmult_mod ^ (G.GAME.consumeable_usage_total and G.GAME.consumeable_usage_total.tarot or 0)}}
  end,
  rarity = "tboj_the_beast",
  cost = 0,
  atlas = "the_beast",
  no_collection = true,
  perishable_compat = false,
  eternal_compat = true,
  blueprint_compat = false,
  rental_compat = false,
  calculate = function(self, card, context)
    if context.joker_main then
      return {
        xmult = card.ability.extra.Xmult_mod ^ (G.GAME.consumeable_usage_total and G.GAME.consumeable_usage_total.tarot or 0)
      }
    end
  end,
  in_pool = function (self, args)
    return false
  end
}

SMODS.Joker {
  key = "the_beast",
  pos = {x = 4, y = 0},
  config = {card_limit = 1, extra = {}},
  loc_vars = function(self, info_queue, card)
    return {vars = {}}
  end,
  rarity = "tboj_the_beast",
  cost = 0,
  atlas = "the_beast",
  no_collection = true,
  perishable_compat = false,
  eternal_compat = true,
  blueprint_compat = false,
  rental_compat = false,
  calculate = function(self, card, context)
    if context.press_play then
      local eligible = {}
      for _, v in ipairs(G.jokers.cards) do
        if not SMODS.is_eternal(v, {destroy_cards = true}) then
          eligible[#eligible+1] = v
        end
      end

      if #eligible > 0 then
        local destr = pseudorandom_element(eligible, "tboj_the_beast")
        SMODS.destroy_cards(destr, {bypass_eternal = true})
        return {
          message = localize("tboj_blasphemous_ex")
        }
      end
    end
  end,
  in_pool = function (self, args)
    return false
  end
}

SMODS.Blind {
  key = "the_beast",
  dollars = 12,
  mult = 2,
  boss = { tboj_final_boss = true },
  boss_colour = HEX("E62F0D"),
  pos = { x = 0, y = 24 },
  atlas = "boss_blinds",
  discovered = false,
  debuff = { },
  config = {keys = {"j_tboj_ultra_famine", "j_tboj_ultra_pestilence", "j_tboj_ultra_war", "j_tboj_ultra_death"}, unused = {"j_tboj_ultra_famine", "j_tboj_ultra_pestilence", "j_tboj_ultra_war", "j_tboj_ultra_death"}},
  calculate = function(self, blind, context)
    if context.blind_disabled or context.blind_defeated then
      for _, joker in ipairs(G.jokers.cards) do
        if TBOJ.table_contains(blind.effect.keys, joker.config.center.key) then
          SMODS.destroy_cards(joker, {bypass_eternal = true})
        end
      end
    end

    if blind.disabled then return end

    if context.press_play and G.jokers.cards[1] then
      blind.prepped = true
    end

    if context.hand_drawn and blind.prepped then
      blind.prepped = nil
      for _, joker in ipairs(G.jokers.cards) do
        if TBOJ.table_contains(blind.effect.keys, joker.config.center.key) then
          SMODS.destroy_cards(joker, {bypass_eternal = true})
        end
      end

      if #blind.effect.unused > 0 then
        local harbinger, pos = pseudorandom_element(blind.effect.unused, "tboj_the_beast")
        table.remove(blind.effect.unused, pos)
        local _card = SMODS.add_card{area = G.jokers, key = harbinger, no_edition = true}
        _card:set_eternal(true)
      elseif not next(SMODS.find_card("j_tboj_the_beast")) then
        local _card = SMODS.add_card{area = G.jokers, key = "j_tboj_the_beast", no_edition = true}
        _card:set_eternal(true)
      end
    end
  end,
  defeat = function(self)
    for _, key in ipairs(self.config.keys) do
      for _, v in pairs(SMODS.find_card(key)) do
        SMODS.destroy_cards(v, {bypass_eternal = true})
      end
    end

    for _, v in pairs(SMODS.find_card("j_tboj_the_beast")) do
      SMODS.destroy_cards(v, {bypass_eternal = true})
    end
  end,
  in_pool = function (self)
    return G.GAME.modifiers.tboj_final_boss
      and G.GAME.round_resets.ante > 0
      and G.GAME.round_resets.ante % G.GAME.win_ante == 0
  end
}