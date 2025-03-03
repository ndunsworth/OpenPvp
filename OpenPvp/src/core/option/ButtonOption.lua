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

opvp.ButtonOption = opvp.CreateClass(opvp.Option);

function opvp.ButtonOption:init(key, name, description)
    opvp.Option.init(self, key, name, description);

    self:setFlags(opvp.Option.DONT_SAVE_FLAG, true);

    self.clicked = opvp.Signal(key);
end

function opvp.ButtonOption:type()
    return opvp.ButtonOption.TYPE;
end

function opvp.ButtonOption:createWidget(name, parent)
    local button = CreateFrame("Button", name, parent, "UIPanelButtonTemplate");

    button:SetText(self:name());

    button:SetWidth(button:GetTextWidth() + 15);
    button:SetHeight(button:GetTextHeight() + 12);

    button:SetScript(
        "OnClick",
        function(frame, mouseButton, state)
            self.clicked:emit(mouseButton, state);
        end
    );

    button:RegisterForClicks("AnyDown", "AnyUp");

    self:createWidgetTooltip(button);

    button:SetEnabled(self:isEnabled());

    self._frame = button;

    return button;
end

function opvp.ButtonOption:_onEnableChanged(state)
    if self._frame ~= nil then
        self._frame:SetEnabled(state);
    end
end

local function create_button_option(...)
    return opvp.ButtonOption(...);
end

opvp.ButtonOption.TYPE = opvp.OptionType("button", create_button_option);
