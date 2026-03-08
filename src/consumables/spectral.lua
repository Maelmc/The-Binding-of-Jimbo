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
    return target and target.config and target.config.center and target.config.center.key
  end,
  use = function(self, card, area, copier)
    local target = TBOJ.leftmost_or_selected_joker()
    if target.config.center.key == "j_joker" or target.config.center.key == "j_tboj_the_sad_onion" then
      SMODS.destroy_cards(target,true)
      return
    end
    for k, v in ipairs(G.P_CENTER_POOLS.Joker) do
      if v.key == target.config.center.key then
        for l = k-1, 0, -1 do
          local prev = G.P_CENTER_POOLS.Joker[l]
          if not prev.no_collection then
            TBOJ.reroll(target,prev.key)
            return
          end
        end
        return -- only if somehow there's no previous joker? more of a failsafe than anything
      end
    end
  end
}