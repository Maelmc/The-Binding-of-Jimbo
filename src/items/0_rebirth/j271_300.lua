-- D100
-- D4
-- D10
TBOJ.Active {
  key = "d10",
  pos = {x = 14, y = 18},
  cost = 6,
  config = {extra = {max_charge = 2, curr_charge = 2, rank_change = 1}},
  loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.curr_charge, card.ability.extra.max_charge, card.ability.extra.rank_change}}
  end,
  calculate = function(self, card, context)
    TBOJ.eor_charge(card,context)
  end,
  can_use = function(self, card)
    return G.hand and G.hand.cards and #G.hand.cards > 0
  end,
  use = function(self, card, area, copier)
    TBOJ.juice_flip_hand(card)
    for i=1, #G.hand.cards do
      local valid_suits = {}
      local suit = pseudorandom_element(SMODS.Suits, pseudoseed('tboj_d10'..G.GAME.round_resets.ante))
      G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0.1,
        func = function()
          assert(SMODS.modify_rank(G.hand.cards[i], -card.ability.extra.rank_change))
          assert(SMODS.change_base(G.hand.cards[i], suit.key))
          return true
      end
      }))
    end
    TBOJ.juice_flip_hand(nil, true)
  end,
  keep_on_use = function(self, card)
    return true
  end,
  in_pool = function(self)
    return TBOJ.in_pool(self)
  end,
  attributes = {"rank", "suit"}
}

-- Blank Card
-- Book of Secrets

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