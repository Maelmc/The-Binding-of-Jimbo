SMODS.Back {
	name = "isaac",
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
        SMODS.add_card { key = "active_tboj_the_d6", area = G.actives, set = "tboj_active" }
        return true
      end
    }))
  end
}