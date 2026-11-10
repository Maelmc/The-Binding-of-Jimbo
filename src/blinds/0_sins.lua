SMODS.Blind {
  key = "envy",
  dollars = 4,
  mult = 1.5,
  big = { min = 1 },
  boss_colour = HEX("BBBBBB"),
  pos = { x = 0, y = 3 },
  atlas = "boss_blinds",
  discovered = false,
  debuff = { },
  config = {percent = 10},
  collection_loc_vars = function (self)
    return {vars = {self.config.percent}}
  end,
  loc_vars = function (self)
    return { vars = {self.config.percent}}
  end,
  calculate = function(self, blind, context)
    if not blind.disabled then
      if G.GAME.chips >= G.GAME.blind.chips then
        G.GAME.chips = 0
        if not G.GAME.modifiers.tboj_envy_first_phase then
          TBOJ.modify_blind_size({mult = blind.effect.percent / 100, source = blind})
        end
        G.GAME.modifiers.tboj_envy_first_phase = true
      end
    end

    if not blind.disabled then
      if context.drawing_cards and G.GAME.modifiers.tboj_envy_first_phase then
        G.GAME.modifiers.tboj_envy_first_phase = nil
        blind:disable()
      end
    end
  end,
  defeat = function(self)
    G.GAME.modifiers.tboj_envy_first_phase = nil
    G.GAME.modifiers.tboj_envy_defeated = true
  end,
  in_pool = function (self)
    return G.GAME.modifiers.tboj_allow_sin and not G.GAME.modifiers.tboj_envy_defeated
  end
}

SMODS.Blind {
  key = "super_envy",
  dollars = 4,
  mult = 1.5,
  big = { min = 1 },
  boss_colour = HEX("8575E3"),
  pos = { x = 0, y = 4 },
  atlas = "boss_blinds",
  discovered = false,
  debuff = { },
  config = {percent = 25},
  collection_loc_vars = function (self)
    return {vars = {self.config.percent}}
  end,
  loc_vars = function (self)
    return { vars = {self.config.percent}}
  end,
  calculate = function(self, blind, context)
    if not blind.disabled then
      if G.GAME.chips >= G.GAME.blind.chips then
        G.GAME.chips = 0
        if not G.GAME.modifiers.tboj_envy_first_phase then
          TBOJ.modify_blind_size({mult = blind.effect.percent / 100, source = blind})
        end
        G.GAME.modifiers.tboj_envy_first_phase = true
      end
    end

    if not blind.disabled then
      if context.drawing_cards and G.GAME.modifiers.tboj_envy_first_phase then
        G.GAME.modifiers.tboj_envy_first_phase = nil
        blind:disable()
      end
    end
  end,
  defeat = function(self)
    G.GAME.modifiers.tboj_envy_first_phase = nil
  end,
  in_pool = function (self)
    return G.GAME.modifiers.tboj_allow_sin and G.GAME.modifiers.tboj_more_sins and G.GAME.modifiers.tboj_envy_defeated
  end
}

SMODS.Blind {
  key = "gluttony",
  dollars = 4,
  mult = 2,
  big = { min = 1 },
  boss_colour = G.C.TBOJ.MOD_COLOR,
  pos = { x = 0, y = 5 },
  atlas = "boss_blinds",
  discovered = false,
  debuff = { },
  config = {disabled = false},
  defeat = function(self)
    G.GAME.modifiers.tboj_glutonny_defeated = true
  end,
  calculate = function(self, blind, context)
    if context.blind_disabled then
      G.GAME.blind.chips = G.GAME.blind.chips / (self.mult/1.5)
      G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
    end
  end,
  in_pool = function (self)
    return G.GAME.modifiers.tboj_allow_sin and not G.GAME.modifiers.tboj_glutonny_defeated
  end
}

SMODS.Blind {
  key = "super_gluttony",
  dollars = 4,
  mult = 3,
  big = { min = 1 },
  boss_colour = G.C.TBOJ.MOD_COLOR,
  pos = { x = 0, y = 6 },
  atlas = "boss_blinds",
  discovered = false,
  debuff = { },
  config = {disabled = false},
  calculate = function(self, blind, context)
    if context.blind_disabled then
      G.GAME.blind.chips = G.GAME.blind.chips / (self.mult/1.5)
      G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
    end
  end,
  in_pool = function (self)
    return G.GAME.modifiers.tboj_allow_sin and G.GAME.modifiers.tboj_more_sins and G.GAME.modifiers.tboj_glutonny_defeated
  end
}

