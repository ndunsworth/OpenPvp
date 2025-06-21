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

opvp.MatchTeam = opvp.CreateClass(opvp.Party);

function opvp.MatchTeam:init(match)
    opvp.Party.init(self);

    self._match           = match;
    self._id              = 0;
    self._dampening       = false;
    self._dampening_found = false;
    self._winner          = false;
end

function opvp.MatchTeam:cr()
    if self._match:isRated() == false then
        return 0;
    end

    local value = 0;
    local count = 0;

    local members = self:members();
    local member;

    for n=1, #members do
        member = members[n];

        if member:isRatingKnown() == true then
            value = value + member:cr();
            count = count + 1;
        end
    end

    if count > 0 then
        return value / count;
    else
        return 0;
    end
end

function opvp.MatchTeam:id()
    return self._id;
end

function opvp.MatchTeam:identifierName()
    if self:isHostile() == true then
        return opvp.strs.MATCH_HOSTILE_TEAM;
    else
        return opvp.strs.MATCH_FRIENDLY_TEAM;
    end
end

function opvp.MatchTeam:identifierMemberName(invert)
    if invert == true then
        if self:isHostile() == true then
            return opvp.strs.MATCH_FRIENDLY_PLAYER;
        else
            return opvp.strs.MATCH_HOSTILE_PLAYER;
        end
    else
        if self:isHostile() == true then
            return opvp.strs.MATCH_HOSTILE_PLAYER;
        else
            return opvp.strs.MATCH_FRIENDLY_PLAYER;
        end
    end
end

function opvp.MatchTeam:isFriendly()
    if self._provider ~= nil then
        return self._provider:isFriendly();
    else
        return true;
    end
end

function opvp.MatchTeam:isHostile()
    if self._provider ~= nil then
        return self._provider:isHostile();
    else
        return false;
    end
end

function opvp.MatchTeam:isLoser()
    return not self._winner;
end

function opvp.MatchTeam:isWinner()
    return self._winner;
end

function opvp.MatchTeam:mmr()
    if self._match:isRated() == false then
        return 0;
    end

    local value = 0;
    local count = 0;

    local members = self:members();
    local member;

    for n=1, #members do
        member = members[n];

        if member:isRatingKnown() == true then
            value = value + member:mmr();
            count = count + 1;
        end
    end

    if value > 0 and count > 0 then
        return value / count;
    else
        return 0;
    end
end

function opvp.MatchTeam:_connectSignals()
    if self:isTest() == false and self:hasPlayer() == true then
        opvp.event.PARTY_LOOT_METHOD_CHANGED:connect(self, self._onLootMethodChanged);
        opvp.event.PLAYER_DIFFICULTY_CHANGED:connect(self, self._onDifficultyChangedEvent);
        opvp.event.READY_CHECK:connect(self, self._onReadyCheck);
        opvp.event.READY_CHECK_CONFIRM:connect(self, self._onReadyCheckConfirm);
        opvp.event.READY_CHECK_FINISHED:connect(self, self._onReadyCheckFinished);
    end
end

function opvp.MatchTeam:_disconnectSignals()
    if self:isTest() == false and self:hasPlayer() == true then
        opvp.event.PARTY_LOOT_METHOD_CHANGED:disconnect(self, self._onLootMethodChanged);
        opvp.event.PLAYER_DIFFICULTY_CHANGED:disconnect(self, self._onDifficultyChangedEvent);
        opvp.event.READY_CHECK:disconnect(self, self._onReadyCheck);
        opvp.event.READY_CHECK_CONFIRM:disconnect(self, self._onReadyCheckConfirm);
        opvp.event.READY_CHECK_FINISHED:disconnect(self, self._onReadyCheckFinished);
    end
end

function opvp.MatchTeam:_onInitialized()
    self._dampening_found = false;

    if self:isHostile() == true then
        self:_setActive(true);

        self._dampening = false;
    else
        self._dampening = self._match:hasDampening();
    end
end

