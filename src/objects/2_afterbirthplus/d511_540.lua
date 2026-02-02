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

-- Broken Modem
-- 515
-- 516
-- Fast Bombs
-- Buddy in a Box
-- Lil Delirium
-- Jumper Cables
-- 521
-- 522
-- 523
-- Technology Zero
-- Leprosy
-- 7 seals
-- 527
-- Angelic Prism
-- Pop!
-- Death's List
-- Haemolacria
-- Lachryphagy
-- Trisagion
-- Schoolbag
SMODS.Joker {
  key = "schoolbag", 
  pos = {x = 8, y = 35},
  config = {extra = {active_limit = 1}},
  loc_vars = function(self, info_queue, card)
		return {vars = {card.ability.extra.active_limit}}
  end,
  rarity = 2,
  cost = 6,
  atlas = "jokers",
  blueprint_compat = false,
  add_to_deck = function(self, card, from_debuff)
    local add = card.ability.extra.active_limit
    G.E_MANAGER:add_event(Event({func = function()
      G.actives.config.card_limit = G.actives.config.card_limit + add
      return true end }))
  end,
  remove_from_deck = function(self, card, from_debuff)
    local remove = card.ability.extra.active_limit
    G.E_MANAGER:add_event(Event({func = function()
      G.actives.config.card_limit = G.actives.config.card_limit - remove

      G.E_MANAGER:add_event(Event({func = function()
        local not_neg = {}
        for _, v in pairs(G.actives.cards) do
          if not v.edition or (v.edition and not v.edition.negative) then
            table.insert(not_neg,v)
          end
        end
        if #not_neg > 0 and #not_neg > G.actives.config.card_limit then
          local target = pseudorandom_element(not_neg,"schoolbag")
          target:start_dissolve()
        end
        return true end
      }))

      return true end
    }))
  end,
}