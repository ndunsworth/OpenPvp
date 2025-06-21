
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

opvp.private.PartyMemberSpellInterrupted = opvp.CreateClass(opvp.OptionFeature);

function opvp.private.PartyMemberSpellInterrupted:init(option, mask, affiliation)
    opvp.OptionFeature.init(self, option);

    self._mask        = mask;
    self._affiliation = affiliation;
end

function opvp.private.PartyMemberSpellInterrupted:isFeatureEnabled()
    return self:option():value();
end

function opvp.private.PartyMemberSpellInterrupted:isRoleValid(role)
    return role:isNull() or self._mask:isRoleEnabled(role);
end

function opvp.private.PartyMemberSpellInterrupted:_onFeatureActivated()
    opvp.OptionFeature._onFeatureActivated(self);

    opvp.party.memberSpellInterrupted:connect(self, self._onMemberSpellInterrupted);
    opvp.match.playerSpellInterrupted:connect(self, self._onMemberSpellInterrupted);
end

function opvp.private.PartyMemberSpellInterrupted:_onFeatureDeactivated()
    opvp.OptionFeature._onFeatureDeactivated(self);

    opvp.party.memberSpellInterrupted:disconnect(self, self._onMemberSpellInterrupted);
    opvp.match.playerSpellInterrupted:disconnect(self, self._onMemberSpellInterrupted);
end

function opvp.private.PartyMemberSpellInterrupted:_onMemberSpellInterrupted(
    member,
    sourceName,
    sourceGUID,
    spellId,
    spellName,
    spellSchool,
    extraSpellId,
    extraSpellName,
    extraSpellSchool,
    castLength,
    castProgress
)
    if (
        member:affiliation() ~= self._affiliation or
        self:isRoleValid(member:role()) == false
    ) then
        return
    end

    local msg = (
        self:isFriendly()
        and opvp.options.announcements.friendlyParty.memberSpellInterrupted:value()
        or opvp.options.announcements.hostileParty.memberSpellInterrupted:value()
    );

    local identifier;

    if castProgress > 0 then
        opvp.printMessageOrDebug(
            (
                self:isFriendly()
                and opvp.options.announcements.friendlyParty.memberSpellInterrupted:value()
                or opvp.options.announcements.hostileParty.memberSpellInterrupted:value()
            ),
            (
                member:isPlayer()
                and opvp.strs.MATCH_SELF_SPELL_INTERRUPTED_WITH_TIME
                or opvp.strs.MATCH_PLAYER_SPELL_INTERRUPTED_WITH_TIME
            ),
            self:identifierMemberName(),
            member:nameOrId(member:isSpecKnown()),
            opvp.spell.link(extraSpellId),
            castProgress,
            castLength
        );
    else
        opvp.printMessageOrDebug(
            (
                self:isFriendly()
                and opvp.options.announcements.friendlyParty.memberSpellInterrupted:value()
                or opvp.options.announcements.hostileParty.memberSpellInterrupted:value()
            ),
            (
                member:isPlayer()
                and opvp.strs.MATCH_SELF_SPELL_INTERRUPTED
                or opvp.strs.MATCH_PLAYER_SPELL_INTERRUPTED
            ),
            self:identifierMemberName(),
            member:nameOrId(member:isSpecKnown()),
            opvp.spell.link(extraSpellId)
        );
    end

    if opvp.match.inMatch() == true then
        if member:isPlayer() == true then
            msg = opvp.strs.MATCH_SELF_LOS_CONTROL;
        else
            msg = opvp.strs.MATCH_PLAYER_LOC;
        end

        if member:isFriendly() == true then
            identifier = opvp.strs.MATCH_FRIENDLY_PLAYER;
        else
            identifier = opvp.strs.MATCH_HOSTILE_PLAYER;
        end
    else
        if member:isPlayer() == true then
            msg = opvp.strs.PARTY_SELF_LOS_CONTROL;
        else
            msg = opvp.strs.PARTY_MBR_LOC;
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
        member:nameOrId(member:isSpecKnown()),
        opvp.spell.link(aura:spellId()),
        ccCategoryState:drName()
    );
end

local opvp_friendly_spell_int_announce_singleton;
local opvp_enemy_spell_int_announce_singleton;

local function opvp_party_member_cc_announce_ctor()
    opvp_friendly_spell_int_announce_singleton = opvp.private.PartyMemberSpellInterrupted(
        opvp.options.announcements.friendlyParty.memberSpellInterrupted,
        opvp.options.announcements.friendlyParty.memberSpellInterruptedRole,
        opvp.Affiliation.FRIENDLY
    );

    opvp_enemy_spell_int_announce_singleton = opvp.private.PartyMemberSpellInterrupted(
        opvp.options.announcements.hostileParty.memberSpellInterrupted,
        opvp.options.announcements.hostileParty.memberSpellInterruptedRole,
        opvp.Affiliation.HOSTILE
    );
end

opvp.OnAddonLoad:register(opvp_party_member_cc_announce_ctor);
