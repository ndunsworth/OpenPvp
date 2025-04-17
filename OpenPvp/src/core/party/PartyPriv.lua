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

opvp.private.PartyPriv = opvp.CreateClass(opvp.Party);

function opvp.private.PartyPriv:init()
    opvp.Party.init(self);
end

function opvp.private.PartyPriv:_onDifficultyChanged(mask)
    local do_msg = opvp.options.announcements.friendlyParty.difficultyChanged:value();
    local name;

    if bit.band(mask, opvp.PartyDifficultyType.DUNGEON) ~= 0 then
        name = GetDifficultyInfo(self:dungeonDifficulty());

        if name ~= nil then
            opvp.printMessageOrDebug(
                do_msg,
                opvp.strs.PARTY_DUNGEON_DIFF_CHANGED,
                self:identifierName(),
                name
            );
        end
    end

    if bit.band(mask, opvp.PartyDifficultyType.RAID) ~= 0 then
        name = GetDifficultyInfo(self:raidDifficulty());

        if name ~= nil then
            opvp.printMessageOrDebug(
                do_msg,
                opvp.strs.PARTY_RAID_DIFF_CHANGED,
                self:identifierName(),
                name
            );
        end
    end

    if bit.band(mask, opvp.PartyDifficultyType.RAID_LEGACY) ~= 0 then
        name = GetDifficultyInfo(self:legacyRaidDifficulty());

        if name ~= nil then
            opvp.printMessageOrDebug(
                do_msg,
                opvp.strs.PARTY_RAID_LEGACY_DIFF_CHANGED,
                self:identifierName(),
                name
            );
        end
    end

    opvp.Party._onDifficultyChanged(self, mask);
end

function opvp.private.PartyPriv:_onMemberInfoUpdate(member, mask)
    opvp.Party._onMemberInfoUpdate(self, member, mask);

    if member:isPlayer() == true then
        return;
    end

    if bit.band(mask, opvp.PartyMember.DEAD_FLAG) ~= 0 then
        if member:isDead() == true then
            local do_msg = opvp.options.announcements.friendlyParty.memberDeath:value();

            if member:isSpecKnown() == true then
                opvp.printMessageOrDebug(
                    do_msg,
                    opvp.strs.PARTY_MBR_DIED_WITH_SPEC,
                    self:identifierName(),
                    member:nameOrId(),
                    member:classInfo():color():GenerateHexColor(),
                    member:specInfo():name(),
                    member:classInfo():name()
                );
            else
                opvp.printMessageOrDebug(
                    do_msg,
                    opvp.strs.PARTY_MBR_DIED,
                    self:identifierName(),
                    member:nameOrId()
                );
            end
        end
    end
end

function opvp.private.PartyPriv:_onMemberSpecUpdate(member, newSpec, oldSpec)
    opvp.Party._onMemberSpecUpdate(self, member, newSpec, oldSpec);

    if member:isPlayer() == true or newSpec == oldSpec then
        return;
    end

    local do_msg = opvp.options.announcements.friendlyParty.memberSpecUpdate:value();

    opvp.printMessageOrDebug(
        do_msg,
        opvp.strs.PARTY_MBR_SPEC_CHANGED,
        self:identifierName(),
        member:nameOrId(),
        member:classInfo():color():GenerateHexColor(),
        member:specInfo():name(),
        member:classInfo():name()
    );
end

function opvp.private.PartyPriv:_onPartyTypeChanged(newPartyType, oldPartyType)
    local do_msg = opvp.options.announcements.friendlyParty.typeChanged:value();

    if newPartyType == opvp.PartyType.PARTY then
        opvp.printMessageOrDebug(do_msg, opvp.strs.PARTY_CHANGED_TO_PARTY, self:identifierName());
    else
        opvp.printMessageOrDebug(do_msg, opvp.strs.PARTY_CHANGED_TO_RAID, self:identifierName());
    end

    opvp.Party._onPartyTypeChanged(self, newPartyType, oldPartyType);
end

function opvp.private.PartyPriv:_onRosterEndUpdate(newMembers, updatedMembers, removedMembers)
    local do_msg = opvp.options.announcements.friendlyParty.memberJoinLeave:value();

    local member;

    for n=1, #removedMembers do
        member = removedMembers[n];

        if member:isPlayer() == false then
            if member:isSpecKnown() == true then
                opvp.printMessageOrDebug(
                    do_msg,
                    opvp.strs.PARTY_MBR_LEAVE_WITH_SPEC,
                    self:identifierName(),
                    member:nameOrId(),
                    member:classInfo():color():GenerateHexColor(),
                    member:specInfo():name(),
                    member:classInfo():name()
                );
            else
                opvp.printMessageOrDebug(
                    do_msg,
                    opvp.strs.PARTY_MBR_LEAVE,
                    self:identifierName(),
                    member:nameOrId()
                );
            end
        end
    end

    for n=1, #newMembers do
        member = newMembers[n];

        if member:isPlayer() == false then
            if member:isSpecKnown() == true then
                opvp.printMessage(
                    do_msg,
                    opvp.strs.PARTY_MBR_JOINED_WITH_SPEC,
                    self:identifierName(),
                    member:nameOrId(),
                    member:classInfo():color():GenerateHexColor(),
                    member:specInfo():name(),
                    member:classInfo():name()
                );
            else
                opvp.printMessageOrDebug(
                    do_msg,
                    opvp.strs.PARTY_MBR_JOINED,
                    self:identifierName(),
                    member:nameOrId()
                );
            end
        end
    end

    opvp.Party._onRosterEndUpdate(self, newMembers, updatedMembers, removedMembers);
end
