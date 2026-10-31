-- Sacred Orb
SMODS.Joker {
  key = "sacred_orb",
  pos = { x = 0, y = 46 },
  config = {extra = {num = 1, den = 3}},
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue+1] = {set = 'Other', key = 'tboj_reroll'}
    local num, den = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.den, "tboj_sacred_orb")
    return {vars = {num, den}}
  end,
  rarity = 3,
  cost = 8,
  atlas = "jokers",
  perishable_compat = true,
  eternal_compat = true,
  blueprint_compat = false,
  calculate = function(self, card, context)
    if context.modify_shop_card then
      if context.card.config and context.card.config.center then
        if context.card.config.center.rarity == 1 or context.card.config.center.rarity == "Common" then
          local _k = SMODS.poll_object({type = "Joker", seed = "tboj_sacred_orb"..G.GAME.round_resets.ante, rarities = {"Uncommon", "Rare"}}) --TBOJ.get_random_key({set = "Joker", seed = "tboj_sacred_orb", banned_rarities = {1, 4, "Common", "Legendary"}})
          TBOJ.reroll(context.card, _k, true)
        end

        if (context.card.config.center.rarity == 2 or context.card.config.center.rarity == "Uncommon") and SMODS.pseudorandom_probability(card, "tboj_sacred_orb_uncommon"..G.GAME.round_resets.ante, card.ability.extra.num, card.ability.extra.den, "tboj_sacred_orb_uncommon"..G.GAME.round_resets.ante) then
          local _k = SMODS.poll_object({type = "Joker", seed = "tboj_sacred_orb"..G.GAME.round_resets.ante, rarities = {"Uncommon", "Rare"}}) --TBOJ.get_random_key({set = "Joker", seed = "tboj_sacred_orb", banned_rarities = {1, 4, "Common", "Legendary"}})
          TBOJ.reroll(context.card, _k, true)
        end
      end
    end
  end,
  in_pool = function (self, args)
    return TBOJ.in_pool(self, args)
  end,
  attributes = {"tboj_angel", "passive", "chance"}
}

-- Sauguine Bond
-- The Swarm

