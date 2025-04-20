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

opvp.EnumOption = opvp.CreateClass(opvp.Option);

function opvp.EnumOption:init(key, name, description, values)
    opvp.Option.init(self, key, name, description);

    self._values  = opvp.List:createCopyFromArray(values);

    if self._values:isEmpty() == false then
        self._index = 1;
    else
        self._index = 0;
    end

    self.changed       = opvp.Signal(key);
    self.valuesChanged = opvp.Signal(self._key .. ".valuesChanged");
end

function opvp.EnumOption:createWidget(name, parent)
    local init_values = function(dropdown, level, menuList)
        local info = UIDropDownMenu_CreateInfo();
        local index = dropdown.option:index();

        for n=1, dropdown.option:size() do
            info.text     = dropdown.option:valueForIndex(n);
            info.value    = n;
            info.checked  = n == index;

            info.func = function(button, arg1, arg2, checked, mouseButton)
                UIDropDownMenu_SetSelectedValue(dropdown, button.value, button.value);

                UIDropDownMenu_SetText(dropdown, dropdown.option:valueForIndex(button.value));

                dropdown.option:setIndex(button.value);

                button.checked = true;
            end

            UIDropDownMenu_AddButton(info)
        end
    end

    local init_size = function(dropdown, level, menuList)
        local max_width = 0;

        for n=1, dropdown.option:size() do
            UIDropDownMenu_SetText(dropdown, dropdown.option:valueForIndex(n));

            max_width = max(max_width, dropdown.Text:GetUnboundedStringWidth());
        end

        UIDropDownMenu_SetText(dropdown, dropdown.option:value());

        UIDropDownMenu_SetWidth(
            dropdown,
            (
                max_width +
                dropdown.Button:GetWidth() +
                UIDROPDOWNMENU_DEFAULT_WIDTH_PADDING
            )
        );
    end

    local frame = CreateFrame("Frame", name, parent);
    local label = frame:CreateFontString(name .. "_Label", "OVERLAY", "OptionsFontHighlight");
    local dropdown = CreateFrame("Frame", name .. "_Dropdown", frame, "UIDropDownMenuTemplate");

    frame.label = label;
    frame.dropdown = dropdown;

    dropdown.noResize = 0;

    dropdown.option = self;

    UIDropDownMenu_Initialize(dropdown, init_values);

    UIDropDownMenu_SetSelectedValue(dropdown, self:index(), self:index());

    UIDropDownMenu_SetDropDownEnabled(dropdown, self:isEnabled());

    init_size(dropdown);

    self.changed:connect(
        function()
            UIDropDownMenu_SetSelectedValue(dropdown, self:index(), self:index());

            UIDropDownMenu_SetText(dropdown, self:value());
        end
    );

    self.valuesChanged:connect(
        function()
            UIDropDownMenu_ClearAll(dropdown);

            UIDropDownMenu_Initialize(dropdown, init_values);

            UIDropDownMenu_SetSelectedValue(dropdown, self:index(), self:index());

            init_size(dropdown);
        end
    );

    self:createWidgetTooltip(dropdown);

    label:SetText(self:name());

    label:SetWidth(0);

    label:SetPoint("TOPLEFT", frame);
    label:SetPoint("BOTTOMLEFT", frame);

    --~ dropdown:SetAllPoints();

    dropdown:SetPoint("LEFT", label, "RIGHT");
    dropdown:SetPoint("TOP", frame, "TOP");
    dropdown:SetPoint("BOTTOM", frame, "BOTTOM");

    frame:SetSize(
        (
            label:GetWidth() +
            dropdown:GetWidth() -
            UIDROPDOWNMENU_DEFAULT_WIDTH_PADDING * 0.75
        ),
        max(label:GetHeight(), dropdown:GetHeight())
    );

    self._frame = frame;

    return frame;
end

function opvp.EnumOption:fromScript(data)
    if opvp.is_str(data) == true then
        self:setValue(data);
    end
end

function opvp.EnumOption:index()
    return self._index;
end

function opvp.EnumOption:indexForValue(value)
    return self._values:index(value);
end

function opvp.EnumOption:setIndex(index)
    if opvp.is_number(index) == false then
        return;
    end

    if (
        index > 0 and
        index <= self._values:size() and
        index ~= self._index
    ) then
        self._index = index;

        self.changed:emit();
    end
end

function opvp.EnumOption:setValue(value)
    if opvp.is_str(value) == false then
        return;
    end

    if self:inCombatLockdown() == true then
        opvp.printWarning(
            opvp.strs.OPTION_CHANGE_IN_COMBAT_ERR,
            self:name()
        );

        return;
    end

    local index = self:indexForValue(value);

    if index ~= 0 then
        self:setIndex(index);
    end
end

function opvp.EnumOption:size()
    return self._values:size();
end

function opvp.EnumOption:toScript()
    return self:value();
end

function opvp.EnumOption:type()
    return opvp.EnumOption.TYPE;
end

function opvp.EnumOption:value()
    if self._index > 0 then
        return self._values:item(self._index);
    else
        return "";
    end
end

function opvp.EnumOption:valueForIndex(index)
    return self._values:item(index);
end

function opvp.EnumOption:values()
    return self._values:items();
end

function opvp.EnumOption:_onEnableChanged(state)
    if self._frame ~= nil then
        UIDropDownMenu_SetDropDownEnabled(self._frame.dropdown, state);
    end
end

local function opvp_create_enum_option(...)
    return opvp.EnumOption(...);
end

opvp.EnumOption.TYPE = opvp.OptionType("enum", opvp_create_enum_option);
