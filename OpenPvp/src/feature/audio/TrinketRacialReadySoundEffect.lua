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

opvp.private.TrinketRacialReadySoundEffect = opvp.CreateClass(opvp.private.SoundEffect);

function opvp.private.TrinketRacialReadySoundEffect:init(option)
    opvp.private.SoundEffect.init(self, option);
end

function opvp.private.TrinketRacialReadySoundEffect:isFeatureEnabled()
    return self:option():value();
end

function opvp.private.TrinketRacialReadySoundEffect:_onFeatureActivated()
    local player = opvp.player.instance();

    if player:hasPvpRacialTrinket() == true then
        player.pvpTrinketRacialUpdate:connect(self, self._onPvpTrinketUpdate);
    end

    opvp.private.SoundEffect._onFeatureActivated(self);
end

function opvp.private.TrinketRacialReadySoundEffect:_onFeatureDeactivated()
    local player = opvp.player.instance();

    if player:hasPvpRacialTrinket() == true then
        player.pvpTrinketRacialUpdate:disconnect(self, self._onPvpTrinketUpdate);
    end

    opvp.private.SoundEffect._onFeatureDeactivated(self)
end

function opvp.private.TrinketRacialReadySoundEffect:_onPvpTrinketUpdate(state)
    if state == true then
        opvp.effect.trinketRacialReady(
            opvp.player.race(),
            opvp.player.sex()
        );
    end
end

function opvp.effect.trinketRacialReady(race, sex)
    local sound = opvp.effect.trinketRacialReadySound(race);

    sound:play(sex, opvp.SoundChannel.SFX, true);
end

function opvp.effect.trinketRacialReadySound(race)
    return opvp.Emote.RACIAL:sound(race);
end

local opvp_trinket_racial_ready_sound_effect;

local function opvp_trinket_racial_ready_sound_sample(button, state)
    if state == false then
        opvp.effect.trinketRacialReady(
            opvp.player.race(),
            opvp.player.sex()
        );
    end
end

local function opvp_trinket_racial_ready_sound_effect_ctor()
    opvp_trinket_racial_ready_sound_effect = opvp.private.TrinketRacialReadySoundEffect(
        opvp.options.audio.soundeffect.pvp.trinketRacialReady
    );

    opvp.options.audio.soundeffect.pvp.trinketRacialReadySample.clicked:connect(
        opvp_trinket_racial_ready_sound_sample
    );
end

opvp.OnAddonLoad:register(opvp_trinket_racial_ready_sound_effect_ctor);
