-- Spelunker Hat
-- Super Bandage
-- The Gamekid
-- Sack of Pennies
-- Robo-Baby
SMODS.Joker {
  key = "robo_baby",
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue + 1] = G.P_CENTERS.m_tboj_laser
    return {vars = {}}
  end,
  rarity = 2,
  cost = 6,
  atlas = "jokers",
  pos = { x = 4, y = 6 },
  calculate = function(self, card, context)
      if context.first_hand_drawn then
          local _card = SMODS.create_card { set = "Base", enhancement = "m_tboj_laser", area = G.discard }
          G.playing_card = (G.playing_card and G.playing_card + 1) or 1
          _card.playing_card = G.playing_card
          table.insert(G.playing_cards, _card)

          G.E_MANAGER:add_event(Event({
              func = function()
                  G.hand:emplace(_card)
                  _card:start_materialize()
                  G.GAME.blind:debuff_card(_card)
                  G.hand:sort()
                  if context.blueprint_card then
                      context.blueprint_card:juice_up()
                  else
                      card:juice_up()
                  end
                  SMODS.calculate_context({ playing_card_added = true, cards = { _card } })
                  save_run()
                  return true
              end
          }))

          return nil, true -- This is for Joker retrigger purposes
      end
  end,
  familiar = true,
}

-- Little C.H.A.D.
-- The Book of Sin
-- The Relic
SMODS.Joker {
  key = "the_relic",
  pos = { x = 7, y = 6 },
  config = {extra = {}},
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue + 1] = G.P_CENTERS.c_tboj_soul_heart
    return {vars = {}}
  end,
  rarity = 1,
  cost = 6,
  atlas = "jokers",
  perishable_compat = true,
  eternal_compat = true,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.end_of_round and context.game_over == false and context.main_eval then 
      if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
        G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
        G.E_MANAGER:add_event(Event({
          func = (function()
            G.E_MANAGER:add_event(Event({
              func = (function()
                play_sound('timpani')
                SMODS.add_card({ set = 'Loot', key = "c_tboj_soul_heart" })
                card:juice_up(0.3, 0.5)
                G.GAME.consumeable_buffer = 0
                return true
              end)
            }))
            SMODS.calculate_effect({ message = localize('tboj_plus_loot'), colour = G.C.TBOJ.LOOT }, context.blueprint_card or card)
            return true
          end)
        }))
      end
    end
  end,
  in_pool = function (self, args)
    return TBOJ.in_pool(self, args)
  end,
  angel = true
}

-- Little Gish
-- Little Steven
-- The Halo 
SMODS.Joker {
  key = "the_halo",
  pos = { x = 10, y = 6 },
  config = {extra = {chips = 20, mult = 3, money = 1}},
  loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.chips, card.ability.extra.mult, card.ability.extra.money}}
  end,
  rarity = 1,
  cost = 5,
  atlas = "jokers",
  perishable_compat = true,
  eternal_compat = true,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.joker_main then
      return {
        chips = card.ability.extra.chips,
        mult = card.ability.extra.mult,
      }
    end
  end,
  calc_dollar_bonus = function(self, card)
    return TBOJ.ease_money(card.ability.extra.money, true)
	end,
  in_pool = function (self, args)
    return TBOJ.in_pool(self, args)
  end,
  angel = true
}

-- Mom's Bottle of Pills
-- The Common Cold
-- The Parasite
-- The D6
TBOJ.Active {
  key = "the_d6",
  pos = { x = 14, y = 6 },
  --rarity = "Common",
  cost = 6,
  config = {extra = {max_charge = 1, curr_charge = 1}},
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue+1] = {set = 'Other', key = 'tboj_reroll'}
    return {vars = {card.ability.extra.curr_charge, card.ability.extra.max_charge}}
  end,
  calculate = function(self, card, context)
    TBOJ.eor_charge(card,context)
  end,
  can_use = function(self, card)
    return card.ability.extra.curr_charge >= card.ability.extra.max_charge and G.shop_jokers
  end,
  use = function(self, card, area, copier)
    for _, v in pairs(G.shop_jokers.cards) do
      if v.ability.set == "Joker" or v.ability.set == "tboj_active" then
        TBOJ.reroll(v,TBOJ.get_random_key({set = v.ability.set, seed = "d6" .. G.GAME.round_resets.ante, target_rarity = v.config.center.rarity}))
      end
    end
    SMODS.calculate_effect({message = localize('tboj_reroll_ex')}, card)
  end,
  keep_on_use = function(self, card)
    return true
  end,
  in_pool = function(self)
    return TBOJ.in_pool(self)
  end
}