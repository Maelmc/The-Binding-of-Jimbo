-- Dark Prince's Crown
-- Apple!
-- Lead Pencil
-- Dog Tooth
-- Dead Tooth
-- Linger Bean
-- Shard of Glass
SMODS.Joker {
  key = "shard_of_glass",
  pos = {x = 12, y = 29 },
  config = {extra = {}},
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue + 1] = G.P_CENTERS.m_glass
    return {vars = {}}
  end,
  rarity = 1,
  cost = 5,
  atlas = "jokers",
  perishable_compat = true,
  eternal_compat = true,
  blueprint_compat = true,
  enhancement_gate = "m_glass",
  calculate = function(self, card, context)
    if context.remove_playing_cards then
      local to_destroy = {}
      for _, v in pairs(context.removed) do
        if SMODS.has_enhancement(v, "m_glass") and v.area then
          for k, w in ipairs(v.area.cards) do
            if w == v then
              if v.area.cards[k-1] and not TBOJ.table_contains(context.removed, v.area.cards[k-1]) and not v.area.cards[k-1].getting_sliced then
                if not TBOJ.table_contains(to_destroy, v.area.cards[k-1]) then
                  table.insert(to_destroy, v.area.cards[k-1])
                end
              end

              if v.area.cards[k+1] and not TBOJ.table_contains(context.removed, v.area.cards[k+1]) and not v.area.cards[k+1].getting_sliced then
                if not TBOJ.table_contains(to_destroy, v.area.cards[k+1]) then
                  table.insert(to_destroy, v.area.cards[k+1])
                end
              end
            end
          end
        end
      end
      if #to_destroy > 0 then
        SMODS.destroy_cards(to_destroy)
      end
    end
  end,
  in_pool = function (self, args)
    return TBOJ.in_pool(self, args)
  end,
  attributes = {"enhancements", "destroy_card"},
}

-- Metal Plate
-- Eye of Greed
SMODS.Joker {
  key = "eye_of_greed",
  pos = {x = 14, y = 29 },
  config = {extra = {scored = 0, to_score = 20, money_minus = 1}},
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue + 1] = G.P_SEALS.Gold
    return {vars = {card.ability.extra.to_score, card.ability.extra.scored, card.ability.extra.money_minus}}
  end,
  rarity = 1,
  cost = 5,
  atlas = "jokers",
  perishable_compat = true,
  eternal_compat = true,
  blueprint_compat = false,
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play and not context.blueprint then
      card.ability.extra.scored = card.ability.extra.scored + 1
      if card.ability.extra.scored == card.ability.extra.to_score + 1 then
        card.ability.extra.scored = 0
        context.other_card:set_seal("Gold")

        G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) - card.ability.extra.money_minus
        G.E_MANAGER:add_event(Event({
          func = function()
              G.GAME.dollar_buffer = 0
              return true
          end
        }))
    
        return {
          dollars = -card.ability.extra.money_minus,
          card = card
        }
      end
    end
  end,
  in_pool = function (self, args)
    return TBOJ.in_pool(self, args)
  end,
  attributes = {"seals", "modify_card"},
}