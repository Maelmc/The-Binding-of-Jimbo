-- Monstro's Lung
SMODS.Joker {
  key = "monstro_lung",
  pos = {x = 4, y = 15},
  config = {extra = {min = 2, max = 7}},
  loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.min, card.ability.extra.max}}
  end,
  rarity = 1,
  cost = 5,
  atlas = "jokers",
  perishable_compat = true,
  eternal_compat = true,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.determine_hand then
      local cards_added = {}
      local to_add = pseudorandom('tboj_montro_lung', card.ability.extra.min, card.ability.extra.max)
      for _ = 1, to_add do
        local _card = SMODS.create_card {
          set = "Base",
          seal = SMODS.poll_seal({ mod = 10 }),
          edition = SMODS.poll_edition { key = "tboj_montro_lung" .. G.GAME.round_resets.ante, mod = 2, no_negative = true },
          area = G.play
        }
        _card.monstro_target = true
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
        table.insert(cards_added,_card)
      end
      SMODS.calculate_context({playing_card_added = true, cards = cards_added})
    end

    if context.destroy_card and not context.blueprint then
      if context.destroy_card.monstro_target then return {remove = true} end
    end
  end,
  in_pool = function (self, args)
    return TBOJ.in_pool(self, args)
  end,
  familiar = true,
}

-- Abaddon
-- Ball of Tar
-- Stop Watch
SMODS.Joker {
  key = "stop_watch", 
  pos = {x = 7, y = 15},
  config = {extra = {}},
  loc_vars = function(self, info_queue, center)
    return {vars = {}}
  end,
  rarity = 3, 
  cost = 8,
  atlas = "jokers",
  perishable_compat = true,
  eternal_compat = true,
  blueprint_compat = false,
  calculate = function(self, card, context)

  end,
  calc_scaling = function(self, card, scaling_card, initial, scalar_value, args)
    return {
        override_scalar_value = {value = scalar_value * 2}
    }
  end,
  in_pool = function(self)
    return TBOJ.in_pool(self)
  end
}

-- Tiny Planet
-- Infestation 2
-- E. Coli
SMODS.Joker {
  key = "e_coli", 
  pos = {x = 10, y = 15},
  config = {extra = {}},
  loc_vars = function(self, info_queue, center)
    info_queue[#info_queue + 1] = G.P_CENTERS.m_tboj_poop
    return {vars = {}}
  end,
  rarity = 2, 
  cost = 6,
  atlas = "jokers",
  perishable_compat = true,
  eternal_compat = true,
  blueprint_compat = false,
  calculate = function(self, card, context)
    if context.before and not context.blueprint then
            local faces = 0
            for _, scored_card in ipairs(context.scoring_hand) do
                if scored_card:is_face() then
                    faces = faces + 1
                    scored_card:set_ability('m_tboj_poop', nil, true)
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            scored_card:juice_up()
                            return true
                        end
                    }))
                end
            end
            if faces > 0 then
                return {
                    message = localize('k_poop'),
                    colour = G.C.TBOJ.POOP
                }
            end
        end
  end,
  in_pool = function(self)
    return TBOJ.in_pool(self)
  end,
  poop = true,
}
