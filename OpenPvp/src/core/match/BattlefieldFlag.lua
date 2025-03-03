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

opvp.BattlefieldFlag = opvp.CreateClass();

function opvp.BattlefieldFlag:init(map_id, id, faction)
    self._map_id  = map;
    self._id      = id;
    self._faction = faction;
    self._index   = 0;
    self._carrier = "";
end

function opvp.BattlefieldFlag:carrier()
    return self._carrier;
end

function opvp.BattlefieldFlag:faction()
    return self._faction;
end

function opvp.BattlefieldFlag:id()
    return self._id;
end

function opvp.BattlefieldFlag:index()
    return self._index;
end

function opvp.BattlefieldFlag:map()
    return self._map_id;
end

function opvp.BattlefieldFlag:position()
    if self._index ~= 0 then
        local x, y, tex = C_PvP.GetBattlefieldFlagPosition(
            self._index,
            self._map_id
        );

        return CreateVector2D(x, y);
    else
        return CreateVector2D(0, 0);
    end
end

function opvp.BattlefieldFlag:texture()
    if self._index ~= 0 then
        local _, _, tex = C_PvP.GetBattlefieldFlagPosition(
            self._index,
            self._map_id
        );

        return tex;
    else
        return "";
    end
end

function opvp.BattlefieldFlag:_setCarrier(carrier)
    self._carrier = carrier;
end

function opvp.BattlefieldFlag:_setIndex(index)
    self._index = index;
end
