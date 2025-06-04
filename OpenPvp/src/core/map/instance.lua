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

opvp.InstanceId = {
    UNKNOWN                    =    0,

    --~ PVP Battlegrounds
    ALTERAC_VALLEY             =   30,
    ARATHI_BASIN               = 2107,
    ARATHI_BASIN_CLASSIC       =  529,
    ARATHI_BASIN_COMP_STOMP    = 2177,
    ARATHI_BASIN_WINTER        = 1681,
    ASHRAN                     = 1191,
    DEEPHAUL_RAVINE            = 2656,
    DEEPWIND_GORGE             = 1105,
    EYE_OF_THE_STORM           =  566,
    EYE_OF_THE_STORM_RATED     =  968,
    ISLE_OF_CONQUEST           =  628,
    KORRAKS_REVENGE            = 2197,
    SEETHING_SHORE             = 1803,
    SILVERSHARD_MINES          =  727,
    SOUTHSHORE_VS_TARREN_MILL  = 1280,
    STRAND_OF_THE_ANCIENTS     =  607,
    TEMPLE_OF_KOTMOGU          =  998,
    THE_BATTLE_FOR_GILNEAS     =  761,
    THE_BATTLE_FOR_WINTERGRASP = 2118;
    TWIN_PEAKS                 =  726,
    WARSONG_GULCH              = 2106,
    WARSONG_GULCH_CLASSIC      =  489,

    --~ PVP Arenas
    ASHAMANES_FALL             = 1552,
    BLACK_ROOK_HOLD_ARENA      = 1504,
    BLADES_EDGE_ARENA          = 1672,
    CAGE_OF_CARNAGE            = 2759,
    DALARAN_SEWERS             =  617,
    EMPYREAN_DOMAIN            = 2373,
    ENIGMA_ARENA               = 2511,
    ENIGMA_CRUCIBLE            = 2547,
    HOOK_POINT                 = 1825,
    MALDRAXXUS_ARENA           = 2509,
    MUGAMBALA_ARENA            = 1911,
    NAGRAND_ARENA              = 1505,
    NOKHUDON_PROVING_GROUNDS   = 2563,
    RUINS_OF_LORDAERON         =  572,
    THE_RING_OF_VALOR          =  618,
    THE_ROBODROME              = 2167,
    TIGERS_PEAK                = 1134,
    TOL_VIRON_ARENA            =  980
};

opvp.instance = {};

function opvp.instance.isFollowerDungeon()
    return C_LFGInfo.IsInLFGFollowerDungeon()
end
