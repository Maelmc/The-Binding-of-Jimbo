-- Tooth and Nail
-- Binge Eater
-- Guppy's Eye
SMODS.Joker {
  key = "guppy_eye",
  pos = { x = 4, y = 44 },
  config = {extra = {}},
  loc_vars = function(self, info_queue, card)
    if not G.jokers then
      --print("not in game")
      return {vars = {"",localize("tboj_unknown"),"",""}}
    end
    if not TBOJ.table_contains(G.jokers.cards,card) then
      --print("not owned")
      return {vars = {"",localize("tboj_acquire_to_reveal"),"",""}}
    end

    local predict, part1, part2, part3
    if (not G.shop_booster) or (not G.shop_booster.highlighted[1]) then
      part2 = localize("tboj_select_booster")
      predict = ""
      part1 = ""
      part3 = ""
    else
      local set = G.shop_booster.highlighted[1].ability.name
      if set:find("Buffoon") then set = "Buffoon"
      elseif set:find('Standard') then set = "Standard"
      elseif set:find('Spectral') then set = "Spectral"
      elseif set:find('Celestial') then set = "Celestial"
      elseif set:find('Arcana') then set = "Arcana"
      elseif set:find("tboj_devil") then set = "Devil"
      elseif set:find("tboj_angel") then set = "Angel"
      end
      predict = TBOJ.predict_pack(set, G.shop_booster.highlighted[1].ability.extra)
      part1 = localize("tboj_geye_1")
      local key
      if G.P_CENTERS[G.shop_booster.highlighted[1].config.center_key].original_mod then
        key = G.shop_booster.highlighted[1].config.center_key
      else
        key = string.sub(G.shop_booster.highlighted[1].config.center_key,1,#G.shop_booster.highlighted[1].config.center_key - 2)
      end
      part2 = localize({type = "name_text", set = "Other", key = key})
      part3 = localize("tboj_geye_2")
    end
    return {vars = {part1, part2, part3, predict}}
  end,
  rarity = 1,
  cost = 5,
  atlas = "jokers",
  perishable_compat = true,
  eternal_compat = true,
  blueprint_compat = false,
  calculate = function(self, card, context) end,
  in_pool = function (self, args)
    return TBOJ.in_pool(self, args)
  end,
  attributes = {"tboj_devil", "passive"}
}

-- Strawman
-- Dad's Note

-- Soul Locket
SMODS.Joker {
  key = "soul_locket",
  pos = { x = 10, y = 45 },
  config = {extra = {chips = 0, mult = 0, chips_mod = 20, mult_mod = 3}},
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue + 1] = G.P_CENTERS.c_tboj_soul_heart
    info_queue[#info_queue + 1] = G.P_CENTERS.c_tboj_black_heart
    return {vars = {card.ability.extra.chips_mod, card.ability.extra.mult_mod, card.ability.extra.chips, card.ability.extra.mult}}
  end,
  rarity = 1,
  cost = 6,
  atlas = "jokers",
  perishable_compat = false,
  eternal_compat = true,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.using_consumeable and context.consumeable
    and (context.consumeable.config.center.key == "c_tboj_soul_heart" or context.consumeable.config.center.key == "c_tboj_black_heart")
    and not context.blueprint then
      local rand = pseudorandom("tboj_soul_locket") > 0.5 and "MULT" or "CHIPS"
      if rand == "MULT" then
        SMODS.scale_card(card, {
          ref_value = 'mult',
          scalar_value = 'mult_mod',
          message_colour = G.C.MULT,
        })
      else
        SMODS.scale_card(card, {
          ref_value = 'chips',
          scalar_value = 'chips_mod',
          message_colour = G.C.CHIPS,
        })
      end
    end

    if context.joker_main then
      return {
        chips = card.ability.extra.chips,
        mult = card.ability.extra.mult,
      }
    end
  end,
  in_pool = function (self, args)
    return TBOJ.in_pool(self, args)
  end,
  attributes = {"tboj_angel", "tboj_loot", "chips", "mult"}
}