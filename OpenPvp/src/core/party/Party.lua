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

opvp.PartyCategory = {
    HOME     = LE_PARTY_CATEGORY_HOME,
    INSTANCE = LE_PARTY_CATEGORY_INSTANCE
};

opvp.PartyDifficultyType = {
    DUNGEON      = 1,
    RAID         = 2,
    RAID_LEGACY  = 4
};

opvp.PartyType = {
    NONE  = 0,
    PARTY = 1,
    RAID  = 2
};

opvp.Party = opvp.CreateClass();

function opvp.Party:init()
    self._category         = opvp.PartyCategory.HOME;
    self._guid             = "";
    self._provider         = nil;
    self._socket           = nil;
    self._initialized      = false;
    self._owns_provider    = false;
    self._owns_connection  = false;
    self._suspended        = false;
    self._active           = false;
    self._dung_diff        = 1;
    self._raid_diff        = 14;
    self._raid_legacy_diff = 3;
    self._name             = "";
    self._spec_counter     = opvp.ClassSpecCounter();

    self.difficultyChanged      = opvp.Signal("opvp.Party.difficultyChanged");
    self.closed                 = opvp.Signal("opvp.Party.closed");
    self.closing                = opvp.Signal("opvp.Party.closing");
    self.initializing           = opvp.Signal("opvp.Party.initializing");
    self.initialized            = opvp.Signal("opvp.Party.initialized");
    self.leaderChanged          = opvp.Signal("opvp.Party.leaderChanged");
    self.lootMethodChanged      = opvp.Signal("opvp.Party.lootMethodChanged");
    self.memberAuraUpdate       = opvp.Signal("opvp.Party.memberAuraUpdate");
    self.memberInfoUpdate       = opvp.Signal("opvp.Party.memberInfoUpdate");
    self.memberKickEnded        = opvp.Signal("opvp.Party.memberKickEnded");
    self.memberKickStarted      = opvp.Signal("opvp.Party.memberKickStarted");
    self.memberRoleChanged      = opvp.Signal("opvp.Party.memberRoleChanged");
    self.memberSpecUpdate       = opvp.Signal("opvp.Party.memberSpecUpdate");
    self.memberSpellInterrupted = opvp.Signal("opvp.Party.memberSpellInterrupted");
    self.memberStatusChanged    = opvp.Signal("opvp.Party.memberStatusChanged");
    self.readyCheckBegin        = opvp.Signal("opvp.Party.readyCheckBegin");
    self.readyCheckConfirm      = opvp.Signal("opvp.Party.readyCheckConfirm");
    self.readyCheckFinished     = opvp.Signal("opvp.Party.readyCheckFinished");
    self.rosterBeginUpdate      = opvp.Signal("opvp.Party.rosterBeginUpdate");
    self.rosterEndUpdate        = opvp.Signal("opvp.Party.rosterEndUpdate");
    self.typeChanged            = opvp.Signal("opvp.Party.typeChanged");
end

function opvp.Party:affiliation()
    if self._provider ~= nil then
        return self._provider:affiliation();
    else
        return opvp.Affiliation.FRIENDLY;
    end
end

function opvp.Party:category()
    return self._category;
end

function opvp.Party:countdown(seconds)
    if self:hasPlayer() == true and self:isActive() == true then
        C_PartyInfo.DoCountdown(seconds);
    end
end

function opvp.Party:countdownCancel()
    self:countdown(0);
end

function opvp.Party:dungeonDifficulty()
    return self._dung_diff;
end

function opvp.Party:findMemberByGuid(guid)
    if self._provider ~= nil then
        return self._provider:findMemberByGuid(guid)
    else
        return nil;
    end
end

function opvp.Party:findMemberByUnitId(unitId)
    if self._provider ~= nil then
        return self._provider:findMemberByUnitId(unitId)
    else
        return nil;
    end
end

function opvp.Party:findMembersWithAura(spell)
    if self._provider ~= nil then
        return self._provider:findMembersWithAura(spell)
    else
        return {};
    end
end

function opvp.Party:guid()
    return self._guid;
end

