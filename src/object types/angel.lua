TBOJ.angel_active_pool = {}
SMODS.ObjectType {
  key = "tboj_angel",
  default = "j_tboj_breakfast",
}

G.E_MANAGER:add_event(Event({
  func = function()
    for _, v in ipairs(G.P_CENTER_POOLS["tboj_active"]) do
      if v.angel then
        table.insert(TBOJ.angel_active_pool, v.key)
      end
    end

    for _, v in ipairs(G.P_CENTER_POOLS["Joker"]) do
      if v.angel then
        table.insert(G.P_CENTER_POOLS["tboj_angel"], v)
      end
    end
    return true
  end,
}))