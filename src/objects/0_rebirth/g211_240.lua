-- Stop Watch
SMODS.Joker {
  key = "stop_watch", 
  pos = {x = 7, y = 15},
  config = {extra = {}},
  loc_vars = function(self, info_queue, center)
    return {vars = {}}
  end,
  rarity = 3, 
  cost = 8,
  atlas = "jokers",
  perishable_compat = true,
  eternal_compat = true,
  blueprint_compat = false,
  calculate = function(self, card, context)

  end,
  calc_scaling = function(self, card, scaling_card, initial, scalar_value, args)
    return {
        override_scalar_value = {value = scalar_value * 2}
    }
  end,
  in_pool = function(self)
    return TBOJ.in_pool(self)
  end
}

-- Tiny Planet
-- Infestation 2
-- E. Coli
SMODS.Joker {
  key = "e_coli", 
  pos = {x = 10, y = 15},
  config = {extra = {}},
  loc_vars = function(self, info_queue, center)
    info_queue[#info_queue + 1] = G.P_CENTERS.m_tboj_poop
    return {vars = {}}
  end,
  rarity = 2, 
  cost = 6,
  atlas = "jokers",
  perishable_compat = true,
  eternal_compat = true,
  blueprint_compat = false,
  calculate = function(self, card, context)
    if context.before and not context.blueprint then
            local faces = 0
            for _, scored_card in ipairs(context.scoring_hand) do
                if scored_card:is_face() then
                    faces = faces + 1
                    scored_card:set_ability('m_tboj_poop', nil, true)
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            scored_card:juice_up()
                            return true
                        end
                    }))
                end
            end
            if faces > 0 then
                return {
                    message = localize('k_poop'),
                    colour = G.C.TBOJ.POOP
                }
            end
        end
  end,
  in_pool = function(self)
    return TBOJ.in_pool(self)
  end
}
