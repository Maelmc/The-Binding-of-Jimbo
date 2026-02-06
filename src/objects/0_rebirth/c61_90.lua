-- ID 61 doesnt exist
-- Charm of the Vampire
SMODS.Joker {
  key = "charm_of_the_vampire",
  pos = {x = 1, y = 4},
  config = {extra = {mult = 0, mult_mod = 3}},
  loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.mult_mod, card.ability.extra.mult}}
  end,
  rarity = 1,
  cost = 5,
  atlas = "jokers",
  perishable_compat = false,
  eternal_compat = true,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.joker_main then
      return {
        mult = card.ability.extra.mult,
      }
    end

    if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
      card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_mod
      return {
        message = localize('k_upgrade_ex'),
        colour = G.C.MULT
      }
    end
  end,
  in_pool = function (self, args)
    return TBOJ.in_pool(self, args)
  end
}

-- The Battery
SMODS.Joker {
  key = "the_battery",
  pos = {x = 2, y = 4},
  config = {extra = {}},
  loc_vars = function(self, info_queue, card)
    return {vars = {}}
  end,
  rarity = 2,
  cost = 6,
  atlas = "jokers",
  perishable_compat = true,
  eternal_compat = true,
  blueprint_compat = false,
  calculate = function(self, card, context)
  end,
  in_pool = function (self, args)
    return TBOJ.in_pool(self, args)
  end
}

-- Steam Sale
SMODS.Joker {
  key = "steam_sale",
  pos = {x = 3, y = 4},
  config = {extra = {money = 1}},
  loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.money}}
  end,
  rarity = 3,
  cost = 8,
  atlas = "jokers",
  perishable_compat = true,
  eternal_compat = true,
  blueprint_compat = true,
  calculate = function(self, card, context)
  end,
  add_to_deck = function (self, card, from_debuff)
    G.GAME.steam_sale = (G.GAME.steam_sale or 0) + card.ability.extra.money
    G.GAME.round_resets.reroll_cost = G.GAME.round_resets.reroll_cost - card.ability.extra.money
    G.GAME.current_round.reroll_cost = math.max(0, G.GAME.current_round.reroll_cost - card.ability.extra.money)
    G.E_MANAGER:add_event(Event({func = function()
      for _, v in pairs(G.I.CARD) do
        if v.set_cost then v:set_cost() end
      end
      return true end
    }))
  end,
  remove_from_deck = function(self, card, from_debuff)
    G.GAME.steam_sale = G.GAME.steam_sale - card.ability.extra.money
    G.GAME.round_resets.reroll_cost = G.GAME.round_resets.reroll_cost + card.ability.extra.money
    G.GAME.current_round.reroll_cost = math.max(0, G.GAME.current_round.reroll_cost + card.ability.extra.money)
    G.E_MANAGER:add_event(Event({func = function()
      for _, v in pairs(G.I.CARD) do
        if v.set_cost then v:set_cost() end
      end
      return true end
    }))
  end,
  in_pool = function (self, args)
    return TBOJ.in_pool(self, args)
  end
}

-- Anarchist Cookbook
-- The Hourglass
-- Sister Maggy
SMODS.Joker {
  key = "sister_maggy",
  pos = {x = 6, y = 4},
  config = {extra = {mult = 6}},
  loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.mult}}
  end,
  rarity = 1,
  cost = 3,
  atlas = "jokers",
  perishable_compat = true,
  eternal_compat = true,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.joker_main then
      return {
        colour = G.C.MULT,
        mult = card.ability.extra.mult,
      }
    end
  end,
  in_pool = function (self, args)
    return TBOJ.in_pool(self, args)
  end,
  familiar = true
}

