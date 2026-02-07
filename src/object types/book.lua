TBOJ.book_active_pool = {}
SMODS.ObjectType {
  key = "tboj_book",
  default = "j_tboj_breakfast",
}

G.E_MANAGER:add_event(Event({
  func = function()
    for _, v in ipairs(G.P_CENTER_POOLS["tboj_active"]) do
      if v.book then
        table.insert(TBOJ.book_active_pool, v.key)
      end
    end

    for _, v in ipairs(G.P_CENTER_POOLS["Joker"]) do
      if v.book then
        table.insert(G.P_CENTER_POOLS["tboj_book"], v)
      end
    end
    return true
  end,
}))