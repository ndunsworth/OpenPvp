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

opvp.private.TeammateEnemyBurstingSoundEffect = opvp.CreateClass(opvp.MatchOptionFeature);

function opvp.private.TeammateEnemyBurstingSoundEffect:init()
    opvp.MatchOptionFeature.init(self, opvp.options.audio.soundeffect.match.teammateAnnounceEnemyBursting);

    self._valid_test = opvp.MatchTestType.SIMULATION;
    self._match_mask = opvp.PvpType.ARENA;
    self._members    = opvp.List();
    self._expiration = 0;
end

function opvp.private.TeammateEnemyBurstingSoundEffect:isActiveMatchStatus(status)
    return status == opvp.MatchStatus.ROUND_ACTIVE;
end

function opvp.private.TeammateEnemyBurstingSoundEffect:isFeatureEnabled()
    return self:option():value();
end

function opvp.private.TeammateEnemyBurstingSoundEffect:_onFeatureActivated()
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

function opvp.private.TeammateEnemyBurstingSoundEffect:_onFeatureDeactivated()
    opvp.MatchOptionFeature._onFeatureDeactivated(self);

    self._members:clear();

    opvp.match.playerOffensiveLevelUpdate:disconnect(self, self._onPlayerOffensiveLevelUpdate);
end

function opvp.private.TeammateEnemyBurstingSoundEffect:_onPlayerOffensiveLevelUpdate(member, newLevel, oldLevel)
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
                    opvp.effect.enemyBursting(race, sex);
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

function opvp.effect.enemyBursting(race, sex)
    local sound = opvp.effect.enemyBurstingSound(race);

    sound:play(sex, opvp.SoundChannel.SFX, true);
end

local opvp_enemy_bursting_index = 3;

function opvp.effect.enemyBurstingSound(race)
    opvp_enemy_bursting_index = (opvp_enemy_bursting_index + 1) % 4;

    if opvp_enemy_bursting_index == 0 or opvp_enemy_bursting_index == 3 then
        return opvp.Emote.INCOMING:sound(race);
    else
        return opvp.Emote.FLEE:sound(race);
    end
end

local opvp_enemy_bursting_sound_effect;

local function opvp_enemy_bursting_sound_effect_sample(button, state)
    if state == false then
        local race    = opvp.Race.RACES[math.random(2, opvp.MAX_RACE + 1)];
        local sex     = math.random(1, 2);

        opvp.effect.enemyBursting(race:id(), sex);
    end
end

local function opvp_enemy_bursting_sound_effect_ctor()
    opvp_enemy_bursting_sound_effect = opvp.private.TeammateEnemyBurstingSoundEffect();

    opvp.options.audio.soundeffect.match.teammateAnnounceEnemyBurstingSample.clicked:connect(
        opvp_enemy_bursting_sound_effect_sample
    );
end

opvp.OnAddonLoad:register(opvp_enemy_bursting_sound_effect_ctor);
