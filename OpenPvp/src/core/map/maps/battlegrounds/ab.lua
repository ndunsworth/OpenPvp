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
    opvp.Map.ARATHI_BASIN = opvp.Map(
        {
            instance_id  = opvp.InstanceId.ARATHI_BASIN,
            map_id       = 93,
            widgets      = {}
        }
    );

    opvp.Map.ARATHI_BASIN_CLASSIC = opvp.Map(
        {
            instance_id  = opvp.InstanceId.ARATHI_BASIN_CLASSIC,
            map_id       = 1461,
            widgets      = {}
        }
    );

    opvp.Map.ARATHI_BASIN_COMP_STOMP = opvp.Map(
        {
            instance_id  = opvp.InstanceId.ARATHI_BASIN_COMP_STOMP,
            map_id       = 1383,
            widgets      = {}
        }
    );

    opvp.Map.ARATHI_BASIN_WINTER = opvp.Map(
        {
            instance_id  = opvp.InstanceId.ARATHI_BASIN_WINTER,
            map_id       = 837,
            widgets      = {}
        }
    );

    table.insert(opvp.Map.MAPS, opvp.Map.ARATHI_BASIN);
    table.insert(opvp.Map.MAPS, opvp.Map.ARATHI_BASIN_CLASSIC);
    table.insert(opvp.Map.MAPS, opvp.Map.ARATHI_BASIN_COMP_STOMP);
    table.insert(opvp.Map.MAPS, opvp.Map.ARATHI_BASIN_WINTER);
end

opvp.OnAddonLoad:register(init_map);
