local function reset_tboj_card(key, amount, unique_ranks)
  if not key then return end
  if not amount then amount = 1 end
  for i = 1, amount do
    G.GAME.current_round[key..i] = { rank = 'Ace', id = 14, suit = "Spades" }
  end
  local valid_cards = {}
  for _, playing_card in ipairs(G.playing_cards) do
    if not SMODS.has_no_rank(playing_card) then
      valid_cards[#valid_cards + 1] = playing_card
    end
  end
  pseudoshuffle(valid_cards, key .. G.GAME.round_resets.ante)
  local ranks = {}
  for i = 1, amount do
    local rank_diff = 0
    if unique_ranks and valid_cards[i] then
      while valid_cards[i+rank_diff] and TBOJ.table_contains(ranks, valid_cards[i+rank_diff].base.id) do
        rank_diff = rank_diff + 1
      end
      while (rank_diff > 0) and not valid_cards[i+rank_diff] do
        rank_diff = rank_diff - 1
      end
      ranks[#ranks+1] = valid_cards[i+rank_diff].base.id
    end
    print(ranks)
    G.GAME.current_round[key..i].rank = valid_cards[i+rank_diff] and valid_cards[i+rank_diff].base.value or "Ace"
    G.GAME.current_round[key..i].id = valid_cards[i+rank_diff] and valid_cards[i+rank_diff].base.id or 14

    G.GAME.current_round[key..i].suit = valid_cards[i] and valid_cards[i].base.suit or "Spades"
  end
end

local function reset_fruity_plum_suit()
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
    reset_fruity_plum_suit()
    TBOJ.save_last_hand(context)
  end
end

function SMODS.current_mod.reset_game_globals(run_start)
  reset_tboj_card("tboj_death_list_card")
  reset_tboj_card("tboj_marked_card", 3, true)
  reset_tboj_card("tboj_eye_of_the_occult_card")
  if run_start then
    G.GAME.tboj_last_full_hand = {}
    G.GAME.tboj_last_scored_hand = {}
    reset_fruity_plum_suit()
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
    {card_limit = 1, type = 'joker', highlight_limit = 1, align_buttons = true}
  )
  game.actives.config.align_buttons = true
  game.actives.T.x = G.deck.T.x
  game.actives.T.y = G.deck.T.y - G.deck.T.h * 2.25


  game.trinkets = CardArea(
    0, 0.95*G.CARD_H + 0.3,
    2.3*G.CARD_W * 0.7,
    0.95*G.CARD_H,
    {card_limit = 1, type = 'joker', highlight_limit = 1, align_buttons = true}
  )
  game.trinkets.config.align_buttons = true
  game.trinkets.T.x = G.deck.T.x
  game.trinkets.T.y = G.deck.T.y - G.deck.T.h * 1.125

  game.flies = CardArea(
    0, 0.95*G.CARD_H + 0.3,
    4.9*G.CARD_W * 0.3,
    0.1,
    {card_limit = 0, type = 'joker', highlight_limit = 0, bg_colour = G.C.CLEAR, align_buttons = true}
  )
  game.flies.config.align_buttons = true
  game.flies.T.x = G.consumeables.T.x - 4.9*G.CARD_W*0.4
  game.flies.T.y = G.consumeables.T.y + G.consumeables.T.h + 0.35


  game.spiders = CardArea(
    0, 0.95*G.CARD_H + 0.3,
    4.9*G.CARD_W * 0.3,
    0.1,
    {card_limit = 0, type = 'joker', highlight_limit = 0, bg_colour = G.C.CLEAR, align_buttons = true}
  )
  game.spiders.config.align_buttons = true
  game.spiders.T.x = game.flies.T.x + game.flies.T.w + 0.1
  game.spiders.T.y = game.flies.T.y
end