-- Lemegeton
TBOJ.Active {
  key = "lemegeton",
  pos = { x = 6, y = 47 },
  cost = 8,
  config = {extra = {max_charge = 3, curr_charge = 3}},
  loc_vars = function(self, info_queue, card)
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
        local _card = SMODS.add_card { set = "Joker", edition = "e_negative", stickers = { 'perishable' }, force_stickers = true }
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