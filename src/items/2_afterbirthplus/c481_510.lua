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
  end,
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
  attributes = {"tboj_angel", "generation", "joker"}
}

-- Eucharist
-- Sack of Sacks
-- Greed's Gullet
SMODS.Joker {
  key = "greed_gullet",
  pos = {x = 5, y = 33},
  config = {extra = {every = 50, max = 10}},
  loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.every, SMODS.signed(card.ability.extra.max), card.ability.extra.every * card.ability.extra.max}}
  end,
  rarity = 2,
  cost = 6,
  atlas = "jokers",
  perishable_compat = true,
  eternal_compat = true,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.setting_blind then
      local bp = context.blueprint_card
      G.E_MANAGER:add_event(Event({
        func = function()
          local hands = math.min(card.ability.extra.max,math.floor((G.GAME.dollars + (G.GAME.dollar_buffer or 0))/card.ability.extra.every))
          if hands >= 1 then
            ease_hands_played(hands)
            SMODS.calculate_effect(
              { message = localize { type = 'variable', key = 'a_hands', vars = { hands } } },
              bp or card)
          end
          return true
        end
      }))
      return nil, true
    end
  end,
  in_pool = function (self, args)
    return TBOJ.in_pool(self, args)
  end,
  attributes = {"economy", "hand"},
}

-- Large Zit
-- Little Horn