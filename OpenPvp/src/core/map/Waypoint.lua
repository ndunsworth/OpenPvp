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

opvp.Waypoint = opvp.CreateClass();

function opvp.Waypoint:player()
    local pos = opvp.player.mapPosition();

    return opvp.Waypoint(
        opvp.player.mapId(),
        pos.x,
        pos.y
    );
end

function opvp.Waypoint.__eq(self, other)
    if opvp.IsInstance(other, opvp.Waypoint) then
        if self ~= other then
            return (
                other._map == self._map and
                other._pos.x == self._pos.x and
                other._pos.y == self._pos.y and
                other._pos.z == self._pos.z
            );
        else
            return true;
        end
    else
        return false;
    end
end

function opvp.Waypoint:init(mapId, x, y, z)
    self._pos = CreateVector3D(
        opvp.number_else(x),
        opvp.number_else(y),
        opvp.number_else(z)
    );

    self._map = opvp.number_else(mapId);
end

function opvp.Waypoint:isNull()
    return self._map == 0;
end

function opvp.Waypoint:map()
    return self._map;
end

function opvp.Waypoint:position()
    return self._pos:Clone();
end

function opvp.Waypoint:isUserWaypoint()
    return self == opvp.map.userWaypoint();
end

function opvp.Waypoint:setUserWaypoint()
    if self._map ~= 0 then
        opvp.map.setUserWaypoint(self);
    end
end

function opvp.Waypoint:x()
    return self._pos.x;
end

function opvp.Waypoint:y()
    return self._pos.y;
end

function opvp.Waypoint:z()
    return self._pos.y;
end