function opvp.Party:hasPlayer()
    if self._provider ~= nil then
        return self._provider:hasPlayer()
    else
        return false;
    end
end

function opvp.Party:hasMemberProvider()
    return self._provider ~= nil;
end

function opvp.Party:identifierName()
    if self:isRaid() == true then
        return opvp.strs.RAID;
    else
        return opvp.strs.PARTY;
    end
end

function opvp.Party:initialize(category, guid)
    opvp.printDebug(
        "opvp.Party:initialize(category=%d, guid=%s)",
        category,
        tostring(guid)
    );

    if self._initialized == true then
        return;
    end

    self.initializing:emit(category, guid, self);

    self:_initialize(category, guid);

    self._initialized = true;

    self:_onInitialized();

    self.initialized:emit(category, guid, self);
end

function opvp.Party:inspectMemberByGuid(guid)
    if self._provider ~= nil then
        self._provider:inspectMemberByGuid(guid);
    end
end

function opvp.Party:inspectMemberByUnitId(unitId)
    if self._provider ~= nil then
        self._provider:inspectMemberByUnitId(unitId);
    end
end

function opvp.Party:isActive()
    return self._active;
end

function opvp.Party:isCrossFaction()
    if self._provider ~= nil then
        return self._provider:isCrossFaction()
    else
        return false;
    end
end

function opvp.Party:isEmpty()
    if self._provider ~= nil then
        return self._provider:isEmpty()
    else
        return true;
    end
end

function opvp.Party:isFull()
    if self._provider ~= nil then
        return self._provider:isFull()
    else
        return true;
    end
end

function opvp.Party.isGuidInGroup(guid)
    if self._provider ~= nil then
        return self._provider:isGuidInGroup(guid)
    else
        return false;
    end
end

function opvp.Party:isHome()
    return self._category == opvp.PartyCategory.HOME;
end

function opvp.Party:isInitialized()
    return self._initialized;
end

function opvp.Party:isInstance()
    return self._category == opvp.PartyCategory.INSTANCE;
end

function opvp.Party:isParty()
    if self._provider ~= nil then
        return self._provider:isParty()
    else
        return false;
    end
end

function opvp.Party:isRaid()
    if self._provider ~= nil then
        return self._provider:isRaid()
    else
        return false;
    end
end

function opvp.Party:isSuspended()
    return self._suspended;
end

function opvp.Party:isTest()
    if self._provider ~= nil then
        return self._provider:isTest()
    else
        return false;
    end
end

function opvp.Party:legacyRaidDifficulty()
    return self._raid_legacy_diff;
end

function opvp.Party:leave(prompt)
    if self:isTest() == false and self:hasPlayer() == true then
        opvp.party.utils.leave(self._category, prompt);
    end
end

function opvp.Party:logInfo()
    opvp.printMessage(opvp.strs.PARTY_INFO_HEADER, self:identifierName());

    if self:isEmpty() == true then
        opvp.printMessage(opvp.strs.PARTY_INFO_EMPTY, self:identifierName());
    end

    local members = self:members();
    local member;

    for n=1, #members do
        member = members[n];

        if member:isRaceKnown() == true then
            if member:isSpecKnown() == true then
                opvp.printMessage(
                    opvp.strs.PARTY_INFO_MEMBER_WITH_RACE_SPEC,
                    n,
                    member:nameOrId(),
                    member:raceInfo():name(),
                    member:classInfo():color():GenerateHexColor(),
                    member:specInfo():name(),
                    member:classInfo():name()
                );
            else
                opvp.printMessage(
                    opvp.strs.PARTY_INFO_MEMBER_WITH_RACE,
                    n,
                    member:nameOrId(),
                    member:raceInfo():name()
                );
            end
        elseif member:isSpecKnown() == true then
            opvp.printMessage(
                opvp.strs.PARTY_INFO_MEMBER_WITH_SPEC,
                n,
                member:nameOrId(),
                member:classInfo():color():GenerateHexColor(),
                member:specInfo():name(),
                member:classInfo():name()
            );
        else
            opvp.printMessage(
                opvp.strs.PARTY_INFO_MEMBER,
                n,
                member:nameOrId()
            );
        end
    end
