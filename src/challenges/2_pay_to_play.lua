SMODS.Challenge {
  key = "pay_to_play",
  rules = {
    custom = {
      {id = "tboj_empty_shop"},
      {id = "tboj_portable_slot"}
    },
    modifiers = {
      { id = "dollars", value = 250}
    }
  },
  button_colour = G.C.TBOJ.MOD_COLOR,
  apply = function (self)
    G.E_MANAGER:add_event(Event({
      func = function()
        change_shop_size(-2)
        G.GAME.starting_params.vouchers_in_shop = 0
        G.GAME.starting_params.boosters_in_shop = 0
        G.GAME.current_round.voucher.spawn = {}
        SMODS.add_card { key = "active_tboj_portable_slot", area = G.tboj_Actives, set = "tboj_Active" }
        return true
      end
    }))
  end
}