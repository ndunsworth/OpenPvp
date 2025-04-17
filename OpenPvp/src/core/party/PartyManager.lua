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

opvp.PartyPriv = opvp.CreateClass(opvp.Party);

function opvp.PartyPriv:init()
    opvp.Party.init(self);
end

function opvp.PartyPriv:_onDifficultyChanged(mask)
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

function opvp.PartyPriv:_onMemberInfoUpdate(member, mask)
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

function opvp.PartyPriv:_onMemberSpecUpdate(member, newSpec, oldSpec)
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

function opvp.PartyPriv:_onPartyTypeChanged(newPartyType, oldPartyType)
    local do_msg = opvp.options.announcements.friendlyParty.typeChanged:value();

    if newPartyType == opvp.PartyType.PARTY then
        opvp.printMessageOrDebug(do_msg, opvp.strs.PARTY_CHANGED_TO_PARTY, self:identifierName());
    else
        opvp.printMessageOrDebug(do_msg, opvp.strs.PARTY_CHANGED_TO_RAID, self:identifierName());
    end

    opvp.Party._onPartyTypeChanged(self, newPartyType, oldPartyType);
end

function opvp.PartyPriv:_onRosterEndUpdate(newMembers, updatedMembers, removedMembers)
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

opvp.PartyManager = opvp.CreateClass();

function opvp.PartyManager:init(guid)
    self._party           = {opvp.PartyPriv(), opvp.PartyPriv()};
    self._party_home      = nil;
    self._party_inst      = nil;
    self._party_cur       = nil;
    self._party_use       = nil;
    self._is_reloading    = 0;
    self._countdown       = false;
    self._countdown_unit  = "";
    self._countdown_name  = "";
    self._countdown_time  = 0;
    self._countdown_timer = opvp.Timer(1);
    self._socket          = opvp.Socket("OpenPvp");
    --~ self._aura_tracker    = opvp.PartyAuraTracker();
    self._aura_tracker    = opvp.MatchAuraTracker();

    self._aura_tracker:initialize();

    self._socket:connect();

    self._countdown_timer.timeout:connect(self, self._onCountdownUpdate);

    opvp.event.GROUP_FORMED:connect(self, self._onGroupFormed);
    opvp.event.GROUP_JOINED:connect(self, self._onGroupJoined);
    opvp.event.GROUP_LEFT:connect(self, self._onGroupLeft);
    opvp.event.START_PLAYER_COUNTDOWN:connect(self, self._onCountdownBegin);
    opvp.event.CANCEL_PLAYER_COUNTDOWN:connect(self, self._onCountdownCanceled);

    opvp.OnLoadingScreenEnd:connect(self, self._onLoginReload);

    opvp.OnLogout:connect(self, self._onLogout);
end

function opvp.PartyManager:auraTracker()
    return self._aura_tracker;
end

function opvp.PartyManager:findMemberByGuid(guid, category)
    local party = self:party(category)

    if party ~= nil then
        return party:findMemberByGuid(guid);
    else
        return nil;
    end
end

function opvp.PartyManager:findMemberByUnitId(unitId, category)
    local party = self:party(category)

    if party ~= nil then
        return party:findMemberByUnitId(unitId);
    else
        return nil;
    end
end

function opvp.PartyManager:hasParty(category)
    if category == nil then
        return self._party_cur ~= nil;
    elseif category == opvp.PartyCategory.HOME then
        return self._party_home ~= nil;
    elseif category == opvp.PartyCategory.INSTANCE then
        return self._party_inst ~= nil;
    else
        return false;
    end
end

function opvp.PartyManager:hasHomeParty()
    return self._party_home ~= nil;
end

function opvp.PartyManager:hasInstanceParty()
    return self._party_inst ~= nil;
end

function opvp.PartyManager:home()
    return self._party_home;
end

function opvp.PartyManager:instance()
    return self._party_inst;
end

function opvp.PartyManager:isReloading(category)
    if category == nil then
        return self._is_reloading ~= 0;
    else
        return self._is_reloading == category;
    end
