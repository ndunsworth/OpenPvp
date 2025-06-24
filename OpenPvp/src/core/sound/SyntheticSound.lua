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

opvp.SyntheticSound = opvp.CreateClass(opvp.Sound);

function opvp.SyntheticSound:createFromData(data)
    local sounds = {};

    for n=1, #data do
        table.insert(
            sounds,
            opvp.Sound:createFromData(data[n].data, data[n].sound_type)
        );
    end

    return opvp.SyntheticSound(sounds);
end

function opvp.SyntheticSound:init(sounds)
    opvp.Sound.init(self);

    self._sounds = sounds;
    self._index  = 0;
end

function opvp.SyntheticSound:id()
    if self:isNull() == false then
        return self._sounds[self._index]:id();
    else
        return 0;
    end
end

function opvp.SyntheticSound:isNull()
    return #self._sounds == 0;
end

function opvp.SyntheticSound:play(channel, noDupes)
    local sound = self._sounds[self._index + 1];

    if sound ~= nil then
        self._index = (self._index + 1) % #self._sounds;

        return sound:play(channel, noDupes);
    else
        return false, nil;
    end
end

function opvp.SyntheticSound:size()
    return #self._sounds;
end

function opvp.SyntheticSound:type()
    return opvp.SoundType.Synthetic;
end
