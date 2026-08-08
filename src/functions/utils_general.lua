-- Fix money with Talisman
function TBOJ.ease_money(amt, calc_only)
  local earned = amt
  if (SMODS.Mods["Talisman"] or {}).can_load then
    earned = to_number(earned)
  end
  if not calc_only then ease_dollars(earned) end
  return earned
end

-- Get the selected joker, or leftmost if none are selected
function TBOJ.leftmost_or_selected_joker()
  return G.jokers.highlighted[1] or G.jokers.cards[1]
end

---@param args? {set?: string, seed?: string, banned_rarities?: table<string>, target_rarities?: table<string|number>, attributes?: string|table<string>}
--- Get a random key based on arguments
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
  local available = 0
  for _, v in pairs(G.P_CENTERS) do
    if v.set and v.set == set
    and (not (type(v.in_pool) == 'function') or v:in_pool()) -- in pool
    and (not (v.no_pool_flag and G.GAME.pool_flags[v.no_pool_flag]))
    and ((not v.yes_pool_flag) or G.GAME.pool_flags[v.yes_pool_flag])
    and not G.GAME.banned_keys[v.key] -- not banned
    and not (v.set == "Joker" and (not v.mod) and TBOJ.config and TBOJ.config.no_vanilla_joker)
    and not v.no_collection
    and (not _rarity or v.rarity == _rarity) then -- right rarity
      local all_attributes = true
      if attributes then
        for _, _attribute in pairs(attributes) do
          if not TBOJ.center_has_attribute(v,_attribute) then
            all_attributes = false
            break
          end
        end
      end
      if all_attributes then
        if v.enhancement_gate then
          if G.playing_cards then
            for _, vv in pairs(G.playing_cards) do
              if SMODS.has_enhancement(vv, v.enhancement_gate) then
                if SMODS.showman(v.key) or not ((G.GAME.used_jokers[v.key] or next(SMODS.find_card(v.key)))) then
                  table.insert(candidates, v.key)
                  available = available + 1
                else
                  table.insert(candidates,"UNAVAILABLE")
                end
                break
              end
            end
          end
        else
          if SMODS.showman(v.key) or not ((G.GAME.used_jokers[v.key] or next(SMODS.find_card(v.key)))) then
            table.insert(candidates, v.key)
            available = available + 1
          else
            table.insert(candidates,"UNAVAILABLE")
          end
        end
      end
    end
  end
  if available > 0 then
    local elem, _ = pseudorandom_element(candidates, pseudoseed(seed))
    local it = 1
    while elem == 'UNAVAILABLE' do
      it = it + 1
      elem = pseudorandom_element(candidates, pseudoseed(seed..'_resample'..it))
    end
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

-- Deep copy a table
-- https://stackoverflow.com/a/26367080
function TBOJ.table_copy(obj, seen)
  if type(obj) ~= 'table' then return obj end
  if seen and seen[obj] then return seen[obj] end
  local s = seen or {}
  local res = setmetatable({}, getmetatable(obj))
  s[obj] = res
  for k, v in pairs(obj) do res[TBOJ.table_copy(k, s)] = TBOJ.table_copy(v, s) end
  return res
end

-- Flip a table of cards
function TBOJ.juice_flip_cards(cards, source, second)
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

