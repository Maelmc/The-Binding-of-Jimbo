-- Box of Spiders
TBOJ.Active {
  key = "box_of_spiders",
  pos = {x = 2, y = 19},
  cost = 6,
  config = {extra = {max_charge = 2, curr_charge = 2, min = 2, max = 4}},
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue + 1] = G.P_CENTERS.spiderfly_tboj_blue_spider
    return {vars = {card.ability.extra.curr_charge, card.ability.extra.max_charge, card.ability.extra.min, card.ability.extra.max}}
  end,
  calculate = function(self, card, context)
    TBOJ.eor_charge(card,context)
  end,
  can_use = function(self, card)
    return card.ability.extra.curr_charge >= card.ability.extra.max_charge
  end,
  use = function(self, card, area, copier)
    local to_add = pseudorandom('tboj_box_of_spiders', card.ability.extra.min, card.ability.extra.max)
    for _ = 1, to_add do
      local _card = SMODS.create_card {
        set = "tboj_spiderfly",
        key = "spiderfly_tboj_blue_spider",
        area = G.spiders
      }
      _card:add_to_deck()
      G.spiders:emplace(_card)
    end
    SMODS.calculate_effect({message = localize('tboj_spiders_ex'),}, card)
  end,
  keep_on_use = function(self, card)
    return true
  end,
  in_pool = function(self)
    return TBOJ.in_pool(self)
  end,
  spider = true,
  attributes = {"generation"}
}