-- all taken from VanillaRemade, except bl_psychic, bl_plant, bl_head, bl_goad, bl_window, bl_club
local vanilla_bosses = {
  bl_hook = {
    calculate = function(self, blind, context)
      if blind.disabled then return end

      if context.press_play then
          G.E_MANAGER:add_event(Event({
              func = function()
                  local any_selected = nil
                  local _cards = {}
                  for _, playing_card in ipairs(G.hand.cards) do
                      _cards[#_cards + 1] = playing_card
                  end
                  for i = 1, 2 do
                      if G.hand.cards[i] then
                          local selected_card, card_index = pseudorandom_element(_cards, 'hook')
                          G.hand:add_to_highlighted(selected_card, true)
                          table.remove(_cards, card_index)
                          any_selected = true
                          play_sound('card1', 1)
                      end
                  end
                  if any_selected then G.FUNCS.discard_cards_from_highlighted(nil, true) end
                  return true
              end
          }))
          blind.triggered = true -- This won't trigger Matador in this context due to a Vanilla bug (a workaround is setting it in context.debuff_hand)
          delay(0.7)
          G.E_MANAGER:add_event(Event({
              trigger = 'immediate',
              func = (function()
                  SMODS.juice_up_blind()
                  G.E_MANAGER:add_event(Event({
                      trigger = 'after',
                      delay = 0.06 * G.SETTINGS.GAMESPEED,
                      blockable = false,
                      blocking = false,
                      func = function()
                          play_sound('tarot2', 0.76, 0.4); return true
                      end
                  }))
                  play_sound('tarot2', 1, 0.4)
                  return true
              end)
          }))
          delay(0.4)
      end
    end
  },
  bl_ox = {
    calculate = function(self, blind, context)
      if blind.disabled then return end

      if context.debuff_hand then
          blind.triggered = false
          if context.scoring_name == G.GAME.current_round.most_played_poker_hand then
              blind.triggered = true
              if not context.check then
                  return {
                      dollars = -G.GAME.dollars,
                      instant = true,
                      func = function()
                          blind:wiggle()
                      end
                  }
              end
          end
      end
    end
  },
  bl_house = {
    calculate = function(self, blind, context)
        if context.blind_disabled then
            for i = 1, #G.hand.cards do
                if G.hand.cards[i].facing == 'back' then
                    G.hand.cards[i]:flip()
                end
            end
            for _, playing_card in pairs(G.playing_cards) do
                playing_card.ability.wheel_flipped = nil
            end
        end

        if blind.disabled then return end

        if context.stay_flipped and context.to_area == G.hand and
            G.GAME.current_round.hands_played == 0 and G.GAME.current_round.discards_used == 0 then
            return {
                stay_flipped = true
            }
        end
    end
  },
  bl_wall = {
    calculate = function(self, blind, context)
        if context.blind_disabled then
            G.GAME.blind.chips = G.GAME.blind.chips / 2
            G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
        end
    end
  },
  bl_wheel = {
    calculate = function(self, blind, context)
        if context.blind_disabled then
            for i = 1, #G.hand.cards do
                if G.hand.cards[i].facing == 'back' then
                    G.hand.cards[i]:flip()
                end
            end
            for _, playing_card in pairs(G.playing_cards) do
                playing_card.ability.wheel_flipped = nil
            end
        end

        if blind.disabled then return end

        if context.stay_flipped and context.to_area == G.hand and
            SMODS.pseudorandom_probability(blind, 'wheel', 1, 7) then
            return {
                stay_flipped = true
            }
        end
    end
  },
  bl_arm = {
    calculate = function(self, blind, context)
        if blind.disabled then return end

        if context.debuff_hand then
            blind.triggered = false
            if G.GAME.hands[context.scoring_name].level > 1 then
                blind.triggered = true
                if not context.check then
                    return {
                        level_up = -1
                    }
                end
            end
        end
    end
  },
  bl_fish = {
    calculate = function(self, blind, context)
        if context.blind_disabled then
            for i = 1, #G.hand.cards do
                if G.hand.cards[i].facing == 'back' then
                    G.hand.cards[i]:flip()
                end
            end
            for _, playing_card in pairs(G.playing_cards) do
                playing_card.ability.wheel_flipped = nil
            end
        end

        if context.setting_blind or context.hand_drawn then
            blind.prepped = nil
        end

        if blind.disabled then return end

        if context.press_play then
            blind.prepped = true
        end
        if context.stay_flipped and context.to_area == G.hand and blind.prepped then
            return {
                stay_flipped = true
            }
        end
    end
  },
  bl_water = {
    calculate = function(self, blind, context)
        if context.blind_disabled then
            ease_discard(blind.effect.discards_sub)
        end

        if blind.disabled then return end

        if context.setting_blind then
            blind.effect.discards_sub = G.GAME.current_round.discards_left
            ease_discard(-blind.effect.discards_sub)
        end
    end
  },
  bl_manacle = {
    calculate = function(self, blind, context)
        if context.blind_disabled then
            G.hand:change_size(1)
        end

        if blind.disabled then return end

        if context.blind_defeated then
            G.hand:change_size(1)
        end

        if context.setting_blind then
            G.hand:change_size(-1)
        end
    end
  },
  bl_eye = {
    calculate = function(self, blind, context)
        if blind.disabled then return end

        if context.setting_blind then
            blind.effect.hands = {}
            for _, poker_hand in ipairs(G.handlist) do
                blind.effect.hands[poker_hand] = false
            end
        end
        if context.debuff_hand then
            if blind.effect.hands[context.scoring_name] then
                blind.triggered = true
                return {
                    debuff = true
                }
            end
            if not context.check then
                blind.effect.hands[context.scoring_name] = true
            end
        end
    end
  },
  bl_mouth = {
    calculate = function(self, blind, context)
        if blind.disabled then return end
        if context.setting_blind then
            blind.only_hand = false
        end
        if context.debuff_hand then
            if blind.effect.only_hand and blind.effect.only_hand ~= context.scoring_name then
                blind.triggered = true
                return {
                    debuff = true,
                    debuff_text = blind.loc_debuff_text ..
                        (blind.effect.only_hand and ' [' .. localize(blind.effect.only_hand, 'poker_hands') .. ']' or '')
                }
            end
            if not context.check then
                blind.effect.only_hand = context.scoring_name
            end
        end
    end
  },
  bl_serpent = {
    calculate = function(self, blind, context)
        if blind.disabled then return end

        if context.drawing_cards and (G.GAME.current_round.hands_played ~= 0 or G.GAME.current_round.discards_used ~= 0) then
            return {
                cards_to_draw = 3
            }
        end
    end
  },
  bl_pillar = {
    calculate = function(self, blind, context)
        if blind.disabled then return end

        if context.debuff_card and context.debuff_card.area ~= G.jokers and
            context.debuff_card.ability.played_this_ante then
            return {
                debuff = true
            }
        end
    end
  },
  bl_needle = {
    calculate = function(self, blind, context)
        if context.blind_disabled then
            ease_hands_played(blind.effect.hands_sub)
        end

        if blind.disabled then return end

        if context.setting_blind then
            blind.effect.hands_sub = G.GAME.round_resets.hands - 1
            ease_hands_played(blind.effect.hands_sub)
        end
    end
  },
  bl_tooth = {
    calculate = function(self, blind, context)
        if blind.disabled then return end

        if context.press_play then
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.2,
                func = function()
                    for i = 1, #G.play.cards do
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                G.play.cards[i]:juice_up()
                                return true
                            end,
                        }))
                        ease_dollars(-1)
                        delay(0.23)
                    end
                    return true
                end
            }))
            blind.triggered = true -- This won't trigger Matador in this context due to a Vanilla bug (a workaround is setting it in context.debuff_hand)
            G.E_MANAGER:add_event(Event({
                trigger = 'immediate',
                func = (function()
                    SMODS.juice_up_blind()
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 0.06 * G.SETTINGS.GAMESPEED,
                        blockable = false,
                        blocking = false,
                        func = function()
                            play_sound('tarot2', 0.76, 0.4)
                            return true
                        end
                    }))
                    play_sound('tarot2', 1, 0.4)
                    return true
                end)
            }))
            delay(0.4)
        end
    end
  },
  bl_flint = {
    calculate = function(self, blind, context)
        if blind.disabled then return end

        if context.modify_hand then
            blind.triggered = true -- This won't trigger Matador in this context due to a Vanilla bug (a workaround is setting it in context.debuff_hand)
            mult = mod_mult(math.max(math.floor(mult * 0.5 + 0.5), 1))
            hand_chips = mod_chips(math.max(math.floor(hand_chips * 0.5 + 0.5), 0))
            update_hand_text({ sound = 'chips2', modded = true }, { chips = hand_chips, mult = mult })
        end
    end
  },
  bl_mark = {
    calculate = function(self, blind, context)
        if context.blind_disabled then
            for i = 1, #G.hand.cards do
                if G.hand.cards[i].facing == 'back' then
                    G.hand.cards[i]:flip()
                end
            end
            for _, playing_card in pairs(G.playing_cards) do
                playing_card.ability.wheel_flipped = nil
            end
        end

        if blind.disabled then return end

        if context.stay_flipped and context.to_area == G.hand and
            context.other_card:is_face(true) then
            return {
                stay_flipped = true
            }
        end
    end
  },
  bl_final_acorn = {
    calculate = function(self, blind, context)
        if blind.disabled then return end

        if context.setting_blind then
            if #G.jokers.cards > 0 then
                G.jokers:unhighlight_all()
                for _, joker in ipairs(G.jokers.cards) do
                    joker:flip()
                end
                if #G.jokers.cards > 1 then
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 0.2,
                        func = function()
                            G.E_MANAGER:add_event(Event({
                                func = function()
                                    G.jokers:shuffle('aajk')
                                    play_sound('cardSlide1', 0.85)
                                    return true
                                end,
                            }))
                            delay(0.15)
                            G.E_MANAGER:add_event(Event({
                                func = function()
                                    G.jokers:shuffle('aajk')
                                    play_sound('cardSlide1', 1.15)
                                    return true
                                end
                            }))
                            delay(0.15)
                            G.E_MANAGER:add_event(Event({
                                func = function()
                                    G.jokers:shuffle('aajk')
                                    play_sound('cardSlide1', 1)
                                    return true
                                end
                            }))
                            delay(0.5)
                            return true
                        end
                    }))
                end
            end
        end
    end,
  },
  bl_final_leaf = {
    calculate = function(self, blind, context)
        if blind.disabled then return end

        if context.debuff_card and context.debuff_card.area ~= G.jokers then
            return {
                debuff = true
            }
        end
        if context.selling_card and context.card.ability.set == 'Joker' then
            G.E_MANAGER:add_event(Event({
                trigger = 'immediate',
                func = function()
                    blind:disable()
                    return true
                end
            }))
        end
    end
  },
  bl_final_vessel = {
    calculate = function(self, card, context)
        if context.blind_disabled then
            G.GAME.blind.chips = G.GAME.blind.chips / 3
            G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
        end
    end
  },
  bl_final_heart = {
    calculate = function(self, blind, context)
        if context.blind_disabled or context.blind_defeated then
            for _, joker in ipairs(G.jokers.cards) do
                joker.ability.crimson_heart_chosen = nil
            end
        end

        if blind.disabled then return end

        if context.debuff_card and context.debuff_card.area == G.jokers then
            if context.debuff_card.ability.crimson_heart_chosen then
                return {
                    debuff = true
                }
            end
        end
        if context.press_play and G.jokers.cards[1] then
            blind.triggered = true -- This won't trigger Matador in this context due to a Vanilla bug (a workaround is setting it in context.debuff_hand)
            blind.prepped = true
        end
        if context.hand_drawn then
            if blind.prepped and G.jokers.cards[1] then
                local prev_chosen_set = {}
                local fallback_jokers = {}
                local jokers = {}
                for i = 1, #G.jokers.cards do
                    if G.jokers.cards[i].ability.crimson_heart_chosen then
                        prev_chosen_set[G.jokers.cards[i]] = true
                        G.jokers.cards[i].ability.crimson_heart_chosen = nil
                        if G.jokers.cards[i].debuff then SMODS.recalc_debuff(G.jokers.cards[i]) end
                    end
                end
                for i = 1, #G.jokers.cards do
                    if not G.jokers.cards[i].debuff then
                        if not prev_chosen_set[G.jokers.cards[i]] then
                            jokers[#jokers + 1] = G.jokers.cards[i]
                        end
                        table.insert(fallback_jokers, G.jokers.cards[i])
                    end
                end
                if #jokers == 0 then jokers = fallback_jokers end
                local _card = pseudorandom_element(jokers, 'crimson_heart')
                if _card then
                    _card.ability.crimson_heart_chosen = true
                    SMODS.recalc_debuff(_card)
                    _card:juice_up()
                    blind:wiggle()
                end
            end
            blind.prepped = nil
        end
    end
  },
  bl_final_bell = {
    calculate = function(self, blind, context)
        if context.blind_disabled or context.blind_defeated then
            for _, playing_card in ipairs(G.playing_cards) do
                playing_card.ability.forced_selection = nil
            end
        end

        if blind.disabled then return end

        if context.hand_drawn then
            local any_forced = nil
            for _, playing_card in ipairs(G.hand.cards) do
                if playing_card.ability.forced_selection then
                    any_forced = true
                end
            end
            if not any_forced then
                G.hand:unhighlight_all()
                local forced_card = pseudorandom_element(G.hand.cards, 'cerulean_bell')
                forced_card.ability.forced_selection = true
                G.hand:add_to_highlighted(forced_card)
            end
        end
    end
  },
  bl_psychic = {
    debuff_hand = function (self, cards, hand, handname, check)
      return #cards < G.P_BLINDS["bl_psychic"].debuff.h_size_ge
    end,
  },
  bl_plant = {
    calculate = function(self, blind, context)
      if blind.disabled then return end

      if context.debuff_card and context.debuff_card:is_face() then
          return {
              debuff = true
          }
      end
    end,
    defeat = function(self)
      for _, v in pairs(G.playing_cards) do
        if v:is_face() then SMODS.debuff_card(v, false, 'bl_plant') end
      end
    end,
    disable = function(self)
      for _, v in pairs(G.playing_cards) do
        if v:is_face() then SMODS.debuff_card(v, false, 'bl_plant') end
      end
    end,
  },
  bl_head = {
    calculate = function(self, blind, context)
      if blind.disabled then return end

      if context.debuff_card and context.debuff_card:is_suit("Hearts") then
          return {
              debuff = true
          }
      end
    end,
    defeat = function(self)
      for _, v in pairs(G.playing_cards) do
        if v:is_suit("Hearts") then SMODS.debuff_card(v, false, 'bl_head') end
      end
    end,
    disable = function(self)
      for _, v in pairs(G.playing_cards) do
        if v:is_suit("Hearts") then SMODS.debuff_card(v, false, 'bl_head') end
      end
    end,
  },
  bl_goad = {
    calculate = function(self, blind, context)
      if blind.disabled then return end

      if context.debuff_card and context.debuff_card:is_suit("Spades") then
          return {
              debuff = true
          }
      end
    end,
    defeat = function(self)
      for _, v in pairs(G.playing_cards) do
        if v:is_suit("Spades") then SMODS.debuff_card(v, false, 'bl_goad') end
      end
    end,
    disable = function(self)
      for _, v in pairs(G.playing_cards) do
        if v:is_suit("Spades") then SMODS.debuff_card(v, false, 'bl_goad') end
      end
    end,
  },
  bl_window = {
    calculate = function(self, blind, context)
      if blind.disabled then return end

      if context.debuff_card and context.debuff_card:is_suit("Diamonds") then
          return {
              debuff = true
          }
      end
    end,
    defeat = function(self)
      for _, v in pairs(G.playing_cards) do
        if v:is_suit("Diamonds") then SMODS.debuff_card(v, false, 'bl_window') end
      end
    end,
    disable = function(self)
      for _, v in pairs(G.playing_cards) do
        if v:is_suit("Diamonds") then SMODS.debuff_card(v, false, 'bl_window') end
      end
    end,
  },
  bl_club = {
    calculate = function(self, blind, context)
      if blind.disabled then return end

      if context.debuff_card and context.debuff_card:is_suit("Clubs") then
          return {
              debuff = true
          }
      end
    end,
    defeat = function(self)
      for _, v in pairs(G.playing_cards) do
        if v:is_suit("Clubs") then SMODS.debuff_card(v, false, 'bl_club') end
      end
    end,
    disable = function(self)
      for _, v in pairs(G.playing_cards) do
        if v:is_suit("Clubs") then SMODS.debuff_card(v, false, 'bl_club') end
      end
    end,
  }
}

