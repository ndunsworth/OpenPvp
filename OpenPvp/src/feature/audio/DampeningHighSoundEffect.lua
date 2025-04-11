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

opvp.DampeningHighSoundEffect = opvp.CreateClass(opvp.MatchOptionFeature);

function opvp.DampeningHighSoundEffect:init(option)
    opvp.MatchOptionFeature.init(self, option);

    self._dampening_warn = false;
end

function opvp.DampeningHighSoundEffect:isActiveMatchStatus(status)
    return status == opvp.MatchStatus.ROUND_ACTIVE;
end

function opvp.DampeningHighSoundEffect:isFeatureEnabled()
    return self:option():value();
end

function opvp.DampeningHighSoundEffect:isValidMatch(match)
    return (
        match ~= nil and
        match:hasDampening() == true
    );
end

function opvp.DampeningHighSoundEffect:_onFeatureActivated()
    opvp.match.dampeningUpdate:connect(
        self,
        self._onDampeningUpdate
    );

    self._dampening_warn = true;

    opvp.MatchOptionFeature._onFeatureActivated(self)
end

function opvp.DampeningHighSoundEffect:_onFeatureDeactivated()
    opvp.match.dampeningUpdate:disconnect(
        self,
        self._onDampeningUpdate
    );

    opvp.MatchOptionFeature._onFeatureDeactivated(self)
end

function opvp.DampeningHighSoundEffect:_onDampeningUpdate(value)
    if value == 0 then
        self._dampening_warn = true;
    elseif (
        self._dampening_warn == true and
        value >= 0.4
    ) then
        opvp.effect.dampeningHigh(opvp.player.faction());
    end
end

function opvp.effect.dampeningHigh(faction)
    local sound_id;

    if faction == opvp.ALLIANCE then
        sound_id = 8456;
    else
        sound_id = 8457;
    end

    PlaySound(sound_id, opvp.SoundChannel.SFX);
end

local function opvp_damp_high_sound_effect_sample(button, state)
    if state == false then
        opvp.effect.dampeningHigh(opvp.player.faction());
    end
end

local opvp_damp_high_sound_effect;

local function opvp_damp_high_sound_effect_ctor()
    opvp_damp_high_sound_effect = opvp.DampeningHighSoundEffect(
        opvp.options.audio.soundeffect.match.dampeningHigh
    );

    opvp.options.audio.soundeffect.match.dampeningHighSample.clicked:connect(
        opvp_damp_high_sound_effect_sample
    );
end

opvp.OnAddonLoad:register(opvp_damp_high_sound_effect_ctor);
