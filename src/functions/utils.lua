function TBOJ.in_pool(self, args)
    if next(find_joker("Showman")) then
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
function TBOJ.reroll(card, to_key)
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

  if not card.edition then
    card:juice_up()
    play_sound('generic1')
  else
    card:juice_up(1, 0.5)
    if card.edition.foil then play_sound('foil1', 1.2, 0.4) end
    if card.edition.holo then play_sound('holo1', 1.2*1.58, 0.4) end
    if card.edition.polychrome then play_sound('polychrome1', 1.2, 0.7) end
    if card.edition.negative then play_sound('negative', 1.5, 0.4) end
    if card.edition.poke_shiny then
      play_sound('poke_e_shiny', 1, 0.2)
      G.P_CENTERS.e_poke_shiny.on_load(card)
    end
  end
end

function TBOJ.leftmost_or_selected()
    return G.jokers.highlighted[1] or G.jokers.cards[1]
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
  local target_rarity = args.target_rarity
  local candidates = {}
  for _, v in pairs(G.P_CENTERS) do
    if v.set and v.set == set
    and (not (type(v.in_pool) == 'function') or v:in_pool())
    and not G.GAME.banned_keys[v.key]
    and (not target_rarity or v.rarity == target_rarity)
    and (not banned_rarities or not table.contains(banned_rarities,v.rarity))
    and not ((G.GAME.used_jokers[v.key] or next(SMODS.find_card(v.key))) and not SMODS.showman(v.key)) then
      if v.enhancement_gate then
        if G.playing_cards then
          for kk, vv in pairs(G.playing_cards) do
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
  if #candidates > 0 then
    return pseudorandom_element(candidates, pseudoseed(seed))
  elseif set == "Joker" then return "j_joker"
  elseif set == "tboj_active" then return "active_tboj_book_of_belial"
  elseif set == "tboj_trinket" then return "trinket_tboj_swallowed_penny"
  end
end

function table.contains(table, element)
  for _, value in pairs(table) do
    if value == element then
      return true
    end
  end
  return false
end

function TBOJ.juice_flip_hand(card, second)
  local sound = 'card1'
  local base_percent = 1.15
  local extra = nil
  if second then sound = 'tarot2' end
  if second then base_percent = 0.85 end
  if second then extra = .6 end
  G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
      play_sound('tarot1')
      card:juice_up(0.3, 0.5)
      return true end }))
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

function TBOJ.juice_flip(card, second)
  local sound = 'card1'
  local base_percent = 1.15
  local extra = nil
  if second then sound = 'tarot2' end
  if second then base_percent = 0.85 end
  if second then extra = .6 end
  G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
      play_sound('tarot1')
      card:juice_up(0.3, 0.5)
      return true end }))
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

-- Mostly copied from Visibility's Crystal Geode
function TBOJ.balance_percent(card, percent)
  local percentage_mult = mult * percent
  local percentage_chips = hand_chips * percent
  mult = mult - math.floor(percentage_mult)
  hand_chips = hand_chips - math.floor(percentage_chips)
  local balance = math.floor((percentage_mult + percentage_chips) / 2)
  mult = mult + balance
  hand_chips = hand_chips + balance
  update_hand_text({delay = 0}, {chips = hand_chips, mult = mult})
  G.E_MANAGER:add_event(Event({
    delay = 0.6,
    trigger = 'after',
    func = (function()
      --card:juice_up()
      play_sound('gong', 0.94, 0.3)
      play_sound('gong', 0.94*1.5, 0.2)
      play_sound('tarot1', 1.5)
      ease_colour(G.C.UI_CHIPS, {0.8, 0.45, 0.85, 1})
      ease_colour(G.C.UI_MULT, {0.8, 0.45, 0.85, 1})
      G.E_MANAGER:add_event(Event({
        trigger = 'after',
        blockable = false,
        blocking = false,
        delay =  0.8,
        func = (function() 
            ease_colour(G.C.UI_CHIPS, G.C.BLUE, 0.8)
            ease_colour(G.C.UI_MULT, G.C.RED, 0.8)
          return true
        end)
      }))
      G.E_MANAGER:add_event(Event({
        trigger = 'after',
        blockable = false,
        blocking = false,
        no_delete = true,
        delay =  1.3,
        func = (function() 
          G.C.UI_CHIPS[1], G.C.UI_CHIPS[2], G.C.UI_CHIPS[3], G.C.UI_CHIPS[4] = G.C.BLUE[1], G.C.BLUE[2], G.C.BLUE[3], G.C.BLUE[4]
          G.C.UI_MULT[1], G.C.UI_MULT[2], G.C.UI_MULT[3], G.C.UI_MULT[4] = G.C.RED[1], G.C.RED[2], G.C.RED[3], G.C.RED[4]
          return true
        end)
      }))
      return true
    end)
  }))
  return { 
    message = localize { type = 'variable', key = 'tboj_percent', vars = { percent } },
    loc_vars = { percent }, colour =  {0.8, 0.45, 0.85, 1} 
  }
end