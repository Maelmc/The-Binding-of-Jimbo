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

function TBOJ.ease_money(amt, calc_only)
  local earned = amt
  if (SMODS.Mods["Talisman"] or {}).can_load then
    earned = to_number(earned)
  end
  if not calc_only then ease_dollars(earned) end
  return earned
end

-- Stolen from Pokermon
function TBOJ.reroll(card, to_key, silent)
  local new_card = G.P_CENTERS[to_key]
  if not new_card then return end
  if card.config.center == new_card then return end
  
  card.children.center = Sprite(card.T.x, card.T.y, card.T.w, card.T.h, G.ASSET_ATLAS[new_card.atlas or "Joker"], new_card.pos)
  card.children.center.states.hover = card.states.hover
  card.children.center.states.click = card.states.click
  card.children.center.states.drag = card.states.drag
  card.children.center.states.collide.can = false
  card.children.center:set_role({major = card, role_type = 'Glued', draw_major = card})
  card:set_ability(new_card, true)
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
    create_shop_card_ui(card)
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
    SMODS.calculate_effect({message = localize('tboj_reroll_ex')}, card)
  end
end

function TBOJ.leftmost_or_selected_joker()
  return G.jokers.highlighted[1] or G.jokers.cards[1]
end

function TBOJ.leftmost_or_selected_active()
  return G.actives.highlighted[1] or G.actives.cards[1]
end

function TBOJ.eor_charge(card,context)
  if context.end_of_round and context.cardarea == G.actives then
    TBOJ.charge_active(card,1)
  end
end

function TBOJ.charge_active(card,amount)
  local charged = false
  for _ = 1, amount do
    if next(SMODS.find_card("j_tboj_the_battery")) and card.ability.extra.curr_charge <  card.ability.extra.max_charge * 2 or
    card.ability.extra.curr_charge <  card.ability.extra.max_charge then
      charged = true
      card.ability.extra.curr_charge = card.ability.extra.curr_charge + 1
    else break end
  end
  if charged then 
    SMODS.calculate_effect({message = localize('tboj_charged_ex')}, card)
  end
end

function TBOJ.get_random_key(args)
  local set = args.set
  local seed = args.seed
  local banned_rarities = args.banned_rarities
  local target_rarities = args.target_rarities
  local attributes = args.attributes and (type(args.attributes) ~= "table" and {args.attributes} or args.attributes) or nil
  local _rarity = nil
  if set == "Joker" then
    if target_rarities then
      if (TBOJ.table_contains(target_rarities, "Legendary") or TBOJ.table_contains(target_rarities, 4)) and (#target_rarities == 1 or pseudorandom('soul_'..seed) > 0.997) then
        _rarity = 4
      else
        while true do
          _rarity = SMODS.poll_rarity(set, "rarity"..seed)
          if TBOJ.table_contains(target_rarities, _rarity) then break end
        end
      end
    elseif banned_rarities then
      while true do
        _rarity = SMODS.poll_rarity(set, "rarity"..seed)
        if not TBOJ.table_contains(banned_rarities, _rarity) then break end
      end
    else
      _rarity = SMODS.poll_rarity(set, "rarity"..seed)
    end
  end

  local candidates = {}
  for _, v in pairs(G.P_CENTERS) do
    if v.set and v.set == set
    and (not (type(v.in_pool) == 'function') or v:in_pool())
    and (not (v.no_pool_flag and G.GAME.pool_flags[v.no_pool_flag]))
    and ((not v.yes_pool_flag) or G.GAME.pool_flags[v.yes_pool_flag])
    and not G.GAME.banned_keys[v.key]
    and (not _rarity or v.rarity == _rarity)
    and not ((G.GAME.used_jokers[v.key] or next(SMODS.find_card(v.key))) and not SMODS.showman(v.key)) then
      local all_attributes = true
      if attributes then
        if not v.attributes then
          all_attributes = false
        else
          for _, _attribute in pairs(attributes) do
            if not TBOJ.table_contains(v.attributes, _attribute) then
              all_attributes = false
              break
            end
          end
        end
      end
      if all_attributes then
        if v.enhancement_gate then
          if G.playing_cards then
            for _, vv in pairs(G.playing_cards) do
              if SMODS.has_enhancement(vv, v.enhancement_gate) then
                table.insert(candidates, v.key)
                break
              end
            end
          end
        else
          table.insert(candidates, v.key)
        end
      end
    end
  end
  if #candidates > 0 then
    local elem, _ = pseudorandom_element(candidates, pseudoseed(seed))
    return elem
  elseif set == "Joker" then return "j_tboj_breakfast"
  elseif set == "tboj_active" then return "active_tboj_the_d6"
  elseif set == "tboj_trinket" then return "trinket_tboj_swallowed_penny"
  elseif SMODS.ObjectTypes[set] and SMODS.ObjectTypes[set].default and G.P_CENTERS[SMODS.ObjectTypes[set].default] then return SMODS.ObjectTypes[set].default
  end
end

function TBOJ.table_contains(table, element)
  for _, value in pairs(table) do
    if value == element then
      return true
    end
  end
  return false
end

function TBOJ.juice_flip_cards(cards,source, second)
  if not cards[1] then
    if Object.is(cards, Card) then
      cards = {cards}
    else
      return
    end
  end
  local sound = 'card1'
  local base_percent = 1.15
  local extra = nil
  if second then sound = 'tarot2' end
  if second then base_percent = 0.85 end
  if second then extra = .6 end
  if source then
    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
      play_sound('tarot1')
      source:juice_up(0.3, 0.5)
      return true end })
    )
  end
  for i=1, #cards do
    local percent = nil
    if second then
      percent = base_percent + (i-0.999)/(#cards-0.998)*0.3
    else
      percent = base_percent - (i-0.999)/(#cards-0.998)*0.3
    end
    G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() cards[i]:flip();play_sound(sound, percent, extra);cards[i]:juice_up(0.3, 0.3);return true end }))
  end
  delay(0.2)
