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

opvp.private.TeammateGreetingsSoundEffect = opvp.CreateClass(opvp.MatchOptionFeature);

function opvp.private.TeammateGreetingsSoundEffect:init()
    opvp.MatchOptionFeature.init(self, opvp.options.audio.soundeffect.match.teammateGreetings);

    self._valid_test = opvp.MatchTestType.NONE;
    self._match_mask = opvp.PvpType.ARENA;
    self._players    = opvp.List();
    self._last_greet = 0;
end

function opvp.private.TeammateGreetingsSoundEffect:greetPlayer(guid, race, sex)
    if self:hasGreetedPlayer(guid) == true then
        return false;
    end

    self._players:append(guid);

    local prev_greet = self._last_greet;

    self._last_greet = GetTime();

    local greet_diff = self._last_greet - prev_greet;
    local great_offset;

    if greet_diff < 5 then
        greet_offset = (5 - greet_diff) + 1.5 + (0.75 * math.random());
    else
        greet_offset = 5 + (0.5 * math.random());
    end

    opvp.Timer:singleShot(
        greet_offset,
        function()
            opvp.effect.teammateGreetings(race, sex);
        end
    );

    return true;
end

function opvp.private.TeammateGreetingsSoundEffect:hasGreetedPlayer(guid)
    return self._players:contains(guid);
end

function opvp.private.TeammateGreetingsSoundEffect:isFeatureEnabled()
    return self:option():value();
end

function opvp.private.TeammateGreetingsSoundEffect:_greetMember(member)
    if (
        member:isPlayer() == false and
        member:isGuidKnown() == true and
        member:isRaceKnown() == true and
        member:isSexKnown() == true
    ) then
        self:greetPlayer(member:guid(), member:race(), member:sex());
    end
end

function opvp.private.TeammateGreetingsSoundEffect:_onFeatureActivated()
    opvp.match.playerInfoUpdate:connect(self, self._onPlayerInfoUpdated);
    opvp.match.rosterEndUpdate:connect(self, self._onPlayerRosterUpdated);

    local match = opvp.match.current();

    if match ~= nil then
        local team = match:playerTeam();

        if team ~= nil then
            local member;

            for n=1, team:size() do
                member = team:member(n);

                if member ~= nil then
                    self:_greetMember(member);
                end
            end
        end
    end

    opvp.MatchOptionFeature._onFeatureActivated(self)
end

function opvp.private.TeammateGreetingsSoundEffect:_onFeatureDeactivated()
    self._players:clear();
    self._last_greet = 0;

    opvp.match.playerInfoUpdate:disconnect(self, self._onPlayerInfoUpdated);
    opvp.match.rosterEndUpdate:disconnect(self, self._onPlayerRosterUpdated);

    opvp.MatchOptionFeature._onFeatureDeactivated(self)
end

function opvp.private.TeammateGreetingsSoundEffect:_onPlayerInfoUpdated(member, mask)
    if (
        member:isHostile() == false and
        bit.band(mask, opvp.PartyMember.CHARACTER_RACE_SEX_MASK) ~= 0
    ) then
        self:_greetMember(member);
    end
end

function opvp.private.TeammateGreetingsSoundEffect:_onPlayerRosterUpdated(team, newMembers, updatedMembers, removedMembers)
    if team:isHostile() == true then
        return;
    end

    for n=1, #newMembers do
        self:_greetMember(newMembers[n]);
    end

    for n=1, #updatedMembers do
        self:_greetMember(updatedMembers[n][1]);
    end
end

function opvp.effect.teammateGreetings(race, sex)
    local sound = opvp.effect.teammateGreetingsSound(race);

    sound:play(sex, opvp.SoundChannel.SFX, false);
end

function opvp.effect.teammateGreetingsSound(race)
    return opvp.Emote.HELLO:sound(race);
end

local opvp_teammate_greetings_sound_effect;

local function opvp_teammate_greetings_sound_effect_sample(button, state)
    if state == false then
        opvp.effect.teammateGreetings(
            math.random(1, opvp.MAX_RACE),
            math.random(1, 2)
        );
    end
end

local function opvp_teammate_greetings_sound_effect_ctor()
    opvp_teammate_greetings_sound_effect = opvp.private.TeammateGreetingsSoundEffect();

    opvp.options.audio.soundeffect.match.teammateGreetingsSample.clicked:connect(
        opvp_teammate_greetings_sound_effect_sample
    );
end

opvp.OnAddonLoad:register(opvp_teammate_greetings_sound_effect_ctor);
