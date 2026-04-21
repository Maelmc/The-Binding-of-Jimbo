TBOJ.remove_deck = {
  ["b_abandoned"] = function()
    local suits = {"Spades","Hearts","Clubs","Diamonds"}
    local ranks = {"King","Queen","Jack"}
    for _, v in pairs(suits) do
      for _, w in pairs(ranks) do
        SMODS.add_card {
          set = "Base",
          area = G.deck,
          rank = w,
          suit = v
        }
      end
    end
  end,
  ["b_anaglyph"] = function() end, -- anaglyph is only a calculate function so nothing to remove
  ["b_black"] = function()
    G.jokers:change_size(-1)
    G.GAME.round_resets.hands = G.GAME.round_resets.hands + 1
    ease_hands_played(1)
  end,
  ["b_blue"] = function()
    G.GAME.round_resets.hands = G.GAME.round_resets.hands - 1
    ease_hands_played(-1)
  end,
  ["b_challenge"] = function() end, -- there's nothing to be done here
  ["b_checkered"] = function() end, -- this one sucks to do
  ["b_erratic"] = function() end, -- uuuuuuuuuuuuh
  ["b_ghost"] = function()
    G.GAME.spectral_rate = G.GAME.spectral_rate - 2
  end,
  ["b_green"] = function()
    G.GAME.modifiers.money_per_hand = nil
    G.GAME.modifiers.money_per_discard = nil
    G.GAME.modifiers.no_interest = nil
  end,
  ["b_magic"] = function()
    --[[for _, v in pairs(G.vouchers.cards) do
      if v.config.center_key == "v_crystal_ball" then
        v:unredeem()
        return
      end
    end]] -- doesnt work
  end,
  ["b_nebula"] = function()
    --[[for _, v in pairs(G.vouchers.cards) do
      if v.config.center_key == "v_telescope" then
        v:unredeem() -- from spectrallib
        break
      end
    end]] -- doesnt work
    G.consumeables:change_size(1)
  end,
  ["b_painted"] = function()
    G.jokers:change_size(1)
    G.hand:change_size(-3)
  end,
  ["b_plasma"] = function() end,
  ["b_red"] = function()
    G.GAME.round_resets.discards = G.GAME.round_resets.discards - 1
    ease_discard(-1)
  end,
  ["b_yellow"] = function() end, -- should we remove the extra money?
  ["b_zodiac"] = function()
    --[[for _, v in pairs(G.vouchers.cards) do
      if v.config.center_key == "v_telescope" or v.config.center_key == "v_overstock_norm" or v.config.center_key == "v_tarot_merchant" then
        v:unredeem() -- from spectrallib
      end
    end]] -- doesnt work
  end,
}

function TBOJ.add_remove_deck(key,func,override)
  if (key and type(key) == "string") and (func and type(func) == "function") then
    if override or not TBOJ.remove_deck[key] then
      TBOJ.remove_deck[key] = func
    end
  end
end

