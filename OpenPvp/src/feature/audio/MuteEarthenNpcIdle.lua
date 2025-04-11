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

local EARTHEN_IDLE_FILEDATA_IDS = {
    --PlayerRace - Earthen - Male - Exert - Idle OEP
    5919566,
    5919568,
    5919570,
    5919572,
    5919574,
    --EarthenDwarfMale_fidget_5919534
    5919534,
    5919536,
    5919582,
    5919588,
    --EarthenDwarfMale_fidget7_5927790
    5927790,
    5927792,
    5927794,
    5927796,
    5927798,
    5927800,
    --EarthenDwarfFemale_fidget6_5919839
    5919628,
    5919630,
    5919632,
    5919634,
    5919636,
    5919638,
    5919640,
    5919642,
    --PlayerRace - Earthen - Female  - Exert - Idle OEP
    5919801,
    5919803,
    5919805,
    5919807,
    --EarthenDwarfFemale_fidget6_5919839
    5919839,
    5919842,
    5919844,
    5919846,
    5919848,
    --EarthenDwarfFemale_fidget13_5919801
    5919801,
    5919803,
    5919805,
    5919807,
    5919809,
    5919811,
    5919813,
    5919815,
    5919817,
    5919819,
};

opvp.private.MuteEarthenNpcIdle = opvp.CreateClass(opvp.OptionFeature);

function opvp.private.MuteEarthenNpcIdle:init(option)
    opvp.OptionFeature.init(self, option);
end

function opvp.private.MuteEarthenNpcIdle:isFeatureEnabled()
    return self:option():value();
end

function opvp.private.MuteEarthenNpcIdle:_onFeatureActivated()
    for n=1, #EARTHEN_IDLE_FILEDATA_IDS do
        MuteSoundFile(EARTHEN_IDLE_FILEDATA_IDS[n]);
    end

    opvp.OptionFeature._onFeatureActivated(self);
end

function opvp.private.MuteEarthenNpcIdle:_onFeatureDeactivated()
    for n=1, #EARTHEN_IDLE_FILEDATA_IDS do
        UnmuteSoundFile(EARTHEN_IDLE_FILEDATA_IDS[n]);
    end

    opvp.OptionFeature._onFeatureDeactivated(self);
end

local opvp_mute_earthen_npc_idle;

local function opvp_mute_earthen_npc_idle_ctor()
    opvp_mute_earthen_npc_idle = opvp.private.MuteEarthenNpcIdle(
        opvp.options.audio.general.muteEarthenNpcIdle
    );
end

opvp.OnAddonLoad:register(opvp_mute_earthen_npc_idle_ctor);
