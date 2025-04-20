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

opvp.BoolOption = opvp.CreateClass(opvp.Option);

function opvp.BoolOption:init(key, name, description, value)
    opvp.Option.init(self, key, name, description);

    if opvp.is_bool(value) == true then
        self._value = value;
    else
        self._value = false
    end

    self.changed = opvp.Signal(key);
end

function opvp.BoolOption:createWidget(name, parent)
    local frame = CreateFrame("Frame", name, parent);
    local checkbox = CreateFrame(
        "CheckButton",
        name .. "_CheckButton",
        frame,
        "OptionsSmallCheckButtonTemplate"
    );

    checkbox.text = frame:CreateFontString(nil, "OVERLAY", "OptionsFontHighlight");

    checkbox.text:SetPoint("LEFT", checkbox, "RIGHT", 0);

    checkbox.text:SetText(self:name());

    checkbox.text:SetTextHeight(12);

    checkbox:SetChecked(self._value);

    checkbox:SetPoint("TOPLEFT", frame, 0, 0)
    --~ checkbox:SetPoint("BOTTOMRIGHT", 0, 0)
    --~ checkbox:SetPoint("BOTTOMRIGHT")
    --~ checkbox:SetPoint("BOTTOMLEFT", 0, 0)

    checkbox:SetScript(
        "OnClick",
        function()
            self:setValue(checkbox:GetChecked())
        end
    );

    self.changed:connect(
        checkbox,
        checkbox.SetChecked
    );

    frame:SetWidth(checkbox:GetWidth() + checkbox.text:GetWidth());
    frame:SetHeight(checkbox:GetHeight());

    self:createWidgetTooltip(checkbox)

    frame.checkbox = checkbox;

    self._frame = frame;

    return frame;
end

function opvp.BoolOption:fromScript(data)
    --~ opvp.printMessage(
        --~ "BoolOption(\"%s\"):fromScript(%s)",
        --~ self:key(),
        --~ opvp.to_string(data)
    --~ );

    self:setValue(data);
end

function opvp.BoolOption:setValue(value)
    if opvp.is_bool(value) == false then
        return;
    end

    if self:inCombatLockdown() == true then
        opvp.printWarning(
            opvp.strs.OPTION_CHANGE_IN_COMBAT_ERR,
            self:name()
        );

        return;
    end

    if value ~= self._value then
        self._value = value;

        self.changed:emit(value);
    end
end

function opvp.BoolOption:toScript()
    return self._value;
end

function opvp.BoolOption:type()
    return opvp.BoolOption.TYPE;
end

function opvp.BoolOption:value()
    return self._value;
end

function opvp.BoolOption:_onEnableChanged(state)
    if self._frame ~= nil then
        if state == true then
            self._frame.checkbox:Enable();
        else
            self._frame.checkbox:Disable();
        end
    end
end

local function create_bool_option(...)
    return opvp.BoolOption(...);
end

opvp.BoolOption.TYPE = opvp.OptionType("bool", create_bool_option);
