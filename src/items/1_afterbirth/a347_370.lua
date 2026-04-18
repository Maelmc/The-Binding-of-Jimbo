-- Lil Chest
-- Sworn Protector
-- Friend Zone
SMODS.Joker {
  key = "friend_zone",
  pos = {x = 3, y = 24},
  config = {extra = {money = 1}},
  loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.money}}
  end,
  rarity = 1,
  cost = 4,
  atlas = "jokers",
  perishable_compat = true,
  eternal_compat = true,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play then
      local third = context.scoring_hand[3] or {}
      local fourth = context.scoring_hand[4] or {}
      if context.other_card == third or context.other_card == fourth then
        return {
          dollars = card.ability.extra.money,
        }
      end
    end
  end,
  in_pool = function (self, args)
    return TBOJ.in_pool(self, args)
  end,
  attributes = {"tboj_familiar", "tboj_fly", "economy"}
}

-- Lost Fly
-- Scatter Bomb