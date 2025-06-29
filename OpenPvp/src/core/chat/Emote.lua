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

opvp.EmoteId = {
    UNKNOWN          =  0,
    APPLAUD          =  1,
    ATTACK_TARGET    =  2,
    BATTLESHOUT      =  3,
    BEG              =  4,
    CHARGE           =  5,
    CHEER            =  6,
    CONGRATULATE     =  7,
    FLEE             =  8,
    FOLLOW_ME        =  9,
    FOR_THE_ALLIANCE = 10,
    FOR_THE_HORDE    = 11,
    FOR_THE_FACTION  = 12,
    GOODBYE          = 13,
    HELLO            = 14,
    HELP             = 15,
    INCOMING         = 16,
    INVENTORY_FULL   = 17,
    LAUGH            = 18,
    OOPS             = 19,
    OPEN_FIRE        = 20,
    RACIAL           = 21,
    RASP             = 22,
    ROAR             = 23,
    SIGH             = 24,
    SORRY            = 25,
    TAUNT            = 26,
    THREATEN         = 27,
    VICTORY          = 28,
    WHOA             = 29
};

opvp.Emote = opvp.CreateClass();

opvp.Emote.EMOTES = {};

function opvp.Emote:createFromId(id)
    local emote = opvp.Emote.EMOTES[id + 1];

    if emote ~= nil then
        return emote;
    else
        return opvp.Emote.UNKNOWN;
    end
end

function opvp.Emote:init(cfg)
    self._id     = cfg.id;
    self._name   = cfg.name;
    self._sounds = opvp.List();

    local sound_null      = opvp.Sound:null();
    local char_sound_null = opvp.CharacterSound:null();
    local sound;
    local sound_info;

    if cfg.sounds ~= nil then
        for n=1, #cfg.sounds do
            sound_info = cfg.sounds[n];

            self._sounds:append(
                opvp.CharacterSound(
                    opvp.Sound:createFromData(
                        sound_info.female_id,
                        sound_info.female_id_type
                    ),
                    opvp.Sound:createFromData(
                        sound_info.male_id,
                        sound_info.male_id_type
                    )
                )
            );
        end
    end
end

function opvp.Emote:emote(unitId)
    DoEmote(self._id, unitId);
end

function opvp.Emote:hasSound()
    return self._sounds:isEmpty() == false;
end

function opvp.Emote:id()
    return self._id;
end

function opvp.Emote:name()
    return self._name;
end

function opvp.Emote:playSound(race, sex, channel, noDupes)
    local sound = self:sound(race);

    if sound ~= nil then
        if sex == nil then
            sex = opvp.player.sex()
        end

        sound:play(sex, channel, noDupes)
    end
end

function opvp.Emote:sound(race)
    if race == nil then
        race = opvp.player.race();
    end

    local sound = self._sounds:item(race);

    if sound ~= nil then
        return sound;
    else
        return opvp.Sound:null();
    end
end
