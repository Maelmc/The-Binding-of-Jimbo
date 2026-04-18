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
          TBOJ.reroll(context.card, TBOJ.get_random_key({set = "Joker", seed = "tboj_sacred_orb", banned_rarities = {1, 4, "Common", "Legendary"}}), true)
        end

        if (context.card.config.center.rarity == 2 or context.card.config.center.rarity == "Uncommon") and SMODS.pseudorandom_probability(card, "tboj_sacred_orb", card.ability.extra.num, card.ability.extra.den, "tboj_sacred_orb") then
          TBOJ.reroll(context.card, TBOJ.get_random_key({set = "Joker", seed = "tboj_sacred_orb", banned_rarities = {1, 4, "Common", "Legendary"}}), true)
        end
      end
    end
  end,
  in_pool = function (self, args)
    return TBOJ.in_pool(self, args)
  end,
  attributes = {"tboj_angel", "passive", "chance"}
}

-- Dark Arts
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
          SMODS.destroy_cards(card, true, nil, true)
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

-- Suplex
-- Bag of Crafting
-- Flip
-- Lemegeton
TBOJ.Active {
  key = "lemegeton",
  pos = { x = 6, y = 47 },
  cost = 8,
  config = {extra = {max_charge = 6, curr_charge = 6}},
  loc_vars = function(self, info_queue, card)
    if not card.edition or (card.edition and not card.edition.negative) then
      info_queue[#info_queue+1] = G.P_CENTERS.e_negative
    end
    return {vars = {card.ability.extra.curr_charge, card.ability.extra.max_charge}}
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
        local _card = SMODS.add_card { set = "Joker", edition = "e_negative", stickers = { 'perishable' }, force_stickers = true, key_append = "tboj_lemegeton" }
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
          area = G.flies
        }
        _card.states.visible = nil
        _card:add_to_deck()
        G.flies:emplace(_card)
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
            SMODS.destroy_cards(_c,true)
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