-- Salvation
-- Vanishing Twin
-- Twisted Pair
SMODS.Joker {
  key = "twisted_pair",
  pos = { x = 7, y = 46 },
  config = {extra = {reduce = 0.75}},
  loc_vars = function(self, info_queue, card)
    if card.area and card.area == G.jokers then
      local left_joker
      local right_joker
      for i = 1, #G.jokers.cards do
        if G.jokers.cards[i] == card then
          left_joker = G.jokers.cards[i - 1]
          right_joker = G.jokers.cards[i + 1]
        end
      end
      local compat_left = left_joker and left_joker ~= card and left_joker.config.center.blueprint_compat
      local compat_right = right_joker and right_joker ~= card and right_joker.config.center.blueprint_compat
      local main_end = {
        {
          n = G.UIT.C,
          config = { align = "bm", minh = 0.4 },
          nodes = {
            {
              n = G.UIT.R,
              config = { ref_table = card, align = "m", colour = compat_left and mix_colours(G.C.GREEN, G.C.JOKER_GREY, 0.8) or mix_colours(G.C.RED, G.C.JOKER_GREY, 0.8), r = 0.05, padding = 0.06 },
              nodes = {
                { n = G.UIT.T, config = { text = ' ' .. localize("tboj_left") .. ': ' .. localize('k_' .. (compat_left and 'compatible' or 'incompatible')) .. ' ', colour = G.C.UI.TEXT_LIGHT, scale = 0.32 * 0.8 } },
              }
            },
            {
              n = G.UIT.R,
              config = { ref_table = card, align = "m", colour = G.C.UI.TEXT_LIGHT, padding = G.t_p or 0.025 },
              nodes = {
                {},
              }
            },
            {
              n = G.UIT.R,
              config = { ref_table = card, align = "m", colour = compat_right and mix_colours(G.C.GREEN, G.C.JOKER_GREY, 0.8) or mix_colours(G.C.RED, G.C.JOKER_GREY, 0.8), r = 0.05, padding = 0.06 },
              nodes = {
                { n = G.UIT.T, config = { text = ' ' .. localize("tboj_right") .. ': ' .. localize('k_' .. (compat_right and 'compatible' or 'incompatible')) .. ' ', colour = G.C.UI.TEXT_LIGHT, scale = 0.32 * 0.8 } },
              }
            },
          }
        }
      }
      return { vars = {card.ability.extra.reduce}, main_end = main_end }
    end
    return { vars = {card.ability.extra.reduce}}
  end,
  rarity = 4,
  cost = 20,
  atlas = "jokers",
  perishable_compat = true,
  eternal_compat = true,
  blueprint_compat = true,
  calculate = function(self, card, context)
    local left_joker
    local right_joker
    for i = 1, #G.jokers.cards do
      if G.jokers.cards[i] == card then
        left_joker = G.jokers.cards[i - 1]
        right_joker = G.jokers.cards[i + 1]
      end
    end
    local ret_left = SMODS.blueprint_effect(card, left_joker, context)
    -- Vanilla jokers return their own message with the original value, so we remove it to display the correct message
    if ret_left and left_joker and not left_joker.config.center.mod then
      for k, v in pairs(ret_left) do
        local start_, _ = string.find(k, "_mod")
        if start_ then
          ret_left.message = nil
          ret_left[string.sub(k, 1, start_ -1)] = v
          ret_left[k] = nil
        end
      end
    end
    local ret_right = SMODS.blueprint_effect(card, right_joker, context)
    -- Vanilla jokers return their own message with the original value, so we remove it to display the correct message
    if ret_right and left_joker and not left_joker.config.center.mod then
      for k, v in pairs(ret_right) do
        local start_, _ = string.find(k, "_mod")
        if start_ then
          ret_right.message = nil
          ret_right[string.sub(k, 1, start_ -1)] = v
          ret_right[k] = nil
        end
      end
    end

    -- nest results: first left joker then right joker
    if ret_left then
      if ret_right then
        local target = ret_left
        while true do
          if target.extra then target = target.extra
          else
            target.extra = ret_right
            break
          end
        end
      end
    elseif ret_right then
      ret_left = SMODS.shallow_copy(ret_right)
      ret_right = nil
    else return end

    -- x0.75 chips, mult, xmult, money
    local to_reduce = {
      'chips', 'h_chips', 'chip_mod',
      'mult', 'h_mult', 'mult_mod',
      'p_dollars', 'dollars', 'h_dollars',
    }

    local xmult_names = {
      'x_mult', 'Xmult', 'xmult', 'x_mult_mod', 'Xmult_mod',
    }

    local function reduce_values(ret)
      if ret then
        ret.colour = G.C.BLACK
        for _, v in pairs(to_reduce) do
          if ret[v] then ret[v] = ret[v] * card.ability.extra.reduce end
        end
        for _, v in pairs(xmult_names) do
          if ret[v] then ret[v] = (ret[v] - 1) * 0.75 + 1 end -- only reduce what's above 1
        end
        if ret.extra then ret.extra = reduce_values(ret.extra) end
        return SMODS.shallow_copy(ret)
      end
      return {}
    end
    ret_left = reduce_values(ret_left)
    print(ret_left)
    return ret_left
  end,
  in_pool = function (self, args)
    return TBOJ.in_pool(self, args)
  end,
  attributes = {"tboj_devil", "tboj_devil", "tboj_familiar", "copying", "position"}
}

-- Azazel's Rage
-- Echo Chamber

