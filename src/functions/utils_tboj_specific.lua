-- All items in_pool function
function TBOJ.in_pool(self, args)
  if SMODS.showman(self.key) then
    return true
  end

  if next(SMODS.find_card(self.key)) then
    return false
  end

  if self.enhancement_gate and G.playing_cards then
    for _, v in pairs(G.playing_cards) do
      if v.config.center.key == self.enhancement_gate then
        return true
      end
    end
    return false
  end

  return true
end

-- Stolen from Pokermon
-- Transform a card into another card
function TBOJ.reroll(card, to_key, silent, from_cycling)
  local new_card = G.P_CENTERS[to_key]
  if not new_card then return end
  if card.config.center == new_card then return end

  card.children.center.atlas = SMODS.get_atlas((new_card.atlas or (new_card.set == 'Joker' or new_card.consumeable or new_card.set == 'Voucher') and new_card.set) or 'centers')
  card.children.center:set_sprite_pos(new_card.pos)
  --if card.config.center.set_sprites then
  --  card.config.center:set_sprites(card, card.children.front, true)
  --end
  if from_cycling then card.children.tboj_from_cycle = true end
  card:set_ability(new_card, true)
  card.children.tboj_from_cycle = nil
  card:set_cost()

  if new_card.soul_pos then
    card.children.floating_sprite = Sprite(card.T.x, card.T.y, card.T.w, card.T.h, G.ASSET_ATLAS[new_card.atlas or "Joker"], new_card.soul_pos)
    card.children.floating_sprite.role.draw_major = card
    card.children.floating_sprite.states.hover.can = false
    card.children.floating_sprite.states.click.can = false
  elseif card.children.floating_sprite then
    card.children.floating_sprite:remove()
    card.children.floating_sprite = nil
  end

  if card.area == G.shop_jokers or card.area == G.shop_booster or card.area == G.shop_vouchers then
    if not from_cycling then
      create_shop_card_ui(card)
    end
  end

  if not silent then
    if card.edition then
      if card.edition.foil then play_sound('foil1', 1.2, 0.4) end
      if card.edition.holo then play_sound('holo1', 1.2*1.58, 0.4) end
      if card.edition.polychrome then play_sound('polychrome1', 1.2, 0.7) end
      if card.edition.negative then play_sound('negative', 1.5, 0.4) end
      if card.edition.poke_shiny then
        play_sound('poke_e_shiny', 1, 0.2)
        G.P_CENTERS.e_poke_shiny.on_load(card)
      end
    end
    if not from_cycling then
      SMODS.calculate_effect({message = localize('tboj_reroll_ex')}, card)
    end
  end

  if card.states.hover.is then
    card:stop_hover()
    -- Card:hover() but without the juice
    play_sound('paper1', math.random()*0.2 + 0.9, 0.35)

    --if this is the focused card
    if card.states.focus.is and not card.children.focused_ui then
        card.children.focused_ui = G.UIDEF.card_focus_ui(card)
    end

    if card.facing == 'front' and (not card.states.drag.is or G.CONTROLLER.HID.touch) and not card.no_ui and not G.debug_tooltip_toggle then 
        if card.children.alert and not card.config.center.alerted then
            card.config.center.alerted = true
            G:save_progress()
        elseif card.children.alert and card.seal and not G.P_SEALS[card.seal].alerted then
            G.P_SEALS[card.seal].alerted = true
            G:save_progress()
        end

        card.ability_UIBox_table = card:generate_UIBox_ability_table()
        card.config.h_popup = G.UIDEF.card_h_popup(card)
        card.config.h_popup_config = card:align_h_popup()

        Node.hover(card)
    end
  end

  --[[if then
    card.area:remove_from_highlighted(card)
    card.area:add_to_highlighted(card)
  end]]
end

-- Get the selected active, or leftmost if none are selected
function TBOJ.leftmost_or_selected_active()
  return G.tboj_actives.highlighted[1] or G.tboj_actives.cards[1]
end

-- Charge the active at the end of round
function TBOJ.eor_charge(card,context)
  if context.end_of_round and context.cardarea == G.tboj_actives then
    TBOJ.charge_active(card,1)
  end
end

-- Check if an active can be charged
function TBOJ.can_charge(card)
  if (not card) or (not card.ability) or (not card.ability.extra) or not (card.ability.extra.curr_charge and card.ability.extra.max_charge) then
    return false
  end

  return next(SMODS.find_card("j_tboj_the_battery")) and card.ability.extra.curr_charge <  card.ability.extra.max_charge * 2
    or card.ability.extra.curr_charge <  card.ability.extra.max_charge
end

-- Charge an active
function TBOJ.charge_active(card,amount)
  local charged = false
  for _ = 1, amount do
    if TBOJ.can_charge(card) then
      charged = true
      card.ability.extra.curr_charge = card.ability.extra.curr_charge + 1
    else break end
  end
  if charged then
    SMODS.calculate_effect({message = localize('tboj_charged_ex')}, card)
  end
end

