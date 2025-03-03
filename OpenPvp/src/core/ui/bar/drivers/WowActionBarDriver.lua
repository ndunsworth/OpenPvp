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

local opvp_wow_actionbar_flag_lookup = {
    [opvp.ActionBarId.BAR_2] = 1,
    [opvp.ActionBarId.BAR_3] = 2,
    [opvp.ActionBarId.BAR_4] = 4,
    [opvp.ActionBarId.BAR_5] = 8,
    [opvp.ActionBarId.BAR_6] = 16,
    [opvp.ActionBarId.BAR_7] = 32,
    [opvp.ActionBarId.BAR_8] = 64
};

opvp.WowActionBarDriver = opvp.CreateClass(opvp.ActionBarDriver);

function opvp.WowActionBarDriver:init(id)
    opvp.ActionBarDriver.init(self, id);

    self._flag = opvp_wow_actionbar_flag_lookup[id];

    if self._flag == nil then
        self._flag = 0;
    end
end

function opvp.WowActionBarDriver:isEnabled()
    return bit.band(C_CVar.GetCVar("enableMultiActionBars"), self._flag) ~= 0;
end

function opvp.WowActionBarDriver:name()
    return "WoW";
end

function opvp.WowActionBarDriver:setEnabled(state)
    if self._flag == 0 then
        return;
    end

    local mask = C_CVar.GetCVar("enableMultiActionBars");

    if state == true then
        mask = bit.bor(mask, self._flag);
    else
        mask = bit.band(mask, bit.bnot(self._flag));
    end

    C_CVar.SetCVar("enableMultiActionBars", mask);

    MultiActionBar_Update();

    EventRegistry:TriggerEvent("ActionBarShownSettingUpdated");
end
