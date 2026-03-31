-- Charged Baby
-- Dead Eye
-- Holy Light
SMODS.Joker {
  key = "holy_light",
  pos = {x = 13, y = 24},
  config = {extra = {Xmult_multi = 2, num = 1, den = 5}},
  loc_vars = function(self, info_queue, card)
    local num, den = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.den, "tboj_holy_light")
    return {vars = {num, den, card.ability.extra.Xmult_multi}}
  end,
  rarity = 2,
  cost = 7,
  atlas = "jokers",
  perishable_compat = true,
  eternal_compat = true,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play and SMODS.pseudorandom_probability(card, "tboj_holy_light", card.ability.extra.num, card.ability.extra.den, "tboj_holy_light") then
      return {
        xmult = card.ability.extra.Xmult_multi
      }
    end
  end,
  in_pool = function (self, args)
    return TBOJ.in_pool(self, args)
  end,
  angel = true,
}
-- Host Hat
-- Restock
-- Bursting Sack
-- Number Two
SMODS.Joker {
  key = "number_two",
  pos = {x = 2, y = 25},
  config = {extra = {every = 2, current = 0}},
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue+1] = G.P_CENTERS.m_tboj_poop
    info_queue[#info_queue + 1] = G.P_CENTERS.c_tboj_bomb
    return {vars = {card.ability.extra.every, card.ability.extra.current}}
  end,
  rarity = 2,
  cost = 5,
  atlas = "jokers",
  perishable_compat = true,
  eternal_compat = true,
  blueprint_compat = true,
  enhancement_gate = "m_tboj_poop",
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play then
      if not context.end_of_round and not context.before
      and not context.after and not context.other_card.debuff
      and SMODS.has_enhancement(context.other_card, "m_tboj_poop") then
        card.ability.extra.current = card.ability.extra.current + 1
        if card.ability.extra.current == card.ability.extra.every then
          card.ability.extra.current = 0
          local _card = SMODS.add_card({ set = 'Loot', key = "c_tboj_bomb", edition = 'e_negative' })
          _card.states.visible = nil
          _card.ability.extra.fused = true
          G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.1,
            func = function() 
              _card:start_materialize()
              card:juice_up()
              return true 
            end 
          }))
          SMODS.calculate_effect({message = localize('tboj_oops_dot'),}, context.other_card)
        end
      end
    end
  end,
  in_pool = function (self, args)
    return TBOJ.in_pool(self, args)
  end,
  poop = true,
}

-- Pupula Duplex
-- Pay To Play

-- Key Bum
-- Rune Bag
-- Seraphim
SMODS.Joker {
  key = "seraphim",
  pos = {x = 14, y = 25},
  config = {extra = {Xmult_multi = 2}},
  loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.Xmult_multi}}
  end,
  rarity = 2,
  cost = 6,
  atlas = "jokers",
  perishable_compat = true,
  eternal_compat = true,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.pre_splash then
      local _card = copy_card(G.play.cards[1])
      _card.seraphim_target = true
      _card.states.visible = false
      _card:add_to_deck()
      G.deck.config.card_limit = G.deck.config.card_limit + 1
      G.play:emplace(_card)
      G.E_MANAGER:add_event(Event({
        func = function()
          _card:start_materialize()
          if context.blueprint_card then
            context.blueprint_card:juice_up()
          else
            card:juice_up()
          end
          return true
        end
      }))
      SMODS.calculate_context({playing_card_added = true, cards = {_card}})
    end

    if context.individual and context.other_card.seraphim_target then
      return {
        colour = G.C.MULT,
        Xmult = card.ability.extra.Xmult_multi
      }
    end

    if context.destroy_card and not context.blueprint then
      if context.destroy_card.seraphim_target then return {remove = true} end
    end
  end,
  in_pool = function (self, args)
    return TBOJ.in_pool(self, args)
  end,
  familiar = true,
  angel = true,
}

-- Betrayal
-- Betrayal
SMODS.Joker {
  key = "betrayal",
  pos = {x = 0, y = 26},
  config = {extra = {triggered = false}},
  loc_vars = function(self, info_queue, card)
    return {vars = {}}
  end,
  rarity = 2,
  cost = 6,
  atlas = "jokers",
  perishable_compat = true,
  eternal_compat = true,
  blueprint_compat = false,
  calculate = function(self, card, context)
    if context.destroy_card and not context.blueprint and not card.ability.extra.triggered and G.GAME.current_round.hands_played == 0 then
      local pos = 1
      for k, v in ipairs(context.scoring_hand) do
        if v == context.destroy_card then pos = k break end
      end
      
      if context.scoring_hand[pos+1] and TBOJ.total_chips(context.destroy_card) < TBOJ.total_chips(context.scoring_hand[pos+1]) then
        card.ability.extra.triggered = true
        return {
          remove = true,
          message = localize("tboj_betrayal_ex")
        }
      end
    end

    if context.setting_blind and not context.blueprint then card.ability.extra.triggered = false end
  end,
  in_pool = function (self, args)
    return TBOJ.in_pool(self, args)
  end,
  devil = true,
}

-- Zodiac
-- Serpent's Kiss