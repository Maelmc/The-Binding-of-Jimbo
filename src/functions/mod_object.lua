local function reset_death_list_card()
  G.GAME.current_round.tboj_death_list_card = { rank = 'Ace' }
  local valid_mail_cards = {}
  for _, playing_card in ipairs(G.playing_cards) do
    if not SMODS.has_no_rank(playing_card) then
      valid_mail_cards[#valid_mail_cards + 1] = playing_card
    end
  end
  local mail_card = pseudorandom_element(valid_mail_cards, 'tboj_death_list' .. G.GAME.round_resets.ante)
  if mail_card then
    G.GAME.current_round.tboj_death_list_card.rank = mail_card.base.value
    G.GAME.current_round.tboj_death_list_card.id = mail_card.base.id
  end
end

local function reset_fruity_plum_card()
  local valid_suits = {}
  for _, v in pairs(SMODS.Suits) do
    if v.key ~= G.GAME.tboj_fruity_plum_suit then valid_suits[#valid_suits + 1] = v end
  end
  if valid_suits[1] then
    local suit = pseudorandom_element(valid_suits, pseudoseed('tboj_fruity_plum'..G.GAME.round_resets.ante))
    G.GAME.tboj_fruity_plum_suit = suit.key
  end
end

SMODS.current_mod.calculate = function(self, context)
  if G.GAME.modifiers.tboj_aprils_fool and context.buying_card then
    TBOJ.reroll(context.card,TBOJ.get_random_key({set = context.card.ability.set, seed = "tboj_aprils_fools" .. G.GAME.round_resets.ante}),true)
  end

  if G.GAME.modifiers.tboj_aprils_fool and context.using_active then
    TBOJ.reroll(context.active,TBOJ.get_random_key({set = context.active.ability.set, seed = "tboj_aprils_fools" .. G.GAME.round_resets.ante}))
    if context.active.ability.extra.curr_charge then context.active.ability.extra.curr_charge = 0 end
  end

  -- Change Fruity Plum's suit each hand
  if context.after then
    reset_fruity_plum_card()
    TBOJ.save_last_hand(context)
  end
end

function SMODS.current_mod.reset_game_globals(run_start)
  reset_death_list_card()
  if run_start then
    G.GAME.tboj_last_full_hand = {}
    G.GAME.tboj_last_scored_hand = {}
    reset_fruity_plum_card()
  end
end

SMODS.current_mod.set_debuff = function(card)
   if (G.GAME and G.GAME.blind and G.GAME.blind.name == "bl_tboj_siren" and not G.GAME.blind.disabled) and card.config and card.config.center and card.config.center.familiar then return true end
   if (G.GAME and G.GAME.blind and G.GAME.blind.name == "bl_tboj_monstro" and not G.GAME.blind.disabled) and card.tboj_monstro then return true end
   return false
end

function SMODS.current_mod.custom_card_areas(game)
  game.actives = CardArea(
    0, 0.95*G.CARD_H + 0.3,
    2.3*G.CARD_W * 0.7,
    0.95*G.CARD_H,
    {card_limit = 1, type = 'joker', highlight_limit = 1}
  )
  game.actives.config.align_buttons = true
  game.actives.T.x = G.deck.T.x
  game.actives.T.y = G.deck.T.y - G.deck.T.h * 2.25


  game.trinkets = CardArea(
    0, 0.95*G.CARD_H + 0.3,
    2.3*G.CARD_W * 0.7,
    0.95*G.CARD_H,
    {card_limit = 1, type = 'joker', highlight_limit = 1}
  )
  game.trinkets.config.align_buttons = true
  game.trinkets.T.x = G.deck.T.x
  game.trinkets.T.y = G.deck.T.y - G.deck.T.h * 1.125

  game.flies = CardArea(
    0, 0.95*G.CARD_H + 0.3,
    4.9*G.CARD_W * 0.3,
    0.1,
    {card_limit = 0, type = 'joker', highlight_limit = 0, bg_colour = G.C.CLEAR}
  )
  game.flies.config.align_buttons = true
  game.flies.T.x = G.consumeables.T.x - 4.9*G.CARD_W*0.4
  game.flies.T.y = G.consumeables.T.y + G.consumeables.T.h + 0.35


  game.spiders = CardArea(
    0, 0.95*G.CARD_H + 0.3,
    4.9*G.CARD_W * 0.3,
    0.1,
    {card_limit = 0, type = 'joker', highlight_limit = 0, bg_colour = G.C.CLEAR}
  )
  game.spiders.config.align_buttons = true
  game.spiders.T.x = game.flies.T.x + game.flies.T.w + 0.1
  game.spiders.T.y = game.flies.T.y
end