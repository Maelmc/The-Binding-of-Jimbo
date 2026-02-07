-- Soul Locket
SMODS.Joker {
  key = "soul_locket",
  pos = { x = 10, y = 45 },
  config = {extra = {chips = 0, mult = 0, chips_mod = 20, mult_mod = 3}},
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue + 1] = G.P_CENTERS.c_tboj_soul_heart
    return {vars = {card.ability.extra.chips_mod, card.ability.extra.mult_mod, card.ability.extra.chips, card.ability.extra.mult}}
  end,
  rarity = 1,
  cost = 6,
  atlas = "jokers",
  perishable_compat = false,
  eternal_compat = true,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.using_consumeable and context.consumeable and context.consumeable.config.center.key == "c_tboj_soul_heart" and not context.blueprint then
      local rand = pseudorandom("tboj_soul_locket") > 0.5 and "MULT" or "CHIPS"
      if rand == "MULT" then
        card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_mod
      else
        card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chips_mod
      end
      return {
        message = localize('k_upgrade_ex'),
        colour = G.C[rand]
      }
    end

    if context.joker_main then
      return {
        chips = card.ability.extra.chips,
        mult = card.ability.extra.mult,
      }
    end
  end,
  in_pool = function (self, args)
    return TBOJ.in_pool(self, args)
  end,
  angel = true
}