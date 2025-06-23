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

local DIALOG_SOUNDKIT_IDS = {
    [opvp.InstanceId.CAGE_OF_CARNAGE] = {},
    [opvp.InstanceId.ENIGMA_ARENA] = {
        188954,
        188955,
        188956,
        188957,
        188958,
        188959
    },
    [opvp.InstanceId.ENIGMA_CRUCIBLE] = {
        188954,
        188955,
        188956,
        188957,
        188958,
        188959
    },
    [opvp.InstanceId.HOOK_POINT] = {
        104433,
        104434,
        104435,
        104436,
        104437,
        104438,
        104439,
        104440,
        104441,
        104442,
        104443,
        104444
    },
    [opvp.InstanceId.MUGAMBALA_ARENA] = {
        104445,
        104446,
        104447,
        104448,
        104449,
        104450,
        104451
    },
    [opvp.InstanceId.NOKHUDON_PROVING_GROUNDS] = {
        200420,
        200421,
        200422,
        200423,
        200424,
        200425,
        200426,
        200427
    }
};

local DIALOG_FILEDATA_IDS = {
    [opvp.InstanceId.CAGE_OF_CARNAGE] = {
        6177849,
        6177850,
        6177851,
        6177852,
        6177853,
        6177854,
        6177855,
        6177857,
        6177858,
        6177859,
        6177860,
        6177861,
        6177862,
        6177863
    },
    [opvp.InstanceId.ENIGMA_ARENA] = {
        4291841,
        4291842,
        4291843,
        4291844,
        4291845,
        4291846
    },
    [opvp.InstanceId.ENIGMA_CRUCIBLE] = {
        4291841,
        4291842,
        4291843,
        4291844,
        4291845,
        4291846
    },
    [opvp.InstanceId.HOOK_POINT] = {
        1990632,
        1990633,
        1990634,
        1990635,
        1990636,
        1990637,
        1990638,
        1990639,
        1990640,
        1990641,
        1990642,
        1990643
    },
    [opvp.InstanceId.MUGAMBALA_ARENA] = {
        1990668,
        1990669,
        1990670,
        1990671,
        1990672,
        1990673,
        1990674
    },
    [opvp.InstanceId.NOKHUDON_PROVING_GROUNDS] = {
        4621427,
        4621428,
        4621429,
        4621430,
        4621431,
        4621432,
        4621433,
        4621434
    }
};

opvp.private.MuteNPCDialogMatchFeature = opvp.CreateClass(opvp.MatchOptionFeature);

function opvp.private.MuteNPCDialogMatchFeature:init(option)
    opvp.MatchOptionFeature.init(self, option);

    self._valid_test  = opvp.MatchTestType.NONE;
    self._map         = opvp.InstanceId.UNKNOWN;
    self._map_ids     = opvp.List:createFromArray(
        {
            opvp.InstanceId.CAGE_OF_CARNAGE,
            --~ opvp.InstanceId.ENIGMA_ARENA,
            opvp.InstanceId.ENIGMA_CRUCIBLE,
            opvp.InstanceId.HOOK_POINT,
            opvp.InstanceId.MUGAMBALA_ARENA,
            opvp.InstanceId.NOKHUDON_PROVING_GROUNDS
        }
    );

    self._msg_filter = opvp.MuteChatTypesMessageFilter(
        {
            opvp.ChatType.MONSTER_EMOTE,
            opvp.ChatType.MONSTER_PARTY,
            opvp.ChatType.MONSTER_SAY,
            opvp.ChatType.MONSTER_WHISPER,
            opvp.ChatType.MONSTER_YELL,
            opvp.ChatType.RAID_BOSS_EMOTE,
            opvp.ChatType.RAID_BOSS_WHISPER
        }
    );
end

function opvp.private.MuteNPCDialogMatchFeature:isValidMap(map)
    return (
        map ~= nil and
        opvp.IsInstance(map, opvp.Map) == true and
        self._map_ids:contains(map:instanceId()) == true and
        self:option():isBitEnabled(
            self._map_ids:index(map:instanceId())
        ) == true
    );
end

function opvp.private.MuteNPCDialogMatchFeature:isValidMatch(match)
    return (
        match ~= nil and
        match:isArena() == true and
        match:isTest() == false and
        self:isValidMap(match:map()) == true
    );
end

function opvp.private.MuteNPCDialogMatchFeature:isFeatureEnabled()
    return self:option():isZero();
end

function opvp.private.MuteNPCDialogMatchFeature:_onFeatureActivated()
    local map = opvp.Map:createFromCurrentInstance();
    local sound_ids = DIALOG_FILEDATA_IDS[map:instanceId()];

    if sound_ids ~= nil then
        for n=1, #sound_ids do
            MuteSoundFile(sound_ids[n]);
        end

        self._map = map:instanceId();

        self._msg_filter:connect();
    end

    opvp.MatchOptionFeature._onFeatureActivated(self);
end

function opvp.private.MuteNPCDialogMatchFeature:_onFeatureDeactivated()
    local sound_ids = DIALOG_FILEDATA_IDS[self._map];

    if sound_ids ~= nil then
        for n=1, #sound_ids do
            UnmuteSoundFile(sound_ids[n]);
        end

        self._map = opvp.InstanceId.UNKNOWN;

        self._msg_filter:disconnect();
    end

    opvp.MatchOptionFeature._onFeatureDeactivated(self);
end

local opvp_mute_npc_dialog_match_feature;

local function opvp_mute_npc_dialog_match_feature_ctor()
    opvp_mute_npc_dialog_match_feature = opvp.private.MuteNPCDialogMatchFeature(
        opvp.options.match.muteNPCDialog.maps
    );
end

opvp.OnAddonLoad:register(opvp_mute_npc_dialog_match_feature_ctor);
