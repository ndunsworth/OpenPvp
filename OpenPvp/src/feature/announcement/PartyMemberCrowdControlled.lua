
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

local opvp_cc_valid_mask = bit.bor(
    opvp.CrowdControlType.DISARM,
    opvp.CrowdControlType.ROOT,
    opvp.CrowdControlType.DISORIENT,
    opvp.CrowdControlType.INCAPACITATE,
    opvp.CrowdControlType.SILENCE,
    opvp.CrowdControlType.STUN
);

opvp.private.PartyMemberCrowdControlled = opvp.CreateClass(opvp.OptionFeature);

function opvp.private.PartyMemberCrowdControlled:init(option, mask, affiliation)
    opvp.MatchOptionFeature.init(self, option);

    self._mask        = mask;
    self._affiliation = affiliation;
end

function opvp.private.PartyMemberCrowdControlled:isFeatureEnabled()
    return self:option():value();
end

function opvp.private.PartyMemberCrowdControlled:isRoleValid(role)
    return role:isNull() or self._mask:isRoleEnabled(role);
end

function opvp.private.PartyMemberCrowdControlled:_onFeatureActivated()
    opvp.OptionFeature._onFeatureActivated(self);

    local tracker = opvp.party.ccTracker();

    tracker.memberCrowdControlAdded:connect(self, self._onMemberCrowdControlAdded);
end

function opvp.private.PartyMemberCrowdControlled:_onFeatureDeactivated()
    opvp.OptionFeature._onFeatureDeactivated(self);

    local tracker = opvp.party.ccTracker();

    tracker.memberCrowdControlAdded:disconnect(self, self._onMemberCrowdControlAdded);
end

function opvp.private.PartyMemberCrowdControlled:_onMemberCrowdControlAdded(
    member,
    aura,
    spell,
    ccCategoryState,
    ccMaskNew,
    ccMaskOld,
    newDr
)
    if (
        newDr == false or
        member:affiliation() ~= self._affiliation or
        bit.band(ccCategoryState:id(), opvp_cc_valid_mask) == 0 or
        (
            self:isRoleValid(member:role()) == false and
            member:isPlayer() == false
        )
    ) then
        return
    end

    local msg;
    local identifier;

    if opvp.match.inMatch() == true then
        if member:isPlayer() == true then
            msg = opvp.strs.MATCH_SELF_LOS_CONTROL;
        elseif member:isSpecKnown() == true then
            msg = opvp.strs.MATCH_PLAYER_LOS_CONTROL_WITH_SPEC;
        else
            msg = opvp.strs.MATCH_PLAYER_LOS_CONTROL;
        end

        if member:isFriendly() == true then
            identifier = opvp.strs.MATCH_FRIENDLY_PLAYER;
        else
            identifier = opvp.strs.MATCH_HOSTILE_PLAYER;
        end
    else
        if member:isPlayer() == true then
            msg = opvp.strs.PARTY_SELF_LOS_CONTROL;
        elseif member:isSpecKnown() == true then
            msg = opvp.strs.PARTY_MBR_LOS_CONTROL_WITH_SPEC;
        else
            msg = opvp.strs.PARTY_MBR_LOS_CONTROL;
        end

        if opvp.party.isParty() == true then
            identifier = opvp.strs.PARTY;
        else
            identifier = opvp.strs.RAID;
        end
    end

    local cls = member:classInfo();
    local spec = member:specInfo();

    opvp.printMessage(
        msg,
        identifier,
        member:nameOrId(),
        cls:color():GenerateHexColor(),
        spec:name(),
        cls:name(),
        C_Spell.GetSpellLink(aura:spellId()),
        ccCategoryState:drName()
    );
end

local opvp_friendly_cc_announce_singleton;
local opvp_enemy_cc_announce_singleton;

local function opvp_party_member_cc_announce_ctor()
    opvp_friendly_cc_announce_singleton = opvp.private.PartyMemberCrowdControlled(
        opvp.options.announcements.friendlyParty.memberCrowdControlled,
        opvp.options.announcements.friendlyParty.memberCrowdControlledRole,
        opvp.Affiliation.FRIENDLY
    );

    opvp_enemy_cc_announce_singleton = opvp.private.PartyMemberCrowdControlled(
        opvp.options.announcements.hostileParty.memberCrowdControlled,
        opvp.options.announcements.hostileParty.memberCrowdControlledRole,
        opvp.Affiliation.HOSTILE
    );
end

opvp.OnAddonLoad:register(opvp_party_member_cc_announce_ctor);
