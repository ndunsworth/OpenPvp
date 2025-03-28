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

local INSURANCE_FILEDATA_IDS = {
    6222657,
    6222659,
    6222661,
    6222663,
    6222665,
    6222667,
    6222669,
    6222671,
    6222673,
    6222675,
    6222677,
    6222679,
    6222681,
    6222683,
    6222685,
    6421997,
    6421999,
    6422001,
    6422002,
    6422003,
    6422005
};

opvp.MuteInsuranceSoundEffect = opvp.CreateClass(opvp.OptionFeature);

function opvp.MuteInsuranceSoundEffect:init(option)
    opvp.OptionFeature.init(self, option);
end

function opvp.MuteInsuranceSoundEffect:isFeatureEnabled()
    return self:option():value();
end

function opvp.MuteInsuranceSoundEffect:_onFeatureActivated()
    for n=1, #INSURANCE_FILEDATA_IDS do
        MuteSoundFile(INSURANCE_FILEDATA_IDS[n]);
    end

    opvp.OptionFeature._onFeatureActivated(self);
end

function opvp.MuteInsuranceSoundEffect:_onFeatureDeactivated()
    for n=1, #INSURANCE_FILEDATA_IDS do
        UnmuteSoundFile(INSURANCE_FILEDATA_IDS[n]);
    end

    opvp.OptionFeature._onFeatureDeactivated(self);
end

local opvp_mute_insurance;

local function opvp_mute_insurance_ctor()
    opvp_mute_insurance = opvp.MuteInsuranceSoundEffect(
        opvp.options.audio.general.muteInsuranceTierSfx
    );
end

opvp.OnAddonLoad:register(opvp_mute_insurance_ctor);
