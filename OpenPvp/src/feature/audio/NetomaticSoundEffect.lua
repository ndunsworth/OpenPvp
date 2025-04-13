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

opvp.private.NetomaticSoundEffect = opvp.CreateClass(opvp.OptionFeature);

function opvp.private.NetomaticSoundEffect:init(option)
    opvp.OptionFeature.init(self, option);

    local event_op = opvp.CombatLogLogicalOp(opvp.CombatLogLogicalOp.OR);

    event_op:addCondition(opvp.SubEventCombatLogCondition(opvp.combatlog.SPELL_CAST_START));
    event_op:addCondition(opvp.SubEventCombatLogCondition(opvp.combatlog.SPELL_CAST_SUCCESS));

    local op = opvp.CombatLogLogicalOp();

    op:addCondition(event_op);

    op:addCondition(
        opvp.TargetFlagsCombatLogCondition(
            opvp.CombatLogLogicalOp.SOURCE,
            opvp.CombatLogLogicalOp.BIT_AND,
            opvp.CombatLogLogicalOp.CMP_EQUAL,
            bit.bor(COMBATLOG_OBJECT_TYPE_PLAYER, COMBATLOG_OBJECT_REACTION_HOSTILE),
            bit.bor(COMBATLOG_OBJECT_TYPE_PLAYER, COMBATLOG_OBJECT_REACTION_HOSTILE)
        )
    );

    op:addCondition(opvp.SpellIdCombatLogCondition({279490, 13120}));

    self._event_filter = opvp.CallbackCombatLogFilter(
        function(filter, info)
            self:_onCastEvent(info);
        end,
        op
    );
end

function opvp.private.NetomaticSoundEffect:canActivate()
    return (
        opvp.player.inSanctuary() == false and
        opvp.match.inMatch() == false
    );
end

function opvp.private.NetomaticSoundEffect:isFeatureEnabled()
    return self:option():value();
end

function opvp.private.NetomaticSoundEffect:_onCastEvent(info)
    if info.subevent == "SPELL_CAST_START" then
        local extraSpellId, extraSpellName, extraSchool, auraType = select(12, CombatLogGetCurrentEventInfo());

        local unit = opvp.Unit:createFromUnitGuid(info.sourceGUID);

        if unit:isNull() == false then
            opvp.printWarning(
                "%s - %s (%s %s)",
                extraSpellName,
                info.sourceName,
                unit:raceInfo():name(),
                unit:classInfo():name()
            );
        else
            opvp.printWarning(
                "%s - %s",
                extraSpellName,
                info.sourceName
            );
        end

        opvp.effect.netomaticWarning(
            opvp.player.race(),
            opvp.player.sex()
        );
    else
        opvp.effect.netomaticIncoming(
            opvp.player.race(),
            opvp.player.sex()
        );
    end
end

function opvp.private.NetomaticSoundEffect:_onFeatureEnabled()
    local player = opvp.player.instance();

    player.inSanctuaryChanged:connect(self, self._onSanctuaryChanged);

    opvp.match.exit:connect(self, self._onMatchExit);
    opvp.match.entered:connect(self, self._onMatchEntered);

    opvp.OptionFeature._onFeatureEnabled(self)
end

function opvp.private.NetomaticSoundEffect:_onFeatureActivated()
    self._event_filter:connect();

    opvp.OptionFeature._onFeatureActivated(self)
end

function opvp.private.NetomaticSoundEffect:_onFeatureDeactivated()
    self._event_filter:disconnect();

    opvp.OptionFeature._onFeatureDeactivated(self)
end

function opvp.private.NetomaticSoundEffect:_onFeatureDisabled()
    local player = opvp.player.instance();

    player.inSanctuaryChanged:disconnect(self, self._onSanctuaryChanged);

    opvp.match.exit:disconnect(self, self._onMatchExit);
    opvp.match.entered:disconnect(self, self._onMatchEntered);

    opvp.OptionFeature._onFeatureDisabled(self)
end

function opvp.private.NetomaticSoundEffect:_onLoadingScreenEnd()
    if self:isFeatureEnabled() == true and self:canActivate() == true then
        self:_setActive(true);
    end
end

function opvp.private.NetomaticSoundEffect:_onMatchEntered()
    self:_setActive(false);
end

function opvp.private.NetomaticSoundEffect:_onMatchExit()
    opvp.OnLoadingScreenEnd:connect(self, self._onLoadingScreenEnd)
end

function opvp.private.NetomaticSoundEffect:_onSanctuaryChanged(state)
    if state == true then
        self:_setActive(false);
    elseif self:canActivate() == true then
        self:_setActive(true);
    end
end

function opvp.effect.netomaticIncoming(race, sex)
    local sound = opvp.effect.netomaticIncomingSound(race);

    sound:play(sex, opvp.SoundChannel.SFX, true);
end

function opvp.effect.netomaticIncomingSound(race)
    return opvp.Emote.FLEE:sound(race);
end

function opvp.effect.netomaticWarning(race, sex)
    local sound = opvp.effect.netomaticWarningSound(race);

    sound:play(sex, opvp.SoundChannel.SFX, true);
end

function opvp.effect.netomaticWarningSound(race)
    return opvp.Emote.INCOMING:sound(race);
end

local opvp_netomatic_emote_sound_effect;
local opvp_netomatic_emote_sound_effect_sample_index = 0

local function opvp_netomatic_emote_sound_sample(button, state)
    if state == false then
        if opvp_netomatic_emote_sound_effect_sample_index == 0 then
            opvp.effect.netomaticWarning(
                opvp.player.race(),
                opvp.player.sex()
            );
        else
            opvp.effect.netomaticIncoming(
                opvp.player.race(),
                opvp.player.sex()
            );
        end

        opvp_netomatic_emote_sound_effect_sample_index = (opvp_netomatic_emote_sound_effect_sample_index + 1) % 2;
    end
end

local function opvp_netomatic_emote_sound_effect_ctor()
    opvp_netomatic_emote_sound_effect = opvp.private.NetomaticSoundEffect(
        opvp.options.audio.soundeffect.pvp.netomaticEmotes
    );

    opvp.options.audio.soundeffect.pvp.netomaticEmotesSample.clicked:connect(
        opvp_netomatic_emote_sound_sample
    );
end

opvp.OnAddonLoad:register(opvp_netomatic_emote_sound_effect_ctor);
