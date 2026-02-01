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
    return TBOJ.leftmost_or_selected()
  end,
  use = function(self, card, area, copier)
    local target = TBOJ.leftmost_or_selected()
    if target.config.center.key == "j_joker" or target.config.center.key == "j_tboj_the_sad_onion" then
      target:start_dissolve({ G.C.RED }, nil, 1.6)
      return
    end
    for k, v in ipairs(G.P_CENTER_POOLS.Joker) do
      if v.key == target.config.center.key then
        local prev = G.P_CENTER_POOLS.Joker[k-1].key
        TBOJ.reroll(target,prev)
      end
    end
  end
}