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

opvp.private.TeammateDeathSoundEffect = opvp.CreateClass(opvp.MatchOptionFeature);

function opvp.private.TeammateDeathSoundEffect:init()
    opvp.MatchOptionFeature.init(self, opvp.options.audio.soundeffect.match.teammateDeath);

    self._valid_test = opvp.MatchTestType.SIMULATION;
    self._match_mask  = opvp.PvpType.ARENA;

    --~ local op = opvp.CombatLogLogicalOp();

    --~ op:addCondition(opvp.SubEventCombatLogCondition("UNIT_DIED"));

    --~ op:addCondition(
        --~ opvp.TargetFlagsCombatLogCondition(
            --~ opvp.CombatLogLogicalOp.DESTINATION,
            --~ opvp.CombatLogLogicalOp.BIT_AND,
            --~ opvp.CombatLogLogicalOp.CMP_EQUAL,
            --~ bit.bor(COMBATLOG_OBJECT_TYPE_PLAYER, COMBATLOG_OBJECT_REACTION_FRIENDLY, COMBATLOG_OBJECT_AFFILIATION_MINE),
            --~ bit.bor(COMBATLOG_OBJECT_TYPE_PLAYER, COMBATLOG_OBJECT_REACTION_FRIENDLY)
        --~ )
    --~ );

    --~ self._event_filter = opvp.CallbackCombatLogFilter(
        --~ function(filter, info)
            --~ self:_onUnitDeath(info.destName, info.destGUID);
        --~ end,
        --~ op
    --~ );
end

function opvp.private.TeammateDeathSoundEffect:isActiveMatchStatus(status)
    return status == opvp.MatchStatus.ROUND_COMPLETE;

    --~ return (
        --~ status == opvp.MatchStatus.ROUND_ACTIVE or
        --~ status == opvp.MatchStatus.ROUND_COMPLETE or
        --~ status == opvp.MatchStatus.COMPLETE
    --~ );
end

function opvp.private.TeammateDeathSoundEffect:isFeatureEnabled()
    return self:option():value();
end

function opvp.private.TeammateDeathSoundEffect:_onFeatureActivated()
    opvp.MatchOptionFeature._onFeatureActivated(self);

    --~ self._event_filter:disconnect();

    local match = opvp.match.current();

    if match ~= nil and match:isWinner() == false then
        local team = match:playerTeam();

        if team ~= nil then
            local members = team:members();
            local member;

            for n=1, #members do
                member = members[n];

                if (
                    member:isPlayer() == false and
                    member:isDead() == true and
                    opvp.unit.isFeignDeath(member:id()) == false and
                    member:isRaceKnown() == true and
                    member:isSexKnown() == true
                ) then
                    local race = member:race();
                    local sex  = member:sex();

                    opvp.Timer:singleShot(
                        1.5 + (0.5 * math.random()),
                        function()
                            opvp.effect.teammateDeath(race, sex);
                        end
                    );

                    break
                end
            end
        end
    end
end

function opvp.private.TeammateDeathSoundEffect:_onFeatureDeactivated()
    opvp.MatchOptionFeature._onFeatureDeactivated(self);

    --~ self._event_filter:disconnect();
end

function opvp.private.TeammateDeathSoundEffect:_onUnitDeath(unitId, guid)
    if opvp.unit.isFeignDeath(unitId) == true then
        return;
    end

    local member = opvp.party.findMemberByGuid(guid);

    if (
        member == nil or
        member:isRaceKnown() == false or
        member:isSexKnown() == false
     ) then
        return;
    end

    local race = member:race();
    local sex  = member:sex();

    opvp.Timer:singleShot(
        1.5 + (0.5 * math.random()),
        function()
            opvp.effect.teammateDeath(race, sex);
        end
    );
end

function opvp.effect.teammateDeath(race, sex)
    local sound = opvp.effect.teammateDeathSound(race);

    sound:play(sex, opvp.SoundChannel.SFX, true);
end

local opvp_beg_races = opvp.List:createFromArray(
    {
        opvp.DARK_IRON_DWARF,
        opvp.DRACTHYR,
        opvp.HIGHMOUNTAIN_TAUREN,
        opvp.KUL_TIRAN,
        opvp.LIGHTFORGED_DRAENEI,
        opvp.MAGHAR_ORC,
        opvp.MECHAGNOME,
        opvp.NIGHTBORNE,
        opvp.PANDAREN,
        opvp.VOID_ELF,
        opvp.VULPERA,
        opvp.ZANDALARI_TROLL
    }
);

function opvp.effect.teammateDeathSound(race)
    local rnd = math.random(1, 5);

    if rnd == 1 then
        local sound = opvp.Emote.SIGH:sound(race);

        if sound:isNull() == false then
            return sound;
        end

        rnd = 2;
    elseif rnd == 3 then
        local sound = opvp.Emote.DEFEAT:sound(race);

        if sound:isNull() == false then
            return sound;
        end

        rnd = 4;
    elseif rnd == 5 then
        if opvp_beg_races:contains(race) == true then
            return opvp.Emote.BEG:sound(race);
        end

        rnd = 2 * math.random(0, 1);
    end

    if rnd == 2 then
        return opvp.Emote.OOPS:sound(race);
    else
        return opvp.Emote.SORRY:sound(race);
    end
end

local opvp_teammate_death_sound_effect;

local function opvp_teammate_death_sound_effect_sample(button, state)
    if state == false then
        opvp.effect.teammateDeath(
            math.random(1, opvp.MAX_RACE),
            math.random(1, 2)
        );
    end
end

local function opvp_teammate_death_sound_effect_ctor()
    opvp_teammate_death_sound_effect = opvp.private.TeammateDeathSoundEffect();

    opvp.options.audio.soundeffect.match.teammateDeathSample.clicked:connect(
        opvp_teammate_death_sound_effect_sample
    );
end

opvp.OnAddonLoad:register(opvp_teammate_death_sound_effect_ctor);
