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

opvp.private.DampeningHighSoundEffect = opvp.CreateClass(opvp.MatchOptionFeature);

function opvp.private.DampeningHighSoundEffect:init(option)
    opvp.MatchOptionFeature.init(self, option);

    self._dampening_warn = 40;
end

function opvp.private.DampeningHighSoundEffect:isActiveMatchStatus(status)
    return status == opvp.MatchStatus.ROUND_ACTIVE;
end

function opvp.private.DampeningHighSoundEffect:isFeatureEnabled()
    return self:option():value();
end

function opvp.private.DampeningHighSoundEffect:isValidMatch(match)
    return (
        match ~= nil and
        match:hasDampening() == true
    );
end

function opvp.private.DampeningHighSoundEffect:_onFeatureActivated()
    opvp.match.dampeningUpdate:connect(
        self,
        self._onDampeningUpdate
    );

    self._dampening_warn = 40;

    opvp.MatchOptionFeature._onFeatureActivated(self)
end

function opvp.private.DampeningHighSoundEffect:_onFeatureDeactivated()
    opvp.match.dampeningUpdate:disconnect(
        self,
        self._onDampeningUpdate
    );

    opvp.MatchOptionFeature._onFeatureDeactivated(self)
end

function opvp.private.DampeningHighSoundEffect:_onDampeningUpdate(value)
    value = value * 100;

    if value == 0 then
        self._dampening_warn = 40;
    elseif value >= self._dampening_warn then
        self._dampening_warn = self._dampening_warn + 20;

        opvp.effect.dampeningHigh(opvp.player.faction());
    end
end

function opvp.effect.dampeningHigh(faction)
    local sound = opvp.Faction:fromId(faction):pvpWarningSound();

    if faction == opvp.ALLIANCE then
        sound = opvp.Faction.ALLIANCE:pvpWarningSound();
    else
        sound = opvp.Faction.HORDE:pvpWarningSound();
    end

    sound:play(opvp.SoundChannel.SFX, true);
end

local function opvp_damp_high_sound_effect_sample(button, state)
    if state == false then
        opvp.effect.dampeningHigh(opvp.player.faction());
    end
end

local opvp_damp_high_sound_effect;

local function opvp_damp_high_sound_effect_ctor()
    opvp_damp_high_sound_effect = opvp.private.DampeningHighSoundEffect(
        opvp.options.audio.soundeffect.match.dampeningHigh
    );

    opvp.options.audio.soundeffect.match.dampeningHighSample.clicked:connect(
        opvp_damp_high_sound_effect_sample
    );
end

opvp.OnAddonLoad:register(opvp_damp_high_sound_effect_ctor);
