-- Spelunker Hat
-- Super Bandage
-- The Gamekid
-- Sack of Pennies
-- Robo-Baby
-- Little C.H.A.D.
-- The Book of Sin
-- The Relic
-- Little Gish
-- Little Steven
-- The Halo
-- Mom's Bottle of Pills
-- The Common Cold
-- The Parasite
-- The D6
TBOJ.Active {
  key = "the_d6",
  pos = { x = 14, y = 6 },
  --rarity = "Common",
  cost = 6,
  config = {extra = {max_charge = 1, curr_charge = 1}},
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue+1] = {set = 'Other', key = 'tboj_reroll'}
    return {vars = {card.ability.extra.curr_charge, card.ability.extra.max_charge}}
  end,
  calculate = function(self, card, context)
    TBOJ.eor_charge(card,context)
  end,
  can_use = function(self, card)
    return card.ability.extra.curr_charge >= card.ability.extra.max_charge and G.shop_jokers
  end,
  use = function(self, card, area, copier)
    for _, v in pairs(G.shop_jokers.cards) do
      if v.ability.set == "Joker" or v.ability.set == "tboj_active" then
        TBOJ.reroll(v,TBOJ.get_random_key({set = v.ability.set, seed = "d6" .. G.GAME.round_resets.ante, target_rarity = v.config.center.rarity}))
      end
    end
    SMODS.calculate_effect({message = localize('tboj_reroll_ex')}, card)
  end,
  keep_on_use = function(self, card)
    return true
  end,
  in_pool = function(self)
    return TBOJ.in_pool(self)
  end
}