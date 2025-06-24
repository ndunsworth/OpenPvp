-- Copyright (c) 2025, Nathan Dunsworth
-- All rights reserved.
--
-- Redistribution and use in source and binary forms, with or without modification,
-- are permitted provided that the following conditions are met:
--
--     * Redistributions of source code must retain the above copyright notice,
--       this list of conditions and the following disclaimer.
--     * Redistributions in binary form must reproduce the above copyright notice,
--       this list of conditions and the following disclaimer in the documentation
--       and/or other materials provided with the distribution.
--     * Neither the name of {{ project }} nor the names of its contributors
--       may be used to endorse or promote products derived from this software
--       without specific prior written permission.
--
-- THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
-- "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
-- LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
-- A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
-- CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
-- EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
-- PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
-- PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
-- LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
-- NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
-- SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

local _, OpenPvp = ...
local opvp = OpenPvp;

local opvp_mask_all_lookup = {
    0x1,
    0x3,
    0x7,
    0xf,
    0x1f,
    0x3f,
    0x7f,
    0xff,
    0x1ff,
    0x3ff,
    0x7ff,
    0xfff,
    0x1fff,
    0x3fff,
    0x7fff,
    0xffff,
    0x1ffff,
    0x3ffff,
    0x7ffff,
    0xfffff,
    0x1fffff,
    0x3fffff,
    0x7fffff,
    0xffffff,
    0x1ffffff,
    0x3ffffff,
    0x7ffffff,
    0xfffffff,
    0x1fffffff,
    0x3fffffff,
    0x7fffffff,
    0xffffffff,
};

opvp.BitMaskOption = opvp.CreateClass(opvp.Option);

function opvp.BitMaskOption:init(key, name, description, size, columns, value)
    opvp.Option.init(self, key, name, description);

    self._size     = max(1, min(size, 32));
    self._columns  = max(1, min(self._size, columns));

    self._mask_all = opvp_mask_all_lookup[self._size];
    self._mask     = opvp.number_else(value, self._mask_all);

    self.changed = opvp.Signal(key);
end

function opvp.BitMaskOption:columns()
    return self._columns;
end

function opvp.BitMaskOption:createWidget(name, parent)
    local frame = CreateFrame("Frame", name, parent);

    frame.checkboxes = {};

    local index  = 1;
    local column = 1;

    local column_frame = CreateFrame("Frame", nil, parent);
    local last_frame;
    local last_column_frame = frame;
    local checkbox;
    local width = 0;
    local height = 0;
    local max_widths = {};
    local total_width = 0;
    local total_height = 0;
    local enabled = self:isEnabled();

    column_frame:SetPoint("TOPLEFT", frame, 0, 0);
    column_frame:SetPoint("TOPRIGHT", frame, 0, 0);

    while index <= self._size do
        local flag = bit.lshift(1, index - 1);

        checkbox = CreateFrame(
            "CheckButton",
            name .. "_CheckButton",
            column_frame,
            "OptionsSmallCheckButtonTemplate"
        );

        if last_frame == nil then
            checkbox:SetPoint("LEFT", column_frame, 0, 0);
        else
            checkbox:SetPoint("LEFT", last_frame, "RIGHT", 0, 0);
        end

        checkbox:SetChecked(bit.band(self._mask, flag) ~= 0);

        checkbox.text = frame:CreateFontString(nil, "OVERLAY", "OptionsFontHighlight");

        checkbox.text:SetJustifyH("LEFT");

        checkbox.text:SetPoint("LEFT", checkbox, "RIGHT", 0);

        checkbox.text:SetText(self:labelForIndex(index));

        checkbox:SetEnabled(enabled);

        checkbox:SetScript(
            "OnClick",
            function(checkbox)
                self:_setBits(flag, checkbox:GetChecked())
            end
        );

        max_widths[column] = max(
            opvp.number_else(max_widths[column]),
            checkbox.text:GetWidth()
        );

        width = width + checkbox:GetWidth() + checkbox.text:GetWidth();
        height = max(height, max(checkbox:GetHeight(), checkbox.text:GetHeight()));

        last_frame = checkbox.text;

        table.insert(frame.checkboxes, checkbox);

        if column == self._columns or index == self._size then
            column_frame:SetHeight(height);

            total_width  = max(total_width, width);
            total_height = total_height + height;

            if index ~= self._size then
                last_column_frame = column_frame;
                column_frame      = CreateFrame("Frame", nil, parent);
                last_frame        = nil;
                width             = 0;

                column_frame:SetPoint("LEFT", frame, 0, 0);
                column_frame:SetPoint("RIGHT", frame, 0, 0);
                column_frame:SetPoint("TOP", last_column_frame, "BOTTOM", 0, 0);
            end

            column = 1;
        else
            column = column + 1;
        end

        index = index + 1;
    end

    index  = 1;
    column = 1;

    while index <= self._size do
        checkbox = frame.checkboxes[index];

        checkbox.text:SetWidth(max_widths[column]);

        if column == self._columns or index == self._size then
            column = 1;
        else
            column = column + 1;
        end

        index = index + 1;
    end

    frame:SetSize(total_width, total_height);

    self._frame = frame;

    return frame;
