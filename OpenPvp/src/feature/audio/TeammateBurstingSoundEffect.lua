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

opvp.private.TeammateBurstingSoundEffect = opvp.CreateClass(opvp.MatchOptionFeature);

function opvp.private.TeammateBurstingSoundEffect:init()
    opvp.MatchOptionFeature.init(self, opvp.options.audio.soundeffect.match.teammateAnnounceBursting);

    self._valid_test = opvp.MatchTestType.SIMULATION;
    self._match_mask = opvp.PvpType.ARENA;
    self._members    = opvp.List();
    self._expiration = 0;
end

function opvp.private.TeammateBurstingSoundEffect:isActiveMatchStatus(status)
    return status == opvp.MatchStatus.ROUND_ACTIVE;
end

function opvp.private.TeammateBurstingSoundEffect:isFeatureEnabled()
    return self:option():value();
end

function opvp.private.TeammateBurstingSoundEffect:_onFeatureActivated()
    opvp.MatchOptionFeature._onFeatureActivated(self);

    local match = opvp.match.current();

    if match == nil then
        return;
    end

    local team = match:playerTeam();

    if team == nil then
        return;
    end

    if team:size() <= 1 then
        return;
    end

    opvp.match.playerOffensiveLevelUpdate:connect(self, self._onPlayerOffensiveLevelUpdate);

    self._members = opvp.List:createFromArray(team:members());

    self._members:removeItem(team:player());

    self._members:shuffle();

    self._expiration = 0;
end

function opvp.private.TeammateBurstingSoundEffect:_onFeatureDeactivated()
    opvp.MatchOptionFeature._onFeatureDeactivated(self);

    self._members:clear();

    opvp.match.playerOffensiveLevelUpdate:disconnect(self, self._onPlayerOffensiveLevelUpdate);
end

function opvp.private.TeammateBurstingSoundEffect:_onPlayerOffensiveLevelUpdate(member, newLevel, oldLevel)
    if (
        member:isFriendly() == true or
        newLevel ~= opvp.SpellProperty.OFFENSIVE_HIGH or
        GetTime() < self._expiration
    ) then
        return;
    end

    local member;
    local count = 0;
    local time_sep = math.random(1.35, 1.85);

    for n=1, self._members:size() do
        member = self._members:item(n);

        if (
            member:isRaceKnown() == true and
            member:isSexKnown() == true
        ) then
            local race = member:race();
            local sex  = member:sex();

            opvp.Timer:singleShot(
                (time_sep * (count + 1)) + (0.25 * math.random()),
                function()
                    opvp.effect.friendlyBursting(race, sex);
                end
            );

            count = count + 1;

            if count >= 2 then
                return;
            end
        end
    end

    if count ~= 0 then
        self._expiration = GetTime() + 10;
    end
end

function opvp.effect.friendlyBursting(race, sex)
    local sound = opvp.effect.friendlyBurstingSound(race);

    sound:play(sex, opvp.SoundChannel.SFX, true);
end

local opvp_friendly_bursting_index = 0;

local opvp_friendly_bursting_emotes = {
    opvp.Emote.ATTACK_TARGET,
    opvp.Emote.OPEN_FIRE,
    opvp.Emote.CHARGE
}

function opvp.effect.friendlyBurstingSound(race)
    opvp_friendly_bursting_index = (opvp_friendly_bursting_index + 1) % 3;

    local emote = opvp_friendly_bursting_emotes[opvp_friendly_bursting_index + 1];

    return emote:sound(race);
end

local opvp_friendly_bursting_sound_effect;

local function opvp_friendly_bursting_sound_effect_sample(button, state)
    if state == false then
        local race    = opvp.Race.RACES[math.random(2, opvp.MAX_RACE + 1)];
        local sex     = math.random(1, 2);

        opvp.effect.friendlyBursting(race:id(), sex);
    end
end

local function opvp_friendly_bursting_sound_effect_ctor()
    opvp_friendly_bursting_sound_effect = opvp.private.TeammateBurstingSoundEffect();

    opvp.options.audio.soundeffect.match.teammateAnnounceBurstingSample.clicked:connect(
        opvp_friendly_bursting_sound_effect_sample
    );
end

opvp.OnAddonLoad:register(opvp_friendly_bursting_sound_effect_ctor);