end

function opvp.PartyManager:isCountingDown()
    return self._countdown;
end

function opvp.PartyManager:logInfo()
    if self._party_cur ~= nil then
        self._party_cur:logInfo();
    end
end

function opvp.PartyManager:member(index, category)
    local party = self:party(category)

    if party ~= nil then
        return party:member(index);
    else
        return nil;
    end
end

function opvp.PartyManager:members(category)
    local party = self:party(category);

    if party ~= nil then
        return party:memebers();
    else
        return {};
    end
end

function opvp.PartyManager:party(category)
    if category == opvp.PartyCategory.HOME then
        return self._party_home;
    elseif category == opvp.PartyCategory.INSTANCE then
        return self._party_inst;
    else
        return self._party_cur;
    end
end

function opvp.PartyManager:size(category)
    local party;

    if category == nil then
        party = self._party_cur;
    else
        party = self:party(category);
    end

    if party ~= nil then
        return party:size();
    else
        return 0;
    end
end

function opvp.PartyManager:_onCountdownBegin(initiatedBy, timeRemaining, totalTime, informChat, initiatedByName)
    if self._countdown_timer:isActive() == true then
        self:_onCountdownCanceled(
            self._countdown_unit,
            false,
            self._countdown_name
        );
    end

    self._countdown      = true;
    self._countdown_unit = initiatedBy;
    self._countdown_name = initiatedByName;
    self._countdown_time = totalTime;

    self._countdown_timer:setTriggerLimit(timeRemaining);

    self._countdown_timer:start();

    opvp.printMessageOrDebug(
        opvp.options.announcements.friendlyParty.pullTimer:value(),
        opvp.strs.PULL_TIMER_STARTED,
        opvp.time.formatSeconds(totalTime),
        self._countdown_name
    );

    opvp.party.countdown:emit(self._countdown_unit, timeRemaining, self._countdown_time);
end

function opvp.PartyManager:_onCountdownUpdate()
    if self._countdown_timer:remainingTriggers() > 0 then
        opvp.printMessageOrDebug(
            opvp.options.announcements.friendlyParty.pullTimer:value(),
            opvp.strs.PULL_TIMER_UPDATE,
            self._countdown_timer:remainingTriggers()
        );
    else
        opvp.printMessageOrDebug(
            opvp.options.announcements.friendlyParty.pullTimer:value(),
            opvp.strs.PULL_TIMER_ENDED
        );
    end

    opvp.party.countdown:emit(
        self._countdown_unit,
        self._countdown_name,
        self._countdown_timer:remainingTriggers(),
        self._countdown_time
    );
end

function opvp.PartyManager:_onCountdownCanceled(initiatedBy, informChat, initiatedByName)
    opvp.printMessageOrDebug(
        opvp.options.announcements.friendlyParty.pullTimer:value(),
        opvp.strs.PULL_TIMER_CANCELED
    );

    self._countdown_timer:stop();

    self._countdown = false;

    opvp.party.countdown:emit(
        self._countdown_unit,
        self._countdown_name,
        -1,
        self._countdown_time
    );
end

function opvp.PartyManager:_onGroupFormed(category, guid)
    local party = self:party(category);

    if party == nil then
        return;
    end

    opvp.printMessageOrDebug(
        opvp.options.announcements.friendlyParty.joinLeave:value(),
        opvp.strs.PARTY_FORMED,
        self._party_cur:identifierName()
    );

    opvp.party.formed:emit(party);
end

