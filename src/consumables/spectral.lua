-- Smelter
SMODS.Consumable {
  key = "smelter",
  set = "Spectral",
  pos = { x = 12, y = 0 },
  atlas = "consumables",
  cost = 4,
  unlocked = true,
  loc_vars = function(self, info_queue, card)
    if not card.edition or (card.edition and not card.edition.negative) then
      info_queue[#info_queue+1] = G.P_CENTERS.e_negative
    end
    return {vars = {}}
  end,
  can_use = function(self, card)
    return G.tboj_Trinkets and #G.tboj_Trinkets.highlighted == 1
  end,
  use = function(self, card, area, copier)
    G.E_MANAGER:add_event(Event({
      func = function() 
        local target = G.tboj_Trinkets.highlighted[1]
        target:set_edition("e_negative",true)
        return true 
      end 
    }))
  end,
  attributes = {"editions"},
}

-- Spindown Dice
SMODS.Consumable {
  key = "spindown_dice",
  set = "Spectral",
  pos = { x = 0, y = 0 },
  atlas = "consumables",
  cost = 4,
  unlocked = true,
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue+1] = {set = 'Other', key = 'tboj_reroll'}
    return {vars = {}}
  end,
  can_use = function(self, card)
    local target = TBOJ.leftmost_or_selected_joker()
    return target and target.config and target.config.center and target.config.center.key and not target:is_rarity("tboj_transformation")
  end,
  use = function(self, card, area, copier)
    local target = TBOJ.leftmost_or_selected_joker()
    if target.config.center.key == "j_joker" or target.config.center.key == "j_tboj_the_sad_onion" then
      G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0.4,
        func = function() 
          SMODS.destroy_cards(target,{bypass_eternal = true})
          return true 
        end 
      }))
      return
    end
    for k, v in ipairs(G.P_CENTER_POOLS.Joker) do
      if v.key == target.config.center.key then
        for l = k-1, 1, -1 do
          local prev = G.P_CENTER_POOLS.Joker[l]
          if (not prev.no_collection) and (prev.rarity ~= "tboj_transformation") then
            G.E_MANAGER:add_event(Event({
              trigger = 'after',
              delay = 0.4,
              func = function()
                TBOJ.reroll(target,prev.key)
                return true
              end
            }))
            return
          end
        end
        return -- only if somehow there's no previous joker? more of a failsafe than anything
      end
    end
  end
}