SMODS.Blind {
  key = "wrath",
  dollars = 4,
  mult = 1.5,
  big = { min = 1 },
  boss_colour = HEX("BBBBBB"),
  pos = { x = 0, y = 7 },
  atlas = "boss_blinds",
  discovered = false,
  debuff = { },
  config = {mult = 0.75},
  collection_loc_vars = function (self)
    return {vars = {self.config.mult}}
  end,
  loc_vars = function (self)
    return {vars = {self.config.mult}}
  end,
  calculate = function(self, blind, context)
    if not blind.disabled then
      if context.modify_hand then
          mult = mod_mult(math.max(math.floor(mult * blind.effect.mult + 0.5), 1))
          update_hand_text({ sound = 'chips2', modded = true }, { chips = hand_chips, mult = mult })
        end
    end
  end,
  defeat = function(self)
    G.GAME.modifiers.tboj_wrath_defeated = true
  end,
  in_pool = function (self)
    return G.GAME.modifiers.tboj_allow_sin and not G.GAME.modifiers.tboj_wrath_defeated
  end
}

SMODS.Blind {
  key = "super_wrath",
  dollars = 4,
  mult = 1.5,
  big = { min = 1 },
  boss_colour = HEX("7A7A7A"),
  pos = { x = 0, y = 8 },
  atlas = "boss_blinds",
  discovered = false,
  debuff = { },
  config = {mult = 0.75},
  collection_loc_vars = function (self)
    return {vars = {self.config.mult}}
  end,
  loc_vars = function (self)
    return {vars = {self.config.mult}}
  end,
  calculate = function(self, blind, context)
    if not blind.disabled then
      if context.modify_hand then
          mult = mod_mult(math.max(math.floor(mult * blind.effect.mult + 0.5), 1))
          hand_chips = mod_chips(math.max(math.floor(hand_chips * blind.effect.mult + 0.5), 0))
          update_hand_text({ sound = 'chips2', modded = true }, { chips = hand_chips, mult = mult })
        end
    end
  end,
  in_pool = function (self)
    return G.GAME.modifiers.tboj_allow_sin and G.GAME.modifiers.tboj_more_sins and G.GAME.modifiers.tboj_wrath_defeated
  end
}

