SMODS.Challenge {
  key = "daily_run",
  rules = {
    custom = {
      {id = 'tboj_daily_run'},
      {id = 'tboj_daily_run2'},
    },
  },
  button_colour = G.C.TBOJ.MOD_COLOR,
  apply = function (self)
    G.E_MANAGER:add_event(Event({
      func = function()
        SMODS.add_card { area = G.actives, set = "tboj_active" }
        SMODS.add_card { area = G.jokers, set = "Joker" }
        return true
      end
    }))
  end
}