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

    -- Digit images (0-9)
    instance.digits = {}
    for i = 0, 9 do
        instance.digits[i] = base_path .. "numbers\\" .. i .. ".png"
    end

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

    instance.adjust_panel = {
        steps   = {100, 10, 1},                    -- left/mid/right step sizes
        x_pos   = {380, 436, 489},                 -- left/mid/right x
        y_inc   = 30,                              -- top row y
        y_dec   = 153,                             -- bottom row y
        width   = 49,
        height  = 28,
        target_address = 0x081A                    -- ← CHANGE THIS to the memory address you want to adjust
                                                   -- (e.g. 0x081C for shot height, or a different one)
    }

    instance.distance_panel = {
        width = 40,
        height = 80,
        x_pos = {386, 439, 491},
        y_pos = 65,
        address = 0x081A
    }

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

function Stats_Overlay:onChevronClick()
    -- Adjustment panel clicks (after bars loop)
    local panel = self.adjust_panel
    local mx = forms.getMouseX(self.pic)
    local my = forms.getMouseY(self.pic)

    for col = 1, 3 do
        local step = panel.steps[col]
        local x    = panel.x_pos[col]

        -- Top button (+)
        local top_y = panel.y_inc
        if mx >= x and mx <= x + panel.width and
           my >= top_y and my <= top_y + panel.height then
            local val = memory.read_s16_le(panel.target_address)

            if val + step <= 500 then
                memory.write_s16_le(panel.target_address, val + step)
            else
                memory.write_s16_le(panel.target_address, 500)
            end
            -- optional: clamp if desired → math.min(127, val + step)
            return
        end

        -- Bottom button (−)
        local bot_y = panel.y_dec
        if mx >= x and mx <= x + panel.width and
           my >= bot_y and my <= bot_y + panel.height then
            local val = memory.read_s16_le(panel.target_address)

            if val - step >= 150 then
                memory.write_s16_le(panel.target_address, val - step)
            else
                memory.write_s16_le(panel.target_address, 150)
            end
            -- optional: clamp → math.max(-128, val - step)
            return
        end
    end
end

function Stats_Overlay:onBarClick()
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

function Stats_Overlay:get_digits(value)
    -- Assuming unsigned 16-bit (0–65535), but clamp to 0–999 for 3 digits
    value = math.max(0, math.min(999, value))
    
    local hundreds = math.floor(value / 100)
    local tens     = math.floor((value % 100) / 10)
    local ones     = value % 10
    
    return hundreds, tens, ones
end

function Stats_Overlay:draw_distance_panel()
    local panel = self.distance_panel
    local value = memory.read_u16_le(panel.address)   -- unsigned 16-bit read
    
    local h, t, o = self:get_digits(value)
    
    -- Draw hundreds (left)
    forms.drawImage(
        self.pic,
        self.digits[h],
        panel.x_pos[1], panel.y_pos,
        panel.width, panel.height
    )
    
    -- Draw tens (middle)
    forms.drawImage(
        self.pic,
        self.digits[t],
        panel.x_pos[2], panel.y_pos,
        panel.width, panel.height
    )
    
    -- Draw ones (right)
    forms.drawImage(
        self.pic,
        self.digits[o],
        panel.x_pos[3], panel.y_pos,
        panel.width, panel.height
    )
end

function Stats_Overlay:set_picture_box(offset, form_handler)
    self.offset = offset
    self.pic = forms.pictureBox(form_handler, 0, offset, self.window.width, self.window.height)

    forms.addclick(self.pic, function() self:onBarClick() end)
    forms.addclick(self.pic, function() self:onChevronClick() end)

    -- Initial background
    forms.drawRectangle(self.pic, 0, 0, self.window.width, self.window.height, nil, "white")
end

function Stats_Overlay:draw_overlay()
    -- Clear background
    forms.drawRectangle(self.pic, 0, 0, self.window.width, self.window.height, nil, "white")

    -- Main overlay image
    forms.drawImage(self.pic, self.images.overlay, 0, 0)

    -- Existing dynamic bars
    for _, b in ipairs(self.bars) do
        local value = memory.read_s8(b.address)
        local img_name = self:get_image_name(value)
        forms.drawImage(self.pic, self.images[img_name], b.x, b.y)
    end

    -- New: Draw the 3-digit distance panel
    self:draw_distance_panel()

    forms.refresh(self.pic)
end

return Stats_Overlay