end

function TBOJ.juice_flip_hand(source, second)
  local sound = 'card1'
  local base_percent = 1.15
  local extra = nil
  if second then sound = 'tarot2' end
  if second then base_percent = 0.85 end
  if second then extra = .6 end
  if source then
    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
      play_sound('tarot1')
      source:juice_up(0.3, 0.5)
      return true end })
    )
  end
  for i=1, #G.hand.cards do
    local percent = nil
    if second then
      percent = base_percent + (i-0.999)/(#G.hand.cards-0.998)*0.3
    else
      percent = base_percent - (i-0.999)/(#G.hand.cards-0.998)*0.3
    end
    G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() G.hand.cards[i]:flip();play_sound(sound, percent, extra);G.hand.cards[i]:juice_up(0.3, 0.3);return true end }))
  end
  delay(0.2)
end

function TBOJ.juice_flip_highlighted(source, second)
  local sound = 'card1'
  local base_percent = 1.15
  local extra = nil
  if second then sound = 'tarot2' end
  if second then base_percent = 0.85 end
  if second then extra = .6 end
  if source then
    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
      play_sound('tarot1')
      source:juice_up(0.3, 0.5)
      return true end })
    )
  end
  for i=1, #G.hand.highlighted do
    local percent = nil
    if second then
      percent = base_percent + (i-0.999)/(#G.hand.highlighted-0.998)*0.3
    else
      percent = base_percent - (i-0.999)/(#G.hand.highlighted-0.998)*0.3
    end
    G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() G.hand.highlighted[i]:flip();play_sound(sound, percent, extra);G.hand.highlighted[i]:juice_up(0.3, 0.3);return true      end }))
  end
  delay(0.2)
end

function TBOJ.id_to_value(id)
  if id == 11 then return "Jack"
  elseif id == 12 then return "Queen"
  elseif id == 13 then return "King"
  elseif id == 14 then return "Ace"
  else return tostring(id)
  end
end

function TBOJ.total_chips(card)
  local total_chips = (card.ability.bonus) + (card.ability.perma_bonus or 0)
  if card.ability.effect ~= 'Stone Card' and not card.config.center.replace_base_card then
    total_chips = total_chips + (card.base.nominal)
  end
  if card.edition then
    total_chips = total_chips + (card.edition.chips or 0)
  end
  return total_chips
end

