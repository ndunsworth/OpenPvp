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

    self._match     = match;
    self._id        = 0;
    self._mmr       = 0;
    self._mmr_gain  = 0;
    self._cr        = 0;
    self._cr_gain   = 0;
end

function opvp.MatchTeam:cr()
    return self._cr;
end

function opvp.MatchTeam:crGain()
    return self._cr_gain;
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

function opvp.MatchTeam:mmr()
    return self._mmr;
end

function opvp.MatchTeam:mmrGain()
    return self._mmr_gain;
end

function opvp.MatchTeam:_initialize(category, guid)
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

function opvp.MatchTeam:_onMemberInfoUpdate(member, mask)
    if member:isPlayer() == false then
        if bit.band(mask, opvp.PartyMember.SPEC_FLAG) ~= 0 then
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
        elseif bit.band(mask, opvp.PartyMember.DEAD_FLAG) ~= 0 then
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

    opvp.Party._onMemberInfoUpdate(self, member, mask);

    opvp.match.playerInfoUpdated:emit(self, member, mask);
end

function opvp.MatchTeam:_onRosterEndUpdate(newMembers, updatedMembers, removedMembers)
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

    opvp.match.playerRosterUpdated:emit(self, newMembers, updatedMembers, removedMembers);

    opvp.Party._onRosterEndUpdate(self, newMembers, updatedMembers, removedMembers);
end

function opvp.MatchTeam:_setCR(rating)
    self._cr = rating;
end

function opvp.MatchTeam:_setId(id)
    self._id = id;
end

function opvp.MatchTeam:_setCRGain(value)
    self._cr_gain = value;
end

function opvp.MatchTeam:_setMatch(match)
    self._match = match;
end

function opvp.MatchTeam:_setMMR(rating)
    self._mmr = rating;
end

function opvp.MatchTeam:_setMMRGain(value)
    self._mmr_gain = rating;
end
