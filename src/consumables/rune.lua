SMODS.Consumable {
  key = "jera",
  set = "tboj_Loot",
  pos = { x = 5, y = 0 },
  atlas = "consumables",
  cost = 4,
  unlocked = true,
  config = { extra = {}},
  loc_vars = function(self, info_queue, card)
    local jera_c = G.GAME.last_tboj_Loot and G.P_CENTERS[G.GAME.last_tboj_Loot] or nil
    local last_tboj_Loot = jera_c and localize { type = 'name_text', key = jera_c.key, set = jera_c.set } or
        localize('k_none')
    local colour = (not jera_c or jera_c.name == 'c_tboj_jera') and G.C.RED or G.C.GREEN

    if not (not jera_c or jera_c.name == 'c_tboj_jera') then
        info_queue[#info_queue + 1] = jera_c
    end

    local main_end = {
        {
            n = G.UIT.C,
            config = { align = "bm", padding = 0.02 },
            nodes = {
                {
                    n = G.UIT.C,
                    config = { align = "m", colour = colour, r = 0.05, padding = 0.05 },
                    nodes = {
                        { n = G.UIT.T, config = { text = ' ' .. last_tboj_Loot .. ' ', colour = G.C.UI.TEXT_LIGHT, scale = 0.3, shadow = true } },
                    }
                }
            }
        }
    }

    return { vars = { last_tboj_Loot }, main_end = main_end }
  end,
  can_use = function(self, card)
    return (#G.consumeables.cards < G.consumeables.config.card_limit or card.area == G.consumeables) and
            G.GAME.last_tboj_Loot and
            G.GAME.last_tboj_Loot ~= 'c_tboj_jera'
  end,
  use = function(self, card, area, copier)
    G.E_MANAGER:add_event(Event({
      trigger = 'after',
      delay = 0.4,
      func = function()
        if G.consumeables.config.card_limit > #G.consumeables.cards then
          play_sound('timpani')
          SMODS.add_card({ key = G.GAME.last_tboj_Loot })
          card:juice_up(0.3, 0.5)
        end
        return true
      end
    }))
    delay(0.6)
  end,
  tboj_rune = true,
}

SMODS.Consumable {
  key = "dagaz",
  set = "tboj_Loot",
  pos = { x = 6, y = 0 },
  atlas = "consumables",
  cost = 4,
  unlocked = true,
  config = { extra = {}},
  loc_vars = function(self, info_queue, card)
    return {}
  end,
  can_use = function(self, card)
    local target = TBOJ.leftmost_or_selected_joker()
    if not target or not target.ability then return false end
    if target.config.center.rarity == "tboj_transformation" then return false end
    local ab = target.ability
    if ab.perishable or ab.rental or ab.eternal or target.debuff then return true end
  end,
  use = function(self, card, area, copier)
    local target = TBOJ.leftmost_or_selected_joker()
    if target.ability and target.ability.set == "Joker" and not (target.config.center.rarity == "tboj_transformation") then
      local ab = target.ability
      if ab.perishable or ab.rental or ab.eternal or target.debuff then
        G.E_MANAGER:add_event(Event({
          func = (function()
            ab.perishable = false
            ab.perish_tally = nil
            ab.eternal = false
            ab.rental = false
            target:set_debuff(false)
            card_eval_status_text(target, 'extra', nil, nil, nil, {message = localize("tboj_purified_ex")})
            return true
          end)
        }))
      end
    end
  end,
  tboj_rune = true,
  in_pool = function(self)
    local ok = false
    for i = 1, #G.jokers.cards do
      local target = G.jokers.cards[i]
      if target.ability and target.ability.set == "Joker" then
        if target.config.center.rarity ~= "tboj_transformation" then
          local ab = target.ability
          if ab.perishable or ab.rental or ab.eternal then
            ok = true
            break
          end
        end
      end
    end
    return ok
  end
}

SMODS.Consumable {
  key = "perthro",
  set = "tboj_Loot",
  pos = { x = 7, y = 0 },
  atlas = "consumables",
  cost = 4,
  unlocked = true,
  config = { extra = {}},
  loc_vars = function(self, info_queue, card)
    return {}
  end,
  can_use = function(self, card)
    return G.shop_jokers and G.shop_jokers.cards
  end,
  use = function(self, card, area, copier)
    for _, v in pairs(G.shop_jokers.cards) do
      if v.ability.set == "Joker" or v.ability.set == "tboj_Active" then
        TBOJ.reroll(v,TBOJ.get_random_key({set = v.ability.set, seed = "d6" .. G.GAME.round_resets.ante, target_rarities = {v.config.center.rarity}}))
      end
    end
  end,
  tboj_rune = true,
}

SMODS.Consumable {
  key = "algiz",
  set = "tboj_Loot",
  pos = { x = 9, y = 0 },
  atlas = "consumables",
  cost = 4,
  unlocked = true,
  config = { extra = {hands = 1 }},
  loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.hands}}
  end,
  can_use = function(self, card)
    return G.STATE == G.STATES.SELECTING_HAND
  end,
  use = function(self, card, area, copier)
    ease_hands_played(card.ability.extra.hands)
  end,
  tboj_rune = true,
}

local soul_weight = 3

