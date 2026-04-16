SMODS.Blind {
  key = "envy",
  dollars = 4,
  mult = 1.5,
  big = true,
  boss = false,
  boss_colour = HEX("BBBBBB"),
  pos = { x = 0, y = 3 },
  atlas = "boss_blinds",
  discovered = false,
  debuff = { },
  config = {disabled = false},
  calculate = function(self, blind, context)
    if not blind.disabled then
      if G.GAME.chips >= G.GAME.blind.chips then
        blind.triggered = true
        G.GAME.chips = 0
        TBOJ.modify_blind_size({mult = 0.1, source = blind})
        blind:disable()
      end
    end
  end,
  defeat = function(self)
    G.GAME.modifiers.tboj_envy_defeated = true
  end,
}

SMODS.Blind {
  key = "super_envy",
  dollars = 4,
  mult = 1.5,
  big = true,
  boss = false,
  boss_colour = HEX("8575E3"),
  pos = { x = 0, y = 4 },
  atlas = "boss_blinds",
  discovered = false,
  debuff = { },
  config = {disabled = false},
  calculate = function(self, blind, context)
    if not blind.disabled then
      if G.GAME.chips >= G.GAME.blind.chips then
        blind.triggered = true
        G.GAME.chips = 0
        TBOJ.modify_blind_size({mult = 0.25, source = blind})
        blind:disable()
      end
    end
  end,
  in_pool = function (self)
    return G.GAME.modifiers.tboj_more_sins and G.GAME.modifiers.tboj_envy_defeated
  end
}

SMODS.Blind {
  key = "gluttony",
  dollars = 4,
  mult = 2,
  big = true,
  boss = false,
  boss_colour = G.C.TBOJ.MOD_COLOR,
  pos = { x = 0, y = 5 },
  atlas = "boss_blinds",
  discovered = false,
  debuff = { },
  config = {disabled = false},
  defeat = function(self)
    G.GAME.modifiers.tboj_glutonny_defeated = true
  end,
}

SMODS.Blind {
  key = "super_gluttony",
  dollars = 4,
  mult = 3,
  big = true,
  boss = false,
  boss_colour = G.C.TBOJ.MOD_COLOR,
  pos = { x = 0, y = 6 },
  atlas = "boss_blinds",
  discovered = false,
  debuff = { },
  config = {disabled = false},
  in_pool = function (self)
    return G.GAME.modifiers.tboj_more_sins and G.GAME.modifiers.tboj_glutonny_defeated
  end
}

SMODS.Blind {
  key = "wrath",
  dollars = 4,
  mult = 1.5,
  big = true,
  boss = false,
  boss_colour = HEX("BBBBBB"),
  pos = { x = 0, y = 7 },
  atlas = "boss_blinds",
  discovered = false,
  debuff = { },
  config = {disabled = false},
  calculate = function(self, blind, context)
    if not blind.disabled then
      if context.modify_hand then
          blind.triggered = true -- This won't trigger Matador in this context due to a Vanilla bug (a workaround is setting it in context.debuff_hand)
          mult = mod_mult(math.max(math.floor(mult * 0.75 + 0.5), 1))
          update_hand_text({ sound = 'chips2', modded = true }, { chips = hand_chips, mult = mult })
        end
    end
  end,
  defeat = function(self)
    G.GAME.modifiers.tboj_wrath_defeated = true
  end,
}

SMODS.Blind {
  key = "super_wrath",
  dollars = 4,
  mult = 1.5,
  big = true,
  boss = false,
  boss_colour = HEX("7A7A7A"),
  pos = { x = 0, y = 8 },
  atlas = "boss_blinds",
  discovered = false,
  debuff = { },
  config = {disabled = false},
  calculate = function(self, blind, context)
    if not blind.disabled then
      if context.modify_hand then
          blind.triggered = true -- This won't trigger Matador in this context due to a Vanilla bug (a workaround is setting it in context.debuff_hand)
          mult = mod_mult(math.max(math.floor(mult * 0.75 + 0.5), 1))
          hand_chips = mod_chips(math.max(math.floor(hand_chips * 0.75 + 0.5), 0))
          update_hand_text({ sound = 'chips2', modded = true }, { chips = hand_chips, mult = mult })
        end
    end
  end,
  in_pool = function (self)
    return G.GAME.modifiers.tboj_more_sins and G.GAME.modifiers.tboj_wrath_defeated
  end
}

