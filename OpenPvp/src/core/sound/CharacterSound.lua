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

opvp.CharacterSound = opvp.CreateClass();

function opvp.CharacterSound:null()
    return opvp_null_sound;
end

function opvp.CharacterSound:init(female, male)
    self._female = female;
    self._male = male;
end

function opvp.CharacterSound:isFemaleNull()
    return self._female:isNull();
end

function opvp.CharacterSound:isMaleNull()
    return self._male:isNull();
end

function opvp.CharacterSound:isNull()
    return (
        self._female:isNull() == true and
        self._male:isNull() == true
    );
end

function opvp.CharacterSound:femaleSound()
    return self._female;
end

function opvp.CharacterSound:maleSound()
    return self._male;
end

function opvp.CharacterSound:play(sex, channel, noDupes)
    if sex == opvp.Sex.FEMALE then
        self:playFemale(channel, noDupes);
    else
        self:playMale(channel, noDupes);
    end
end

function opvp.CharacterSound:playFemale(channel, noDupes)
    self._female:play(channel, noDupes);
end

function opvp.CharacterSound:playMale(channel, noDupes)
    self._male:play(channel, noDupes);
end

function opvp.CharacterSound:sound(sex)
    if sex == opvp.Sex.FEMALE then
        return self._female;
    else
        return self._male;
    end
end

local opvp_null_sound = opvp.CharacterSound(opvp.Sound:null(), opvp.Sound:null());
