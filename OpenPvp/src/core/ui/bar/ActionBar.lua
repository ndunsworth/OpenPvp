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

opvp.ActionBarId = {
    BAR_1            = 1,
    BAR_2            = 6,
    BAR_3            = 5,
    BAR_4            = 3,
    BAR_5            = 4,
    BAR_6            = 13,
    BAR_7            = 14,
    BAR_8            = 15,
    BONUS_ACTION_BAR = 2,
    CLASS_BAR_1      = 7,
    CLASS_BAR_2      = 8,
    CLASS_BAR_3      = 9,
    CLASS_BAR_4      = 10
};

local opvp_snapshot_names = {
    [opvp.ActionBarId.BAR_1]            = "ActionBar1",
    [opvp.ActionBarId.BAR_2]            = "ActionBar2",
    [opvp.ActionBarId.BAR_3]            = "ActionBar3",
    [opvp.ActionBarId.BAR_4]            = "ActionBar4",
    [opvp.ActionBarId.BAR_5]            = "ActionBar5",
    [opvp.ActionBarId.BAR_6]            = "ActionBar6",
    [opvp.ActionBarId.BAR_7]            = "ActionBar7",
    [opvp.ActionBarId.BAR_8]            = "ActionBar8"
};

opvp.ActionBar = opvp.CreateClass(opvp.Bar);

function opvp.ActionBar:init(id, name)
    opvp.Bar.init(self, opvp.WowActionBarDriver(id), name);

    self._id = id;
end

function opvp.ActionBar:id()
    return self._id;
end

function opvp.ActionBar:_setDriver(driver)
    if (
        driver ~= nil and (
            opvp.IsInstance(driver, opvp.ActionBarDriver) == false or
            driver:id() ~= self._id
        )
    ) then
        return;
    end

    if driver == nil then
        driver = opvp.WowActionBarDriver(self._id);
    end

    self._driver = driver;
end

function opvp.ActionBar:_snapshotKey()
    local key = opvp_snapshot_names[self._id];

    if key ~= nil then
        return key;
    else
        return "";
    end
end
