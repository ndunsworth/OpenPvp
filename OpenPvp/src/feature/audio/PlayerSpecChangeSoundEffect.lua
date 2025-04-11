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

opvp.private.PlayerSpecChangeSoundEffect = opvp.CreateClass(opvp.private.SoundEffect);

function opvp.private.PlayerSpecChangeSoundEffect:init(option)
    opvp.private.SoundEffect.init(self, option);
end

function opvp.private.PlayerSpecChangeSoundEffect:isFeatureEnabled()
    return self:option():value();
end

function opvp.private.PlayerSpecChangeSoundEffect:_onFeatureActivated()
    opvp.Player:instance().specChanged:connect(
        self,
        self._onSpecChanged
    );

    opvp.private.SoundEffect._onFeatureActivated(self)
end

function opvp.private.PlayerSpecChangeSoundEffect:_onFeatureDeactivated()
    opvp.Player:instance().specChanged:disconnect(
        self,
        self._onSpecChanged
    );

    opvp.private.SoundEffect._onFeatureDeactivated(self)
end

function opvp.private.PlayerSpecChangeSoundEffect:_onSpecChanged(newSpec, oldSpec)
    if newSpec:isValid() == true and oldSpec:isValid() ~= false then
        opvp.effect.playerSpecChange(newSpec);
    end
end

function opvp.effect.playerSpecChange(spec)
    PlaySound(
        opvp.effect.playerSpecChangeSoundId(spec),
        opvp.SoundChannel.SFX,
        false
    );
end

function opvp.effect.playerSpecChangeSoundId(spec)
    return spec:sound();
end

local opvp_player_spec_change_sound_effect;
local opvp_player_spec_change_sample_index = 0;

local function opvp_player_spec_change_sound_effect_sample(button, state)
    if state == false then
        local specs = opvp.player.specs();
        local spec = specs[opvp_player_spec_change_sample_index + 1];

        opvp.options.audio.soundeffect.player.specChangeSampleLabel:setName(
            string.format(
                "%s %s",
                opvp.utils.textureIdMarkup(spec:icon(), 22, 22),
                spec:colorString(spec:name())
            )
        );

        opvp.effect.playerSpecChange(spec);

        opvp_player_spec_change_sample_index = (opvp_player_spec_change_sample_index + 1) % #specs;
    end
end

local function opvp_player_spec_change_sound_effect_ctor()
    opvp_player_spec_change_sound_effect = opvp.private.PlayerSpecChangeSoundEffect(
        opvp.options.audio.soundeffect.player.specChange
    );

    opvp.options.audio.soundeffect.player.specChangeSample.clicked:connect(
        opvp_player_spec_change_sound_effect_sample
    );
end

opvp.OnAddonLoad:register(opvp_player_spec_change_sound_effect_ctor);
