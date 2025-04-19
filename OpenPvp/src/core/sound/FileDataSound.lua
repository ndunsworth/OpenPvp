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

local opvp_null_sound;

opvp.FileDataSound = opvp.CreateClass(opvp.Sound);

function opvp.FileDataSound:createFromData(data)
    if data ~= 0 then
        return opvp.FileDataSound(data);
    else
        return opvp_null_sound;
    end
end

function opvp.FileDataSound:null()
    return opvp_null_sound;
end

function opvp.FileDataSound:init(id)
    opvp.Sound.init(self);

    assert(opvp.is_number(id) or opvp.is_str(id));

    if id == "" then
        id = 0;
    end

    self._id = id;
end

function opvp.FileDataSound:id()
    return self._id;
end

function opvp.FileDataSound:isNull()
    return self._id == 0;
end

function opvp.FileDataSound:play(channel, noDupes)
    if self._id == 0 then
        return false, nil;
    end

    if channel == nil then
        channel = opvp.SoundChannel.SFX;
    end

    return PlaySoundFile(self._id, channel);
end

function opvp.FileDataSound:type()
    return opvp.SoundType.FileData;
end

opvp_null_sound = opvp.FileDataSound(0);