-- Get a Big Blind
function TBOJ.get_new_big()
  G.GAME.perscribed_big = G.GAME.perscribed_big or {}
  if G.GAME.perscribed_big and G.GAME.perscribed_big[G.GAME.round_resets.ante] then
    local ret_big = G.GAME.perscribed_big[G.GAME.round_resets.ante]
    G.GAME.perscribed_big[G.GAME.round_resets.ante] = nil
    G.GAME.bosses_used[ret_big] = G.GAME.bosses_used[ret_big] + 1
    return ret_big
  end
  if G.FORCE_BIG then return G.FORCE_BIG end

  if not next(SMODS.find_card("j_tboj_champion_belt")) then
    if G.GAME.modifiers.tboj_more_sins then
      if pseudorandom("big",1,3) == 1 then -- 66% for sin under corpse+ stake
        G.GAME.bosses_used["bl_big"] = G.GAME.bosses_used["bl_big"] + 1
        return "bl_big"
      end
    elseif pseudorandom("big",1,4) > 1 then --25% for sin
      G.GAME.bosses_used["bl_big"] = G.GAME.bosses_used["bl_big"] + 1
      return "bl_big"
    end
  end

  local eligible_big = {}
  for k, v in pairs(G.P_BLINDS) do
    if k ~= "bl_big" or (k == "bl_big" and not next(SMODS.find_card("j_tboj_champion_belt"))) then
      local res, options = SMODS.add_to_pool(v)
      options = options or {}
      if not v.big then
      elseif not v.in_pool then
        eligible_big[k] = true
      elseif v.in_pool and type(v.in_pool) == 'function' then
        eligible_big[k] = res and true or nil
      end
    end
  end
  for k, _ in pairs(G.GAME.banned_keys) do
    if eligible_big[k] then eligible_big[k] = nil end
  end

  local min_use
  for k, v in pairs(G.GAME.bosses_used) do
    if eligible_big[k] then
      eligible_big[k] = v
      if not min_use or eligible_big[k] <= min_use then
        min_use = eligible_big[k]
      end
    end
  end
  for k, v in pairs(eligible_big) do
    if eligible_big[k] then
      if eligible_big[k] > min_use then
        eligible_big[k] = nil
      end
    end
  end
  local _, big = pseudorandom_element(eligible_big, pseudoseed('big'))
  G.GAME.bosses_used[big] = G.GAME.bosses_used[big] + 1

  return big
end

function TBOJ.ease_dollars(mod, instant)
    local handy_ease_muted = (Handy and Handy.animation_skip.mute_ease_dollars > 0) or false
    local function _mod(mod2)
        local dollar_UI = G.HUD:get_UIE_by_ID('dollar_text_UI')
        mod2 = mod2 or 0
        local text = '+'..localize('$')
                local col = G.C.MONEY
                if to_big(mod2) < to_big(0) then
            text = '-'..localize('$')
            col = G.C.RED
        else
          inc_career_stat('c_dollars_earned', mod2)
        end
        --Ease from current chips to the new number of chips
        G.GAME.dollars = G.GAME.dollars + mod2
        check_and_set_high_score('most_money', G.GAME.dollars)
        check_for_unlock({type = 'money'})
        dollar_UI.config.object:update()
        G.HUD:recalculate()
        --Popup text next to the chips in UI showing number of chips gained/lost
        attention_text({
          text = text..tostring(math.abs(mod2)),
          scale = 0.8,
          hold = 0.7,
          cover = dollar_UI.parent,
          cover_colour = col,
          align = 'cm',
          })
        --Play a chip sound
        if handy_ease_muted then return end
        play_sound('coin1')
    end
    if instant then
        _mod(mod)
    else
        G.E_MANAGER:add_event(Event({
        trigger = 'immediate',
        func = function()
            _mod(mod)
            return true
        end
        }))
    end

    SMODS.calculate_context({
        money_altered = true,
        amount = mod,
        from_shop = (G.STATE == G.STATES.SHOP or G.STATE == G.STATES.SMODS_BOOSTER_OPENED or G.STATE == G.STATES.SMODS_REDEEM_VOUCHER) or nil,
        from_consumeable = (G.STATE == G.STATES.PLAY_TAROT) or nil,
        from_scoring = (G.STATE == G.STATES.HAND_PLAYED) or nil,
        tboj_from_counterfeit = true,
    })
end

function Card:tboj_bone_break()
  if self.getting_sliced and not (self.ability.set == 'Default' or self.ability.set == 'Enhanced') then
    local flags = SMODS.calculate_context({joker_type_destroyed = true, card = self})
    if flags.no_destroy then self.getting_sliced = nil; return false end
  end
  local dissolve_time = 0.7
  self.dissolve = 0
  self.dissolve_colours = {{1,1,1,0.8}}
  self:juice_up()
  local childParts = Particles(0, 0, 0,0, {
      timer_type = 'TOTAL',
      timer = 0.007*dissolve_time,
      scale = 0.3,
      speed = 4,
      lifespan = 0.5*dissolve_time,
      attach = self,
      colours = self.dissolve_colours,
      fill = true
  })
  G.E_MANAGER:add_event(Event({
      trigger = 'after',
      blockable = false,
      delay =  0.5*dissolve_time,
      func = (function() childParts:fade(0.15*dissolve_time) return true end)
  }))
  G.E_MANAGER:add_event(Event({
      blockable = false,
      func = (function()
              play_sound('tboj_bone_break_0'..math.random(1, 3), math.random()*0.2 + 0.9,0.5)
              play_sound('generic1', math.random()*0.2 + 0.9,0.5)
          return true end)
  }))
  G.E_MANAGER:add_event(Event({
      trigger = 'ease',
      blockable = false,
      ref_table = self,
      ref_value = 'dissolve',
      ease_to = 1,
      delay =  0.5*dissolve_time,
      func = (function(t) return t end)
  }))
  G.E_MANAGER:add_event(Event({
      trigger = 'after',
      blockable = false,
      delay =  0.55*dissolve_time,
      func = (function() self:remove() return true end)
  }))
  G.E_MANAGER:add_event(Event({
      trigger = 'after',
      blockable = false,
      delay =  0.51*dissolve_time,
  }))
end