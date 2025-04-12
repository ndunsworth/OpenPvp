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
    opvp.Map.MALDRAXXUS_ARENA = opvp.Map(
        {
            instance_id  = opvp.InstanceId.MALDRAXXUS_ARENA,
            map_id       = 0,
            stats        = {
                [opvp.PvpStatId.ROUNDS_WON] = 1015
            },
            widgets      = {
                {
                    widget_set  = 1,
                    widget_id   = 3595,
                    widget_type = Enum.UIWidgetVisualizationType.IconAndText,
                    name        = "GoldTeamPlayersRemaining"
                },
                {
                    widget_set  = 1,
                    widget_id   = 3596,
                    widget_type = Enum.UIWidgetVisualizationType.IconAndText,
                    name        = "PurpleTeamPlayersRemaining"
                },
                {
                    widget_set  = 1,
                    widget_id   = 3521,
                    widget_type = Enum.UIWidgetVisualizationType.IconAndText,
                    name        = "Round"
                }
            }
        }
    );

    table.insert(opvp.Map.MAPS, opvp.Map.MALDRAXXUS_ARENA);
end

opvp.OnAddonLoad:register(init_map);