SMODS.Blind {
  key = "pride",
  dollars = 4,
  mult = 1.5,
  big = { min = 1 },
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
            G.GAME.modifiers.tboj_pride[id] = (G.GAME.modifiers.tboj_pride[id] or 0) + 1
          end
        end
      end

      if context.debuff_hand then
        if not G.GAME.modifiers.tboj_pride then return end
        for _, v in pairs(context.full_hand) do
          local id = tostring(v:get_id())
          for k, _ in pairs(G.GAME.modifiers.tboj_pride) do
            if k == id then return end
          end
        end
        local ranks = ""
        for k, v in pairs(G.GAME.modifiers.tboj_pride) do
          for i = 1, v do
            ranks = ranks .. k .. ", "
          end
        end
        ranks = string.sub(ranks, 1, #ranks - 2)
        return {
          debuff = true,
          debuff_text = localize {type = 'variable', key = 'tboj_last_played_hand_singular', vars = { ranks }}
        }
      end
    end
  end,
  defeat = function(self)
    G.GAME.modifiers.tboj_pride_defeated = true
  end,
  in_pool = function (self)
    return G.GAME.modifiers.tboj_allow_sin and not G.GAME.modifiers.tboj_pride_defeated
  end
}

SMODS.Blind {
  key = "super_pride",
  dollars = 4,
  mult = 1.5,
  big = { min = 1 },
  boss_colour = HEX("E280D8"),
  pos = { x = 0, y = 10 },
  atlas = "boss_blinds",
  discovered = false,
  debuff = { },
  config = {amount = 2},
  collection_loc_vars = function (self)
    return {vars = {self.config.amount}}
  end,
  loc_vars = function (self)
    return { vars = {self.config.amount}}
  end,
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

      if context.debuff_hand then
        if not G.GAME.modifiers.tboj_pride then return end
        local common = 0
        local used = {}
        for _, v in pairs(context.full_hand) do
          local id = tostring(v:get_id())
          for k, vv in pairs(G.GAME.modifiers.tboj_pride) do
            if k == id then
              if vv >= blind.effect.amount then return end
              if not TBOJ.table_contains(used,id) then
                common = common + vv
                if common >= blind.effect.amount then return end
                used[#used+1] = id
              end
            end
          end
        end
        local ranks = ""
        for k, v in pairs(G.GAME.modifiers.tboj_pride) do
          for i = 1, v do
            ranks = ranks .. k .. ", "
          end
        end
        ranks = string.sub(ranks, 1, #ranks - 2)
        return {
          debuff = true,
          debuff_text = localize {type = 'variable', key = 'tboj_last_played_hand_var', vars = { blind.effect.amount, blind.effect.amount ~= 1 and "s" or "", ranks }}
        }
      end
    end
  end,
  in_pool = function (self)
    return G.GAME.modifiers.tboj_allow_sin and G.GAME.modifiers.tboj_more_sins and G.GAME.modifiers.tboj_pride_defeated
  end
}

SMODS.Blind {
  key = "lust",
  dollars = 4,
  mult = 1.5,
  big = { min = 1 },
  boss_colour = HEX("DB9AE0"),
  pos = { x = 0, y = 12 },
  atlas = "boss_blinds",
  discovered = false,
  debuff = { },
  config = {amount = 2},
  collection_loc_vars = function (self)
    return {vars = {self.config.amount}}
  end,
  loc_vars = function (self)
    return { vars = {self.config.amount}}
  end,
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
    return not (suit_count >= self.config.amount)
  end,
  defeat = function(self)
    G.GAME.modifiers.tboj_lust_defeated = true
  end,
  in_pool = function (self)
    return G.GAME.modifiers.tboj_allow_sin and not G.GAME.modifiers.tboj_lust_defeated
  end
}

SMODS.Blind {
  key = "super_lust",
  dollars = 4,
  mult = 1.5,
  big = { min = 1 },
  boss_colour = HEX("DB9AE0"),
  pos = { x = 0, y = 13 },
  atlas = "boss_blinds",
  discovered = false,
  debuff = { },
  config = {amount = 3},
  collection_loc_vars = function (self)
    return {vars = {self.config.amount}}
  end,
  loc_vars = function (self)
    return { vars = {self.config.amount}}
  end,
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
    return not (suit_count >= self.config.amount)
  end,
  in_pool = function (self)
    return G.GAME.modifiers.tboj_allow_sin and G.GAME.modifiers.tboj_more_sins and G.GAME.modifiers.tboj_lust_defeated
  end
}

SMODS.Blind {
  key = "greed",
  dollars = 4,
  mult = 1.5,
  big = { min = 1 },
  boss_colour = HEX("DFCB00"),
  pos = { x = 0, y = 14 },
  atlas = "boss_blinds",
  discovered = false,
  debuff = { },
  config = {amount = 2},
  collection_loc_vars = function (self)
    return {vars = {self.config.amount}}
  end,
  loc_vars = function (self)
    return { vars = {self.config.amount}}
  end,
  calculate = function(self, blind, context)
    if not blind.disabled then
      if context.press_play then
        G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) - blind.effect.amount
        G.E_MANAGER:add_event(Event({
          func = function()
            G.GAME.dollar_buffer = 0
            return true
          end
        }))
        return {
          dollars = -blind.effect.amount
        }
      end
    end
  end,
  defeat = function(self)
    G.GAME.modifiers.tboj_greed_defeated = true
  end,
  in_pool = function (self)
    return G.GAME.modifiers.tboj_allow_sin and not G.GAME.modifiers.tboj_greed_defeated
  end
}

SMODS.Blind {
  key = "super_greed",
  dollars = 4,
  mult = 1.5,
  big = { min = 1 },
  boss_colour = HEX("DFCB00"),
  pos = { x = 0, y = 15 },
  atlas = "boss_blinds",
  discovered = false,
  debuff = { },
  config = {amount = 2},
  collection_loc_vars = function (self)
    return {vars = {self.config.amount}}
  end,
  loc_vars = function (self)
    return { vars = {self.config.amount}}
  end,
  calculate = function(self, blind, context)
    if not blind.disabled then
      if context.press_play or (context.pre_discard and not context.hook) then
        G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) - blind.effect.amount
        G.E_MANAGER:add_event(Event({
          func = function()
            G.GAME.dollar_buffer = 0
            return true
          end
        }))
        return {
          dollars = -blind.effect.amount
        }
      end
    end
  end,
  in_pool = function (self)
    return G.GAME.modifiers.tboj_allow_sin and G.GAME.modifiers.tboj_more_sins and G.GAME.modifiers.tboj_greed_defeated
  end
}

SMODS.Blind {
  key = "sloth",
  dollars = 4,
  mult = 1.5,
  big = { min = 1 },
  boss_colour = HEX("A3D337"),
  pos = { x = 0, y = 16 },
  atlas = "boss_blinds",
  discovered = false,
  debuff = { },
  config = {amount = 1},
  collection_loc_vars = function (self)
    return {vars = {self.config.amount}}
  end,
  loc_vars = function (self)
    return { vars = {self.config.amount}}
  end,
  set_blind = function(self)
    ease_hands_played(-self.config.amount)
    G.GAME.blind:juice_up()
  end,
  defeat = function(self)
    G.GAME.modifiers.tboj_sloth_defeated = true
  end,
  in_pool = function (self)
    return G.GAME.modifiers.tboj_allow_sin and not G.GAME.modifiers.tboj_sloth_defeated
  end
}

SMODS.Blind {
  key = "super_sloth",
  dollars = 4,
  mult = 1.5,
  big = { min = 1 },
  boss_colour = HEX("A3D337"),
  pos = { x = 0, y = 17 },
  atlas = "boss_blinds",
  discovered = false,
  debuff = { },
  config = {amount = 1},
  collection_loc_vars = function (self)
    return {vars = {self.config.amount}}
  end,
  loc_vars = function (self)
    return { vars = {self.config.amount}}
  end,
  set_blind = function(self)
    ease_hands_played(-self.config.amount)
    ease_discard(-self.config.amount)
    G.GAME.blind:juice_up()
  end,
  in_pool = function (self)
    return G.GAME.modifiers.tboj_allow_sin and G.GAME.modifiers.tboj_more_sins and G.GAME.modifiers.tboj_sloth_defeated
  end
}