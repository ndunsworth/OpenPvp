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

local OPVP_FOCUS_INDICATOR_WIDTH = 10;

opvp.ArenaFocusIndicator = opvp.CreateClass(opvp.UnitFrameFocusIndicator);

function opvp.ArenaFocusIndicator:init(index, parent)
    opvp.UnitFrameFocusIndicator.init(self, "arena" .. index, parent);

    opvp.options.match.general.focusIndicator.changed:connect(
        self,
        self._onOptionChanged
    );
end

function opvp.ArenaFocusIndicator:_onOptionChanged()
    if opvp.match.inMatch() == true or opvp.layout.isEditing() == true then
        self:_setEnabled(
            opvp.options.match.general.focusIndicator:value()
        );
    end
end

function opvp.ArenaFocusIndicator:_onShow()
    self:_setEnabled(
        opvp.options.match.general.focusIndicator:value()
    );
end

local opvp_arena_focus_indicators;

local function opvp_arena_focus_indicator_ctor()
    opvp_arena_focus_indicators = {
        opvp.ArenaFocusIndicator(
            1,
            CompactArenaFrameMember1HealthBar
        ),
        opvp.ArenaFocusIndicator(
            2,
            CompactArenaFrameMember2HealthBar
        ),
        opvp.ArenaFocusIndicator(
            3,
            CompactArenaFrameMember3HealthBar
        )
    };

    hooksecurefunc(
        CompactArenaFrame,
        "UpdateLayout",
        function(frame)
            if opvp.options.match.general.focusIndicator:value() == true then
                CompactArenaFrameMember1.CcRemoverFrame:SetPoint("TOPLEFT", CompactArenaFrameMember1, "TOPRIGHT", OPVP_FOCUS_INDICATOR_WIDTH + 2, -1)
                CompactArenaFrameMember2.CcRemoverFrame:SetPoint("TOPLEFT", CompactArenaFrameMember2, "TOPRIGHT", OPVP_FOCUS_INDICATOR_WIDTH + 2, -1)
                CompactArenaFrameMember3.CcRemoverFrame:SetPoint("TOPLEFT", CompactArenaFrameMember3, "TOPRIGHT", OPVP_FOCUS_INDICATOR_WIDTH + 2, -1)
            end
        end
    );
end

opvp.OnLoginReload:register(opvp_arena_focus_indicator_ctor);