-- Flip all cards held in hand
function TBOJ.juice_flip_hand(source, second, opposite_way)
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
  if opposite_way then
    for i=1, #G.hand.cards do
      local percent = nil
      if second then
        percent = base_percent + (i-0.999)/(#G.hand.cards-0.998)*0.3
      else
        percent = base_percent - (i-0.999)/(#G.hand.cards-0.998)*0.3
      end
      G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() G.hand.cards[(#G.hand.cards-i+1)]:flip();play_sound(sound, percent, extra);G.hand.cards[(#G.hand.cards-i+1)]:juice_up(0.3, 0.3);return true end }))
    end
  else
    for i=1, #G.hand.cards do
      local percent = nil
      if second then
        percent = base_percent + (i-0.999)/(#G.hand.cards-0.998)*0.3
      else
        percent = base_percent - (i-0.999)/(#G.hand.cards-0.998)*0.3
      end
      G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() G.hand.cards[i]:flip();play_sound(sound, percent, extra);G.hand.cards[i]:juice_up(0.3, 0.3);return true end }))
    end
  end
  delay(0.2)
end

-- Flip all highlighted cards
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

-- Converts a card's ID to the corresponding value
function TBOJ.id_to_value(id)
  if id == 11 then return "Jack"
  elseif id == 12 then return "Queen"
  elseif id == 13 then return "King"
  elseif id == 14 then return "Ace"
  else return tostring(id)
  end
end

-- Get a card's total chips
function TBOJ.total_chips(card)
  local total_chips = card:get_chip_bonus()
  if card.edition then
    total_chips = total_chips + (card.edition.chips or 0)
  end
  return total_chips
end

-- Add a card to the shop and realign them
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

-- Predict the next result of an rng call
function TBOJ.predict_seed(key)
  local pkey = G.GAME.pseudorandom[key]
  if not G.GAME.pseudorandom[key] then
    pkey = pseudohash(key..(G.GAME.pseudorandom.seed or ''))
  end

  pkey = math.abs(tonumber(string.format("%.13f", (2.134453429141+pkey*1.72431234)%1)))
  return (pkey + (G.GAME.pseudorandom.hashed_seed or 0))/2
end

-- Predict the next boss blind
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

-- Predict a booster pack's content
function TBOJ.predict_pack(args)
  TBOJ.predict_pack_state = true
  local amount = args.amount
  local pack = args.pack
  local create_card = args.create_card
  local pack_self = args.pack_self

  local og_seed = {}
  for k, v in pairs(G.GAME.pseudorandom) do
    og_seed[k] = v
  end

  local og_used = {}
  for k, v in pairs(G.GAME.used_jokers) do
    og_used[k] = v
  end

  local keys = {}

  for i = 1, amount do
    -- in theory, should always run this
    if create_card then
      local _card_to_spawn = create_card(pack_self, pack_self, i)
      local card
      if type((_card_to_spawn or {}).is) == 'function' and _card_to_spawn:is(Card) then
        card = _card_to_spawn
      else
        card = SMODS.create_card(_card_to_spawn)
      end
      keys[#keys+1] = {
        card = card,
        key = card.config.center.key,
        --[[set = card.config.center.set,
        rank = card.base and card.base.value or nil,
        suit = card.base and card.base.suit or nil,
        enhancement = card.config.center.key,
        edition = card.edition and card.edition.key or nil,
        seal = card:get_seal(),
        stickers = {eternal = card.ability and card.ability.eternal or nil, perishable = card.ability and card.ability.perishable or nil, rental = card.ability and card.ability.rental or nil}]]
      }
      G.GAME.used_jokers[card.config.center.key] = true

    -- otherwise run manual checks that work with vanilla + tboj content, as a failsafe
    elseif pack == "Arcana" then
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
        keys[#keys+1] = {key = forced_key}
        G.GAME.used_jokers[forced_key] = true
      else
        local _pool, _pool_key
        if G.GAME.used_vouchers.v_omen_globe and pseudorandom('omen_globe') > 0.8 then
          _pool, _pool_key = get_current_pool("Spectral", nil, nil, 'ar2')
        else
          _pool, _pool_key = get_current_pool("Tarot", nil, nil, 'ar1')
        end
        local center = pseudorandom_element(_pool, pseudoseed(_pool_key))
        local it = 1
        while center == 'UNAVAILABLE' do
            it = it + 1
            center = pseudorandom_element(_pool, pseudoseed(_pool_key..'_resample'..it))
        end
        keys[#keys+1] = {key = center}
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
        keys[#keys+1] = {key = _planet}
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
          keys[#keys+1] = {key = forced_key}
          G.GAME.used_jokers[forced_key] = true
        else
          local _pool, _pool_key = get_current_pool("Planet", nil, nil, 'pl1')
          local center = pseudorandom_element(_pool, pseudoseed(_pool_key))
          local it = 1
          while center == 'UNAVAILABLE' do
              it = it + 1
              center = pseudorandom_element(_pool, pseudoseed(_pool_key..'_resample'..it))
          end
          keys[#keys+1] = {key = center}
          G.GAME.used_jokers[center] = true
        end
      end

    elseif pack == "Standard" then
      local _set = (pseudorandom(pseudoseed('stdset'..G.GAME.round_resets.ante)) > 0.6) and "Enhanced" or "Base"

      local center
      if _set == "Enhanced" then
        local _pool, _pool_key = get_current_pool(_set, nil, nil, 'sta')
        center = pseudorandom_element(_pool, pseudoseed(_pool_key))
        local it = 1
        while center == 'UNAVAILABLE' do
          it = it + 1
          center = pseudorandom_element(_pool, pseudoseed(_pool_key..'_resample'..it))
        end
      end

      local _c, _ = pseudorandom_element(G.P_CARDS, pseudoseed('frontsta'..G.GAME.round_resets.ante))
      keys[#keys+1] = {set = _set, rank = _c.value, suit = _c.suit, enhancement = center, edition = SMODS.poll_edition { key = "standard_edition" .. G.GAME.round_resets.ante, mod = 2, no_negative = true }, seal = SMODS.poll_seal({ mod = 10 })}

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
        keys[#keys+1] = {key = forced_key}
        G.GAME.used_jokers[forced_key] = true
      else
        local _pool, _pool_key = get_current_pool("Spectral", nil, nil, 'spe')
        local center = pseudorandom_element(_pool, pseudoseed(_pool_key))
        local it = 1
        while center == 'UNAVAILABLE' do
            it = it + 1
            center = pseudorandom_element(_pool, pseudoseed(_pool_key..'_resample'..it))
        end
        keys[#keys+1] = {key = center}
        G.GAME.used_jokers[center] = true
      end

    elseif pack == "Buffoon" then
      local center
      if i == 1 and next(SMODS.find_card("j_tboj_pentagram")) then
        local rand = pseudorandom("tboj_pentagram")
        if rand < 0.5 then
          center = TBOJ.get_random_key{set = "Joker", attributes = "tboj_angel", seed = "tboj_pentagram"}
        else
          center = TBOJ.get_random_key{set = "Joker", attributes = "tboj_devil", seed = "tboj_pentagram"}
        end
      else
        local _pool, _pool_key = get_current_pool("Joker", nil, nil, 'buf')
        center = pseudorandom_element(_pool, pseudoseed(_pool_key))
        local it = 1
        while center == 'UNAVAILABLE' do
            it = it + 1
            center = pseudorandom_element(_pool, pseudoseed(_pool_key..'_resample'..it))
        end
      end

      local _eternal
      local _perish
      local eternal_perishable_poll = pseudorandom(('packetper')..G.GAME.round_resets.ante)
      if G.GAME.modifiers.all_eternal then _eternal = true
      else
        _eternal = G.GAME.modifiers.enable_eternals_in_shop and eternal_perishable_poll > 0.7 and not SMODS.Stickers["eternal"].should_apply
      end
      if not _eternal then
        _perish = G.GAME.modifiers.enable_perishables_in_shop and ((eternal_perishable_poll > 0.4) and (eternal_perishable_poll <= 0.7)) and not SMODS.Stickers["perishable"].should_apply
      end
      local _rental = G.GAME.modifiers.enable_rentals_in_shop and pseudorandom(('packssjr')..G.GAME.round_resets.ante) > 0.7 and not SMODS.Stickers["rental"].should_apply
      keys[#keys+1] = {key = center, edition = poll_edition('edibuf'..G.GAME.round_resets.ante), stickers = {eternal = _eternal, perishable = _perish, rental = _rental}}
      G.GAME.used_jokers[center] = true

    elseif pack == "Angel" then
      local center
      if i == 1 then
        center = TBOJ.get_random_key{set = "tboj_active", attributes = "tboj_angel", seed = "tboj_angel_pack"}
      else
        if pseudorandom('soul_angel'..G.GAME.round_resets.ante) > 0.997 then
          center = TBOJ.get_random_key{set = "Joker", attributes = "tboj_angel", target_rarities = {4, "Legendary"}, seed = "tboj_angel_pack"}
        else
          center = TBOJ.get_random_key{set = "Joker", attributes = "tboj_angel", seed = "tboj_angel_pack"}
        end
      end

      local _eternal
      local _perish
      local eternal_perishable_poll = pseudorandom(('packetper')..G.GAME.round_resets.ante)
      if G.GAME.modifiers.all_eternal then _eternal = true
      else
        _eternal = G.GAME.modifiers.enable_eternals_in_shop and eternal_perishable_poll > 0.7 and not SMODS.Stickers["eternal"].should_apply
      end
      if not _eternal then
        _perish = G.GAME.modifiers.enable_perishables_in_shop and ((eternal_perishable_poll > 0.4) and (eternal_perishable_poll <= 0.7)) and not SMODS.Stickers["perishable"].should_apply
      end
      local _rental = G.GAME.modifiers.enable_rentals_in_shop and pseudorandom(('packssjr')..G.GAME.round_resets.ante) > 0.7 and not SMODS.Stickers["rental"].should_apply
      keys[#keys+1] = {key = center, edition = poll_edition('edibuf'..G.GAME.round_resets.ante), stickers = {eternal = _eternal, perishable = _perish, rental = _rental}}
      G.GAME.used_jokers[center] = true

    elseif pack == "Devil" then
      local center
      if i == 1 then
        center = TBOJ.get_random_key{set = "tboj_active", attributes = "tboj_devil", seed = "tboj_devil_pack"}
      else
        if pseudorandom('soul_devil'..G.GAME.round_resets.ante) > 0.997 then
          center = TBOJ.get_random_key{set = "Joker", attributes = "tboj_devil", target_rarities = {4, "Legendary"}, seed = "tboj_devil_pack"}
        else
          center = TBOJ.get_random_key{set = "Joker", attributes = "tboj_devil", seed = "tboj_devil_pack"}
        end
      end

      local _eternal
      local _perish
      local eternal_perishable_poll = pseudorandom(('packetper')..G.GAME.round_resets.ante)
      if G.GAME.modifiers.all_eternal then _eternal = true
      else
        _eternal = G.GAME.modifiers.enable_eternals_in_shop and eternal_perishable_poll > 0.7 and not SMODS.Stickers["eternal"].should_apply
      end
      if not _eternal then
        _perish = G.GAME.modifiers.enable_perishables_in_shop and ((eternal_perishable_poll > 0.4) and (eternal_perishable_poll <= 0.7)) and not SMODS.Stickers["perishable"].should_apply
      end
      local _rental = G.GAME.modifiers.enable_rentals_in_shop and pseudorandom(('packssjr')..G.GAME.round_resets.ante) > 0.7 and not SMODS.Stickers["rental"].should_apply
      keys[#keys+1] = {key = center, edition = poll_edition('edibuf'..G.GAME.round_resets.ante), stickers = {eternal = _eternal, perishable = _perish, rental = _rental}}
      G.GAME.used_jokers[center] = true

    else
      TBOJ.predict_pack_state = nil
      return keys
    end
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

  TBOJ.predict_pack_state = nil
  return keys
end

-- Modify score required to beat the blind
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

-- Save a played hand to a variable
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

-- Check if a given center has a given attribute
function TBOJ.center_has_attribute(center,attribute)
  if not SMODS.Attributes[attribute] or not center.attributes then return false end
  if center.attributes[attribute] then return true end
  for _, att in ipairs(SMODS.Attributes[attribute].alias or {}) do
    if center.attributes[att] then return true end
  end
  return false
end

-- Recalculate the scoring hand
function TBOJ.get_scoring_hand()
  local text,disp_text,poker_hands,scoring_hand,non_loc_disp_text = G.FUNCS.get_poker_hand_info(G.play.cards)
  local final_scoring_hand = {}
  for i=1, #G.play.cards do
      local splashed = SMODS.always_scores(G.play.cards[i]) or next(find_joker('Splash'))
      local unsplashed = SMODS.never_scores(G.play.cards[i])
      if not splashed then
          for _, card in pairs(scoring_hand) do
              if card == G.play.cards[i] then splashed = true end
          end
      end
      local effects = {}
      SMODS.calculate_context({modify_scoring_hand = true, other_card =  G.play.cards[i], full_hand = G.play.cards, scoring_hand = scoring_hand, in_scoring = true, ignore_other_debuff = true}, effects)
      local flags = SMODS.trigger_effects(effects, G.play.cards[i])
      if flags.add_to_hand then splashed = true end
    if flags.remove_from_hand then unsplashed = true end
      if splashed and not unsplashed then table.insert(final_scoring_hand, G.play.cards[i]) end
  end

  return final_scoring_hand
end

function TBOJ.count_unique_suits(hand)
  local suits = {}
  local suit_count = 0

  for k, v in pairs(hand) do
    for x, y in pairs(SMODS.Suits) do
      if not SMODS.has_any_suit(v) and v:is_suit(y.key, true) and not suits[y.key] then
        suits[y.key] = true
        suit_count = suit_count + 1
        break
      end
    end
  end

  for k, v in pairs(hand) do
    for x, y in pairs(SMODS.Suits) do
      if SMODS.has_any_suit(v) and v:is_suit(y.key) and not suits[y.key] then
        suits[y.key] = true
        suit_count = suit_count + 1
        break
      end
    end
  end

  return suit_count
end

function TBOJ.is_in_collection(card)
  if not card.area and G.OVERLAY_MENU then return true end
  if card.area and card.area.config.collection then return true end
  if G.your_collection then
    for k, v in pairs(G.your_collection) do
      if card.area == v then
        return true
      end
    end
  end
  return false
end

function TBOJ.apply_cursed(card, start, tally)
  tally = tally or start
  card:add_sticker("tboj_cursed", true)
  card.ability.tboj_cursed = {perish_start = start, perish_tally = tally}
end