--[[
SMODS.Consumable {
  key = "soul_of_cain",
  set = "tboj_Loot",
  pos = { x = 1, y = 1 },
  atlas = "consumables",
  cost = 4,
  unlocked = true,
  weight = soul_weight,
  config = { extra = {min = 1, max = 25}},
  loc_vars = function(self, info_queue, card)
    return { vars = {card.ability.extra.min, card.ability.extra.max}}
  end,
  can_use = function(self, card)
    return true
  end,
  use = function(self, card, area, copier)
    G.E_MANAGER:add_event(Event({
			trigger = "after",
			delay = 0.2,
			func = function()
				play_sound("tarot1")
				local tag = Tag(G.GAME.round_resets.blind_tags["Small"])
				add_tag(tag)
        local target = copier or card
				target:juice_up(0.8, 0.5)
				return true
			end,
		}))

    G.E_MANAGER:add_event(Event({
			trigger = "after",
			delay = 0.2,
			func = function()
				play_sound("tarot1")
				local tag = Tag(G.GAME.round_resets.blind_tags["Big"])
				add_tag(tag)
        local target = copier or card
				target:juice_up(0.8, 0.5)
				return true
			end,
		}))

    if G.GAME.round_resets.blind_tags["Boss"] then
      G.E_MANAGER:add_event(Event({
        trigger = "after",
        delay = 0.2,
        func = function()
          play_sound("tarot1")
          local tag = Tag(G.GAME.round_resets.blind_tags["Boss"])
          add_tag(tag)
          local target = copier or card
          target:juice_up(0.8, 0.5)
          return true
        end,
      }))
    end
    delay(0.6)
  end,
  tboj_rune = true,
}
]]

--[[
SMODS.Consumable {
  key = "soul_of_eve",
  set = "tboj_Loot",
  pos = { x = 4, y = 1 },
  atlas = "consumables",
  cost = 4,
  unlocked = true,
  weight = soul_weight,
  config = { extra = {amount = 30}},
  loc_vars = function(self, info_queue, card)
  end,
  can_use = function(self, card)
    return true
  end,
  use = function(self, card, area, copier)
    for i = 1, card.ability.extra.amount do
      G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0.4,
        func = function()
          play_sound('timpani')
          local _bird = SMODS.add_card({ set = 'Joker', key = "j_tboj_dead_bird", edition = "e_negative" })
          TBOJ.apply_cursed(_bird, 1)
          return true
        end
      }))
    end
    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0.4,
        func = function()
          card:juice_up(0.3, 0.5)
          return true
        end
      }))
    delay(0.6)
  end,
  tboj_rune = true,
}
]]

--[[
SMODS.Consumable {
  key = "soul_of_lilith",
  set = "tboj_Loot",
  pos = { x = 10, y = 1 },
  atlas = "consumables",
  cost = 4,
  unlocked = true,
  weight = soul_weight,
  config = { extra = {}},
  loc_vars = function(self, info_queue, card)
  end,
  can_use = function(self, card)
    return G.jokers and #G.jokers.cards < G.jokers.config.card_limit
  end,
  use = function(self, card, area, copier)
    G.E_MANAGER:add_event(Event({
      trigger = 'after',
      delay = 0.4,
      func = function()
        play_sound('timpani')
        SMODS.add_card({ set = 'Joker', key = TBOJ.get_random_key({set = "Joker", attributes = {"tboj_familiar"}}) })
        card:juice_up(0.3, 0.5)
        return true
      end
    }))
    delay(0.6)
  end,
  tboj_rune = true,
}
]]

SMODS.Consumable {
  key = "soul_of_the_keeper",
  set = "tboj_Loot",
  pos = { x = 11, y = 1 },
  atlas = "consumables",
  cost = 4,
  unlocked = true,
  weight = soul_weight,
  config = { extra = {min = 1, max = 25}},
  loc_vars = function(self, info_queue, card)
    return { vars = {card.ability.extra.min, card.ability.extra.max}}
  end,
  can_use = function(self, card)
    return true
  end,
  use = function(self, card, area, copier)
    G.E_MANAGER:add_event(Event({
      trigger = 'after',
      delay = 0.4,
      func = function()
        play_sound('timpani')
        card:juice_up(0.3, 0.5)
        ease_dollars(pseudorandom("tboj_soul_of_the_keeper", card.ability.extra.min, card.ability.extra.max), true)
        return true
      end
    }))
    delay(0.6)
  end,
  tboj_rune = true,
}

SMODS.Consumable {
  key = "soul_of_jacob_esau",
  set = "tboj_Loot",
  pos = { x = 1, y = 2 },
  atlas = "consumables",
  cost = 4,
  unlocked = true,
  weight = soul_weight,
  config = { extra = {cursed = 3}},
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue+1] = {set = 'Other', key = 'tboj_cursed', vars = {card.ability.extra.cursed, "s", card.ability.extra.cursed}}
    return { vars = {card.ability.extra.cursed}}
  end,
  can_use = function(self, card)
    return G.jokers and #G.jokers.cards > 0 and #G.jokers.cards < G.jokers.config.card_limit
  end,
  use = function(self, card, area, copier)
    local chosen_joker = pseudorandom_element( G.jokers.cards, 'tboj_soul_of_jacob_esau')
    local copied_joker = SMODS.copy_card(chosen_joker, {strip_edition = chosen_joker.edition and chosen_joker.edition.negative})
    if copied_joker.ability.invis_rounds then copied_joker.ability.invis_rounds = 0 end
    if type(copied_joker.ability.extra) == "table" and copied_joker.ability.extra.invis_rounds then copied_joker.ability.extra.invis_rounds = 0 end
    TBOJ.apply_cursed(copied_joker, card.ability.extra.cursed)
    SMODS.calculate_effect({ message = localize('k_duplicated_ex') }, copied_joker)
  end,
  tboj_rune = true,
}