SMODS.Enhancement {
  key = "bone",
  atlas = "enhancements",
  pos = { x = 2, y = 0 },
  config = { bonus = 100, extra = { num = 1, den = 4 }},
  loc_vars = function(self, info_queue, card)
    local num, den = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.den, "tboj_bone")
    return {vars = {card.ability.bonus, num, den}}
  end,
  calculate = function(self, card, context)
    if context.destroy_card and context.cardarea == G.play and context.destroy_card == card
    and SMODS.pseudorandom_probability(card, 'tboj_bone', card.ability.extra.num, card.ability.extra.den) then
      return {
        remove = true
      }
    end
  end,
  in_pool = function(self, args) return true end,
}