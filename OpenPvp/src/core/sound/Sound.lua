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

opvp.SoundType = {
    FileData  = 1,
    SoundKit  = 2,
    Synthetic = 3
};

opvp.Sound = opvp.CreateClass();

function opvp.Sound:createFromData(data, dataType)
    if dataType == nil or dataType == opvp.SoundType.SoundKit then
        return opvp.SoundKitSound:createFromData(data);
    elseif dataType == opvp.SoundType.FileData then
        return opvp.FileDataSound:createFromData(data);
    elseif dataType == opvp.SoundType.Synthetic then
        return opvp.SyntheticSound:createFromData(data);
    else
        return opvp_null_sound;
    end
end

function opvp.Sound:null()
    return opvp_null_sound;
end

function opvp.Sound:init(id, soundType)
end

function opvp.Sound:isNull()
    return true;
end

function opvp.Sound:play(channel, noDupes)

end

function opvp.Sound:type()
    return self._type;
end

opvp_null_sound = opvp.Sound(0);
