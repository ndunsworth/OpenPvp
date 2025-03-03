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

opvp.FFAZoneSoundEffect = opvp.CreateClass(opvp.SoundEffect);

function opvp.FFAZoneSoundEffect:init(option)
    opvp.SoundEffect.init(self, option);
end

function opvp.FFAZoneSoundEffect:isFeatureEnabled()
    return self:option():value();
end

function opvp.FFAZoneSoundEffect:_onFeatureActivated()
    opvp.Player:instance().inFFAChanged:connect(
        self,
        self._onFFAChanged
    );

    opvp.SoundEffect._onFeatureActivated(self)
end

function opvp.FFAZoneSoundEffect:_onFeatureDeactivated()
    opvp.Player:instance().inFFAChanged:disconnect(
        self,
        self._onFFAChanged
    );

    opvp.SoundEffect._onFeatureDeactivated(self)
end

function opvp.FFAZoneSoundEffect:_onFFAChanged(state)
    opvp.effect.ffaZone(state);
end

function opvp.effect.ffaZone(state)
    PlaySound(
        opvp.effect.ffaZoneSoundId(state),
        opvp.SoundChannel.SFX,
        false
    );
end

function opvp.effect.ffaZoneSoundId(state)
    if state == true then
        return SOUNDKIT.UI_WARMODE_ACTIVATE;
    else
        return SOUNDKIT.UI_WARMODE_DECTIVATE;
    end
end

local opvp_ffazone_sound_effect;
local opvp_ffazone_sample_index = false;

local function opvp_ffazone_sound_effect_sample(button, state)
    if state == false then
        opvp_ffazone_sample_index = not opvp_ffazone_sample_index;

        opvp.effect.ffaZone(opvp_ffazone_sample_index);
    end
end

local function opvp_ffazone_sound_effect_ctor()
    opvp_ffazone_sound_effect = opvp.FFAZoneSoundEffect(
        opvp.options.audio.soundeffect.pvp.ffaZone
    );

    opvp.options.audio.soundeffect.pvp.ffaZoneSample.clicked:connect(
        opvp_ffazone_sound_effect_sample
    );
end

opvp.OnAddonLoad:register(opvp_ffazone_sound_effect_ctor);