function Back:apply_mid_run()
  local obj = self.effect.center
	if obj.apply and type(obj.apply) == 'function' then
		obj:apply(self)
	end

  if self.effect.config.jokers then
    delay(0.4)
    G.E_MANAGER:add_event(Event({
      func = function()
        for k, v in ipairs(self.effect.config.jokers) do
          if (#G.jokers.cards + (G.GAME.joker_buffer or 0)) >= G.jokers.config.card_limit then break end
          G.GAME.joker_buffer = (G.GAME.joker_buffer or 0) + 1
          local card = create_card('Joker', G.jokers, nil, nil, nil, nil, v, 'deck')
          card:add_to_deck()
          G.jokers:emplace(card)
          card:start_materialize()
        end
        return true
      end
    }))
  end

  if self.effect.config.voucher then
    if not G.GAME.used_vouchers[self.effect.config.voucher] then
      G.GAME.used_vouchers[self.effect.config.voucher] = true
      G.E_MANAGER:add_event(Event({
          func = function()
              Card.apply_to_run(nil, G.P_CENTERS[self.effect.config.voucher])
              return true
          end
      }))
    end
  end

  if self.effect.config.hands then 
    G.GAME.round_resets.hands = G.GAME.round_resets.hands + self.effect.config.hands
    ease_hands_played(self.effect.config.hands)
  end

  if self.effect.config.consumables then
    delay(0.4)
    G.E_MANAGER:add_event(Event({
      func = function()
        for k, v in ipairs(self.effect.config.consumables) do
          if #G.consumeables.cards + (G.GAME.consumeable_buffer or 0) >= G.consumeables.config.card_limit then break end
          G.GAME.consumeable_buffer = (G.GAME.consumeable_buffer or 0) + 1
          local card = create_card('Tarot', G.consumeables, nil, nil, nil, nil, v, 'deck')
          card:add_to_deck()
          G.consumeables:emplace(card)
        end
      return true
      end
    }))
  end

  if self.effect.config.dollars then
    TBOJ.ease_money(self.effect.config.dollars)
    SMODS.calculate_context({
      money_altered = true,
      amount = self.effect.config.dollars,
    })
end
  if self.effect.config.remove_faces then
    local to_destroy = {}
    for _, v in pairs(G.playing_cards) do
      local id = self:get_id()
      local rank = SMODS.Ranks[self.base.value]
      if id and id > 0 and rank and rank.face then
        to_destroy[#to_destroy+1] = v
      end
    end
    SMODS.destroy_cards(to_destroy)
  end

  if self.effect.config.spectral_rate then
    G.GAME.spectral_rate = (G.GAME.spectral_rate or 0) + self.effect.config.spectral_rate
  end

  if self.effect.config.discards then 
    ease_discard(self.effect.config.discards)
  end

  if self.effect.config.reroll_discount then
    G.GAME.round_resets.reroll_cost = G.GAME.round_resets.reroll_cost - self.effect.config.reroll_discount
    G.GAME.current_round.reroll_cost = math.max(0, G.GAME.current_round.reroll_cost - self.effect.config.reroll_discount)
  end

  if self.effect.config.edition then
    -- do we want to apply this one?? it's not used anyway
  end

  if self.effect.config.vouchers then
    for k, v in pairs(self.effect.config.vouchers) do
      if not G.GAME.used_vouchers[v] then
        G.GAME.used_vouchers[v] = true
        G.GAME.starting_voucher_count = (G.GAME.starting_voucher_count or 0) + 1
        G.E_MANAGER:add_event(Event({
          func = function()
            Card.apply_to_run(nil, G.P_CENTERS[v])
            return true
          end
        }))
      end
    end
  end

  if self.name == 'Checkered Deck' then
    G.E_MANAGER:add_event(Event({
      func = function()
        for k, v in pairs(G.playing_cards) do
          if v.base.suit == 'Clubs' then 
            v:change_suit('Spades')
          end
          if v.base.suit == 'Diamonds' then 
            v:change_suit('Hearts')
          end
        end
      return true
      end
    }))
  end

  G.E_MANAGER:add_event(Event({
    func = function()
      G.E_MANAGER:add_event(Event({
        func = function()
          save_run()
          return true
        end
      }))
      return true
    end
  }))

  if self.effect.config.randomize_rank_suit then
    for _, v in pairs(G.playing_cards) do
      local suit = pseudorandom_element(SMODS.Suits, pseudoseed('sccsuit' .. G.GAME.round_resets.ante)).card_key
      local rank = pseudorandom_element(SMODS.Ranks, pseudoseed('sccrank' .. G.GAME.round_resets.ante)).card_key
      SMODS.change_base(v,suit,rank)
    end
  end

  if self.effect.config.joker_slot then
    G.jokers:change_size(self.effect.config.joker_slot)
  end

  if self.effect.config.hand_size then
    G.hand:change_size(self.effect.config.hand_size)
  end

  if self.effect.config.ante_scaling then
    G.GAME.starting_params.ante_scaling = (G.GAME.starting_params.ante_scaling or 0) + self.effect.config.ante_scaling
  end

  if self.effect.config.consumable_slot then
    G.consumables:change_size(self.effect.config.consumable_slot)
  end

  if self.effect.config.boosters_in_shop then
    G.GAME.starting_params.boosters_in_shop = self.effect.config.boosters_in_shop
  end

  if self.effect.config.no_interest then
    G.GAME.modifiers.no_interest = true
  end

  if self.effect.config.extra_hand_bonus then 
    G.GAME.modifiers.money_per_hand = (G.GAME.modifiers.money_per_hand or 0) + self.effect.config.extra_hand_bonus
  end

  if self.effect.config.extra_discard_bonus then 
    G.GAME.modifiers.money_per_discard = (G.GAME.modifiers.money_per_discard or 0) + self.effect.config.extra_discard_bonus
  end
end

function TBOJ.change_deck(to,remove_previous)
  if remove_previous then
    if TBOJ.remove_deck[G.GAME.selected_back_key.key] then TBOJ.remove_deck[G.GAME.selected_back_key.key]() end
  end

  local new_deck = G.P_CENTERS[to]
  G.GAME.selected_back_key = G.P_CENTERS[to]
  G.GAME.selected_back = Back(new_deck)
  G.GAME.selected_back:apply_mid_run()

  for _, v in pairs(G.I.CARD) do
    if v.children and v.children.back then
      v.children.back:remove()
      local atlas_key = (G.GAME.viewed_back or G.GAME.selected_back) and ((G.GAME.viewed_back or G.GAME.selected_back)[G.SETTINGS.colourblind_option and 'hc_atlas' or 'lc_atlas'] or (G.GAME.viewed_back or G.GAME.selected_back).atlas) or 'centers'
      v.children.back = SMODS.create_sprite(v.T.x, v.T.y, v.T.w, v.T.h, atlas_key, G.GAME["selected_back"].pos)
      v.children.back.states.hover = v.states.hover
      v.children.back.states.click = v.states.click
      v.children.back.states.drag = v.states.drag
      v.children.back.states.collide.can = false
      v.children.back:set_role({major = v, role_type = 'Glued', draw_major = v})
    end
  end
end