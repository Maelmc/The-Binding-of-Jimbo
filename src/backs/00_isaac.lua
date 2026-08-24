SMODS.Back {
	key = "isaac",
  unlocked = true,
  discovered = true,
	config = {},
  loc_vars = function(self, info_queue, center)
    return {vars = {}}
  end,
	pos = { x = 0, y = 0 },
	atlas = "backs",
  apply = function(self)
    G.E_MANAGER:add_event(Event({
      func = function()
        SMODS.add_card { key = "active_tboj_the_d6", area = G.tboj_Actives, set = "tboj_Active" }
        return true
      end
    }))
  end
}