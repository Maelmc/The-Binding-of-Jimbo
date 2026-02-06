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
