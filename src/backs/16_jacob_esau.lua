SMODS.Back {
	key = "jacob_esau",
  unlocked = true,
  discovered = true,
	config = { joker_slot = -1, active_slot = 1, trinket_slot = 1 },
  loc_vars = function(self, info_queue, center)
    return {vars = {self.config.active_slot, self.config.trinket_slot, self.config.joker_slot}}
  end,
	pos = { x = 16, y = 0 },
	atlas = "backs",
  apply = function(self, back)
    G.GAME.starting_params.tboj_active_slot = G.GAME.starting_params.tboj_active_slot + self.config.active_slot
    G.GAME.starting_params.tboj_trinket_slot = G.GAME.starting_params.tboj_trinket_slot + self.config.trinket_slot
  end,
}

TBOJ.add_remove_deck("b_jacob_esau", function()
  G.tboj_Actives.config.card_limit = G.tboj_Actives.config.card_limit - 1
  G.tboj_Trinkets.config.card_limit = G.tboj_Trinkets.config.card_limit - 1
  G.jokers.config.card_limit = G.jokers.config.card_limit + 1

  -- schoolbag effect of removing extra active
  G.E_MANAGER:add_event(Event({func = function()
    G.E_MANAGER:add_event(Event({func = function()
      local not_neg = {}
      for _, v in pairs(G.tboj_Actives.cards) do
        if not v.edition or (v.edition and not v.edition.negative) then
          table.insert(not_neg,v)
        end
      end
      if #not_neg > 0 and #not_neg > G.tboj_Actives.config.card_limit then
        local target = pseudorandom_element(not_neg,"schoolbag")
        SMODS.destroy_cards(target, {bypass_eternal = true})
      end
      return true end
    }))

    return true end
  }))
end)