function opvp.MatchTeam:_onMemberAuraUpdate(member, aurasAdded, aurasUpdated, aurasRemoved, fullUpdate)
    opvp.Party._onMemberAuraUpdate(
        self,
        member,
        aurasAdded,
        aurasUpdated,
        aurasRemoved,
        fullUpdate
    );

    if self._dampening == false or self._match:isActive() == false then
        return;
    end

    local aura;

    if self._dampening_found == false then
        aura = aurasAdded:findOneBySpellId(110310);

        if aura ~= nil then
            self._match:_setDampening(aura:applications() / 100.0);

            self._dampening_found = true;

            return;
        end
    end

    aura = aurasUpdated:findOneBySpellId(110310);

    if aura ~= nil then
        self._match:_setDampening(aura:applications() / 100.0);

        self._dampening_found = true;

        return;
    end
end

function opvp.MatchTeam:_onMemberInfoUpdate(member, mask)
    opvp.Party._onMemberInfoUpdate(self, member, mask);

    opvp.match.playerInfoUpdate:emit(member, mask);

    if member:isPlayer() == true then
        return;
    end

    if bit.band(mask, opvp.PartyMember.DEAD_FLAG) ~= 0 then
        if member:isDead() == true then
            opvp.printMessageOrDebug(
                (
                    self:isFriendly()
                    and opvp.options.announcements.friendlyParty.memberDeath:value()
                    or opvp.options.announcements.hostileParty.memberDeath:value()
                ),
                opvp.strs.MATCH_PLAYER_DIED,
                self:identifierMemberName(),
                member:nameOrId(member:isSpecKnown(), true)
            );
        end
    end
end

function opvp.MatchTeam:_onMemberSpecUpdate(member, newSpec, oldSpec)
    opvp.Party._onMemberSpecUpdate(self, member, newSpec, oldSpec);

    if member:isPlayer() == true or newSpec == oldSpec then
        return;
    end

    opvp.printMessageOrDebug(
        (
            self:isFriendly()
            and opvp.options.announcements.friendlyParty.memberSpecUpdate:value()
            or opvp.options.announcements.hostileParty.memberSpecUpdate:value()
        ),
        opvp.strs.MATCH_PLAYER_SPEC_CHANGED,
        self:identifierMemberName(),
        member:nameOrId(false, true),
        member:classInfo():color():GenerateHexColor(),
        member:specInfo():name(),
        member:classInfo():name()
    );
end

