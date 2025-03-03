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

local opvp_bg_map_min_lvl_lookup = {
    [opvp.InstanceId.ARATHI_BASIN]               = 10,
    [opvp.InstanceId.ARATHI_BASIN_CLASSIC]       = 10,
    [opvp.InstanceId.ARATHI_BASIN_COMP_STOMP]    = 10,
    [opvp.InstanceId.ARATHI_BASIN_WINTER]        = 10,
    [opvp.InstanceId.WARSONG_GULCH]              = 10,
    [opvp.InstanceId.WARSONG_GULCH_CLASSIC]      = 10,

    [opvp.InstanceId.ALTERAC_VALLEY]             = 20,
    [opvp.InstanceId.ASHRAN]                     = 20,
    [opvp.InstanceId.EYE_OF_THE_STORM]           = 20,
    [opvp.InstanceId.ISLE_OF_CONQUEST]           = 20,
    [opvp.InstanceId.THE_BATTLE_FOR_GILNEAS]     = 20,
    [opvp.InstanceId.THE_BATTLE_FOR_WINTERGRASP] = 20,

    [opvp.InstanceId.SILVERSHARD_MINES]          = 30,
    [opvp.InstanceId.TWIN_PEAKS]                 = 30,

    [opvp.InstanceId.DEEPWIND_GORGE]             = 40,
    [opvp.InstanceId.SEETHING_SHORE]             = 40,
    [opvp.InstanceId.TEMPLE_OF_KOTMOGU]          = 40
};

local opvp_bg_info_null;

opvp.BattlegroundInfo = opvp.CreateClass();

function opvp.BattlegroundInfo:null()
    if opvp_bg_info_null ~= nil then
        return opvp_bg_info_null;
    end

    opvp_bg_info_null = opvp.BattlegroundInfo(0);

    return opvp_bg_info_null;
end

function opvp.BattlegroundInfo:init(index)
    self._index            = index;
    self._name             = "";
    self._desc             = "";
    self._map              = opvp.Map.UNKNOWN;
    self._mask             = 0;
    self._enabled          = false;
    self._player_level_min = GetMaxLevelForPlayerExpansion();

    self:update();
end

function opvp.BattlegroundInfo:canQueue()
    local localizedName,
    canEnter,
    isHoliday,
    isRandom,
    battleGroundID,
    mapDescription,
    bgInstanceID,
    maxPlayers,
    gameType,
    iconTexture,
    shortDescription,
    longDescription,
    hasControllingHoliday = GetBattlegroundInfo(self._index);

    return (canEnter ~= nil and canEnter);
end

function opvp.BattlegroundInfo:description()
    return self._desc;
end

function opvp.BattlegroundInfo:index()
    return self._index;
end

function opvp.BattlegroundInfo:isNull()
    return self._index == 0;
end

function opvp.BattlegroundInfo:mask()
    return self._mask;
end

function opvp.BattlegroundInfo:name()
    return self._name;
end

function opvp.BattlegroundInfo:minimumPlayerLevel()
    return self._player_level_min;
end

function opvp.BattlegroundInfo:map()
    return self._map;
end

function opvp.BattlegroundInfo:update()
    if self._index == 0 then
        return;
    end

    local localizedName,
    canEnter,
    isHoliday,
    isRandom,
    battleGroundID,
    mapDescription,
    bgInstanceID,
    maxPlayers,
    gameType,
    iconTexture,
    shortDescription,
    longDescription,
    hasControllingHoliday = GetBattlegroundInfo(self._index);

    self._name      = localizedName;
    self._desc      = mapDescription;
    self._map       = opvp.Map:createFromInstanceId(bgInstanceID);

    if maxPlayers >= 35 then
        self._mask = opvp.PvpFlag.EPIC;
    else
        self._mask = 0;
    end

    local min_level = opvp_bg_map_min_lvl_lookup[self._map:instanceId()];

    if min_level ~= nil then
        self._player_level_min = min_level;
    else
        self._player_level_min = GetMaxLevelForPlayerExpansion();
    end
end

opvp.BattlegroundQueue = opvp.CreateClass(opvp.PvpQueue);

function opvp.BattlegroundQueue:init(id)
    opvp.PvpQueue.init(self, id, opvp.PvpType.BATTLEGROUND, 0);

    self._info = opvp.BattlegroundInfo:null();
end

function opvp.BattlegroundQueue:canQueue()
    return self._info:canQueue();
end

function opvp.BattlegroundQueue:description()
    return self._info:description();
end

function opvp.BattlegroundQueue:info()
    return self._info;
end

function opvp.BattlegroundQueue:join(info, asGroup)
    if self:isQueued() == false then
        self._setInfo(info);

        JoinBattlefield(info:index(), asGroup);
    end
end

function opvp.BattlegroundQueue:isEnabled()
    return self._info:isEnabled();
end

function opvp.BattlegroundQueue:isNull()
    return self._info:isNull();
end

function opvp.BattlegroundQueue:map()
    return self._info:map();
end

function opvp.BattlegroundQueue:maximumPlayerLevel()
    return GetMaxLevelForPlayerExpansion();
end

function opvp.BattlegroundQueue:minimumPlayerLevel()
    return self._info:minimumPlayerLevel();
end

function opvp.BattlegroundQueue:name()
    return self._info:name();
end

function opvp.BattlegroundQueue:_createMatchDescription(map)
    return opvp.BattlegroundMatchDescription(map);
end

function opvp.BattlegroundQueue:_setInfo(info)
    self._info = info;

    self._mask = self._info:mask();
end

local function opvp_bg_queue_ctor()
    opvp.Queue.BATTLEGROUND_1    = opvp.BattlegroundQueue(100);
    opvp.Queue.BATTLEGROUND_2    = opvp.BattlegroundQueue(101);
    opvp.Queue.BATTLEGROUND_3    = opvp.BattlegroundQueue(102);
    opvp.Queue.BATTLEGROUND_TEST = opvp.BattlegroundQueue(103);
end

opvp.OnAddonLoad:register(opvp_bg_queue_ctor);
