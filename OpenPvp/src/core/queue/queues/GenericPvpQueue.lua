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

opvp.GenericPvpQueue = opvp.CreateClass(opvp.PvpQueue);

function opvp.GenericPvpQueue:init(id, pvpType, flags, name, description)
    opvp.PvpQueue.init(self, id, pvpType, flags);

    self._name           = name;
    self._desc           = description;
    self._groups_allowed = true;
    self._xfaction       = false;

    self._player_level_min = GetMaxLevelForPlayerExpansion();
    self._player_level_max = GetMaxLevelForPlayerExpansion();
end

function opvp.GenericPvpQueue:description()
    return self._desc;
end

function opvp.GenericPvpQueue:maximumPlayerLevel()
    return self._player_level_max;
end

function opvp.GenericPvpQueue:minimumPlayerLevel()
    return self._player_level_min;
end

function opvp.GenericPvpQueue:name()
    return self._name;
end

function opvp.GenericPvpQueue:updateInfo()

end

opvp.Queue.NO_QUEUE = opvp.GenericPvpQueue(1, opvp.PvpType.NONE, 0, "");