end

function opvp.BitMaskOption:fromScript(data)
    --~ opvp.printMessage(
        --~ "BitMaskOption(\"%s\"):fromScript(%s)",
        --~ self:key(),
        --~ opvp.to_string(data)
    --~ );

    self:set(data);
end

function opvp.BitMaskOption:index(mask)
    return bit.band(self._mask, mask) ~= 0;
end

function opvp.BitMaskOption:isBitEnabled(mask)
    return bit.band(self._mask, mask) ~= 0;
end

function opvp.BitMaskOption:isBitsEnabled(mask)
    return bit.band(self._mask, mask) == bit;
end

function opvp.BitMaskOption:isBitValid(mask)
    return bit.band(self._mask_all, mask) == mask;
end

function opvp.BitMaskOption:isZero()
    return self._mask == 0;
end

function opvp.BitMaskOption:labelForIndex(index)
    if index > 0 and index <= self._size then
        return "value " .. index
    else
        return "";
    end
end

function opvp.BitMaskOption:mask()
    return self._mask;
end

function opvp.BitMaskOption:maskAll()
    return self._mask_all;
end

function opvp.BitMaskOption:set(mask)
    self._mask = 0;

    self:setBits(mask, true);
end

function opvp.BitMaskOption:setBits(mask, state)
    mask = bit.band(self._mask_all, mask);

    if state == true then
        mask = bit.band(mask, bit.bnot(self._mask));
    else
        mask = bit.band(self._mask, bit.bnot(mask));
    end

    if mask == 0 then
        return;
    end

    if (
        (
            state == true and
            bit.band(self._mask, mask) == mask
        ) or
        (
            state == false and
            bit.band(self._mask, mask) == 0
        )
    ) then
        return;
    end

    self:_setBits(mask, state);

    if self._frame == nil then
        self.changed:emit();

        return;
    end

    while mask ~= 0 do
        index = opvp.math.ffs(mask);

        self._frame.checkboxes[index + 1]:SetChecked(state);

        mask = bit.band(mask, bit.bnot(bit.lshift(1, index)));
    end
end

function opvp.BitMaskOption:_setBits(mask, state)
    if state == true then
        self._mask = bit.bor(self._mask, mask);
    else
        self._mask = bit.band(self._mask, bit.bnot(mask));
    end
end

function opvp.BitMaskOption:size()
    return self._size;
end

function opvp.BitMaskOption:toScript()
    return self._mask;
end

function opvp.BitMaskOption:type()
    return opvp.BitMaskOption.TYPE;
end

function opvp.BitMaskOption:_onEnableChanged(state)
    if self._frame ~= nil then
        for n=1, self._size do
            self._frame.checkboxes[n]:SetEnabled(state);
        end
    end
end

local function create_bitmask_option(...)
    return opvp.BitMaskOption(...);
end

opvp.BitMaskOption.TYPE = opvp.OptionType("bitmask", create_bitmask_option);
