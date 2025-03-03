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

local _, OpenPvpLib = ...
local opvp = OpenPvpLib;

opvp.CombatExitCallbackManager = opvp.CreateClass();

function opvp.CombatExitCallbackManager:init()
    self._signal = opvp.Signal("opvp.OnCombatExit");
    self._combat = false;

    opvp.player.instance().inCombatChanged:connect(self, self._onCombatChanged);
end

function opvp.CombatExitCallbackManager:register(...)
    if self._combat == true then
        self._signal:connect(...);

        return;
    end

    local arg_count = select("#", ...);

    local connection;

    if arg_count == 1 then
        connection = {0, select(1, ...)};

        if opvp.IsInstance(connection[2], opvp.Signal) then
            connection[1] = connection[2];
            connection[2] = connection[2].emit;
        end
    elseif arg_count == 2 then
        connection = {select(1, ...), select(2, ...)};
    end

    if connection[1] == nil or connection[2] == nil or type(connection[2]) ~= "function" then
        return;
    end

    if connection[1] ~= 0 then
        status, err = pcall(connection[2], connection[1]);
    else
        status, err = pcall(connection[2]);
    end

    if status == false then
        opvp.printWarning(
            "opvp.OnCombatExit, %s",
            err
        );
    end
end

function opvp.CombatExitCallbackManager:unregister(...)
    self._signal:disconnect(...);
end

function opvp.CombatExitCallbackManager:_onCombatChanged(state)
    self._combat = state;

    if state == false then
        self._signal:emit();

        self._signal:disconnectAll();
    end
end

local function opvp_combat_exit_cb_mgr_singleton_ctor()
    opvp.OnCombatExit = opvp.CombatExitCallbackManager();
end

opvp.OnLoginReload:register(opvp_combat_exit_cb_mgr_singleton_ctor);
