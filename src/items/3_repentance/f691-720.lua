-- Sacred Orb
SMODS.Joker {
  key = "sacred_orb",
  pos = { x = 0, y = 46 },
  config = {extra = {num = 1, den = 3}},
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue+1] = {set = 'Other', key = 'tboj_reroll'}
    local num, den = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.den, "tboj_sacred_orb")
    return {vars = {num, den}}
  end,
  rarity = 3,
  cost = 8,
  atlas = "jokers",
  perishable_compat = true,
  eternal_compat = true,
  blueprint_compat = false,
  calculate = function(self, card, context)
    if context.modify_shop_card then
      if context.card.config and context.card.config.center then
        if context.card.config.center.rarity == 1 or context.card.config.center.rarity == "Common" then
          TBOJ.reroll(context.card, TBOJ.get_random_key({set = "Joker", seed = "tboj_sacred_orb", banned_rarities = {1, 4, "Common", "Legendary"}}), true)
        end

        if (context.card.config.center.rarity == 2 or context.card.config.center.rarity == "Uncommon") and SMODS.pseudorandom_probability(card, "tboj_sacred_orb", card.ability.extra.num, card.ability.extra.den, "tboj_sacred_orb") then
          TBOJ.reroll(context.card, TBOJ.get_random_key({set = "Joker", seed = "tboj_sacred_orb", banned_rarities = {1, 4, "Common", "Legendary"}}), true)
        end
      end
    end
  end,
  in_pool = function (self, args)
    return TBOJ.in_pool(self, args)
  end,
  angel = true
}

-- many
-- Lemegeton
TBOJ.Active {
  key = "lemegeton",
  pos = { x = 6, y = 47 },
  cost = 8,
  config = {extra = {max_charge = 3, curr_charge = 3}},
  loc_vars = function(self, info_queue, card)
    if not card.edition or (card.edition and not card.edition.negative) then
      info_queue[#info_queue+1] = G.P_CENTERS.e_negative
    end
    return {vars = {card.ability.extra.curr_charge, card.ability.extra.max_charge}}
  end,
  calculate = function(self, card, context)
    TBOJ.eor_charge(card,context)
  end,
  can_use = function(self, card)
    return card.ability.extra.curr_charge >= card.ability.extra.max_charge
  end,
  use = function(self, card, area, copier)
    G.E_MANAGER:add_event(Event({
      trigger = 'after',
      delay = 0.4,
      func = function()
        local _card = SMODS.add_card { set = "Joker", edition = "e_negative", stickers = { 'perishable' }, force_stickers = true, key_append = "tboj_lemegeton" }
        SMODS.calculate_effect({message = localize('k_plus_joker'), colour = G.C.BLUE}, _card)
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
  end,
  devil = true,
  book = true,
}