SMODS.Blind {
  key = "pride",
  dollars = 4,
  mult = 1.5,
  big = true,
  boss = false,
  boss_colour = HEX("BBBBBB"),
  pos = { x = 0, y = 9 },
  atlas = "boss_blinds",
  discovered = false,
  debuff = { },
  config = {disabled = false},
  set_blind = function(self)
    G.GAME.modifiers.tboj_pride = nil
  end,
  calculate = function(self, blind, context)
    if not blind.disabled then
      if context.before then
        G.GAME.modifiers.tboj_pride = {}
        for _, v in ipairs(context.full_hand) do
          if not SMODS.has_no_rank(v) then
            local id = tostring(v:get_id())
            G.GAME.modifiers.tboj_pride[id] = true
          end
        end
      end
    end
  end,
  debuff_hand = function (self, cards, hand, handname, check)
    if not G.GAME.modifiers.tboj_pride then return false end
    for _, v in pairs(cards) do
      local id = tostring(v:get_id())
      for k, _ in pairs(G.GAME.modifiers.tboj_pride) do
        if k == id then return false end
      end
    end
    return true
  end,
  defeat = function(self)
    G.GAME.modifiers.tboj_pride_defeated = true
  end,
}

SMODS.Blind {
  key = "super_pride",
  dollars = 4,
  mult = 1.5,
  big = true,
  boss = false,
  boss_colour = HEX("E280D8"),
  pos = { x = 0, y = 10 },
  atlas = "boss_blinds",
  discovered = false,
  debuff = { },
  config = {disabled = false},
  set_blind = function(self)
    G.GAME.modifiers.tboj_pride = nil
  end,
  calculate = function(self, blind, context)
    if not blind.disabled then
      if context.before then
        G.GAME.modifiers.tboj_pride = {}
        for _, v in ipairs(context.full_hand) do
          if not SMODS.has_no_rank(v) then
            local id = tostring(v:get_id())
            G.GAME.modifiers.tboj_pride[id] = (G.GAME.modifiers.tboj_pride[id] or 0) + 1
          end
        end
      end
    end
  end,
  debuff_hand = function (self, cards, hand, handname, check)
    if not G.GAME.modifiers.tboj_pride then return false end
    local common = 0
    local used = {}
    for _, v in pairs(cards) do
      local id = tostring(v:get_id())
      for k, vv in pairs(G.GAME.modifiers.tboj_pride) do
        if k == id then
          if TBOJ.table_contains(used,id) then
            if vv >= 2 then return false end
          else
            common = common + 1
            if common >= 2 then return false end
            used[#used+1] = id
          end
        end
      end
    end
    return true
  end,
  in_pool = function (self)
    return G.GAME.modifiers.tboj_more_sins and G.GAME.modifiers.tboj_pride_defeated
  end
}

SMODS.Blind {
  key = "lust",
  dollars = 4,
  mult = 1.5,
  big = true,
  boss = false,
  boss_colour = HEX("DB9AE0"),
  pos = { x = 0, y = 12 },
  atlas = "boss_blinds",
  discovered = false,
  debuff = { },
  config = {disabled = false},
  debuff_hand = function (self, cards, hand, handname, check)
    local suits = {}
    local suit_count = 0
    for i = 1, #cards do
      if not SMODS.has_any_suit(cards[i]) then
        for _, v in pairs(SMODS.Suits) do
          if cards[i]:is_suit(v.key) then
            suits[v.key] = true
          end
        end
      end
    end
    for i = 1, #cards do
      if SMODS.has_any_suit(cards[i]) then
        suit_count = suit_count + 1
      end
    end
    for _, _ in pairs(suits) do
      suit_count = suit_count + 1
    end
    return not (suit_count >= 2)
  end,
  defeat = function(self)
    G.GAME.modifiers.tboj_lust_defeated = true
  end,
}

SMODS.Blind {
  key = "super_lust",
  dollars = 4,
  mult = 1.5,
  big = true,
  boss = false,
  boss_colour = HEX("DB9AE0"),
  pos = { x = 0, y = 13 },
  atlas = "boss_blinds",
  discovered = false,
  debuff = { },
  config = {disabled = false},
  debuff_hand = function (self, cards, hand, handname, check)
    local suits = {}
    local suit_count = 0
    for i = 1, #cards do
      if not SMODS.has_any_suit(cards[i]) then
        for _, v in pairs(SMODS.Suits) do
          if cards[i]:is_suit(v.key) and not suits[v.key] then
            suits[v.key] = true
            break
          end
        end
      end
    end
    for i = 1, #cards do
      if SMODS.has_any_suit(cards[i]) then
        suit_count = suit_count + 1
      end
    end
    for _, _ in pairs(suits) do
      suit_count = suit_count + 1
    end
    return not (suit_count >= 3)
  end,
  in_pool = function (self)
    return G.GAME.modifiers.tboj_more_sins and G.GAME.modifiers.tboj_lust_defeated
  end
}

SMODS.Blind {
  key = "greed",
  dollars = 4,
  mult = 1.5,
  big = true,
  boss = false,
  boss_colour = HEX("DFCB00"),
  pos = { x = 0, y = 14 },
  atlas = "boss_blinds",
  discovered = false,
  debuff = { },
  config = {disabled = false},
  calculate = function(self, blind, context)
    if not blind.disabled then
      if context.press_play then
        blind.triggered = true
        G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) - 2
        G.E_MANAGER:add_event(Event({
          func = function()
            G.GAME.dollar_buffer = 0
            return true
          end
        }))
        return {
          dollars = -2
        }
      end
    end
  end,
  defeat = function(self)
    G.GAME.modifiers.tboj_greed_defeated = true
  end,
}

