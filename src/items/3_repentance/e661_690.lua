-- Tooth and Nail
-- Binge Eater
-- Guppy's Eye
SMODS.Joker {
  key = "guppy_eye",
  pos = { x = 4, y = 44 },
  config = {extra = {}},
  loc_vars = function(self, info_queue, card)
    local cardarea = CardArea(G.ROOM.T.x, G.ROOM.T.y, G.CARD_W * 0.7, G.CARD_H * 0.7, {
      type = "title_2", card_limit = 0, highlight_limit = 0
    })
    if (not G.jokers) or (not TBOJ.table_contains(G.jokers.cards,card)) then
      return {vars = {elements = {cardarea}}}
    end

    local predict
    if (not G.shop_booster) or (not G.shop_booster.highlighted[1]) then
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
      if predict then
        cardarea.T.w = cardarea.T.w * (#predict+1)
        for _, v in ipairs(predict) do
          local _card
          if v.rank then
            _card = SMODS.create_card({set = "Base", area = cardarea, rank = v.rank, suit = v.suit })
            if v.enhancement then _card:set_ability(v.enhancement) end
            if v.edition then _card:set_edition(v.edition,true,true) end
            if v.seal then _card:set_seal(v.seal,true,true) end
          else
            _card = SMODS.create_card({key = v.key, area = cardarea, no_edition = true})
            if v.edition then _card:set_edition(v.edition,true,true) end
            if v.stickers then
              for l, w in pairs(v.stickers) do
                if w and (_card.config.center[l.."_compat"] ~= false) then
                  local sticker = SMODS.Stickers[l]
                  sticker:apply(_card, true)
                end
              end
            end
          end
          _card.T.scale = _card.T.scale * 0.7
          cardarea:emplace(_card)
        end
      end
    end
    return {vars = {elements = {cardarea}}}
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