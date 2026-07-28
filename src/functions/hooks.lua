-- Active and trinker selection in packs (and shop?)
local csc = G.FUNCS.can_select_card
G.FUNCS.can_select_card = function(e)
  local card = e.config.ref_table
  local card_limit = card.ability.card_limit - card.ability.extra_slots_used
  if card.ability.set == 'tboj_active' then
    if #G.actives.cards < G.actives.config.card_limit + card_limit then
      e.config.colour = G.C.GREEN
      e.config.button = 'use_card'
    else
      e.config.colour = G.C.UI.BACKGROUND_INACTIVE
      e.config.button = nil
    end
    return
  end
  if card.ability.set == 'tboj_trinket' then
    if #G.trinkets.cards < G.trinkets.config.card_limit + card_limit then
      e.config.colour = G.C.GREEN
      e.config.button = 'use_card'
    else
      e.config.colour = G.C.UI.BACKGROUND_INACTIVE
      e.config.button = nil
    end
    return
  end
  return csc(e)
end

-- Increase Loot used count for the run
local scu = set_consumeable_usage
function set_consumeable_usage(card)
  if card.config.center_key and card.ability.consumeable then
    if card.config.center.set == 'tboj_loot' then
      G.E_MANAGER:add_event(Event({
        trigger = 'immediate',
        func = function()
          G.E_MANAGER:add_event(Event({
            trigger = 'immediate',
            func = function()
              G.GAME.last_tboj_loot = card.config.center_key
                return true
            end
          }))
            return true
        end
      }))
    end
  end
  return scu(card)
end

-- Breakfast effect
local click = Card.click
function Card:click()
  if (not self.highlighted) and self.config and self.config.center and self.config.center.key == "j_tboj_breakfast" and self.area == G.jokers then
    if G.hand and #G.hand.cards > 0 then
      SMODS.draw_cards(1)
      self.ability.extra.to_draw = self.ability.extra.to_draw - 1
      if self.ability.extra.to_draw <= 0 then
        SMODS.destroy_cards(self, {bypass_eternal = true, pinch_anim = true})
        SMODS.calculate_effect({message = localize('k_drank_ex'), colour = G.C.FILTER}, self)
      end
    end
  end
  return click(self)
end

--[[local gba = get_blind_amount
function get_blind_amount(ante)
  local amount = gba(ante)
  if ante >= 4 and G.GAME and G.GAME.applied_stakes then
    for _, v in pairs(G.GAME.applied_stakes) do
      if G.P_CENTER_POOLS.Stake[v].key == "stake_tboj_corpse_stake" then
        amount = amount * 2
        break
      end
    end
  end
  return amount
end]]

-- Setting Bloat as the boss during Aprils Fool challenge
local gnb = get_new_boss
function get_new_boss()
  if G.GAME.modifiers.tboj_aprils_fool then return "bl_tboj_bloat" end
  return gnb()
end

-- Getting the correct kind of blind
local bgt = Blind.get_type
function Blind:get_type()
  if self.config and self.config.blind and self.config.blind.small then return "Small" end
  if self.config and self.config.blind and self.config.blind.big then return "Big" end
  return bgt(self)
end

-- remove cards from the glitch crown cycle from used_jokers
local cardremove = Card.remove
function Card:remove()
  local cycling = self.ability and self.ability.tboj_cycling or nil
  local res = cardremove(self)
  if cycling then
    for _, v in pairs(cycling) do
      if not next(SMODS.find_card(v, true)) then
        G.GAME.used_jokers[v] = nil
      end
    end
  end
  return res
end