end

function opvp.Party:member(index)
    if self._provider ~= nil then
        return self._provider:member(index);
    else
        return {};
    end
end

function opvp.Party:members()
    if self._provider ~= nil then
        return self._provider:members();
    else
        return {};
    end
end

function opvp.Party:minimumPlayerLevel()
    return opvp.party.utils.minimumPlayerLevel(self._category);
end

function opvp.Party:memberProvider()
    return self._provider;
end

function opvp.Party:name()
    if self._name == "" then
        return self:identifierName();
    else
        return self._name;
    end
end

function opvp.Party:player()
    if self._provider ~= nil then
        return self._provider:player()
    else
        return nil;
    end
end

function opvp.Party:raidDifficulty()
    return self._raid_diff;
end

function opvp.Party:readyCheck()
    if self:hasPlayer() == true and self:isActive() == true then
        DoReadyCheck();
    end
end

function opvp.Party:shutdown()
    opvp.printDebug(
        "opvp.Party:shutdown(category=%d, guid=%s)",
        self._category,
        self._guid
    );

    if self._initialized == false then
        return;
    end

    self.closing:emit(self);

    self:_shutdown();

    self._initialized = false;

    self:_onShutdown();

    self.closed:emit(self);
end

function opvp.Party:sendAddonMessage(msg, channel, target, priority)
    if self._socket ~= nil then
        self._socket:write(msg, channel, target, priority);
    end
end

function opvp.Party:sendPartyMessage(msg)
    if self:hasPlayer() == true and self:isActive() == true then
        SendChatMessage(msg, opvp.ChatType.PARTY);
    end
end

function opvp.Party:sendRaidMessage(msg)
    if self:hasPlayer() == true and self:isActive() == true then
        SendChatMessage(msg, opvp.ChatType.RAID);
    end
end

function opvp.Party:sendRaidWarning(msg)
    if self:hasPlayer() == true and self:isActive() == true then
        SendChatMessage(msg, opvp.ChatType.RAID_WARNING);
    end
end

function opvp.Party:setName(name)
    self._name = name;
end

function opvp.Party:size()
    if self._provider ~= nil then
        return self._provider:size();
    else
        return 0;
    end
end

function opvp.Party:specCounter()
    return self._spec_counter;
end

function opvp.Party:tokenExprGroup()
    if self._provider ~= nil then
        return self._provider:tokenExprGroup();
    else
        return "";
    end
end

function opvp.Party:tokenExprParty()
    if self._provider ~= nil then
        return self._provider:tokenExprParty();
    else
        return "";
    end
end

function opvp.Party:tokenGroup()
    if self._provider ~= nil then
        return self._provider:tokenGroup();
    else
        return "";
    end
end

function opvp.Party:tokenParty()
    if self._provider ~= nil then
        return self._provider:tokenParty();
    else
        return "";
    end
end

function opvp.Party:_connectSignals()
    if self:isTest() == false and self:hasPlayer() == true then
        opvp.event.PARTY_LOOT_METHOD_CHANGED:connect(self, self._onLootMethodChanged);
        opvp.event.PLAYER_DIFFICULTY_CHANGED:connect(self, self._onDifficultyChangedEvent);
        opvp.event.READY_CHECK:connect(self, self._onReadyCheck);
        opvp.event.READY_CHECK_CONFIRM:connect(self, self._onReadyCheckConfirm);
        opvp.event.READY_CHECK_FINISHED:connect(self, self._onReadyCheckFinished);
    end
end

function opvp.Party:_disconnectSignals()
    if self:isTest() == false and self:hasPlayer() == true then
        opvp.event.PARTY_LOOT_METHOD_CHANGED:disconnect(self, self._onLootMethodChanged);
        opvp.event.PLAYER_DIFFICULTY_CHANGED:disconnect(self, self._onDifficultyChangedEvent);
        opvp.event.READY_CHECK:disconnect(self, self._onReadyCheck);
        opvp.event.READY_CHECK_CONFIRM:disconnect(self, self._onReadyCheckConfirm);
        opvp.event.READY_CHECK_FINISHED:disconnect(self, self._onReadyCheckFinished);
    end
