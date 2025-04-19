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

opvp.FactionSound = opvp.CreateClass();

function opvp.FactionSound:createFromData(data)
    local alliance, horde, neutral;

    if data.alliance ~= nil then
        alliance = opvp.Sound:createFromData(
            data.alliance.data,
            data.alliance.sound_type
        );
    end

    if data.horde ~= nil then
        horde = opvp.Sound:createFromData(
            data.horde.data,
            data.horde.sound_type
        );
    end

    if data.neutral ~= nil then
        horde = opvp.Sound:createFromData(
            data.neutral.data,
            data.neutral.sound_type
        );
    end

    return opvp.FactionSound(alliance, horde, neutral);
end

function opvp.FactionSound:init(alliance, horde, neutral)
    if alliance == nil then
        alliance = opvp.Sound:null();
    end

    if horde == nil then
        horde = opvp.Sound:null();
    end

    if neutral == nil then
        neutral = opvp.Sound:null();
    end

    assert(
        opvp.IsInstance(alliance, opvp.Sound) and
        opvp.IsInstance(horde, opvp.Sound) and
        opvp.IsInstance(neutral, opvp.Sound)
    );

    self._sounds = {
        neutral,
        alliance,
        horde
    };
end

function opvp.FactionSound:playAlliance(channel, noDupes)
    return self:play(opvp.ALLIANCE, channel, noDupes);
end

function opvp.FactionSound:playHorde(channel, noDupes)
    return self:play(opvp.HORDE, channel, noDupes);
end

function opvp.FactionSound:playNeutral(channel, noDupes)
    return self:play(opvp.NEUTRAL, channel, noDupes);
end

function opvp.FactionSound:isNull(faction)
    return self:sound(faction):isNull();
end

function opvp.FactionSound:play(faction, channel, noDupes)
    return self:sound(faction):play(channel, noDupes);
end

function opvp.FactionSound:sound(faction)
    if faction == nil then
        faction = opvp.player.faction();
    end

    local sound = self._sounds[faction + 1];

    if sound ~= nil then
        return sound;
    else
        return opvp.Sound:null();
    end
end

function opvp.FactionSound:type()
    return opvp.SoundType.Faction;
end