-- Taken from Pokermon
function TBOJ.add_to_shop(card,text)
  if G.GAME.shop.joker_max == 1 then
    G.shop_jokers.config.card_limit = G.GAME.shop.joker_max + 1
    G.shop_jokers.T.w = math.min((G.GAME.shop.joker_max + 1)*1.02*G.CARD_W,4.08*G.CARD_W)
    G.shop:recalculate()
  end
  card.states.visible = false
  G.shop_jokers:emplace(card)
  card:start_materialize()
  card:set_cost()
  create_shop_card_ui(card)
  
  if (SMODS.Mods["Talisman"] or {}).can_load then
    if Talisman.config_file.disable_anims then 
      card.states.visible = true
    end
  end
  card:juice_up()
  if text then
    SMODS.calculate_effect({message = text}, card)
  end
end

function TBOJ.predict_seed(key)
  local pkey = G.GAME.pseudorandom[key]
  if not G.GAME.pseudorandom[key] then 
    pkey = pseudohash(key..(G.GAME.pseudorandom.seed or ''))
  end

  pkey = math.abs(tonumber(string.format("%.13f", (2.134453429141+pkey*1.72431234)%1)))
  return (pkey + (G.GAME.pseudorandom.hashed_seed or 0))/2
end

function TBOJ.predict_next_boss()
  if G.GAME.modifiers.tboj_aprils_fool then return "bl_tboj_bloat" end
  local real_ante = G.GAME.round_resets.ante
  G.GAME.round_resets.ante = G.GAME.round_resets.ante + 1
  G.GAME.perscribed_bosses = G.GAME.perscribed_bosses or {
  }
  if G.GAME.perscribed_bosses and G.GAME.perscribed_bosses[G.GAME.round_resets.ante] then 
    local ret_boss = G.GAME.perscribed_bosses[G.GAME.round_resets.ante]
    G.GAME.round_resets.ante = real_ante
    return ret_boss
  end
  if G.FORCE_BOSS then
    G.GAME.round_resets.ante = real_ante
    return G.FORCE_BOSS
  end
  
  local eligible_bosses = {}
  for k, v in pairs(G.P_BLINDS) do
    if G.GAME.round_resets.blind_choices.Boss ~= v.key then
      local res, options = SMODS.add_to_pool(v)
      options = options or {}
      if not v.boss then
      
      elseif options.ignore_showdown_check then
        eligible_bosses[k] = res and true or nil
      elseif v.in_pool and type(v.in_pool) == 'function' then
        if
          (
            ((G.GAME.round_resets.ante)%G.GAME.win_ante == 0 and G.GAME.round_resets.ante >= 2) ==
            (v.boss.showdown or false)
          )
        then
          eligible_bosses[k] = res and true or nil
        end
      elseif not v.boss.showdown and (v.boss.min <= math.max(1, G.GAME.round_resets.ante) and ((math.max(1, G.GAME.round_resets.ante))%G.GAME.win_ante ~= 0 or G.GAME.round_resets.ante < 2)) then
        eligible_bosses[k] = res and true or nil
      elseif v.boss.showdown and (G.GAME.round_resets.ante)%G.GAME.win_ante == 0 and G.GAME.round_resets.ante >= 2 then
        eligible_bosses[k] = res and true or nil
      end
    end
  end
  for k, v in pairs(G.GAME.banned_keys) do
    if eligible_bosses[k] then eligible_bosses[k] = nil end
  end

  local min_use = 100
  for k, v in pairs(G.GAME.bosses_used) do
    if eligible_bosses[k] then
      if G.GAME.round_resets.blind_choices.Boss ~= k then
        eligible_bosses[k] = v
        if eligible_bosses[k] <= min_use then 
          min_use = eligible_bosses[k]
        end
      end
    end
  end
  --local tot_elig = 0
  for k, v in pairs(eligible_bosses) do
    if eligible_bosses[k] then
      if eligible_bosses[k] > min_use then 
        eligible_bosses[k] = nil
      elseif G.GAME.round_resets.blind_choices.Boss == eligible_bosses[k] then
        eligible_bosses[k] = nil
      --else
        --print(k)
        --tot_elig = tot_elig + 1
      end
    end
  end
  --print("eligible bosses: "..tot_elig)
  local _, boss = pseudorandom_element(eligible_bosses, TBOJ.predict_seed('boss'))
  G.GAME.round_resets.ante = real_ante
  return boss