end

function opvp.Party:_initialize(category, guid)
    self._category         = category;
    self._guid             = guid;
    self._dung_diff        = GetDungeonDifficultyID();
    self._raid_diff        = GetRaidDifficultyID();
    self._raid_legacy_diff = GetLegacyRaidDifficultyID();

    if self._provider == nil then
        self:_setProvider(opvp.GenericPartyMemberProvider());
    end

    self._provider.leaderChanged:connect(self, self._onPartyLeaderChanged);
    self._provider.memberAuraUpdate:connect(self, self._onMemberAuraUpdate);
    self._provider.memberInfoUpdate:connect(self, self._onMemberInfoUpdate);
    self._provider.memberPvpTrinketUpdate:connect(self, self._onMemberPvpTrinketUpdate);
    self._provider.memberPvpTrinketUsed:connect(self, self._onMemberPvpTrinketUsed);
    self._provider.memberSpellInterrupted:connect(self, self._onMemberSpellInterrupted);
    self._provider.memberSpecUpdate:connect(self, self._onMemberSpecUpdate);
    self._provider.rosterBeginUpdate:connect(self, self._onRosterBeginUpdate);
    self._provider.rosterEndUpdate:connect(self, self._onRosterEndUpdate);
    self._provider.typeChanged:connect(self, self._onPartyTypeChanged);

    if self._provider:isConnected() == false then
        self._owns_connection = true;

        self._provider:connect(self._category, self._guid);
    else
        local members = self._provider:members();

        if #members > 0 then
            self:_onRosterBeginUpdate()

            self:_onRosterEndUpdate(members, {}, {});
        end
    end

    if self:hasPlayer() == true then
        local block = self.difficultyChanged:block(true);

        self:_onDifficultyChanged(7);

        self.difficultyChanged:block(block);
    end
end

function opvp.Party:_onActiveChanged(state)
    if state == true then
        self:_connectSignals();
    else
        self:_disconnectSignals();
    end
end

function opvp.Party:_onAddonMessageRecieved()
    self._socket:clear();
end

function opvp.Party:_onDifficultyChanged(mask)
    self.difficultyChanged:emit(mask);
end

function opvp.Party:_onDifficultyChangedEvent()
    local mask = 0;

    local id = GetDungeonDifficultyID();

    if id ~= self._dung_diff then
        self._dung_diff = id;

        mask = opvp.PartyDifficultyType.DUNGEON;
    end

    id = GetRaidDifficultyID();

    if id ~= self._raid_diff then
        self._raid_diff = id;

        mask = bit.bor(mask, opvp.PartyDifficultyType.RAID);
    end

    id = GetLegacyRaidDifficultyID();

    if id ~= self._raid_legacy_diff then
        self._raid_legacy_diff = id;

        mask = bit.bor(mask, opvp.PartyDifficultyType.RAID_LEGACY);
    end

    if mask ~= 0 then
        self:_onDifficultyChanged(mask);
    end
end

function opvp.Party:_onInitialized()
end

function opvp.Party:_onLootMethodChanged(state)
    self.lootMethodChanged:emit(state);
end

function opvp.Party:_onMemberAuraUpdate(member, aurasAdded, aurasUpdated, aurasRemoved, fullUpdate)
    self.memberAuraUpdate:emit(member, aurasAdded, aurasUpdated, aurasRemoved, fullUpdate);
end

function opvp.Party:_onMemberKickEnded()
    self.memberKickEnded:emit();
end

function opvp.Party:_onMemberKickStarted()
    self.memberKickStarted:emit();
end

function opvp.Party:_onMemberInfoUpdate(member, mask)
    self.memberInfoUpdate:emit(member, mask);
end

function opvp.Party:_onMemberPvpTrinketUpdate(member, mask)

end

function opvp.Party:_onMemberPvpTrinketUsed(member, spellId, timestamp)

end

