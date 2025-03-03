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

opvp.StringOption = opvp.CreateClass(opvp.Option);

function opvp.StringOption:init(key, name, description, value)
    opvp.Option.init(self, key, name, description);

    if opvp.is_str(value) == true then
        self._value = value;
    else
        self._value = "";
    end

    self.changed = opvp.Signal(key);
end

function opvp.StringOption:createWidget(name, parent)
    local editbox = CreateFrame(
        "EditBox",
        name,
        parent,
        "InputBoxTemplate"
    );

    editbox:SetScript(
        "OnTextChanged",
        function(...)
            self:setValue(editbox:GetText())
        end
    );

    editbox:SetScript(
        "OnTextSet",
        function()
            self:setValue(editbox:GetText())
        end
    );

    editbox:SetPoint("LEFT", parent);
    editbox:SetPoint("RIGHT", parent)

    editbox:SetFontObject(ChatFontNormal);

    editbox:SetAutoFocus(false);
    editbox:SetHeight(40);
    editbox:SetTextInsets(0, 0, 3, 3)
    editbox:SetMaxLetters(128);
    editbox:SetText(self._value);

    editbox:SetEnabled(self:isEnabled());

    editbox:SetCursorPosition(0);

    self._frame = editbox;

    return editbox;
end

function opvp.StringOption:fromScript(data)
    self:setValue(data);
end

function opvp.StringOption:setValue(value)
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

    if value ~= self._value then
        self._value = value;

        self.changed:emit();
    end
end

function opvp.StringOption:toScript()
    return self._value;
end

function opvp.StringOption:type()
    return opvp.StringOption.TYPE;
end

function opvp.StringOption:value()
    return self._value;
end

function opvp.StringOption:_onEnableChanged(state)
    if self._frame ~= nil then
        self._frame:SetEnabled(state);
    end
end

local function create_string_option(...)
    return opvp.StringOption(...);
end

opvp.StringOption.TYPE = opvp.OptionType("float", create_string_option);
