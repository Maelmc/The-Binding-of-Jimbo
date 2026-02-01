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

function TBOJ.charge_active(self,card,context)
  if context.end_of_round then
    if next(SMODS.find_card("j_tboj_the_battery")) and card.ability.extra.curr_charge <  card.ability.extra.max_charge * 2 or
    card.ability.extra.curr_charge <  card.ability.extra.max_charge then
      card.ability.extra.curr_charge = card.ability.extra.curr_charge + 1
    end
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