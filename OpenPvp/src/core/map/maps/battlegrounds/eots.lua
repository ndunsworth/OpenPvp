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

local function init_map()
    opvp.PvpMap.EYE_OF_THE_STORM = opvp.PvpMap(
        {
            instance_id  = opvp.InstanceId.EYE_OF_THE_STORM,
            map_id       = 122,
            music_intro  = 129973,
            stats        = {
                [opvp.PvpStatId.FLAG_CAPTURES] = 183
            },
            widgets      = {}
        }
    );

    opvp.PvpMap.EYE_OF_THE_STORM_RATED = opvp.PvpMap(
        {
            instance_id  = opvp.InstanceId.EYE_OF_THE_STORM_RATED,
            map_id       = 397,
            music_intro  = 129973,
            stats        = {
                battleground  = {
                    [opvp.PvpStatId.BASES_ASSAULTED] = 391,
                    [opvp.PvpStatId.FLAG_CAPTURES]   = 393
                }
            },
            widgets      = {}
        }
    );

    table.insert(opvp.PvpMap.BATTLEGROUND_MAPS, opvp.PvpMap.EYE_OF_THE_STORM);
    table.insert(opvp.PvpMap.BATTLEGROUND_MAPS, opvp.PvpMap.EYE_OF_THE_STORM_RATED);

    table.insert(opvp.PvpMap.MAPS, opvp.PvpMap.EYE_OF_THE_STORM);
    table.insert(opvp.PvpMap.MAPS, opvp.PvpMap.EYE_OF_THE_STORM_RATED);
end

opvp.OnAddonLoad:register(init_map);