-- Technology
-- Chocolate Milk
SMODS.Joker {
  key = "chocolate_milk",
  pos = {x = 8, y = 4},
  config = {extra = {Xmult = 1, Xmult_mod = 0.5}},
  loc_vars = function(self, info_queue, card)
    return {vars = { card.ability.extra.Xmult_mod, card.ability.extra.Xmult }}
  end,
  rarity = 2,
  cost = 7,
  atlas = "jokers",
  perishable_compat = true,
  eternal_compat = true,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.scoring_hand and context.joker_main then
      if G.jokers.cards[#G.jokers.cards] == card then
        return {
          xmult = card.ability.extra.Xmult
        }
      end
    end

    if context.after and context.cardarea == G.jokers and not context.blueprint then
      if G.jokers.cards[#G.jokers.cards] == card then
        card.ability.extra.Xmult = 1
        return {
          message = localize('k_reset'),
          colour = G.C.RED
        }
      else
        card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.Xmult_mod
        return {
          message = localize('k_upgrade_ex')
        }
      end
    end
  end,
  in_pool = function (self, args)
    return TBOJ.in_pool(self, args)
  end
}

-- Growth Hormones
-- Mini Mush
-- Rosary
-- Cube of Meat
-- A Quarter
-- PHD
-- X-Ray Vision
-- My Little Unicorn
TBOJ.Active {
  key = "my_little_unicorn",
  pos = { x = 1, y = 5 },
  --rarity = "Rare",
  cost = 8,
  config = {extra = {max_highlighted = 1, max_charge = 3, curr_charge = 3}},
  loc_vars = function(self, info_queue, card)
    if not card.edition or (card.edition and not card.edition.polychrome) then
      info_queue[#info_queue+1] = G.P_CENTERS.e_polychrome
    end
    return {vars = {card.ability.extra.curr_charge, card.ability.extra.max_charge}}
  end,
  calculate = function(self, card, context)
    TBOJ.eor_charge(card,context)
  end,
  can_use = function(self, card)
    return card.ability.extra.curr_charge >= card.ability.extra.max_charge and G.hand and #G.hand.highlighted > 0 and #G.hand.highlighted <= card.ability.extra.max_highlighted
  end,
  use = function(self, card, area, copier)
    local target = G.hand.highlighted[1]
    target:set_edition("e_polychrome",true)
    card:juice_up(0.3, 0.5)
  end,
  keep_on_use = function(self, card)
    return true
  end,
  in_pool = function(self)
    return TBOJ.in_pool(self)
  end
}

-- Book of Revelations
-- The Mark
-- The Pact
-- Dead Cat
SMODS.Joker {
  key = "dead_cat",
  pos = {x = 5, y = 5},
  config = {extra = {remaining = 9}},
  loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.remaining}}
  end,
  rarity = 2,
  cost = 6,
  atlas = "jokers",
  perishable_compat = true,
  eternal_compat = false,
  blueprint_compat = false,
  calculate = function(self, card, context)
    if context.end_of_round and context.game_over and context.main_eval then
      if G.GAME.chips / G.GAME.blind.chips >= 0.75 then -- See note about Talisman compatibility on the wiki
        G.E_MANAGER:add_event(Event({
          func = function()
            G.hand_text_area.blind_chips:juice_up()
            G.hand_text_area.game_chips:juice_up()
            play_sound('tarot1')
            if card.ability.extra.remaining == 1 then
              card:start_dissolve()
            else
              card.ability.extra.remaining = card.ability.extra.remaining - 1
            end
            return true
        end
        }))
        return {
          message = localize('k_saved_ex'),
          saved = localize('tboj_saved_by')..' '..(G.localization.descriptions.Joker[card.config.center.key].name),
          colour = G.C.RED
        }
      end
    end
  end,
  in_pool = function (self, args)
    return TBOJ.in_pool(self, args)
  end,
  devil = true
}

-- Lord of the Pit
-- The Nail
-- We Need To Go Deeper!
-- Deck of Cards
TBOJ.Active {
  key = "deck_of_cards",
  pos = { x = 9, y = 5 },
  --rarity = "Uncommon",
  cost = 6,
  config = {extra = {max_charge = 1, curr_charge = 1}},
  loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.curr_charge, card.ability.extra.max_charge}}
  end,
  calculate = function(self, card, context)
    TBOJ.eor_charge(card,context)
  end,
  can_use = function(self, card)
    return card.ability.extra.curr_charge >= card.ability.extra.max_charge and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit
  end,
  use = function(self, card, area, copier)
    G.E_MANAGER:add_event(Event({
      trigger = 'after',
      delay = 0.4,
      func = function()
        play_sound('timpani')
        SMODS.add_card({ set = 'Tarot' })
        card:juice_up(0.3, 0.5)
        return true
      end
    }))
  end,
  keep_on_use = function(self, card)
    return true
  end,
  in_pool = function(self)
    return TBOJ.in_pool(self)
  end
}