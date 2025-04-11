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

opvp.TeammateBattlecrySoundEffect = opvp.CreateClass(opvp.MatchOptionFeature);

function opvp.TeammateBattlecrySoundEffect:init()
    opvp.MatchOptionFeature.init(self, opvp.options.audio.soundeffect.match.teammateMatchBeginBattlecry);

    self._valid_test = opvp.MatchTestType.SIMULATION;
end

function opvp.TeammateBattlecrySoundEffect:isActiveMatchStatus(status)
    return status == opvp.MatchStatus.ROUND_ACTIVE;
end

function opvp.TeammateBattlecrySoundEffect:isFeatureEnabled()
    return self:option():value();
end

function opvp.TeammateBattlecrySoundEffect:_onFeatureActivated()
    local match = opvp.match.current();

    if match == nil or match:joinedInProgress() == true then
        opvp.MatchOptionFeature._onFeatureActivated(self);

        return;
    end

    local team = match:playerTeam();

    if team == nil then
        opvp.MatchOptionFeature._onFeatureActivated(self);

        return;
    end

    local party_size = team:size();

    if party_size > 1 then
        local ids = opvp.List();

        for n=1, party_size do
            ids:append(n);
        end

        ids:shuffle();

        local count = 0;
        local max_count;
        local time_sep;
        local member;
        local id;

        if match:isArena() == true then
            max_count = 2;
            time_sep = 1.15;
        else
            max_count = math.random(3, 4);
            time_sep = 0.85;
        end

        while ids:isEmpty() == false and count < max_count do
            id = ids:popFront();

            member = team:member(id);

            if (
                member ~= nil and
                member:isPlayer() == false and
                member:isSexKnown() == true and
                member:isRaceKnown() == true
            ) then
                local race = member:race();
                local sex  = member:sex();

                opvp.Timer:singleShot(
                    (time_sep * count) + (0.25 * math.random()),
                    function()
                        opvp.effect.roundBegin(race, sex);
                    end
                );

                count = count + 1;
            end
        end
    end

    opvp.MatchOptionFeature._onFeatureActivated(self);
end

function opvp.effect.roundBegin(race, sex)
    local sound = opvp.effect.roundBeginSound(race);

    sound:play(sex, opvp.SoundChannel.SFX, true);
end

local opvp_match_begin_fire_races = opvp.List:createFromArray(
    {
        opvp.DARK_IRON_DWARF,
        opvp.DWARF,
        opvp.MAGHAR_ORC,
        opvp.MECHAGNOME,
        opvp.PANDAREN,
        opvp.TROLL,
        opvp.UNDEAD,
        opvp.VOID_ELF,
        opvp.VULPERA
    }
);

function opvp.effect.roundBeginSound(race, faction)
    local rnd = math.random(0, 4);

    if rnd == 0 then
        return opvp.Emote.CHARGE:sound(race);
    elseif rnd == 1 or rnd == 4 then
        if opvp_match_begin_fire_races:contains(race) == true then
            return opvp.Emote.OPEN_FIRE:sound(race);
        else
            return opvp.Emote.BATTLESHOUT:sound(race);
        end
    elseif rnd == 2 then
        return opvp.Emote.BATTLESHOUT:sound(race);
    else
        return opvp.Emote.ROAR:sound(race);
    end
end

local opvp_round_begin_sound_effect;

local function opvp_round_begin_sound_effect_sample(button, state)
    if state == false then
        local race    = opvp.Race.RACES[math.random(2, opvp.MAX_RACE + 1)];
        local sex     = math.random(1, 2);

        opvp.effect.roundBegin(race:id(), sex);
    end
end

local function opvp_round_begin_sound_effect_ctor()
    opvp_round_begin_sound_effect = opvp.TeammateBattlecrySoundEffect();

    opvp.options.audio.soundeffect.match.teammateMatchBeginBattlecrySample.clicked:connect(
        opvp_round_begin_sound_effect_sample
    );
end

opvp.OnAddonLoad:register(opvp_round_begin_sound_effect_ctor);
