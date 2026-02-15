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
    return {vars = {}}
  end,
  rarity = 1,
  cost = 5,
  atlas = "jokers",
  perishable_compat = true,
  eternal_compat = true,
  blueprint_compat = true,
  enhancement_gate = "m_tboj_poop",
  calculate = function(self, card, context)
    if context.remove_playing_cards then
      local to_destroy = {}
      for _, v in pairs(context.removed) do
        if SMODS.has_enhancement(v, "m_glass") and v.area then
          for k, w in ipairs(v.area.cards) do
            if w == v then
              if v.area.cards[k-1] and not table.contains(context.removed, v.area.cards[k-1]) and not v.area.cards[k-1].getting_sliced then
                if not table.contains(to_destroy, v.area.cards[k-1]) then
                  table.insert(to_destroy, v.area.cards[k-1])
                end
              end

              if v.area.cards[k+1] and not table.contains(context.removed, v.area.cards[k+1]) and not v.area.cards[k+1].getting_sliced then
                if not table.contains(to_destroy, v.area.cards[k+1]) then
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
}

-- Metal Plate
-- Eye of Greed