end

function TBOJ.predict_pack(pack,amount)
  local og_seed = {}
  for k, v in pairs(G.GAME.pseudorandom) do
    og_seed[k] = v
  end

  local og_used = {}
  for k, v in pairs(G.GAME.used_jokers) do
    og_used[k] = v
  end

  local res = ""

  for i = 1, amount do
    if pack == "Arcana" then
      local forced_key
      if not G.GAME.banned_keys['c_soul'] then
        local soul_total_rate = 0
        local non_soul_rate = 1
        local modded_souls = {}
        for _, v in ipairs(SMODS.Consumable.legendaries) do
            if ("Tarot" == v.type.key or "Tarot" == v.soul_set) and not (G.GAME.used_jokers[v.key] and not SMODS.showman(v.key) and not v.can_repeat_soul) and SMODS.add_to_pool(v) then
                soul_total_rate = soul_total_rate + v.soul_rate
                non_soul_rate = non_soul_rate * (1 - v.soul_rate)
                non_soul_rate = math.max(non_soul_rate, 0)
                table.insert(modded_souls, v)
            end
        end
        local roll = pseudorandom('soul_smods_'.."Tarot"..G.GAME.round_resets.ante)
        local threshold = 1
        for _, v in ipairs(modded_souls) do
            threshold = threshold - v.soul_rate/soul_total_rate * (1-non_soul_rate)
            if roll > threshold then
                forced_key = v.key
                break
            end
        end
        if  not (G.GAME.used_jokers['c_soul'] and not SMODS.showman('c_soul')) then
            if pseudorandom('soul_'.."Tarot"..G.GAME.round_resets.ante) > 0.997 then
                forced_key = 'c_soul'
            end
        end
      end

      if forced_key then
        res = res .. localize({type = "name_text", set = "Spectral", key = forced_key}) .. (i == amount and "" or ", ")
        G.GAME.used_jokers[forced_key] = true
      else
        local _pool, _pool_key, set
        if G.GAME.used_vouchers.v_omen_globe and pseudorandom('omen_globe') > 0.8 then
          _pool, _pool_key = get_current_pool("Spectral", nil, nil, 'ar2')
          set = "Spectral"
        else
          _pool, _pool_key = get_current_pool("Tarot", nil, nil, 'ar1')
          set = "Tarot"
        end
        local center = pseudorandom_element(_pool, pseudoseed(_pool_key))
        local it = 1
        while center == 'UNAVAILABLE' do
            it = it + 1
            center = pseudorandom_element(_pool, pseudoseed(_pool_key..'_resample'..it))
        end
        res = res .. localize({type = "name_text", set = set, key = center}) .. (i == amount and "" or ", ")
        G.GAME.used_jokers[center] = true
      end
    
    elseif pack == "Celestial" then
      if G.GAME.used_vouchers.v_telescope and i == 1 then
        local _planet, _hand, _tally = nil, nil, 0
        for k, v in ipairs(G.handlist) do
            if G.GAME.hands[v].visible and G.GAME.hands[v].played > _tally then
                _hand = v
                _tally = G.GAME.hands[v].played
            end
        end
        if _hand then
            for k, v in pairs(G.P_CENTER_POOLS.Planet) do
                if v.config.hand_type == _hand then
                    _planet = v.key
                end
            end
        end
        res = res .. localize({type = "name_text", set = "Planet", key = _planet}) .. (i == amount and "" or ", ")
        G.GAME.used_jokers[_planet] = true
      else
        local forced_key
        if not G.GAME.banned_keys['c_soul'] then
          local soul_total_rate = 0
          local non_soul_rate = 1
          local modded_souls = {}
          for _, v in ipairs(SMODS.Consumable.legendaries) do
              if ("Planet" == v.type.key or "Planet" == v.soul_set) and not (G.GAME.used_jokers[v.key] and not SMODS.showman(v.key) and not v.can_repeat_soul) and SMODS.add_to_pool(v) then
                  soul_total_rate = soul_total_rate + v.soul_rate
                  non_soul_rate = non_soul_rate * (1 - v.soul_rate)
                  non_soul_rate = math.max(non_soul_rate, 0)
                  table.insert(modded_souls, v)
              end
          end
          local roll = pseudorandom('soul_smods_'.."Planet"..G.GAME.round_resets.ante)
          local threshold = 1
          for _, v in ipairs(modded_souls) do
              threshold = threshold - v.soul_rate/soul_total_rate * (1-non_soul_rate)
              if roll > threshold then
                  forced_key = v.key
                  break
              end
          end
          if not (G.GAME.used_jokers['c_black_hole'] and not SMODS.showman('c_black_hole')) then
            if pseudorandom('soul_'.."Planet"..G.GAME.round_resets.ante) > 0.997 then
              forced_key = 'c_black_hole'
            end
          end
        end             

        if forced_key then
          res = res .. localize({type = "name_text", set = "Spectral", key = forced_key}) .. (i == amount and "" or ", ")
          G.GAME.used_jokers[forced_key] = true
        else
          local _pool, _pool_key = get_current_pool("Planet", nil, nil, 'pl1')
          local center = pseudorandom_element(_pool, pseudoseed(_pool_key))
          local it = 1
          while center == 'UNAVAILABLE' do
              it = it + 1
              center = pseudorandom_element(_pool, pseudoseed(_pool_key..'_resample'..it))
          end
          res = res .. localize({type = "name_text", set = "Planet", key = center}) .. (i == amount and "" or ", ")
          G.GAME.used_jokers[center] = true
        end
      end

    elseif pack == "Standard" then
      local _c, _ = pseudorandom_element(G.P_CARDS, pseudoseed('front'..('sta' or '')..G.GAME.round_resets.ante))
      res = res .. localize{type = 'variable', key = 'tboj_playing_card', vars = {localize(_c.value, 'ranks'), localize(_c.suit, 'suits_plural')}} .. (i == amount and "" or ", ")

    elseif pack == "Spectral" then
      local forced_key
      if not G.GAME.banned_keys['c_soul'] then
        local soul_total_rate = 0
        local non_soul_rate = 1
        local modded_souls = {}
        for _, v in ipairs(SMODS.Consumable.legendaries) do
            if ("Spectral" == v.type.key or "Spectral" == v.soul_set) and not (G.GAME.used_jokers[v.key] and not SMODS.showman(v.key) and not v.can_repeat_soul) and SMODS.add_to_pool(v) then
                soul_total_rate = soul_total_rate + v.soul_rate
                non_soul_rate = non_soul_rate * (1 - v.soul_rate)
                non_soul_rate = math.max(non_soul_rate, 0)
                table.insert(modded_souls, v)
            end
        end
        local roll = pseudorandom('soul_smods_'.."Spectral"..G.GAME.round_resets.ante)
        local threshold = 1
        for _, v in ipairs(modded_souls) do
            threshold = threshold - v.soul_rate/soul_total_rate * (1-non_soul_rate)
            if roll > threshold then
                forced_key = v.key
                break
            end
        end
        if  not (G.GAME.used_jokers['c_soul'] and not SMODS.showman('c_soul')) then
          if pseudorandom('soul_'.."Spectral"..G.GAME.round_resets.ante) > 0.997 then
            forced_key = 'c_soul'
          end
        end
        if not (G.GAME.used_jokers['c_black_hole'] and not SMODS.showman('c_black_hole')) then
          if pseudorandom('soul_'.."Spectral"..G.GAME.round_resets.ante) > 0.997 then
            forced_key = 'c_black_hole'
          end
        end
      end

      if forced_key then
        res = res .. localize({type = "name_text", set = "Spectral", key = forced_key}) .. (i == amount and "" or ", ")
        G.GAME.used_jokers[forced_key] = true
      else
        local _pool, _pool_key = get_current_pool("Spectral", nil, nil, 'spe')
        local center = pseudorandom_element(_pool, pseudoseed(_pool_key))
        local it = 1
        while center == 'UNAVAILABLE' do
            it = it + 1
            center = pseudorandom_element(_pool, pseudoseed(_pool_key..'_resample'..it))
        end
        res = res .. localize({type = "name_text", set = "Spectral", key = center}) .. (i == amount and "" or ", ")
        G.GAME.used_jokers[center] = true
      end

    elseif pack == "Buffoon" then
      local _pool, _pool_key = get_current_pool("Joker", nil, nil, 'buf')
      local center = pseudorandom_element(_pool, pseudoseed(_pool_key))
      local it = 1
      while center == 'UNAVAILABLE' do
          it = it + 1
          center = pseudorandom_element(_pool, pseudoseed(_pool_key..'_resample'..it))
      end
      res = res .. localize({type = "name_text", set = "Joker", key = center}) .. (i == amount and "" or ", ")
      G.GAME.used_jokers[center] = true

    elseif pack == "Angel" then
      local _k
      if i == 1 then
        _k = TBOJ.get_random_key{set = "tboj_active", attributes = "tboj_angel", seed = "tboj_angel_pack"}
        res = res .. localize({type = "name_text", set = "tboj_active", key = _k}) .. (i == amount and "" or ", ")
      else
        if pseudorandom('soul_angel'..G.GAME.round_resets.ante) > 0.997 then
          _k = TBOJ.get_random_key{set = "Joker", attributes = "tboj_angel", target_rarities = {4, "Legendary"}, seed = "tboj_angel_pack"}
        else
          _k = TBOJ.get_random_key{set = "Joker", attributes = "tboj_angel", seed = "tboj_angel_pack"}
        end
        res = res .. localize({type = "name_text", set = "Joker", key = _k}) .. (i == amount and "" or ", ")
      end
      G.GAME.used_jokers[_k] = true

    elseif pack == "Devil" then
      local _k
      if i == 1 then
        _k = TBOJ.get_random_key{set = "tboj_active", attributes = "tboj_devil", seed = "tboj_devil_pack"}
        res = res .. localize({type = "name_text", set = "tboj_active", key = _k}) .. (i == amount and "" or ", ")
      else
        if pseudorandom('soul_devil'..G.GAME.round_resets.ante) > 0.997 then
          _k = TBOJ.get_random_key{set = "Joker", attributes = "tboj_devil", target_rarities = {4, "Legendary"}, seed = "tboj_devil_pack"}
        else
          _k = TBOJ.get_random_key{set = "Joker", attributes = "tboj_devil", seed = "tboj_devil_pack"}
        end
        res = res .. localize({type = "name_text", set = "Joker", key = _k}) .. (i == amount and "" or ", ")
      end
      G.GAME.used_jokers[_k] = true

    else return localize("tboj_not_supported_pack") end
  end

  for k, _ in pairs(G.GAME.pseudorandom) do
    if og_seed[k] then
      G.GAME.pseudorandom[k] = og_seed[k]
    else
      G.GAME.pseudorandom[k] = nil
    end
  end

  for k, _ in pairs(G.GAME.used_jokers) do
    if og_used[k] then
      G.GAME.used_jokers[k] = og_used[k]
    else
      G.GAME.used_jokers[k] = nil
    end
  end

  return res
