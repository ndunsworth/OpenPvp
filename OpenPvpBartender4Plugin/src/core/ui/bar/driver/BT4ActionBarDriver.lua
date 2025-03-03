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

local _, OpenPvpPlugin = ...
local opvpplugin = OpenPvpPlugin;

local opvp = _G.OpenPvp;

local BT4ActionBars = Bartender4:GetModule("ActionBars");

opvpplugin.BT4ActionBarDriver = opvp.CreateClass(opvp.ActionBarDriver);

function opvpplugin.BT4ActionBarDriver:init(id)
    opvp.ActionBarDriver.init(self, id);
end

function opvpplugin.BT4ActionBarDriver:isEnabled()
    local bar = BT4ActionBars.actionbars[self._id];

    return (
        bar ~= nil and
        bar.config.enabled
    );
end

function opvpplugin.BT4ActionBarDriver:name()
    return "Bartender4";
end

function opvpplugin.BT4ActionBarDriver:setEnabled(state)
    if opvp.system.isLogout() == false then
        if state == true then
            BT4ActionBars:EnableBar(self._id);
        else
            BT4ActionBars:DisableBar(self._id);
        end
    else
        BT4ActionBars.db.profile.actionbars[self._id].enabled = state;
    end
end

local function opvp_bt4_actionbars_init()
    local actionbar_ids = {
        opvp.ActionBarId.BAR_1,
        opvp.ActionBarId.BAR_2,
        opvp.ActionBarId.BAR_3,
        opvp.ActionBarId.BAR_4,
        opvp.ActionBarId.BAR_5,
        opvp.ActionBarId.BAR_6,
        opvp.ActionBarId.BAR_7,
        opvp.ActionBarId.BAR_8
    };

    local actionbar;
    local id;

    for n=1, #actionbar_ids do
        id = actionbar_ids[n];

        actionbar = opvp.actionbar.bar(id);

        if actionbar ~= nil then
            actionbar:_setDriver(
                opvpplugin.BT4ActionBarDriver(id)
            );
        end
    end
end

opvpplugin.OnAddonLoad:register(opvp_bt4_actionbars_init);
