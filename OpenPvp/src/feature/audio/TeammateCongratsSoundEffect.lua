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

opvp.TeammateCongratsSoundEffect = opvp.CreateClass(opvp.MatchOptionFeature);

function opvp.TeammateCongratsSoundEffect:init()
    opvp.MatchOptionFeature.init(self, opvp.options.audio.soundeffect.match.teammateCelebration);

    self._valid_test = opvp.MatchTestType.SIMULATION;
end

function opvp.TeammateCongratsSoundEffect:isActiveMatchStatus(status)
    return (
        status == opvp.MatchStatus.ROUND_COMPLETE or
        status == opvp.MatchStatus.COMPLETE
    );
end

function opvp.TeammateCongratsSoundEffect:isFeatureEnabled()
    return self:option():value();
end

function opvp.TeammateCongratsSoundEffect:_onFeatureActivated()
    opvp.MatchOptionFeature._onFeatureActivated(self);

    opvp.match.outcomeReady:connect(self, self._onOutcomeReady);
end

function opvp.TeammateCongratsSoundEffect:_onFeatureDeactivated()
    opvp.MatchOptionFeature._onFeatureDeactivated(self);

    opvp.match.outcomeReady:disconnect(self, self._onOutcomeReady);
end

function opvp.TeammateCongratsSoundEffect:_onOutcomeReady(match, outcomeType)
    if (
        match:isWinner() == false or
        (
            outcomeType == opvp.MatchOutcomeType.MATCH and
            match:isRoundBased() == true
        )
    ) then
        return;
    end

    local team = match:playerTeam();

    if team == nil then
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
        local member;
        local id;

        if match:isArena() == true then
            max_count = 2;
        else
            max_count = math.random(3, 4);
        end

        while ids:isEmpty() == false and count < max_count do
            id = ids:popFront();

            member = team:member(id);

            if (
                member ~= nil and
                member:isPlayer() == false and
                member:isRaceKnown() == true and
                member:isSexKnown() == true
            ) then
                local race = member:race();
                local sex  = member:sex();

                opvp.Timer:singleShot(
                    (1.5 * count) + (0.25 * math.random()),
                    function()
                        opvp.effect.teamateCongratulate(race, sex);
                    end
                );

                count = count + 1;
            end
        end
    end
end

function opvp.effect.teamateCongratulate(race, sex)
    local sound = opvp.effect.teamateCongratulateSound(race);

    sound:play(sex, opvp.SoundChannel.SFX, true);
end

local opvp_congrats_round_won_index = 0;
local opvp_congrats_taunt_races = opvp.List:createFromArray(
    {
        opvp.BLOOD_ELF,
        opvp.DARK_IRON_DWARF,
        opvp.DRACTHYR,
        opvp.DRAENEI,
        opvp.DWARF,
        opvp.KUL_TIRAN,
        opvp.MECHAGNOME,
        opvp.ORC,
        opvp.UNDEAD,
        opvp.VULPERA,
        opvp.TROLL,
        opvp.ZANDALARI_TROLL
    }
);

function opvp.effect.teamateCongratulateSound(race)
    opvp_congrats_round_won_index = (opvp_congrats_round_won_index + 1) % 2;

    if opvp_congrats_round_won_index == 0 then
        local rnd = math.random(0, 1);

        if rnd == 0 and opvp_congrats_taunt_races:contains(race) then
            return opvp.Emote.TAUNT:sound(race);
        else
            return opvp.Emote.CONGRATULATE:sound(race);
        end
    else
        local rnd = math.random(0, 2);

        if rnd == 0 then
            return opvp.Emote.VICTORY:sound(race);
        elseif rnd == 1 then
            return opvp.Emote.CHEER:sound(race);
        else
            return opvp.Emote.LAUGH:sound(race);
        end
    end
end

local opvp_congrats_round_won_sound_effect;

local function opvp_congrats_round_won_sound_effect_sample(button, state)
    if state == false then
        opvp.effect.teamateCongratulate(
            math.random(1, opvp.MAX_RACE),
            math.random(1, 2)
        );
    end
end

local function opvp_congrats_round_won_sound_effect_ctor()
    opvp_congrats_round_won_sound_effect = opvp.TeammateCongratsSoundEffect();

    opvp.options.audio.soundeffect.match.teammateCelebrationSample.clicked:connect(
        opvp_congrats_round_won_sound_effect_sample
    );
end

opvp.OnAddonLoad:register(opvp_congrats_round_won_sound_effect_ctor);
