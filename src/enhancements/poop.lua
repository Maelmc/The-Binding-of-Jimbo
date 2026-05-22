SMODS.Enhancement {
  key = "poop",
  atlas = "enhancements",
  pos = { x = 0, y = 0 },
  config = { extra = {num1 = 1, den1 = 5, num2 = 1, den2 = 15, money = 5, hand = 1}},
  loc_vars = function(self, info_queue, card)
    local num1, den1 = SMODS.get_probability_vars(card, card.ability.extra.num1, card.ability.extra.den1, "tboj_poop_money")
    local num2, den2 = SMODS.get_probability_vars(card, card.ability.extra.num2, card.ability.extra.den2, "tboj_poop_hand")
    return {vars = {num1, den1, card.ability.extra.money, num2, den2, card.ability.extra.hand}}
  end,
  calculate = function(self, card, context)
    if context.main_scoring and context.cardarea == G.play then
      local ret = {}
      if SMODS.pseudorandom_probability(card, "tboj_poop_money", card.ability.extra.num1, card.ability.extra.den1, "tboj_poop_money") then
        ret.dollars = card.ability.extra.money
      end
      if SMODS.pseudorandom_probability(card, "tboj_poop_hand", card.ability.extra.num2, card.ability.extra.den2, "tboj_poop_hand") then
        ease_hands_played(card.ability.extra.hand)
        SMODS.calculate_effect({ message = localize { type = 'variable', key = 'a_hands', vars = { card.ability.extra.hand } }, colour = G.C.BLUE }, card)
      end
      return ret
    end
  end,
  in_pool = function(self, args) return true end,
}