-- Esau Jr.
-- Berserk!
-- Dark Arts
TBOJ.Active {
  key = "dark_arts",
  pos = { x = 14, y = 46 },
  cost = 5,
  config = {extra = {max_charge = 30, curr_charge = 30, select = 2, mult = 1}},
  loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.curr_charge, card.ability.extra.max_charge, card.ability.extra.select, card.ability.extra.mult}}
  end,
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play and card.ability.extra.curr_charge < card.ability.extra.max_charge then
      card.ability.extra.curr_charge = card.ability.extra.curr_charge + 1
      return {
        message = card.ability.extra.curr_charge >= card.ability.extra.max_charge and localize("tboj_dark_arts_flavor") or localize("tboj_charging_dot"),
        message_card = card
      }
    end
  end,
  can_use = function(self, card)
    return card.ability.extra.curr_charge >= card.ability.extra.max_charge and (G.hand and G.hand.highlighted and #G.hand.highlighted == card.ability.extra.select)
  end,
  use = function(self, card, area, copier)
    G.E_MANAGER:add_event(Event({
      trigger = 'after',
      delay = 0.4,
      func = function()
        play_sound('tarot1')
        card:juice_up(0.3, 0.5)
        return true
      end
    }))
    G.E_MANAGER:add_event(Event({
      trigger = 'after',
      delay = 0.2,
      func = function()
        SMODS.destroy_cards(G.hand.highlighted)
        return true
      end
    }))
    for i = 1, #G.hand.cards do
      G.E_MANAGER:add_event(Event({
        trigger = 'after',
        func = function()
          local target = G.hand.cards[i]
          if not target.getting_sliced then
            target.ability.perma_mult = (target.ability.perma_mult or 0) + card.ability.extra.mult
            SMODS.calculate_effect({message = localize('k_upgrade_ex'), colour = G.C.MULT}, target)
          end
          return true
        end
      }))
    end
    card:juice_up(0.3, 0.5)
  end,
  keep_on_use = function(self, card)
    return true
  end,
  in_pool = function(self)
    return TBOJ.in_pool(self)
  end,
  attributes = {"tboj_devil", "mult", "perma_bonus", "modify_card"}
}

-- Abyss
-- Supper
SMODS.Joker {
  key = "supper",
  pos = { x = 1, y = 47 },
  config = { extra = { money = 6, m_minus = 1 } },
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.money, card.ability.extra.m_minus } }
  end,
  rarity = 1,
  cost = 6,
  atlas = "jokers",
  perishable_compat = true,
  eternal_compat = false,
  blueprint_compat = false,
  calc_dollar_bonus = function(self, card)
    G.E_MANAGER:add_event(Event({
      trigger = 'after',
      delay = 0.4,
      func = function()
        if card.ability.extra.money - card.ability.extra.m_minus <= 0 then
          SMODS.destroy_cards(card, {bypass_eternal = true, pinch_anim = true})
          SMODS.calculate_effect({message = localize("k_eaten_ex"), colour = G.C.MONEY}, card)
        else
          card.ability.extra.money = card.ability.extra.money - card.ability.extra.m_minus
          SMODS.calculate_effect({message = localize({
            type = "variable",
            key = "tboj_minus_money_var",
            vars = { 1 }
          }), colour = G.C.MONEY}, card)
        end
        return true
      end
    }))

    return card.ability.extra.money
  end,
  attributes = {"food", "economy", "scaling"}
}

-- Stapler
SMODS.Joker {
  key = "stapler",
  pos = { x = 2, y = 47 },
  config = {extra = {Xmult = 3}},
  loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.Xmult}}
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
        xmult = card.ability.extra.Xmult
      }
    end
  end,
  in_pool = function (self, args)
    return TBOJ.in_pool(self, args)
  end,
  set_ability = function(self, card, initial, delay_sprites)
    if initial then
      card.pinned = true
    end
  end,
  attributes = {"xmult"},
}

