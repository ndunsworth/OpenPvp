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

local opvp_bg_map_team_size_lookup = {
    [opvp.InstanceId.ALTERAC_VALLEY]            = 40,
    [opvp.InstanceId.ARATHI_BASIN]              = 15,
    [opvp.InstanceId.ARATHI_BASIN_CLASSIC]      = 15,
    [opvp.InstanceId.ARATHI_BASIN_COMP_STOMP]   = 15,
    [opvp.InstanceId.ARATHI_BASIN_WINTER]       = 15,
    [opvp.InstanceId.ASHRAN]                    = 35,
    [opvp.InstanceId.DEEPHAUL_RAVINE]           = 10,
    [opvp.InstanceId.DEEPWIND_GORGE]            = 15,
    [opvp.InstanceId.EYE_OF_THE_STORM]          = 15,
    [opvp.InstanceId.EYE_OF_THE_STORM_RATED]    = 10,
    [opvp.InstanceId.ISLE_OF_CONQUEST]          = 40,
    [opvp.InstanceId.SEETHING_SHORE]            = 10,
    [opvp.InstanceId.SILVERSHARD_MINES]         = 10,
    [opvp.InstanceId.SOUTHSHORE_VS_TARREN_MILL] = 40 ,
    [opvp.InstanceId.STRAND_OF_THE_ANCIENTS]    = 15,
    [opvp.InstanceId.TEMPLE_OF_KOTMOGU]         = 10,
    [opvp.InstanceId.THE_BATTLE_FOR_GILNEAS]    = 10,
    [opvp.InstanceId.TWIN_PEAKS]                = 10,
    [opvp.InstanceId.WARSONG_GULCH]             = 10,
    [opvp.InstanceId.WARSONG_GULCH_CLASSIC]     = 10
};

local opvp_bg_map_mask_lookup = {
    [opvp.InstanceId.ALTERAC_VALLEY]            = bit.bor(opvp.PvpFlag.EPIC, opvp.PvpFlag.NODE, opvp.PvpFlag.RESOURCE),
    [opvp.InstanceId.ARATHI_BASIN]              = bit.bor(opvp.PvpFlag.NODE, opvp.PvpFlag.RESOURCE),
    [opvp.InstanceId.ARATHI_BASIN_CLASSIC]      = bit.bor(opvp.PvpFlag.NODE, opvp.PvpFlag.RESOURCE),
    [opvp.InstanceId.ARATHI_BASIN_COMP_STOMP]   = bit.bor(opvp.PvpFlag.NODE, opvp.PvpFlag.RESOURCE, opvp.PvpFlag.SCENARIO),
    [opvp.InstanceId.ARATHI_BASIN_WINTER]       = bit.bor(opvp.PvpFlag.NODE, opvp.PvpFlag.RESOURCE),
    [opvp.InstanceId.ASHRAN]                    = bit.bor(opvp.PvpFlag.EPIC, opvp.PvpFlag.EPIC, opvp.PvpFlag.RESOURCE, opvp.PvpFlag.ZONE),
    [opvp.InstanceId.DEEPHAUL_RAVINE]           = bit.bor(opvp.PvpFlag.CTF, opvp.PvpFlag.ESCORT, opvp.PvpFlag.RESOURCE),
    [opvp.InstanceId.DEEPWIND_GORGE]            = bit.bor(opvp.PvpFlag.NODE, opvp.PvpFlag.RESOURCE),
    [opvp.InstanceId.EYE_OF_THE_STORM]          = bit.bor(opvp.PvpFlag.CTF, opvp.PvpFlag.NODE, opvp.PvpFlag.RESOURCE),
    [opvp.InstanceId.EYE_OF_THE_STORM_RATED]    = bit.bor(opvp.PvpFlag.CTF, opvp.PvpFlag.NODE, opvp.PvpFlag.RESOURCE),
    [opvp.InstanceId.ISLE_OF_CONQUEST]          = bit.bor(opvp.PvpFlag.EPIC, opvp.PvpFlag.NODE, opvp.PvpFlag.RESOURCE, opvp.PvpFlag.VEHICLE),
    [opvp.InstanceId.SEETHING_SHORE]            = bit.bor(opvp.PvpFlag.RESOURCE),
    [opvp.InstanceId.SILVERSHARD_MINES]         = bit.bor(opvp.PvpFlag.ESCORT, opvp.PvpFlag.RESOURCE),
    [opvp.InstanceId.SOUTHSHORE_VS_TARREN_MILL] = bit.bor(opvp.PvpFlag.BRAWL, opvp.PvpFlag.EPIC, opvp.PvpFlag.RESOURCE, opvp.PvpFlag.SCENARIO),
    [opvp.InstanceId.STRAND_OF_THE_ANCIENTS]    = bit.bor(opvp.PvpFlag.NODE, opvp.PvpFlag.RESOURCE, opvp.PvpFlag.VEHICLE),
    [opvp.InstanceId.TEMPLE_OF_KOTMOGU]         = bit.bor(opvp.PvpFlag.NODE, opvp.PvpFlag.RESOURCE),
    [opvp.InstanceId.THE_BATTLE_FOR_GILNEAS]    = bit.bor(opvp.PvpFlag.NODE, opvp.PvpFlag.RESOURCE),
    [opvp.InstanceId.TWIN_PEAKS]                = opvp.PvpFlag.CTF,
    [opvp.InstanceId.WARSONG_GULCH]             = opvp.PvpFlag.CTF,
    [opvp.InstanceId.WARSONG_GULCH_CLASSIC]     = opvp.PvpFlag.CTF
};

opvp.BattlegroundMatchDescription = opvp.CreateClass(opvp.GenericMatchDescription);

function opvp.BattlegroundMatchDescription:init(map, mask)
    local team_size;

    team_size = opvp_bg_map_team_size_lookup[map:id()];

    if team_size == nil then
        team_size = 15;
    end

    local map_mask = opvp_bg_map_mask_lookup[map:id()];

    if map_mask == nil then
        map_mask = opvp.PvpFlag.RESOURCE;
    end

    opvp.GenericMatchDescription.init(
        self,
        opvp.PvpType.BATTLEGROUND,
        map,
        team_size,
        map_mask
    );
end

function opvp.BattlegroundMatchDescription:createMatch(queue)
    return opvp.BattlegroundMatch(queue, self);
end
