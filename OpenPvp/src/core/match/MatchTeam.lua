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

local function opvp_member_type_name(member)
    if member:isHostile() == true then
        return opvp.strs.MATCH_HOSTILE_PLAYER;
    else
        return opvp.strs.MATCH_FRIENDLY_PLAYER;
    end
end

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

    self._provider.memberTrinketUpdate:connect(
        self,
        self._onMemberTrinketUpdate
    );

    self._provider.memberTrinketUsed:connect(
        self,
        self._onMemberTrinketUsed
    );
end

function opvp.MatchTeam:_disconnectSignals()
    if self:isTest() == false and self:hasPlayer() == true then
        opvp.event.PARTY_LOOT_METHOD_CHANGED:disconnect(self, self._onLootMethodChanged);
        opvp.event.PLAYER_DIFFICULTY_CHANGED:disconnect(self, self._onDifficultyChangedEvent);
        opvp.event.READY_CHECK:disconnect(self, self._onReadyCheck);
        opvp.event.READY_CHECK_CONFIRM:disconnect(self, self._onReadyCheckConfirm);
        opvp.event.READY_CHECK_FINISHED:disconnect(self, self._onReadyCheckFinished);
    end

    self._provider.memberTrinketUpdate:disconnect(
        self,
        self._onMemberTrinketUpdate
    );

    self._provider.memberTrinketUsed:disconnect(
        self,
        self._onMemberTrinketUsed
    );
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
            local do_msg;

            if self:isFriendly() == true then
                do_msg = opvp.options.announcements.friendlyParty.memberDeath:value();
            else
                do_msg = opvp.options.announcements.hostileParty.memberDeath:value();
            end

            if member:isSpecKnown() == true then
                opvp.printMessageOrDebug(
                    do_msg,
                    opvp.strs.MATCH_PLAYER_DIED_WITH_SPEC,
                    opvp_member_type_name(member),
                    member:nameOrId(),
                    member:classInfo():color():GenerateHexColor(),
                    member:specInfo():name(),
                    member:classInfo():name()
                );
            else
                opvp.printMessageOrDebug(
                    do_msg,
                    opvp.strs.MATCH_PLAYER_DIED,
                    opvp_member_type_name(member),
                    member:nameOrId()
                );
            end
        end
    end
end

function opvp.MatchTeam:_onMemberSpecUpdate(member, newSpec, oldSpec)
    opvp.Party._onMemberSpecUpdate(self, member, newSpec, oldSpec);

    if member:isPlayer() == true or newSpec == oldSpec then
        return;
    end

    local do_msg;

    if self:isFriendly() == true then
        do_msg = opvp.options.announcements.friendlyParty.memberSpecUpdate:value();
    else
        do_msg = opvp.options.announcements.hostileParty.memberSpecUpdate:value();
    end

    opvp.printMessageOrDebug(
        do_msg,
        opvp.strs.MATCH_PLAYER_SPEC_CHANGED,
        opvp_member_type_name(member),
        member:nameOrId(),
        member:classInfo():color():GenerateHexColor(),
        member:specInfo():name(),
        member:classInfo():name()
    );
end

function opvp.MatchTeam:_onMemberTrinketUpdate(member)
    opvp.match.playerTrinketUpdate:emit(member);
end

function opvp.MatchTeam:_onMemberTrinketUsed(member, spellId, timestamp)
    local cls = member:classInfo();

    if member:isFriendly() == true then
        if member:isPlayer() == false then
            if member:isSpecKnown() == true then
                opvp.printMessageOrDebug(
                    opvp.options.announcements.friendlyParty.memberTrinket:value(),
                    opvp.strs.MATCH_TRINKET_USED_WITH_SPEC,
                    opvp.strs.MATCH_FRIENDLY_PLAYER,
                    member:nameOrId(),
                    cls:color():GenerateHexColor(),
                    member:specInfo():name(),
                    cls:colorString(cls:name())
                );
            else
                opvp.printMessageOrDebug(
                    opvp.options.announcements.friendlyParty.memberTrinket:value(),
                    opvp.strs.MATCH_TRINKET_USED,
                    opvp.strs.MATCH_FRIENDLY_PLAYER,
                    member:nameOrId(),
                    cls:color():GenerateHexColor(),
                    member:raceInfo():name(),
                    cls:colorString(cls:name())
                );
            end
        end
    else
        if member:isSpecKnown() == true then
            opvp.printMessageOrDebug(
                opvp.options.announcements.hostileParty.memberTrinket:value(),
                opvp.strs.MATCH_TRINKET_USED_WITH_SPEC,
                opvp.strs.MATCH_HOSTILE_PLAYER,
                member:nameOrId(),
                cls:color():GenerateHexColor(),
                member:specInfo():name(),
                cls:colorString(cls:name())
            );
        else
            opvp.printMessageOrDebug(
                opvp.options.announcements.hostileParty.memberTrinket:value(),
                opvp.strs.MATCH_TRINKET_USED,
                opvp.strs.MATCH_HOSTILE_PLAYER,
                member:nameOrId(),
                cls:color():GenerateHexColor(),
                member:raceInfo():name(),
                cls:colorString(cls:name())
            );
        end
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
            if member:isSpecKnown() == true then
                opvp.printMessageOrDebug(
                    do_msg1,
                    opvp.strs.MATCH_PLAYER_LEAVE_WITH_SPEC,
                    opvp_member_type_name(member),
                    member:nameOrId(),
                    member:classInfo():color():GenerateHexColor(),
                    member:specInfo():name(),
                    member:classInfo():name()
                );
            else
                opvp.printMessageOrDebug(
                    do_msg1,
                    opvp.strs.MATCH_PLAYER_LEAVE,
                    opvp_member_type_name(member),
                    member:nameOrId()
                );
            end
        end
    end

    for n=1, #newMembers do
        member = newMembers[n];

        member:_setTeam(self);

        if member:isPlayer() == false then
            if member:isSpecKnown() == true then
                opvp.printMessageOrDebug(
                    do_msg2,
                    opvp.strs.MATCH_PLAYER_JOINED_WITH_SPEC,
                    opvp_member_type_name(member),
                    member:nameOrId(),
                    member:classInfo():color():GenerateHexColor(),
                    member:specInfo():name(),
                    member:classInfo():name()
                );
            else
                opvp.printMessageOrDebug(
                    do_msg2,
                    opvp.strs.MATCH_PLAYER_JOINED,
                    opvp_member_type_name(member),
                    member:nameOrId()
                );
            end
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