-- Suplex
-- Bag of Crafting
-- Flip
-- Lemegeton
TBOJ.Active {
  key = "lemegeton",
  pos = { x = 6, y = 47 },
  cost = 8,
  config = {extra = {max_charge = 6, curr_charge = 6, cursed = 5}},
  loc_vars = function(self, info_queue, card)
    if not card.edition or (card.edition and not card.edition.negative) then
      info_queue[#info_queue+1] = G.P_CENTERS.e_negative
    end
    info_queue[#info_queue+1] = {set = 'Other', key = 'tboj_cursed', vars = {card.ability.extra.cursed, card.ability.extra.cursed > 1 and "s" or "", card.ability.extra.cursed}}
    return {vars = {card.ability.extra.curr_charge, card.ability.extra.max_charge, card.ability.extra.cursed}}
  end,
  calculate = function(self, card, context)
    TBOJ.eor_charge(card,context)
  end,
  can_use = function(self, card)
    return card.ability.extra.curr_charge >= card.ability.extra.max_charge
  end,
  use = function(self, card, area, copier)
    G.E_MANAGER:add_event(Event({
      trigger = 'after',
      delay = 0.4,
      func = function()
        local _card = SMODS.add_card { set = "Joker", edition = "e_negative", key_append = "tboj_lemegeton" }
        TBOJ.apply_cursed(_card, card.ability.extra.cursed)
        SMODS.calculate_effect({message = localize('k_plus_joker'), colour = G.C.BLUE}, _card)
        card:juice_up(0.3, 0.5)
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
  attributes = {"tboj_book", "tboj_devil", "joker", "editions", "generation"}
}

-- Recall
-- Hold
-- Keeper's Sack
SMODS.Joker {
  key = "keeper_sack",
  pos = { x = 10, y = 47 },
  config = { extra = { mult = 0, mult_mod = 1, every = 5, scales_in = 5 } },
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.mult_mod, card.ability.extra.every, card.ability.extra.scales_in, card.ability.extra.mult } }
  end,
  rarity = 2,
  cost = 5,
  atlas = "jokers",
  perishable_compat = false,
  eternal_compat = false,
  blueprint_compat = false,
  calculate = function(self, card, context)
    if context.money_altered and context.from_shop and context.amount < 0 then
      card.ability.extra.scales_in = card.ability.extra.scales_in + context.amount
      local scale_by = 0
      while card.ability.extra.scales_in <= 0 do
        card.ability.extra.scales_in = card.ability.extra.scales_in + card.ability.extra.every
        scale_by = scale_by + 1
      end
      if scale_by > 0 then
        SMODS.scale_card(card, {
          ref_value = 'mult',
          scalar_value = 'mult_mod',
          operation = function(ref_table, ref_value, initial, change)
            ref_table[ref_value] = initial + scale_by*change
          end,
        })
        return nil, true
      end
    end

    if context.joker_main then
      return {
        mult = card.ability.extra.mult
      }
    end
  end,
  attributes = {"mult", "scaling", "reroll"}
}

-- Keeper's Kin
-- Keeper's Box
TBOJ.Active {
  key = "keeper_box",
  pos = { x = 13, y = 47 },
  cost = 6,
  config = {extra = {max_charge = 6, curr_charge = 6}},
  loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.curr_charge, card.ability.extra.max_charge}}
  end,
  calculate = function(self, card, context)
    TBOJ.eor_charge(card,context)
  end,
  can_use = function(self, card)
    return card.ability.extra.curr_charge >= card.ability.extra.max_charge and G.STATE == G.STATES.SHOP
  end,
  use = function(self, card, area, copier)
    SMODS.add_voucher_to_shop()
    SMODS.calculate_effect({message = localize('tboj_plus_voucher')}, card)
  end,
  keep_on_use = function(self, card)
    return true
  end,
  in_pool = function(self)
    return TBOJ.in_pool(self)
  end,
}

-- Everything Jar
-- TMTRAINER
-- Anima Sola
-- Spindown Dice = Spectral
-- Hypercoagulation
-- IBS
SMODS.Joker {
  key = "ibs",
  pos = { x = 4, y = 48 },
  config = {extra = {mult_mod = 10, Xmult_multi = 1.5, Xmult_multi2 = 2}},
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue + 1] = G.P_CENTERS.m_tboj_poop
    info_queue[#info_queue + 1] = G.P_CENTERS.spiderfly_tboj_pretty_fly
    info_queue[#info_queue + 1] = G.P_CENTERS.m_stone
    return {vars = {card.ability.extra.mult_mod, card.ability.extra.Xmult_multi, card.ability.extra.Xmult_multi2}}
  end,
  rarity = 1,
  cost = 6,
  atlas = "jokers",
  perishable_compat = true,
  eternal_compat = true,
  blueprint_compat = true,
  enhancement_gate = "m_tboj_poop",
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.hand and not context.end_of_round and SMODS.has_enhancement(context.other_card, "m_tboj_poop") then
      local _rand = pseudorandom("tboj_ibs",1,7)
      print(_rand)
      if _rand == 1 then -- Corn Poop: Pretty Fly
        local _card = SMODS.create_card {
          set = "tboj_spiderfly",
          key = "spiderfly_tboj_pretty_fly",
          area = G.tboj_flies
        }
        _card.states.visible = nil
        _card:add_to_deck()
        G.tboj_flies:emplace(_card)
        G.E_MANAGER:add_event(Event({
          trigger = 'after',
          delay = 0.1,
          func = function()
            _card:start_materialize()
            return true
          end
        }))
        return {
          message = localize('tboj_corn'),
          card = context.other_card
        }

      elseif _rand == 2 then -- Flaming Poop: Mult
        return {
          message = localize('tboj_flaming'),
          mult = card.ability.extra.mult_mod
        }

      elseif _rand == 3 then -- Stinky Poop: Adjacent to poop
        local to_change = {}
        for i, v in ipairs(G.hand.cards) do
          if v == context.other_card then
            if G.hand.cards[i-1] then
              table.insert(to_change, G.hand.cards[i-1])
            end
            if G.hand.cards[i+1] then
              table.insert(to_change, G.hand.cards[i+1])
            end
            break
          end
        end
        TBOJ.juice_flip_cards(to_change)
        for _, v in ipairs(to_change) do
          G.E_MANAGER:add_event(Event({
          trigger = 'after',
          delay = 0.1,
          func = function()
            v:set_ability("m_tboj_poop")
            return true
          end
          }))
        end
        TBOJ.juice_flip_cards(to_change)
        return {
          message = localize('tboj_stinky'),
        }

      elseif _rand == 4 then -- Black Poop: Change to Spades
        TBOJ.juice_flip_cards({context.other_card})
        local _c = context.other_card
        G.E_MANAGER:add_event(Event({
          trigger = 'after',
          delay = 0.1,
          func = function()
            SMODS.change_base(_c,"Spades",nil)
            return true
          end
        }))
        TBOJ.juice_flip_cards({context.other_card})
        return {
          message = localize('tboj_black'),
        }

      elseif _rand == 5 then -- White Poop: Xmult
        return {
          message = localize('tboj_white'),
          Xmult = card.ability.extra.Xmult_multi
        }

      elseif _rand == 6 then -- Stone Poop: Turn to Stone
        TBOJ.juice_flip_cards({context.other_card})
        local _c = context.other_card
        G.E_MANAGER:add_event(Event({
          trigger = 'after',
          delay = 0.1,
          func = function()
            _c:set_ability("m_stone")
            return true
          end
        }))
        TBOJ.juice_flip_cards({context.other_card})
        return {
          message = localize('tboj_stone'),
        }

      else -- Bomb: boom
        local _c = context.other_card
        G.E_MANAGER:add_event(Event({
          func = function()
            SMODS.destroy_cards(_c, {bypass_eternal = true})
            return true
          end
        }))
        return {
          message = localize('tboj_bomb'),
          Xmult = card.ability.extra.Xmult_multi2
        }
      end

    end
  end,
  in_pool = function (self, args)
    return TBOJ.in_pool(self, args)
  end,
  generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table) -- Taken from Pokermon's fossil ui
    if not full_UI_table.name then
      full_UI_table.name = localize({ type = "name", set = self.set, key = self.key, nodes = full_UI_table.name })
    end
    -- get descriptions
    local vars = self:loc_vars(info_queue, card).vars
    local count = #desc_nodes + 1
    localize{type = 'descriptions', key = self.key, set = self.set, nodes = desc_nodes, vars = vars}
    -- set count to the first line with a colon
    while count <= #desc_nodes and not(desc_nodes[count][1] and desc_nodes[count][1].config.text and string.find(desc_nodes[count][1].config.text,"-")) do
      count = count + 1
    end

    local to_replace = {}
    while #desc_nodes >= count do
      local new_node = {n=G.UIT.R, config={align = "tl", scale = 1.0, colour = G.C.UI.TEXT_LIGHT}, nodes = {}}
      local nodes = desc_nodes[count]
      table.remove(desc_nodes, count)

      if not (nodes[1] and nodes[1].config.text and string.find(nodes[1].config.text,"-")) then
        local last_nodes = to_replace[#to_replace].nodes
        table.insert(nodes, 1, {n=G.UIT.C, config={align = "m", colour = G.C.WHITE, r = 0.05, padding = 0.03, res = 0.15, maxh = 0.2}, nodes={
          {n=G.UIT.T, config={text = "99 ", colour = G.C.WHITE, scale = last_nodes[1].nodes[1].config.scale}},
        }})
        local text_extract = string.match(last_nodes[1].config.text,"%s*-%s*")
        table.insert(nodes, 2, {n=G.UIT.T, config={text = text_extract, colour = G.C.WHITE, scale = last_nodes[1].config.scale, maxh = 0.2}})
      end
      new_node.nodes = nodes
      table.insert(to_replace, new_node)
    end

    desc_nodes[#desc_nodes+1] = {{n=G.UIT.C, config = {align = "tl", scale = 1.0, colour = G.C.UI.TEXT_LIGHT, padding = 0.05}, nodes = to_replace}}
  end,
  attributes = {"tboj_poop", "enhancements", "generation", "mult", "xmult", "modify_card", "suit", "spades"},
}

-- Hemoptysis
-- Ghost Bombs

-- Glass Eye
SMODS.Joker {
  key = "glass_eye",
  pos = { x = 9, y = 48 },
  config = {extra = {Xmult = 1, Xmult_mod = 0.1}},
  loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.Xmult_mod, card.ability.extra.Xmult}}
  end,
  rarity = 2,
  cost = 6,
  atlas = "jokers",
  perishable_compat = false,
  eternal_compat = true,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.pseudorandom_result and context.result then
      SMODS.scale_card(card, {
        ref_value = 'Xmult',
        scalar_value = 'Xmult_mod',
        message_key = 'a_xmult',
      })
      return nil, true
    end

    if context.joker_main then
      return {
        xmult = card.ability.extra.Xmult
      }
    end
  end,
  in_pool = function (self, args)
    return TBOJ.in_pool(self, args)
  end,
  attributes = {"scaling", "xmult"},
}

-- Stye
-- Mom's Ring

--[[
SMODS.Joker {
  key = "glitch",
  pos = { x = 0, y = 0 },
  config = {extra = {}},
  loc_vars = function(self, info_queue, card)
  end,
  rarity = 1,
  cost = 1,
  atlas = "jokers",
  perishable_compat = true,
  eternal_compat = true,
  blueprint_compat = true,
  --no_collection = true,
  calculate = function(self, card, context)
  end,
  in_pool = function (self, args)
    return false
  end,
  set_ability = function(self, card, initial, delay_sprites)
    if initial then
      self:set_sprites(card)
    end
  end,
  set_sprites = function (self, card, front)
    G.GAME.modifiers.tboj_glitch_count = (G.GAME.modifiers.tboj_glitch_count or 0) + 1
    TBOJ.glitch_apply_merged_sprite(card, "tboj_vanilla_jokers")
  end
}]]