end

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

function TBOJ.modify_blind_size(args)
  if args.add then
    G.GAME.blind.chips = G.GAME.blind.chips + args.add
  end
  if args.mult then
    G.GAME.blind.chips = G.GAME.blind.chips * args.mult
  end
  if args.source then
    args.source:juice_up()
  end
  G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
end

function TBOJ.save_last_hand(context)
  G.GAME.tboj_last_full_hand = {}
  G.GAME.tboj_last_scored_hand = {}
  context.full_hand = context.full_hand or {}
  for _, v in ipairs(context.full_hand) do
    local id
    local value
    local suit
    if not SMODS.has_no_rank(v) then
      id = v:get_id()
      value = v.base.value
    end

    if not SMODS.has_no_suit(v) then
      suit = v.base.suit
    end

    G.GAME.tboj_last_full_hand[#G.GAME.tboj_last_full_hand+1] = {id = id, value = value, suit = suit}
  end

  
  for _, v in ipairs(context.scoring_hand) do
    local id
    local value
    local suit
    if not SMODS.has_no_rank(v) then
      id = v:get_id()
      value = v.base.value
    end

    if not SMODS.has_no_suit(v) then
      suit = v.base.suit
    end

    G.GAME.tboj_last_scored_hand[#G.GAME.tboj_last_scored_hand+1] = {id = id, value = value, suit = suit}
  end
end