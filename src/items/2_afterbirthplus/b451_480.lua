-- Sinus Infection
-- Glaucoma
-- Parasitoid
SMODS.Joker {
  key = "parasitoid",
  pos = { x = 10, y = 30 },
  config = {extra = {num = 1, den = 3}},
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue + 1] = G.P_CENTERS.spiderfly_tboj_pretty_fly
    info_queue[#info_queue + 1] = G.P_CENTERS.spiderfly_tboj_blue_spider
    local num, den = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.den, "tboj_parasitoid")
    return {vars = {num, den}}
  end,
  rarity = 2,
  cost = 7,
  atlas = "jokers",
  perishable_compat = true,
  eternal_compat = true,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play then
      if SMODS.pseudorandom_probability(card, "tboj_parasitoid", card.ability.extra.num, card.ability.extra.den, "tboj_parasitoid") then
        local _card = SMODS.create_card {
          set = "tboj_spiderfly",
          key = "spiderfly_tboj_pretty_fly",
          area = G.flies
        }
        _card.states.visible = nil
        _card:add_to_deck()
        G.flies:emplace(_card)
        G.E_MANAGER:add_event(Event({
          trigger = 'after',
          delay = 0.1,
          func = function() 
            _card:start_materialize()
            return true 
          end 
        }))
        SMODS.calculate_effect({message = localize('tboj_flies_ex'),}, context.other_card)
      end

      if SMODS.pseudorandom_probability(card, "tboj_parasitoid", card.ability.extra.num, card.ability.extra.den, "tboj_parasitoid") then
        local _card = SMODS.create_card {
            set = "tboj_spiderfly",
            key = "spiderfly_tboj_blue_spider",
            area = G.spiders
          }
        _card.states.visible = nil
        _card:add_to_deck()
        G.spiders:emplace(_card)
        G.E_MANAGER:add_event(Event({
          trigger = 'after',
          delay = 0.1,
          func = function() 
            _card:start_materialize()
            card:juice_up()
            return true 
          end 
        }))
        SMODS.calculate_effect({message = localize('tboj_spiders_ex'),}, context.other_card)
      end

      return nil, true
    end
  end,
  in_pool = function (self, args)
    return TBOJ.in_pool(self, args)
  end,
  attributes = {"tboj_fly", "tboj_spider", "generation"}
}

-- Eye of Belial
-- Sulfuric Acid

-- Shade
-- Depression
-- Hushy
SMODS.Joker {
  key = "hushy",
  pos = { x = 4, y = 31 },
  config = {extra = {chips = 0, chips_mod = 8}},
  loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.chips_mod, card.ability.extra.chips}}
  end,
  rarity = 1,
  cost = 4,
  atlas = "jokers",
  perishable_compat = true,
  eternal_compat = true,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play then
      if context.other_card:is_suit("Clubs") then
        return {
          chips = card.ability.extra.chips
        }
      else
        SMODS.scale_card(card, {
          ref_value = 'chips',
          scalar_value = 'chips_mod',
        })
        return nil, true
      end
    end

    if context.end_of_round and card.ability.extra.chips ~= 0 then
      card.ability.extra.chips = 0
      return {
        message = localize('k_reset'),
        colour = G.C.RED
      }
    end
  end,
  in_pool = function (self, args)
    return TBOJ.in_pool(self, args)
  end,
  attributes = {"tboj_familiar", "chips", "clubs", "reset"}
}

-- Lil Monstro
-- King Baby

-- Plan C
-- D1
-- Void
TBOJ.Active {
  key = "void",
  pos = { x = 11, y = 31 },
  cost = 7,
  config = {extra = {max_charge = 4, curr_charge = 4}},
  loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.curr_charge, card.ability.extra.max_charge}}
  end,
  calculate = function(self, card, context)
    TBOJ.eor_charge(card,context)
  end,
  can_use = function(self, card)
    return card.ability.extra.curr_charge >= card.ability.extra.max_charge and G.STATE == G.STATES.SHOP and G.shop_jokers and #G.shop_jokers.cards > 0
  end,
  use = function(self, card, area, copier)
    local to_up = #G.shop_jokers.cards
    for i = 1, #G.shop_jokers.cards do
      local target = G.shop_jokers.cards[i]
      SMODS.destroy_cards(target, {bypass_eternal = true})
      if target.ability.set == "Joker" then
        G.GAME.banned_keys[target.config.center.key] = true
        SMODS.calculate_effect({message = localize("tboj_voided")}, card)
      end
    end

    for _ = 1, to_up do
      local _poker_hands = {}
      for k, _ in pairs(G.GAME.hands) do
        if SMODS.is_poker_hand_visible(k) then
          _poker_hands[#_poker_hands+1] = k
        end
      end
      local hand = pseudorandom_element(_poker_hands, "tboj_void")
      SMODS.smart_level_up_hand(card, hand, false, 1)
    end
  end,
  keep_on_use = function(self, card)
    return true
  end,
  in_pool = function(self)
    return TBOJ.in_pool(self)
  end,
  attributes = {"tboj_angel", "tboj_devil", "hand_type", "destroy_card"}
}

-- Pause
-- Smelter
-- Is a Spectral now
--[[TBOJ.Active {
  key = "smelter",
  pos = { x = 13, y = 31 },
  cost = 10,
  config = {extra = {max_charge = 6, curr_charge = 6}},
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
    return card.ability.extra.curr_charge >= card.ability.extra.max_charge and G.trinkets and #G.trinkets.highlighted == 1
  end,
  use = function(self, card, area, copier)
    local target = G.trinkets.highlighted[1]
    target:set_edition("e_negative",true)
    card:juice_up(0.3, 0.5)
  end,
  keep_on_use = function(self, card)
    return true
  end,
  in_pool = function(self)
    return TBOJ.in_pool(self)
  end,
  attributes = {"editions"},
}]]

-- Compost