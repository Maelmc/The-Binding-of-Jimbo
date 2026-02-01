-- Angry Fly
-- Black Hole
-- Bozo
SMODS.Joker {
  key = "bozo",
  pos = {x = 2, y = 34 },
  config = {extra = {}},
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue+1] = G.P_CENTERS.m_tboj_poop
    if not card.edition or (card.edition and not card.edition.polychrome) then
      info_queue[#info_queue+1] = G.P_CENTERS.e_polychrome
    end
    return {vars = {}}
  end,
  rarity = 1,
  cost = 6,
  atlas = "jokers",
  blueprint_compat = false,
  enhancement_gate = "m_tboj_poop",
  calculate = function(self, card, context)
    if context.first_hand_drawn and not context.blueprint then
      local eval = function() return G.GAME.current_round.hands_played == 0 and not G.RESET_JIGGLES end
      juice_card_until(card, eval, true)
    end
    if context.before and G.GAME.current_round.hands_played == 0 and #context.full_hand == 1 and not context.blueprint then
      context.full_hand[1]:set_edition("e_polychrome",true)
      G.E_MANAGER:add_event(Event({
        func = function()
          context.full_hand[1]:juice_up()
          return true
        end
      }))
    end
  end,
  in_pool = function (self, args)
    return TBOJ.in_pool(self, args)
  end,
}