function opvp.MatchTeam:_onMemberSpellInterrupted(
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
    opvp.Party._onMemberSpellInterrupted(
        self,
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
    );

    local do_msg = (
        self:isFriendly()
        and (opvp.options.announcements.friendlyParty.memberSpellInterrupted:value() and opvp.options.announcements.friendlyParty.memberSpellInterruptedRole:isRoleEnabled(member:role()))
        or (opvp.options.announcements.hostileParty.memberSpellInterrupted:value() and opvp.options.announcements.hostileParty.memberSpellInterruptedRole:isRoleEnabled(member:role()))
    );

    local msg;

    if castProgress > 0 then
        if member:isPlayer() == true then
            msg = opvp.strs.MATCH_SELF_SPELL_INTERRUPTED_WITH_TIME;
        else
            msg = opvp.strs.MATCH_PLAYER_SPELL_INTERRUPTED_WITH_TIME;
        end
    else
        if member:isPlayer() == true then
            msg = opvp.strs.MATCH_SELF_SPELL_INTERRUPTED;
        else
            msg = opvp.strs.MATCH_PLAYER_SPELL_INTERRUPTED;
        end
    end

    opvp.printMessageOrDebug(
        do_msg,
        msg,
        self:identifierMemberName(),
        member:nameOrId(member:isSpecKnown(), true),
        opvp.spell.link(extraSpellId),
        castProgress,
        castLength
    );

    opvp.match.playerSpellInterrupted:emit(
        member,
        sourceName,
        sourceGUID,
        spellId,
        spellName,
        spellSchool,
        extraSpellId,
        extraSpellName,
        extraSpellSchool
    );
end

function opvp.MatchTeam:_onMemberPvpTrinketUpdate(member, mask)
    if self._match:isActive() == true then
        local cls = member:classInfo();
        local trinket_state = member:pvpTrinketState();
        local do_msg = (
            self:isHostile()
            and opvp.options.announcements.hostileParty.memberTrinketOffCooldown:value()
            or opvp.options.announcements.friendlyParty.memberTrinketOffCooldown:value()
        );

        if (
            bit.band(mask, opvp.PvpTrinketUpdate.RACIAL_COOLDOWN) ~= 0 and
            trinket_state:isRacialOffCooldown() == true and
            member:isPlayer() == false
        ) then

            opvp.printMessageOrDebug(
                do_msg,
                opvp.strs.MATCH_TRINKET_RACIAL_OFF_CD,
                self:identifierMemberName(),
                member:nameOrId(member:isSpecKnown(), true)
            );
        end

        if (
            bit.band(mask, opvp.PvpTrinketUpdate.TRINKET_COOLDOWN) ~= 0 and
            trinket_state:isTrinketOffCooldown() == true and
            member:isPlayer() == false
        ) then
            opvp.printMessageOrDebug(
                do_msg,
                opvp.strs.MATCH_TRINKET_OFF_CD,
                self:identifierMemberName(),
                member:nameOrId(member:isSpecKnown(), true)
            );
        end

        --~ opvp.printWarning(
            --~ "opvp.MatchTeam:_onMemberTrinketUpdate(%s, %d), racial=%s, trinket=%s, racial_cd=%s, trinket_cd=%s",
            --~ member:nameOrId(),
            --~ mask,
            --~ tostring(trinket_state:hasRacial()),
            --~ tostring(trinket_state:hasTrinket()),
            --~ tostring(trinket_state:hasRacial() and not trinket_state:isRacialOffCooldown()),
            --~ tostring(trinket_state:hasTrinket() and not trinket_state:isTrinketOffCooldown())
        --~ );
    end

    opvp.match.playerTrinketUpdate:emit(member, mask);
end

function opvp.MatchTeam:_onMemberPvpTrinketUsed(member, spellId, timestamp)
    local cls = member:classInfo();

    local do_msg = (
        self:isHostile()
        and opvp.options.announcements.hostileParty.memberTrinket:value()
        or opvp.options.announcements.friendlyParty.memberTrinket:value()
    );

    if member:isPlayer() == false then
        opvp.printMessageOrDebug(
            do_msg,
            opvp.strs.MATCH_TRINKET_USED,
            self:identifierMemberName(),
            member:nameOrId(member:isSpecKnown(), true)
        );
    end

    opvp.match.playerTrinket:emit(member, spellId, timestamp);
end

function opvp.MatchTeam:_onRosterBeginUpdate()
    opvp.Party._onRosterBeginUpdate(self);

    opvp.match.rosterBeginUpdate:emit(self);
end

function opvp.MatchTeam:_onRosterEndUpdate(newMembers, updatedMembers, removedMembers)
    opvp.Party._onRosterEndUpdate(self, newMembers, updatedMembers, removedMembers);

    opvp.match.rosterEndUpdate:emit(self, newMembers, updatedMembers, removedMembers);

    local do_msg1, do_msg2;

    if self:isFriendly() == true then
        do_msg1 = opvp.options.announcements.friendlyParty.memberJoinLeave:value();
        do_msg2 = opvp.options.announcements.friendlyParty.memberSpecUpdate:value();
    else
        do_msg1 = opvp.options.announcements.hostileParty.memberJoinLeave:value();
        do_msg2 = opvp.options.announcements.hostileParty.memberSpecUpdate:value();
    end

    local member;

    for n=1, #removedMembers do
        member = removedMembers[n];

        member:_setTeam(nil);

        if member:isPlayer() == false then
            opvp.printMessageOrDebug(
                do_msg1,
                opvp.strs.MATCH_PLAYER_LEAVE,
                self:identifierMemberName(),
                member:nameOrId(member:isSpecKnown())
            );
        end
    end

    for n=1, #newMembers do
        member = newMembers[n];

        member:_setTeam(self);

        if member:isPlayer() == false then
            opvp.printMessageOrDebug(
                do_msg2,
                opvp.strs.MATCH_PLAYER_JOINED,
                self:identifierMemberName(),
                member:nameOrId(member:isSpecKnown())
            );
        end
    end
end

function opvp.MatchTeam:_onShutdown()
end

function opvp.MatchTeam:_setId(id)
    self._id = id;
end

function opvp.MatchTeam:_setMatch(match)
    self._match = match;
end

function opvp.MatchTeam:_setWinner(state)
    self._winner = state;
end
