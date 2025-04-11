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

opvp.private.TrinketReadySoundEffect = opvp.CreateClass(opvp.private.SoundEffect);

function opvp.private.TrinketReadySoundEffect:init(option)
    opvp.private.SoundEffect.init(self, option);
end

function opvp.private.TrinketReadySoundEffect:isFeatureEnabled()
    return self:option():value();
end

function opvp.private.TrinketReadySoundEffect:_onFeatureActivated()
    local player = opvp.player.instance();

    player.pvpTrinketUpdate:connect(self, self._onPvpTrinketUpdate);

    opvp.private.SoundEffect._onFeatureActivated(self);
end

function opvp.private.TrinketReadySoundEffect:_onFeatureDeactivated()
    local player = opvp.player.instance();

    player.pvpTrinketUpdate:disconnect(self, self._onPvpTrinketUpdate);

    opvp.private.SoundEffect._onFeatureDeactivated(self)
end

function opvp.private.TrinketReadySoundEffect:_onPvpTrinketUpdate(state)
    if state == true then
        opvp.effect.trinketReady(
            opvp.player.faction(),
            opvp.player.race(),
            opvp.player.sex()
        );
    end
end

function opvp.effect.trinketReady(faction, race, sex)
    local sound = opvp.effect.trinketReadySound(faction, race);

    sound:play(sex, opvp.SoundChannel.SFX, true);
end

function opvp.effect.trinketReadySound(faction, race)
    if faction == opvp.ALLIANCE then
        return opvp.Emote.FOR_THE_ALLIANCE:sound(race);
    else
        return opvp.Emote.FOR_THE_HORDE:sound(race);
    end
end

local opvp_trinket_ready_sound_effect;

local function opvp_trinket_ready_sound_sample(button, state)
    if state == false then
        opvp.effect.trinketReady(
            opvp.player.faction(),
            opvp.player.race(),
            opvp.player.sex()
        );
    end
end

local function opvp_trinket_ready_sound_effect_ctor()
    opvp_trinket_ready_sound_effect = opvp.private.TrinketReadySoundEffect(
        opvp.options.audio.soundeffect.pvp.trinketReady
    );

    opvp.options.audio.soundeffect.pvp.trinketReadySample.clicked:connect(
        opvp_trinket_ready_sound_sample
    );
end

opvp.OnAddonLoad:register(opvp_trinket_ready_sound_effect_ctor);