local function add_extra(add, to)
  if to.extra then add_extra(add, to.extra)
  else to.extra = add
  end
end

SMODS.Blind {
  key = "delirium",
  dollars = 12,
  mult = 2,
  boss = { tboj_final_boss = true },
  boss_colour = HEX("CCBCBB"),
  pos = { x = 0, y = 19 },
  atlas = "boss_blinds",
  discovered = false,
  debuff = { },
  config = {disabled = false},
  modifies_draw = true,
  loc_vars = function (self)
    local lines = {"", "", ""}
    local total = #G.GAME.current_round.tboj_delirium_picks
    for i, k in pairs(G.GAME.current_round.tboj_delirium_picks) do
      if i <= total / 3 then
        lines[1] = lines[1] .. localize{set = "Blind", key = k, type = "name_text"} .. ","
        if i + 1 < total / 3 then
          lines[1] = lines[1] .. " "
        end
      elseif i <= total / 3 * 2 + 1 then -- +1 so the 2nd line takes 1 more than the third on ante 9, don't really care about above
        lines[2] = lines[2] .. localize{set = "Blind", key = k, type = "name_text"} .. ","
        if i < total / 3 * 2 then
          lines[2] = lines[2] .. " "
        end
      else
        lines[3] = lines[3] .. localize{set = "Blind", key = k, type = "name_text"}
        if i ~= total then
        lines[3] = lines[3] .. ", "
        end
      end
    end
    return {set = 'Blind', key = 'bl_tboj_delirium_bosses', vars = {lines[1], lines[2], lines[3]}}
  end,
  calc_dollar_bonus = function(self, blind)
    local res = {}
    for i, k in pairs(G.GAME.current_round.tboj_delirium_picks) do
      if k ~= "bl_tboj_delirium" and G.P_BLINDS[k].calc_dollar_bonus and type(G.P_BLINDS[k].calc_dollar_bonus) == "function" then
        res[#res+1] = G.P_BLINDS[k]:calc_dollar_bonus(blind)
      end
    end
    for i = #res, 1, -1 do
      if res[i-1] then add_extra(res[i], res[i-1]) end
    end
    return res[1]
  end,
  calculate = function(self, blind, context)
    if not blind.disabled then

      if context.setting_blind then
        for i, k in pairs(G.GAME.current_round.tboj_delirium_picks) do
          if k ~= "bl_tboj_delirium" and G.P_BLINDS[k].config then
            for kk, vv in pairs(G.P_BLINDS[k].config) do
              if blind.effect[kk] == nil then
                blind.effect[kk] = vv
              end
            end
          end
        end
      end

      -- specific calculate part for debuffing hands to show the blind that debuffs the hand, if any
      if context.debuff_hand then
        local res = {}
        local source = {}
        for i, k in pairs(G.GAME.current_round.tboj_delirium_picks) do
          if k ~= "bl_tboj_delirium" then
            if vanilla_bosses[k] and vanilla_bosses[k].debuff_hand then
              local temp = vanilla_bosses[k].debuff_hand(self, context.full_hand, context.scoring_hand, context.scoring_name, context.check)
              if temp then
                res[#res+1] = temp
                source[#source+1] = k
              end
            elseif vanilla_bosses[k] and vanilla_bosses[k].calculate then
              local temp = vanilla_bosses[k].calculate(self, blind, context)
              if temp then
                res[#res+1] = temp
                source[#source+1] = k
              end
            elseif G.P_BLINDS[k].debuff_hand and type(G.P_BLINDS[k].debuff_hand) == "function" then
              local temp = G.P_BLINDS[k]:debuff_hand(self, context.full_hand, context.scoring_hand, context.scoring_name, context.check)
              if temp then
                res[#res+1] = temp
                source[#source+1] = k
              end
            elseif G.P_BLINDS[k].calculate and type(G.P_BLINDS[k].calculate) == "function" then
              local temp = G.P_BLINDS[k]:calculate(blind, context)
              if temp then
                res[#res+1] = temp
                source[#source+1] = k
              end
            end
          end
        end

        for i, v in ipairs(res) do
          if v == true then
            local boss = localize{set = "Blind", key = source[i], type = "name_text"}
            res[i] = {
              debuff = true,
              debuff_text = localize {type = 'variable', key = 'tboj_element_prevents_hand', vars = { boss }}
            }
          elseif type(v) == "table" and v.debuff then
            local boss = localize{set = "Blind", key = source[i], type = "name_text"}
            res[i].debuff_text = localize {type = 'variable', key = 'tboj_element_prevents_hand', vars = { boss }}
          end
        end

        for i = #res, 1, -1 do
          if res[i-1] then add_extra(res[i], res[i-1]) end
        end
        return res[1]
      end

      -- all other contexts
      local res = {}
      for i, k in pairs(G.GAME.current_round.tboj_delirium_picks) do
        if k ~= "bl_tboj_delirium" then
          if vanilla_bosses[k] and vanilla_bosses[k].calculate then
            res[#res+1] = vanilla_bosses[k].calculate(self, blind, context)
          elseif G.P_BLINDS[k].calculate and type(G.P_BLINDS[k].calculate) == "function" then
            res[#res+1] = G.P_BLINDS[k]:calculate(blind, context)
          end
        end
      end
      for i = #res, 1, -1 do
        if res[i-1] then add_extra(res[i], res[i-1]) end
      end
      return res[1]

    end
  end,
  --[[
  debuff_hand = function(self, cards, hand, handname, check)
    local res = false
    for i, k in pairs(G.GAME.current_round.tboj_delirium_picks) do
      if k ~= "bl_tboj_delirium" then
        if vanilla_bosses[k] and vanilla_bosses[k].debuff_hand then
          res = vanilla_bosses[k].debuff_hand(self, cards, hand, handname, check)
        elseif G.P_BLINDS[k].debuff_hand and type(G.P_BLINDS[k].debuff_hand) == "function" then
          res = G.P_BLINDS[k]:debuff_hand(cards, hand, handname, check)
        end
      end
      if res then break end
    end
    return res
  end,]]
  defeat = function(self)
    for i, k in pairs(G.GAME.current_round.tboj_delirium_picks) do
      if k ~= "bl_tboj_delirium" then
        if vanilla_bosses[k] and vanilla_bosses[k].defeat then
          vanilla_bosses[k].defeat(self)
        elseif G.P_BLINDS[k].defeat and type(G.P_BLINDS[k].defeat) == "function" then
          G.P_BLINDS[k]:defeat()
        end
      end
    end
  end,
  disable = function(self)
    for i, k in pairs(G.GAME.current_round.tboj_delirium_picks) do
      if k ~= "bl_tboj_delirium" then
        if vanilla_bosses[k] and vanilla_bosses[k].disable then
          vanilla_bosses[k].disable(self)
        elseif G.P_BLINDS[k].disable and type(G.P_BLINDS[k].disable) == "function" then
          G.P_BLINDS[k]:disable()
        end
      end
    end
  end,
  drawn_to_hand = function(self)
    for i, k in pairs(G.GAME.current_round.tboj_delirium_picks) do
      if k ~= "bl_tboj_delirium" and G.P_BLINDS[k].drawn_to_hand and type(G.P_BLINDS[k].drawn_to_hand) == "function" then
        G.P_BLINDS[k]:drawn_to_hand()
      end
    end
  end,
  modify_hand = function(self, cards, poker_hands, text, mult, hand_chips)
    local res = 1
    local res2 = 1
    local res3 = false
    for i, k in pairs(G.GAME.current_round.tboj_delirium_picks) do
      if k ~= "bl_tboj_delirium" and G.P_BLINDS[k].modify_hand and type(G.P_BLINDS[k].modify_hand) == "function" then
        local a, b, c = G.P_BLINDS[k]:modify_hand(cards, poker_hands, text, mult, hand_chips)
        res = res * a
        res2 = res2 * b
        res3 = res3 or c
      end
    end
    return res, res2, res3
  end,
  press_play = function(self)
    for i, k in pairs(G.GAME.current_round.tboj_delirium_picks) do
      if k ~= "bl_tboj_delirium" and G.P_BLINDS[k].press_play and type(G.P_BLINDS[k].press_play) == "function" then
        G.P_BLINDS[k]:press_play()
      end
    end
  end,
  recalc_debuff = function(self, card, from_blind)
    local res = false
    for i, k in pairs(G.GAME.current_round.tboj_delirium_picks) do
      if k ~= "bl_tboj_delirium" and G.P_BLINDS[k].recalc_debuff and type(G.P_BLINDS[k].recalc_debuff) == "function" then
        res = res or G.P_BLINDS[k]:recalc_debuff(card, from_blind)
      end
    end
    return res
  end,
  set_blind = function(self)
    local chips = G.GAME.blind.chips
    local mult = 1
    for i, k in pairs(G.GAME.current_round.tboj_delirium_picks) do
      if k ~= "bl_tboj_delirium" and G.P_BLINDS[k].set_blind and type(G.P_BLINDS[k].set_blind) == "function" then
        G.P_BLINDS[k]:set_blind()
      end

      if k ~= "bl_tboj_delirium" and G.P_BLINDS[k].mult ~=2 then mult = mult * (G.P_BLINDS[k].mult/2) end
    end
    if mult ~= 1 then
      G.GAME.blind.chips = chips * mult
      G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
    end
  end,
  stay_flipped = function (self, area, card)
    local res = false
    for i, k in pairs(G.GAME.current_round.tboj_delirium_picks) do
      if k ~= "bl_tboj_delirium" and G.P_BLINDS[k].stay_flipped and type(G.P_BLINDS[k].stay_flipped) == "function" then
        res = res or G.P_BLINDS[k]:stay_flipped(area, card)
      end
    end
    return res
  end,
  in_pool = function (self)
    return G.GAME.modifiers.tboj_final_boss
      and G.GAME.round_resets.ante > 0
      and G.GAME.round_resets.ante % G.GAME.win_ante == 0
  end,
  tboj_artist = "Maelmc"
}