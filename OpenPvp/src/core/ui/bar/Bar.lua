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

opvp.Bar = opvp.CreateClass();

function opvp.Bar:init(driver)
    self._driver = driver;
    self._name = "";
end

function opvp.Bar:driver()
    return self._driver;
end

function opvp.Bar:isDisabled()
    return self._driver:isDisabled();
end

function opvp.Bar:isEnabled()
    return self._driver:isEnabled();
end

function opvp.Bar:name()
    return self._name;
end

function opvp.Bar:_loadSnapshot()
    local opt = self:_snapshotOption();

    if opt == nil then
        return;
    end

    if opt:value() == true then
        self:setEnabled(true);

        opt:setValue(false);
    end
end

function opvp.Bar:setEnabled(state)
    if opvp.player.inCombat() == true then
        return;
    end

    self._driver:setEnabled(state);
end

function opvp.Bar:_setDriver(driver)
    if driver == nil or self._driver == driver then
        return;
    end

    self._driver = driver;
end

function opvp.Bar:setName(name)
    self._name = name;
end

function opvp.Bar:_setSnapshot(state)
    local opt = self:_snapshotOption();

    if opt ~= nil then
        opt:setValue(state);
    end
end

function opvp.Bar:_snapshotKey()
    return "";
end

function opvp.Bar:_snapshotOption()
    local key = self:_snapshotKey();

    if key ~= "" then
        return opvp.private.state.ui.restore.category:findOptionWithKey(key);
    else
        return nil;
    end
end