function opvp.Party:_onMemberSpecUpdate(member, newSpec, oldSpec)
    self.memberSpecUpdate:emit(member, newSpec, oldSpec);
end

function opvp.Party:_onMemberSpellInterrupted(
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
    self.memberSpellInterrupted:emit(
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
end

function opvp.Party:_onPartyLeaderChanged(newLeader, oldLeader)
    self.leaderChanged:emit(newLeader, oldLeader);
end

function opvp.Party:_onPartyTypeChanged(newPartyType, oldPartyType)
    self.typeChanged:emit(newPartyType, oldPartyType);
end

function opvp.Party:_onReadyCheck(initiatorName, readyCheckTimeLeft)
    self.readyCheckBegin:emit(initiatorName, readyCheckTimeLeft);
end

function opvp.Party:_onReadyCheckConfirm(unitTarget, isReady)
    self.readyCheckConfirm:emit(unitTarget, isReady);
end

function opvp.Party:_onReadyCheckFinished(preempted)
    self.readyCheckFinished:emit(preempted);
end

function opvp.Party:_onRosterBeginUpdate()
    self.rosterBeginUpdate:emit(self);
end

function opvp.Party:_onRosterEndUpdate(newMembers, updatedMembers, removedMembers)
    for n=1, #newMembers do
        self._spec_counter:ref(newMembers[n]:specInfo());
    end

    for n=1, #removedMembers do
        self._spec_counter:deref(removedMembers[n]:specInfo());
    end

    self.rosterEndUpdate:emit(self, newMembers, updatedMembers, removedMembers);
end

function opvp.Party:_onShutdown()
end

function opvp.Party:_onSuspendChanged(state)
end

function opvp.Party:_setActive(state)
    if state ~= self._active then
        self._active = state;

        self:_onActiveChanged(state);
    end
end

function opvp.Party:_setProvider(provider)
    if self._initialized == true then
        --~ error
        return;
    end

    if provider ~= nil then
        if opvp.IsInstance(provider, opvp.PartyMemberProvider) == false then
            --~ error
            return;
        end

        if (
            provider:isConnected() == true and
            provider:id() ~= self._guid
        ) then
            --~ error
            return;
        end
    end

    if (
        (provider ~= nil and provider == self._provider) or
        provider == nil and self._owns_provider == true
    ) then
        return;
    end

    if provider == nil then
        provider = opvp.GenericPartyMemberProvider();

        self._owns_provider = true;
    else
        self._owns_provider = false;
    end

    self._provider = provider;
end

function opvp.Party:_setSocket(socket)
    if socket == self._socket then
        return;
    end

    if self._socket ~= nil then
        self._socket.readyRead:disconnect(self, self._onAddonMessageRecieved);
    end

    self._socket = socket;

    if self._socket ~= nil then
        self._socket.readyRead:connect(self, self._onAddonMessageRecieved);
    end
end

function opvp.Party:_shutdown()
    self:_disconnectSignals();

    if self._provider ~= nil then
        self._provider.leaderChanged:disconnect(self, self._onPartyLeaderChanged);
        self._provider.memberAuraUpdate:disconnect(self, self._onMemberAuraUpdate);
        self._provider.memberInfoUpdate:disconnect(self, self._onMemberInfoUpdate);
        self._provider.memberPvpTrinketUpdate:disconnect(self, self._onMemberPvpTrinketUpdate);
        self._provider.memberPvpTrinketUsed:disconnect(self, self._onMemberPvpTrinketUsed);
        self._provider.memberSpellInterrupted:disconnect(self, self._onMemberSpellInterrupted);
        self._provider.memberSpecUpdate:disconnect(self, self._onMemberSpecUpdate);
        self._provider.rosterBeginUpdate:disconnect(self, self._onRosterBeginUpdate);
        self._provider.rosterEndUpdate:disconnect(self, self._onRosterEndUpdate);
        self._provider.typeChanged:disconnect(self, self._onPartyTypeChanged);

        if self._owns_connection == true then
            self._provider:disconnect();

            self._owns_connection = false;
        end
    end

    self._spec_counter:clear();

    self._active = false;
end
