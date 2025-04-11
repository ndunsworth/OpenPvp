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

local FIGHT_SOUNDS_FILEDATA_IDS = {
    --NPC_Mace1H_Mtl_Hit_Flesh
    1393727,
    1393728,
    1393729,
    1393730,
    1393731,
    1393732,
    --NPC_Mace1H_Mtl_Hit_Flesh_Crit
    1393692,
    1393693,
    1393694,
    --FX_Whoosh_Small_Revamp_07
    1302923,
    1302924,
    1302925,
    1302926,
    1302927,
    1302928,
    1302929,
    1302930,
    1302931,
    1302932
};

opvp.private.MutePvpAreaNpcFightSounds = opvp.CreateClass(opvp.OptionFeature);

function opvp.private.MutePvpAreaNpcFightSounds:init(option)
    opvp.OptionFeature.init(self, option);
end

function opvp.private.MutePvpAreaNpcFightSounds:isFeatureEnabled()
    return self:option():value();
end

function opvp.private.MutePvpAreaNpcFightSounds:_onFeatureActivated()
    for n=1, #FIGHT_SOUNDS_FILEDATA_IDS do
        MuteSoundFile(FIGHT_SOUNDS_FILEDATA_IDS[n]);
    end

    opvp.OptionFeature._onFeatureActivated(self);
end

function opvp.private.MutePvpAreaNpcFightSounds:_onFeatureDeactivated()
    for n=1, #FIGHT_SOUNDS_FILEDATA_IDS do
        UnmuteSoundFile(FIGHT_SOUNDS_FILEDATA_IDS[n]);
    end

    opvp.OptionFeature._onFeatureDeactivated(self);
end

local opvp_mute_pvp_area_npc_fight_sounds;

local function opvp_mute_pvp_area_npc_fight_sounds_ctor()
    opvp_mute_pvp_area_npc_fight_sounds = opvp.private.MutePvpAreaNpcFightSounds(
        opvp.options.audio.general.mutePvpAreaNpcFights
    );
end

opvp.OnAddonLoad:register(opvp_mute_pvp_area_npc_fight_sounds_ctor);
