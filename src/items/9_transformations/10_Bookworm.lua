SMODS.Joker {
  key = "transformation_bookworm",
  atlas = "transformations",
  pos = {x = 2, y = 2},
  soul_atlas = "transformations",
  soul_pos = {x = 6, y = 2},
  config = {extra = {num = 1, den = 2, repetitions = 1}},
  loc_vars = function(self, info_queue, card)
    local num, den = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.den, "tboj_transformation_bookworm")
    return {vars = {num, den}}
  end,
  rarity = "tboj_transformation",
  cost = 0,
  perishable_compat = false,
  eternal_compat = true,
  blueprint_compat = false,
  rental_compat = false,
  calculate = function(self, card, context)
    if context.repetition and context.cardarea == G.play
    and SMODS.pseudorandom_probability(card, "tboj_transformation_bookworm", card.ability.extra.num, card.ability.extra.den, "tboj_transformation_bookworm") then
      return {
        repetitions = card.ability.extra.repetitions
      }
    end
  end,
  in_pool = function(self, args)
    return false
  end,
  attributes = {"tboj_transformation"}
}