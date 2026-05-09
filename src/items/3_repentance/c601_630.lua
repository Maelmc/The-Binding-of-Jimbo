-- Larynx
TBOJ.Active {
  key = "larynx",
  pos = { x = 10, y = 40 },
  cost = 6,
  config = {extra = {max_charge = 12, curr_charge = 1, Xmult_mod = 1, active = false}},
  loc_vars = function(self, info_queue, card)
    return {vars = {
      card.ability.extra.curr_charge, card.ability.extra.max_charge,
      card.ability.extra.Xmult_mod, card.ability.extra.Xmult_mod * card.ability.extra.curr_charge,
      card.ability.extra.active and localize("tboj_active") or localize("tboj_inactive")
    }}
  end,
  calculate = function(self, card, context)
    if context.scoring_hand and context.joker_main then
      if card.ability.extra.active then
        card.ability.extra.active = false
        local tmp = card.ability.extra.curr_charge
        card.ability.extra.curr_charge = 0
        return {
          xmult = card.ability.extra.Xmult_mod * tmp
        }
      end
    end
    TBOJ.eor_charge(card,context)
  end,
  can_use = function(self, card)
    return card.ability.extra.curr_charge >= 0 and not card.ability.extra.active
  end,
  use = function(self, card, area, copier)
    card.ability.extra.active = true
    local eval = function(card) return card.ability.extra.active end
    juice_card_until(card, eval, true)
  end,
  manual_deplete_charges = true,
  keep_on_use = function(self, card)
    return true
  end,
  in_pool = function(self)
    return TBOJ.in_pool(self)
  end,
  attributes = {"xmult"},
}

-- 612
-- 613
-- 614
-- 615
-- 616
-- 613
-- 618
-- 619
-- 620
-- Red Stew
SMODS.Joker {
  key = "red_stew",
  pos = { x = 5, y = 41 },
  config = {extra = {mult = 40, mult_mod = 10}},
  loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.mult, card.ability.extra.mult_mod}}
  end,
  rarity = 2,
  cost = 6,
  atlas = "jokers",
  perishable_compat = true,
  eternal_compat = false,
  blueprint_compat = true,
  calculate = function(self, card, context)
    if context.joker_main then
      return {
        mult = card.ability.extra.mult
      }
    end

    if context.after and not context.blueprint then
      if card.ability.extra.mult - card.ability.extra.mult_mod <= 0 then
        SMODS.destroy_cards(card, nil, nil, true)
        return {
          message = localize('k_drank_ex'),
          colour = G.C.MULT
        }
      else
        SMODS.scale_card(card, {
          ref_value = 'mult',
          scalar_value = 'mult_mod',
          operation = '-',
          message_key = 'a_mult_minus',
        })
        return nil, true
      end
    end

    if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
      SMODS.scale_card(card, {
        ref_value = 'mult',
        scalar_value = 'mult_mod',
      })
      return nil, true
    end
  end,
  in_pool = function (self, args)
    return TBOJ.in_pool(self, args)
  end,
  attributes = {"mult", "food", "scaling"},
}

-- Genesis
TBOJ.Active {
  key = "genesis",
  pos = { x = 6, y = 41 },
  cost = 7,
  config = {extra = {}},
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue + 1] = { key = 'tag_buffoon', set = 'Tag' }
    return {vars = {}}
  end,
  calculate = function(self, card, context)
  end,
  can_use = function(self, card)
    return #G.jokers.cards > 0
          and (not G.GAME.blind.in_blind)
          and not (G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.PLANET_PACK or G.STATE ==
                    G.STATES.SPECTRAL_PACK or G.STATE == G.STATES.STANDARD_PACK or G.STATE == G.STATES.BUFFOON_PACK or
                    G.STATE == G.STATES.SMODS_BOOSTER_OPENED)
  end,
  use = function(self, card, area, copier)
    for _, v in pairs(G.jokers.cards) do
      G.E_MANAGER:add_event(Event({
        func = (function()
          SMODS.destroy_cards(v,true)
          add_tag(Tag('tag_buffoon'))
          play_sound('generic1', 0.9 + math.random() * 0.1, 0.8)
          play_sound('holo1', 1.2 + math.random() * 0.1, 0.4)
          return true
        end)
      }))
    end
    G.E_MANAGER:add_event(Event({
      func = (function()
        for i = 1, #G.GAME.tags do
          if G.GAME.tags[i].key == "tag_buffoon" then
            local fake_context = {type = 'new_blind_choice'}
            G.E_MANAGER:add_event(Event({
              func = function()
                G.GAME.tags[i]:apply_to_run(fake_context)
                return true
              end
            }))
            return true
          end
        end
        return true
      end)
    }))
  end,
  keep_on_use = function(self, card)
    return false
  end,
  in_pool = function(self)
    return TBOJ.in_pool(self)
  end,
  attributes = {"tboj_angel", "tag", "joker", "destroy_card", "generation"},
}

-- Sharp Key
-- 624
-- Mega Mush
-- 626
-- 627
-- Death Certificate
-- 629
-- 630