-- Mom's Lipstick
-- Wire Coat Hanger
-- The Bible
-- The Book of Belial
TBOJ.Active {
  key = "book_of_belial",
  pos = { x = 3, y = 2 },
  --rarity = "Common",
  cost = 5,
  config = {extra = {max_highlighted = 1, mult = 4, max_charge = 1, curr_charge = 1}},
  loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.curr_charge, card.ability.extra.max_charge, card.ability.extra.mult, card.ability.extra.max_highlighted}}
  end,
  calculate = function(self, card, context)
    TBOJ.charge_active(self,card,context)
  end,
  can_use = function(self, card)
    return card.ability.extra.curr_charge >= card.ability.extra.max_charge and G.hand and #G.hand.highlighted > 0 and #G.hand.highlighted <= card.ability.extra.max_highlighted
  end,
  use = function(self, card, area, copier)
    local target = G.hand.highlighted[1]
    target.ability.perma_mult = (target.ability.perma_mult or 0) + card.ability.extra.mult
    SMODS.calculate_effect({message = localize('k_upgrade_ex'), colour = G.C.MULT}, target)
    card:juice_up(0.3, 0.5)
  end,
  keep_on_use = function(self, card)
    return true
  end,
  in_pool = function(self)
    return TBOJ.in_pool(self)
  end
}

-- The Necronomicon
-- The Poop
TBOJ.Active {
  key = "the_poop",
  pos = { x = 5, y = 2 },
  --rarity = "Common",
  cost = 3,
  config = {extra = {max_highlighted = 1, max_charge = 1, curr_charge = 1}},
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue + 1] = G.P_CENTERS.m_tboj_poop
    return {vars = {card.ability.extra.curr_charge, card.ability.extra.max_charge, card.ability.extra.max_highlighted}}
  end,
  calculate = function(self, card, context)
    TBOJ.charge_active(self,card,context)
  end,
  can_use = function(self, card)
    return card.ability.extra.curr_charge >= card.ability.extra.max_charge and G.hand and #G.hand.highlighted > 0 and #G.hand.highlighted <= card.ability.extra.max_highlighted
  end,
  use = function(self, card, area, copier)
    TBOJ.juice_flip(card)
    for i = 1, #G.hand.highlighted do
      G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function() G.hand.highlighted[i]:set_ability("m_tboj_poop");return true end }))
    end 
    TBOJ.juice_flip(card, true)
  end,
  keep_on_use = function(self, card)
    return true
  end,
  in_pool = function(self)
    return TBOJ.in_pool(self)
  end
}

-- Mr. Boom
-- Tammy's Head
-- Mom's Bra
-- Kamikaze!
-- Mom's Pad
-- Bob's Rotten Head
-- ID 43 doesnt exist
-- Teleport!
-- Yum Heart
-- Lucky Foot
SMODS.Joker {
  key = "lucky_foot", 
  pos = {x = 0, y = 3},
  config = {extra = {plus_odds = 1}},
  loc_vars = function(self, info_queue, center)
    return {vars = {center.ability.extra.plus_odds}}
  end,
  rarity = 2, 
  cost = 4,
  atlas = "jokers",
  blueprint_compat = false,
  calculate = function(self, card, context)
    if context.mod_probability and not context.blueprint then
      return 
      {
        numerator = context.numerator + card.ability.extra.plus_odds
      }
    end
  end,
  in_pool = function(self)
    return TBOJ.in_pool(self)
  end
}

-- Doctor's Remote
-- Cupid's Arrow
-- Shoot da Whoop!
-- Steven
SMODS.Joker {
  key = "steven",
  pos = {x = 4, y = 3},
  config = {extra = {mult = 12}},
  loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.mult}}
  end,
  rarity = 1,
  cost = 4,
  atlas = "jokers",
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.joker_main then
      return {
        mult = card.ability.extra.mult,
      }
    end
  end,
  in_pool = function (self, args)
    return TBOJ.in_pool(self, args)
  end
}

-- Pentagram
-- Dr. Fetus
-- Magneto
-- Treasure Map
-- Mom's Eye
-- Lemon Mishap
-- Distant Admiration
SMODS.Joker {
  key = "distant_admiration",
  pos = {x = 11, y = 3},
  config = {extra = {mult = 6}},
  loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.mult}}
  end,
  rarity = 1,
  cost = 5,
  atlas = "jokers",
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play then
      local third = context.scoring_hand[3] or {}
      local fourth = context.scoring_hand[4] or {}
      if context.other_card == third or context.other_card == fourth then
        return {
          mult = card.ability.extra.mult,
        }
      end
    end
  end,
  in_pool = function (self, args)
    return TBOJ.in_pool(self, args)
  end,
  familiar = true,
  fly = true,
}

-- Book of Shadows
-- ID 59 doesnt exist
-- The Ladder