function opvp.PartyManager:_onGroupJoined(category, guid)
    self._party_use = nil;

    opvp.party.aboutToJoin:emit(category, guid);

    local party;

    if self._party_use ~= nil then
        party = self._party_use;

        self._party_use = nil;
    else
        if category == opvp.PartyCategory.HOME then
            party = self._party[1];
        elseif category == opvp.PartyCategory.INSTANCE then
            party = self._party[2];
        else
            return;
        end
    end

    if category == opvp.PartyCategory.HOME then
        assert(self._party_home == nil);

        --~ if self._party_home ~= nil then
            --~ self._party_home:shutdown();
        --~ end

        self._party_home = party;

        opvp.private.state.party.homeGuid:setValue(guid);
    elseif category == opvp.PartyCategory.INSTANCE then
        assert(self._party_inst == nil);

        --~ if self._party_inst ~= nil then
            --~ self._party_inst:shutdown();
        --~ end

        self._party_inst = party;

        opvp.private.state.party.instanceGuid:setValue(guid);
    else
        return;
    end

    if (
        self._party_cur == nil or
        category == opvp.PartyCategory.INSTANCE
    ) then
        if self._party_cur ~= nil then
            self._party_cur:_setActive(false);

            self._party_cur:_setSocket(nil);

            self._aura_tracker:_removeParty(self._party_cur);
        end

        self._party_cur = party;

        self._aura_tracker:_addParty(self._party_cur);
    end

    opvp.printMessageOrDebug(
        opvp.options.announcements.friendlyParty.joinLeave:value(),
        opvp.strs.PARTY_JOINED,
        self._party_cur:identifierName()
    );

    party:_setSocket(self._socket);

    party:initialize(category, guid);

    party:_setActive(true);

    opvp.party.joined:emit(party);
end

function opvp.PartyManager:_onGroupLeft(category, guid)
    local party;

    if category == opvp.PartyCategory.HOME then
        if self._party_home ~= nil then
            party = self._party_home;

            self._party_home = nil;

            opvp.private.state.party.homeGuid:setValue("");
        end
    elseif category == opvp.PartyCategory.INSTANCE then
        if self._party_inst ~= nil then
            party = self._party_inst;

            if self._party_inst == self._party_cur then
                self._party_cur = self._party_home;
            end

            self._party_inst = nil;

            opvp.private.state.party.instanceGuid:setValue("");
        end
    end

    if party == nil then
        return;
    end

    opvp.printMessageOrDebug(
        opvp.options.announcements.friendlyParty.joinLeave:value(),
        opvp.strs.PARTY_LEAVE,
        party:identifierName()
    );

    if party:isActive() == true then
        party:_setActive(false);
    end

    party:shutdown();

    party:_setSocket(nil);

    self._socket:clear();

    if (
        self._party_cur ~= nil and
        self._party_cur:category() == opvp.PartyCategory.HOME
    ) then
        self._party_cur:_setSocket(self._socket);

        self._party_cur:_setActive(true);
    end

    opvp.party.left:emit(party);
end

function opvp.PartyManager:_onInviteConfirmation()
end

function opvp.PartyManager:_onLoginReload()
    if opvp.party.utils.isInGroup(opvp.PartyCategory.HOME) == true then
        self._is_reloading = opvp.PartyCategory.HOME;

        local guid = opvp.private.state.party.homeGuid:value();

        if guid == "" then
            guid = "HomePartyUnknown";
        end

        self:_onGroupJoined(
            opvp.PartyCategory.HOME,
            guid
        );

        self._is_reloading = 0;
    else
        opvp.private.state.party.homeGuid:setValue("");
    end

    if opvp.party.utils.isInGroup(opvp.PartyCategory.INSTANCE) == true then
        self._is_reloading = opvp.PartyCategory.INSTANCE;

        local guid = opvp.private.state.party.instanceGuid:value();

        if guid == "" then
            guid = "InstancePartyUnknown";
        end

        self:_onGroupJoined(
            opvp.PartyCategory.INSTANCE,
            guid
        );

        self._is_reloading = 0;
    else
        opvp.private.state.party.instanceGuid:setValue("");
    end
end

function opvp.PartyManager:_onLogout()
    if self._party_home ~= nil then
        opvp.private.state.party.homeGuid:setValue(self._party_home:guid());
    end

    if self._party_inst ~= nil then
        opvp.private.state.party.instanceGuid:setValue(self._party_inst:guid());
    end
end

function opvp.PartyManager:_setParty(party)
    self._party_use = party;
end
