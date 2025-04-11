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

opvp.private.AutoDeclineInviteMatchFeature = opvp.CreateClass(opvp.MatchOptionFeature);

function opvp.private.AutoDeclineInviteMatchFeature:init(option)
    opvp.MatchOptionFeature.init(self, option);

    self._valid_test  = opvp.MatchTestType.NONE;
    self._friends     = opvp.List();
    self._ignore      = opvp.List();
end

function opvp.private.AutoDeclineInviteMatchFeature:isFriend(guid)
    if self._friends:contains(guid) then
        return true;
    end

    if self._ignore:contains(guid) then
        return false;
    end

    local is_friend = (
        C_FriendList.IsFriend(guid) == true or
        C_BattleNet.GetAccountInfoByGUID(guid) ~= nil
    );

    if is_friend == true then
        self._friends:append(guid);
    else
        self._ignore:append(guid);
    end

    return result;
end

function opvp.private.AutoDeclineInviteMatchFeature:isValidMatch(match)
    return (
        match ~= nil and
        match:isTest() == false and
        (
            match:isBlitz() == true or
            match:isShuffle() == true
        )
    );
end

function opvp.private.AutoDeclineInviteMatchFeature:_onFeatureActivated()
    opvp.event.PARTY_INVITE_REQUEST:connect(
        self,
        self._onPartyInviteEvent
    );

    opvp.MatchOptionFeature._onFeatureActivated(self);
end

function opvp.private.AutoDeclineInviteMatchFeature:_onFeatureDeactivated()
    opvp.event.PARTY_INVITE_REQUEST:disconnect(
        self,
        self._onPartyInviteEvent
    );

    self._friends:clear();
    self._ignore:clear();

    opvp.MatchOptionFeature._onFeatureDeactivated(self);
end

function opvp.private.AutoDeclineInviteMatchFeature:_onPartyInviteEvent(
    name,
    isTank,
    isHealer,
    isDamage,
    isNativeRealm,
    allowMultipleRoles,
    inviterGUID,
    questSessionActive
)
    if self:isFriend(inviterGUID) == true then
        return;
    end

    DeclineGroup();

    StaticPopup_Hide("PARTY_INVITE");

    local msg = opvp.options.match.general.blockPartyInviteMessage:value();

    if msg == "" then
        return;
    end

    --~ opvp.printWarning(
        --~ "Party Invite - Match filter auto declined %s's request",
        --~ player:name()
    --~ );

    local player = opvp.Unit:createFromUnitGuid(inviterGUID);

    if player:isNull() then
        return;
    end

    local queue = opvp.queue.active();

    if queue ~= nil then
        msg = string.gsub(msg, "%s", queue:name());
    else
        msg = string.gsub(msg, "%s", "");
    end

    player:sendMessage(msg);
end

local opvp_auto_decline_invite_match_feature;

local function opvp_auto_decline_invite_match_feature_ctor()
    opvp_auto_decline_invite_match_feature = opvp.private.AutoDeclineInviteMatchFeature(
        opvp.options.match.general.blockPartyInvite
    );
end

opvp.OnAddonLoad:register(opvp_auto_decline_invite_match_feature_ctor);
