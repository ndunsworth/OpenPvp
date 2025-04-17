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

function opvp.MatchTeam:_initialize(category, guid)
    self._dampening_found = false;
    self._dampening_found = self._match:hasDampening();

    opvp.Party._initialize(self, category, guid);

    if self:isHostile() == true then
        self:_setActive(true);
    end
end

function opvp.MatchTeam:_onDifficultyChanged(mask)
    --~ if self:isFriendly() == true then
        --~ local do_msg = opvp.options.announcements.friendlyParty.difficultyChanged:value();
        --~ local name;

        --~ if bit.band(mask, opvp.PartyDifficultyType.DUNGEON) ~= 0 then
            --~ name = GetDifficultyInfo(self:dungeonDifficulty());

            --~ if name ~= nil then
                --~ opvp.printMessageOrDebug(
                    --~ do_msg,
                    --~ opvp.strs.MATCH_DUNGEON_DIFF_CHANGED,
                    --~ name
                --~ );
            --~ end
        --~ end

        --~ if bit.band(mask, opvp.PartyDifficultyType.RAID) ~= 0 then
            --~ name = GetDifficultyInfo(self:raidDifficulty());

            --~ if name ~= nil then
                --~ opvp.printMessageOrDebug(
                    --~ do_msg,
                    --~ opvp.strs.MATCH_RAID_DIFF_CHANGED,
                    --~ name
                --~ );
            --~ end
        --~ end

        --~ if bit.band(mask, opvp.PartyDifficultyType.RAID_LEGACY) ~= 0 then
            --~ name = GetDifficultyInfo(self:legacyRaidDifficulty());

            --~ if name ~= nil then
                --~ opvp.printMessageOrDebug(
                    --~ do_msg,
                    --~ opvp.strs.MATCH_RAID_LEGACY_DIFF_CHANGED,
                    --~ name
                --~ );
            --~ end
        --~ end
    --~ end

    opvp.Party._onDifficultyChanged(self, mask);
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
        for n=1, #aurasAdded do
            aura = aurasAdded[n];

            if aura:spellId() == 110310 then
                self._match:_setDampening(aura:applications() / 100.0);

                self._dampening_found = true;

                return;
            end
        end
    end

    for n=1, #aurasUpdated do
        aura = aurasUpdated[n];

        if aura:spellId() == 110310 then
            self._match:_setDampening(aura:applications() / 100.0);

            if self._dampening_found == false then
                self._dampening_found = true;
            end

            return;
        end
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

function opvp.MatchTeam:_setId(id)
    self._id = id;
end

function opvp.MatchTeam:_setMatch(match)
    self._match = match;
end

function opvp.MatchTeam:_setWinner(state)
    self._winner = state;
end