-- add cycling cards to a card
--[[local cc = create_card
function create_card(_type, area, legendary, _rarity, skip_materialize, soulable, forced_key, key_append)
  local res = cc(_type, area, legendary, _rarity, skip_materialize, soulable, forced_key, key_append)
  if res and G.GAME.modifiers.tboj_cycling then
    res.ability.tboj_cycling = {}
    for i = 1, G.GAME.modifiers.tboj_cycling.amount do
      local key = TBOJ.get_random_key({set = res.config.center.set, seed = "tboj_cycling"})
      res.ability.tboj_cycling[#res.ability.tboj_cycling+1] = key
      res.ability.tboj_cycle = 0
      G.GAME.used_jokers[key] = true
    end
  end
  return res
end]]

-- cycle through cards
local cardupdate = Card.update
function Card:update(dt, real_dt)

  if self.ability then
    --local banned_keys = {"Default", "Base", "Enhanced", "Playing Card"} -- these would crash in packs
    if (self.area ~= G.shop_jokers) and (self.area ~= G.pack_cards) then
      self.ability.tboj_cycling = nil
      self.ability.tboj_cycle = nil
    elseif G.GAME.modifiers.tboj_cycling and (not self.ability.tboj_cycling) and G.GAME.modifiers.tboj_cycling.sets[self.config.center.set] then
      self.ability.tboj_cycling = {}
      for _ = 1, G.GAME.modifiers.tboj_cycling.amount do
        local key = TBOJ.get_random_key({set = self.config.center.set, seed = "tboj_cycling"})
        self.ability.tboj_cycling[#self.ability.tboj_cycling+1] = key
        self.ability.tboj_cycle = 0
        G.GAME.used_jokers[key] = true
      end
    end
  end

  if G.GAME.modifiers.tboj_cycling and G.GAME.modifiers.tboj_cycling.sets[self.config.center.set] and self.ability and self.ability.tboj_cycling then
    self.ability.tboj_cycle = self.ability.tboj_cycle + real_dt
    if self.ability.tboj_cycle >= G.GAME.modifiers.tboj_cycling.seconds then
      local cycling = self.ability.tboj_cycling
      local _first = cycling[1]
      table.remove(cycling,1)
      cycling[#cycling+1] = self.config.center.key
      TBOJ.reroll(self, _first, true, true)
      self.ability.tboj_cycling = cycling
      self.ability.tboj_cycle = 0
    end
  end

  if ((not G.GAME.modifiers.tboj_cycling) or G.GAME.modifiers.tboj_cycling.seconds <= 0) and self.ability.tboj_cycling then
    self.ability.tboj_cycling = nil
    self.ability.tboj_cycle = nil
  end

  return cardupdate(self, dt, real_dt)
end

-- let the buttons be clickable while cycling
local scuc = SMODS.clean_up_children
function SMODS.clean_up_children(t)
  if t.tboj_from_cycle then
    local ignore = {center = true, shadow = true, back = true, h_popup = true, front = true, price = true, buy_button = true, buy_and_use_button = true, use_button = true}
    for k, v in pairs(t) do
        if not ignore[k] then
            if type(v) == 'table' and v.remove then v:remove() end
            t[k] = nil
        end
	  end
    return
  end
  return scuc(t)
end

-- set editions and seals passively during pack prediction
local cse = Card.set_edition
function Card:set_edition(edition, immediate, silent, delay)
  if TBOJ.predict_pack_state then
    immediate = true
    silent = true
  end
  return cse(self, edition, immediate, silent, delay)
end

local css = Card.set_seal
function Card:set_seal(_seal, silent, immediate)
  if TBOJ.predict_pack_state then
    immediate = true
    silent = true
  end
  return css(self, _seal, silent, immediate)
end

-- Context for when money is earned
local ed = ease_dollars
function ease_dollars(mod, instant)
  ed(mod, instant)
  SMODS.calculate_context({tboj_money = mod})
end

-- Continuum effect
local cms = SMODS.calculate_main_scoring
TBOJ.Continuum_flag = {check = false}
function SMODS.calculate_main_scoring(context, scoring_hand)
  if (context.cardarea == G.play) and next(SMODS.find_card("j_tboj_continuum")) then
    local parse = {}
    for i, v in ipairs(G.play.cards) do
      parse[i] = v
    end
    for i = 1, #parse do
      context.cardarea = G.play
      local card = G.play.cards[i]
      if context.scoring_hand and not SMODS.check_looping_context(card) then
        context.scoring_hand = TBOJ.get_scoring_hand()
      end
      local in_scoring = scoring_hand and SMODS.in_scoring(card, context.scoring_hand)
      --add cards played to list
      if scoring_hand and not SMODS.has_no_rank(card) and in_scoring then
        G.GAME.cards_played[card.base.value].total = G.GAME.cards_played[card.base.value].total + 1
        if not SMODS.has_no_suit(card) then
          G.GAME.cards_played[card.base.value].suits[card.base.suit] = true
        end
      end
      --if card is debuffed
      if scoring_hand and card.debuff then
        if in_scoring then
          G.GAME.blind.triggered = true
          G.E_MANAGER:add_event(Event({
            trigger = 'immediate',
            func = (function() SMODS.juice_up_blind();return true end)
          }))
          card_eval_status_text(card, 'debuff')
        end
      else
        if scoring_hand then
          if in_scoring then context.cardarea = G.play else context.cardarea = 'unscored' end
        end
        TBOJ.Continuum_flag = {check = true}
        SMODS.score_card(card, context)
      end
    end
  else
    cms(context, scoring_hand)
  end
  TBOJ.Continuum_flag = {check = false}
end