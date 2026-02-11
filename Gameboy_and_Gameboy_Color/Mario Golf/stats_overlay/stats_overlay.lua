local Stats_Overlay = {}
Stats_Overlay.__index = Stats_Overlay

function Stats_Overlay:new()
    local instance = setmetatable({}, { __index = Stats_Overlay })

    instance.window = {
        width  = 714,
        height = 857
    }

    -- Constants
    local bar = {
        width      = 314,
        height     = 101,
        x          = 229,
        y_offsets  = {211, 385, 617, 734},   -- y positions for each stat
        addresses  = {0x081C, 0x081D, 0x081E, 0x081F},
        labels     = {"shot height", "shot trajectory", "shot meet area", "shot control"}
    }

    -- Get script directory
    local source     = debug.getinfo(1, "S").source
    local script_dir = source:match("^@?(.*[/\\])") or ".\\"
    script_dir       = script_dir:gsub("[/\\]$", "")
    local base_path  = script_dir .. "\\"

    -- Load images once
    local images = {
        neutral = base_path .. "bars\\bars_neutral.png",
        overlay = base_path .. "golf_stats_overlay.png",
    }
    for i = 1, 4 do
        images["minus_" .. i] = base_path .. "bars\\bars_minus_"  .. i .. ".png"
        images["plus_"  .. i] = base_path .. "bars\\bars_plus_"   .. i .. ".png"
    end
    instance.images = images

    -- Create bars dynamically
    instance.bars = {}
    for i = 1, 4 do
        local y = bar.y_offsets[i]
        table.insert(instance.bars, {
            x       = bar.x,
            y       = y,
            width   = bar.width,
            height  = bar.height,
            address = bar.addresses[i],
            label   = bar.labels[i],
            image   = images.neutral,
            buttons = {
                minus = { x = bar.x,                  y = y, w = bar.width / 2, h = bar.height },
                plus  = { x = bar.x + (bar.width / 2), y = y, w = bar.width / 2, h = bar.height }
            }
        })
    end

    memory.usememorydomain("WRAM")

    console.writeline("Stats_Overlay has ben instantiated successfully!")
    console.writeline("Don't forget to call Stats_Overlay:set_picture_box(offset, form_handler) to set the display!")
    console.writeline("")

    return instance
end

function Stats_Overlay:get_image_name(value)
    local abs_val = math.abs(value)
    if abs_val > 4 then abs_val = 4 end   -- clamp to available images

    if value < 0 then return "minus_" .. abs_val end
    if value > 0 then return "plus_"  .. abs_val end
    return "neutral"
end

function Stats_Overlay:onClick()
    local mouse_x = forms.getMouseX(self.pic)
    local mouse_y = forms.getMouseY(self.pic)

    if mouse_x < 0 or mouse_y < 0 then return end

    -- console.log(string.format("Click at (%d, %d)", mouse_x, mouse_y))

    for i, b in ipairs(self.bars) do
        local minus = b.buttons.minus
        if mouse_x >= minus.x and mouse_x <= minus.x + minus.w and
           mouse_y >= minus.y and mouse_y <= minus.y + minus.h then
            local val = memory.read_s8(b.address)

            if val > -4 then
                memory.write_s8(b.address, val - 1)
                -- console.log(string.format("%s (-) : %d → %d", b.label, val, val - 1))
            end
            return
        end

        local plus = b.buttons.plus
        if mouse_x >= plus.x and mouse_x <= plus.x + plus.w and
           mouse_y >= plus.y and mouse_y <= plus.y + plus.h then
            local val = memory.read_s8(b.address)

            if val < 4 then
                memory.write_s8(b.address, val + 1)
                -- console.log(string.format("%s (+) : %d → %d", b.label, val, val + 1))
            end
            return
        end
    end

    -- console.log("Click outside button areas")
end

function Stats_Overlay:set_picture_box(offset, form_handler)
    self.offset = offset
    self.pic = forms.pictureBox(form_handler, 0, offset, self.window.width, self.window.height)

    forms.addclick(self.pic, function() self:onClick() end)

    -- Initial background
    forms.drawRectangle(self.pic, 0, 0, self.window.width, self.window.height, nil, "white")
end

function Stats_Overlay:draw_overlay()
    -- Clear background
    forms.drawRectangle(self.pic, 0, 0, self.window.width, self.window.height, nil, "white")

    -- Main overlay
    forms.drawImage(self.pic, self.images.overlay, 0, 0)

    -- Dynamic bars
    for _, b in ipairs(self.bars) do
        local value = memory.read_s8(b.address)
        local img_name = self:get_image_name(value)
        forms.drawImage(self.pic, self.images[img_name], b.x, b.y)
    end

    -- Optional: force refresh (helps some BizHawk versions)
    forms.refresh(self.pic)
end

return Stats_Overlay