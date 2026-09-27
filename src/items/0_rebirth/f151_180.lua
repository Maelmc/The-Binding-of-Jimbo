-- Technology 2
-- Mutant Spider
-- Chemical Peel
SMODS.Joker {
  key = "chemical_peel",
  pos = {x = 3, y = 10},
  config = {extra = {mult = 15}},
  loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.mult}}
  end,
  rarity = 1,
  cost = 4,
  atlas = "jokers",
  perishable_compat = true,
  eternal_compat = true,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.joker_main and G.GAME.current_round.hands_left % 2 == 1 then
      return {
        mult = card.ability.extra.mult
      }
    end
  end,
  in_pool = function (self, args)
    return TBOJ.in_pool(self, args)
  end,
  attributes = {"hands", "mult"}
}

-- The Peeper
SMODS.Joker {
  key = "the_peeper",
  pos = {x = 4, y = 10},
  config = {extra = {mult = 4}},
  loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.mult}}
  end,
  rarity = 1,
  cost = 5,
  atlas = "jokers",
  perishable_compat = true,
  eternal_compat = true,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.hand and not context.end_of_round and context.other_card:is_face() then
      return {
        mult = card.ability.extra.mult
      }
    end
  end,
  in_pool = function (self, args)
    return TBOJ.in_pool(self, args)
  end,
  attributes = {"face", "tboj_familiar", "mult"}
}

-- Habit
SMODS.Joker {
  key = "habit",
  pos = {x = 5, y = 10 },
  config = {extra = {charge = 1}},
  loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.charge}}
  end,
  rarity = 2,
  cost = 5,
  atlas = "jokers",
  perishable_compat = true,
  eternal_compat = true,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.joker_main and G.GAME.current_round.hands_left == 0 then
      if G.tboj_Actives.cards[1] and G.tboj_Actives.cards[1].ability.extra.curr_charge then
        G.E_MANAGER:add_event(Event({
          trigger = 'after',
          delay = 0.4,
          func = function()
            card:juice_up()
            return true
          end
        }))
        TBOJ.charge_active(G.tboj_Actives.cards[1],card.ability.extra.charge)
      end
    end
  end,
  in_pool = function (self, args)
    return TBOJ.in_pool(self, args)
  end,
  attributes = {"tboj_angel", "hands"}
}

-- Blue Candle
-- Cat-o-nine-tails
-- D20
TBOJ.Active {
  key = "d20",
  pos = {x = 0, y = 11},
  cost = 6,
  config = {extra = {max_charge = 2, curr_charge = 2}},
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue+1] = {set = 'Other', key = 'tboj_reroll'}
    return {vars = {card.ability.extra.curr_charge, card.ability.extra.max_charge}}
  end,
  calculate = function(self, card, context)
    TBOJ.eor_charge(card,context)
  end,
  can_use = function(self, card)
    return card.ability.extra.curr_charge >= card.ability.extra.max_charge and
    ((G.shop_jokers and G.shop_jokers.cards and #G.shop_jokers.cards > 0 and G.STATE == G.STATES.SHOP)
    or (G.pack_cards and G.pack_cards.cards and #G.pack_cards.cards > 0))
  end,
  use = function(self, card, area, copier)
    if G.pack_cards and G.pack_cards.cards and #G.pack_cards.cards > 0 then
      for _, v in pairs(G.pack_cards.cards) do
        if v.ability.consumeable or v.ability.set == "tboj_Trinket" or v.ability.set == "Booster" then
          TBOJ.reroll(v,TBOJ.get_random_key({set = v.ability.set, seed = "d20" .. G.GAME.round_resets.ante}))
        end
      end
    else
      for _, v in pairs(G.shop_jokers.cards) do
        if v.ability.consumeable or v.ability.set == "tboj_Trinket" or v.ability.set == "Booster" then
          TBOJ.reroll(v,TBOJ.get_random_key({set = v.ability.set, seed = "d20" .. G.GAME.round_resets.ante}))
        end
      end

      for _, v in pairs(G.shop_booster.cards) do
        if v.ability.consumeable or v.ability.set == "tboj_Trinket" or v.ability.set == "Booster" then
          TBOJ.reroll(v,TBOJ.get_random_key({set = v.ability.set, seed = "d20" .. G.GAME.round_resets.ante}))
        else
        end
      end
    end
  end,
  keep_on_use = function(self, card)
    return true
  end,
  in_pool = function(self)
    return TBOJ.in_pool(self)
  end,
  attributes = {"consumable", "booster", "tboj_dice"}
}

-- Harlequin Baby
-- Epic Fetus

-- Stem Cells
-- Portable Slot
-- Holy Water
SMODS.Joker {
  key = "holy_water",
  pos = {x = 12, y = 11},
  config = {extra = {chips = 4}},
  loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.chips}}
  end,
  rarity = 2,
  cost = 5,
  atlas = "jokers",
  perishable_compat = true,
  eternal_compat = true,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.hand and not context.end_of_round then
      context.other_card.ability.perma_bonus = (context.other_card.ability.perma_bonus or 0) + card.ability.extra.chips
      return {
        message = localize('k_upgrade_ex')
      }
    end
  end,
  in_pool = function (self, args)
    return TBOJ.in_pool(self, args)
  end,
  attributes = {"tboj_angel", "tboj_familiar", "modify_card", "perma_bonus", "chips"}
}

-- Fate
-- The Black Bean