SMODS.Blind {
  key = "super_greed",
  dollars = 4,
  mult = 1.5,
  big = true,
  boss = false,
  boss_colour = HEX("DFCB00"),
  pos = { x = 0, y = 15 },
  atlas = "boss_blinds",
  discovered = false,
  debuff = { },
  config = {disabled = false},
  calculate = function(self, blind, context)
    if not blind.disabled then
      if context.press_play or (context.pre_discard and not context.hook) then
        blind.triggered = true
        G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) - 2
        G.E_MANAGER:add_event(Event({
          func = function()
            G.GAME.dollar_buffer = 0
            return true
          end
        }))
        return {
          dollars = -2
        }
      end
    end
  end,
  in_pool = function (self)
    return G.GAME.modifiers.tboj_more_sins and G.GAME.modifiers.tboj_greed_defeated
  end
}

SMODS.Blind {
  key = "sloth",
  dollars = 4,
  mult = 1.5,
  big = true,
  boss = false,
  boss_colour = HEX("A3D337"),
  pos = { x = 0, y = 16 },
  atlas = "boss_blinds",
  discovered = false,
  debuff = { },
  config = {disabled = false},
  set_blind = function(self)
    ease_hands_played(-1)
    G.GAME.blind:juice_up()
  end,
  defeat = function(self)
    G.GAME.modifiers.tboj_sloth_defeated = true
  end,
}

SMODS.Blind {
  key = "super_sloth",
  dollars = 4,
  mult = 1.5,
  big = true,
  boss = false,
  boss_colour = HEX("A3D337"),
  pos = { x = 0, y = 17 },
  atlas = "boss_blinds",
  discovered = false,
  debuff = { },
  config = {disabled = false},
  set_blind = function(self)
    ease_hands_played(-1)
    ease_discard(-1)
    G.GAME.blind:juice_up()
  end,
  in_pool = function (self)
    return G.GAME.modifiers.tboj_more_sins and G.GAME.modifiers.tboj_sloth_defeated
  end
}