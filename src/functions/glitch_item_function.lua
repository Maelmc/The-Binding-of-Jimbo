-- Helper function to get sprite bounds from an atlas
local function get_sprite_from_atlas(atlas, x, y)
    return {
        x = x * atlas.px,
        y = y * atlas.py,
        w = atlas.px,
        h = atlas.py,
        image = atlas.image
    }
end

local function create_custom_sprite_atlas(canvas, atlas_name)
    return {
        image = canvas,
        px = canvas:getWidth(),
        py = canvas:getHeight(),
        name = atlas_name
    }
end

-- Apply merged sprite to a card
function TBOJ.glitch_apply_merged_sprite(card, atlas_key)
    -- Get all available joker centers, excluding no_collection
    local joker_pool = {}
    if G.GAME.tboj_joker_list then
        joker_pool = G.GAME.tboj_joker_list
    else
        for _, joker_center in ipairs(G.P_CENTER_POOLS["Joker"] or {}) do
            if not SMODS.hide_from_collection(joker_center) then
                table.insert(joker_pool, joker_center)
            end
        end
        G.GAME.tboj_joker_list = joker_pool
    end

    -- Pick random number of sprites (10-15)
    local num_sprites = math.random(10, 15)

    -- Clamp to available jokers
    num_sprites = math.min(num_sprites, #joker_pool)

    -- Standard joker sprite dimensions
    local sprite_w = 71
    local sprite_h = 95

    -- Create canvas
    local canvas = love.graphics.newCanvas(sprite_w, sprite_h)

    -- Save graphics state
    local prev_canvas = love.graphics.getCanvas()
    local prev_color = {love.graphics.getColor()}
    local prev_shader = love.graphics.getShader()

    -- Set up graphics state
    love.graphics.setCanvas(canvas)
    love.graphics.setShader()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.clear(0, 0, 0, 0)

    -- Store original filters and set nearest-neighbor for each atlas
    local atlas_filters = {}

    -- Build list of joker sprite sources (atlas + position)
    pseudoshuffle(joker_pool, "tboj_glitch")
    local joker_sprites = {}
    for i = 1, num_sprites do
        local joker = joker_pool[i]

        -- Get atlas (handle vanilla jokers without explicit atlas field)
        -- Vanilla jokers use "Joker" atlas, SMODS jokers use joker.atlas
        local atlas = SMODS.get_atlas(joker.atlas or "Joker")

        if atlas then
            -- Get position
            local pos_x = joker.pos and joker.pos.x or 0
            local pos_y = joker.pos and joker.pos.y or 0

            table.insert(joker_sprites, {
                atlas = atlas,
                pos_x = pos_x,
                pos_y = pos_y
            })

            -- Store original filter for this atlas if not already stored
            if not atlas_filters[atlas] then
                atlas_filters[atlas] = {atlas.image:getFilter()}
            end

            -- Set nearest-neighbor filtering
            atlas.image:setFilter("nearest", "nearest")
        end
    end

    -- Generate random rectangles with varying sizes
    local rectangles = {}
    local used_joker_indices = {}

    -- Calculate target area for each piece (at least 100/num_sprites % of total sprite area)
    local total_area = sprite_w * sprite_h
    local min_area = total_area / num_sprites
    local max_area = min_area * 2  -- Allow up to 2x the minimum for variety

    for rect_idx = 1, num_sprites do
        if #joker_sprites == 0 then break end

        -- Pick random target area
        local target_area = math.random(math.ceil(min_area), math.ceil(max_area))

        -- Pick random width (10% to 40% of sprite width)
        local rect_w = math.random(math.ceil(sprite_w * 0.1), math.ceil(sprite_w * 0.6))

        -- Calculate height to match target area, clamped to valid range
        local rect_h = math.ceil(target_area / rect_w)
        rect_h = math.max(math.ceil(sprite_h * 0.1), rect_h)

        -- Random position within canvas
        local rect_x = math.random(0, math.max(0, sprite_w - rect_w))
        local rect_y = math.random(0, math.max(0, sprite_h - rect_h))

        -- Pick a random unused joker sprite
        local joker_idx = math.random(1, #joker_sprites)
        local joker_sprite = joker_sprites[joker_idx]
        table.remove(joker_sprites, joker_idx)

        -- Get sprite info from joker
        local src_sprite = get_sprite_from_atlas(joker_sprite.atlas, joker_sprite.pos_x, joker_sprite.pos_y)

        -- Pick random rectangular section that fits the cell size
        local max_offset_x = math.max(0, src_sprite.w - rect_w)
        local max_offset_y = math.max(0, src_sprite.h - rect_h)
        local offset_x = math.random(0, max_offset_x)
        local offset_y = math.random(0, max_offset_y)

        -- Store rectangle info for later drawing
        table.insert(rectangles, {
            dst_x = rect_x,
            dst_y = rect_y,
            w = rect_w,
            h = rect_h,
            src_x = src_sprite.x + offset_x,
            src_y = src_sprite.y + offset_y,
            src_image = src_sprite.image,
            area = rect_w * rect_h
        })
    end

    -- Sort rectangles by area (largest first) so smaller ones draw on top
    table.sort(rectangles, function(a, b) return a.area > b.area end)

    -- Draw rectangles in order
    for _, rect in ipairs(rectangles) do
        local quad = love.graphics.newQuad(
            rect.src_x, rect.src_y,
            rect.w, rect.h,
            rect.src_image:getDimensions()
        )
        love.graphics.draw(rect.src_image, quad, rect.dst_x, rect.dst_y)
    end

    -- Restore graphics state
    for atlas, filters in pairs(atlas_filters) do
        atlas.image:setFilter(filters[1], filters[2])
    end
    love.graphics.setCanvas(prev_canvas)
    love.graphics.setShader(prev_shader)
    love.graphics.setColor(prev_color)

    -- Create atlas from canvas
    local custom_atlas = create_custom_sprite_atlas(canvas, "glitch_merged_" .. G.GAME.modifiers.tboj_glitch_count)

    -- Apply to card's center sprite
    card.children.center.atlas = custom_atlas
    card.children.center:set_sprite_pos({x = 0, y = 0})
end
