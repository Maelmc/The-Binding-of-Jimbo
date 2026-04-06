-- Dull Razor
TBOJ.Active {
  key = "dull_razor",
  pos = { x = 5, y = 32 },
  --rarity = "Uncommon",
  cost = 5,
  config = {extra = {max_charge = 2, curr_charge = 2}},
  loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.curr_charge, card.ability.extra.max_charge}}
  end,
  calculate = function(self, card, context)
    TBOJ.eor_charge(card,context)
  end,
  can_use = function(self, card)
    return card.ability.extra.curr_charge >= card.ability.extra.max_charge and G.hand and #G.hand.highlighted > 0
  end,
  use = function(self, card, area, copier)
    SMODS.calculate_context({remove_playing_cards = true, removed = G.hand.highlighted})
  end,
  keep_on_use = function(self, card)
    return true
  end,
  in_pool = function(self)
    return TBOJ.in_pool(self)
  end
}

-- Eden's Soul
TBOJ.Active {
  key = "eden_soul",
  pos = { x = 9, y = 32 },
  cost = 5,
  config = {extra = {max_charge = 12, curr_charge = 0}},
  loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.curr_charge, card.ability.extra.max_charge}}
  end,
  calculate = function(self, card, context)
    TBOJ.eor_charge(card,context)
  end,
  can_use = function(self, card)
    return card.ability.extra.curr_charge >= card.ability.extra.max_charge and G.jokers.config.card_limit - (#G.jokers.cards + G.GAME.joker_buffer) >= 1
  end,
  use = function(self, card, area, copier)
    local jokers_to_create = math.min(2, G.jokers.config.card_limit - (#G.jokers.cards + G.GAME.joker_buffer))
    G.GAME.joker_buffer = G.GAME.joker_buffer + jokers_to_create
    G.E_MANAGER:add_event(Event({
      func = function()
        for i = 1, jokers_to_create do
          local rarity
          if i == 1 then rarity = "Uncommon" else rarity = "Rare" end
          SMODS.add_card {
            set = 'Joker',
            rarity = rarity,
            key_append = 'tboj_eden_soul'
          }
        end
        G.GAME.joker_buffer = 0
        return true
      end
    }))
  end,
  in_pool = function(self)
    return TBOJ.in_pool(self)
  end,
  attributes = {"tboj_angel"}
}