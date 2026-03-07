SMODS.Consumable {
  key = "jera",
  set = "Loot",
  pos = { x = 5, y = 0 },
  atlas = "consumables",
  cost = 4,
  unlocked = true,
  config = { extra = {}},
  loc_vars = function(self, info_queue, card)
    local jera_c = G.GAME.last_tboj_loot and G.P_CENTERS[G.GAME.last_tboj_loot] or nil
        local last_tboj_loot = jera_c and localize { type = 'name_text', key = jera_c.key, set = jera_c.set } or
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
                            { n = G.UIT.T, config = { text = ' ' .. last_tboj_loot .. ' ', colour = G.C.UI.TEXT_LIGHT, scale = 0.3, shadow = true } },
                        }
                    }
                }
            }
        }

        return { vars = { last_tboj_loot }, main_end = main_end }
  end,
  can_use = function(self, card)
    return (#G.consumeables.cards < G.consumeables.config.card_limit or card.area == G.consumeables) and
            G.GAME.last_tboj_loot and
            G.GAME.last_tboj_loot ~= 'c_tboj_jera'
  end,
  use = function(self, card, area, copier)
    G.E_MANAGER:add_event(Event({
      trigger = 'after',
      delay = 0.4,
      func = function()
        if G.consumeables.config.card_limit > #G.consumeables.cards then
          play_sound('timpani')
          SMODS.add_card({ key = G.GAME.last_tboj_loot })
          card:juice_up(0.3, 0.5)
        end
        return true
      end
    }))
    delay(0.6)
  end,
  rune = true,
}

SMODS.Consumable {
  key = "dagaz",
  set = "Loot",
  pos = { x = 6, y = 0 },
  atlas = "consumables",
  cost = 4,
  unlocked = true,
  config = { extra = {}},
  loc_vars = function(self, info_queue, card)
    return {}
  end,
  can_use = function(self, card)
    local target = TBOJ.leftmost_or_selected()
    if not target or not target.ability then return false end
    local ab = target.ability
    if ab.perishable or ab.rental or ab.eternal or target.debuff then return true end
  end,
  use = function(self, card, area, copier)
    local target = TBOJ.leftmost_or_selected()
    if target.ability and target.ability.set == "Joker" then
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
  rune = true,
  in_pool = function(self)
    local ok = false
    for i = 1, #G.jokers.cards do
      if G.jokers.cards[i].ability and G.jokers.cards[i].ability.set == "Joker" then
        local ab = G.jokers.cards[i].ability
        if ab.perishable or ab.rental or ab.eternal then
          ok = true
          break
        end
      end
    end
    return ok
  end
}

SMODS.Consumable {
  key = "perthro",
  set = "Loot",
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
      if v.ability.set == "Joker" or v.ability.set == "tboj_active" then
        TBOJ.reroll(v,TBOJ.get_random_key({set = v.ability.set, seed = "d6" .. G.GAME.round_resets.ante, target_rarities = {v.config.center.rarity}}))
      end
    end
    SMODS.calculate_effect({message = localize('tboj_reroll_ex')}, card)
  end,
  rune = true,
}