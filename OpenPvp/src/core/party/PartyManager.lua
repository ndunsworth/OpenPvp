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

opvp.PartyManager = opvp.CreateClass(opvp.Object);

function opvp.PartyManager:__del__()
    self._party_home:_setSocket(self._socket);
    self._party_inst:_setSocket(self._socket);

    self._socket:disconnect();
end

function opvp.PartyManager:init(guid)
    self._party           = {opvp.private.PartyPriv(), opvp.private.PartyPriv()};
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
    self._socket          = opvp.Socket(opvp.LIB_NAME);
    self._aura_server     = opvp.AuraServer();
    self._cc_tracker      = opvp.CrowdControlTracker();
    self._cbt_lvl_tracker = opvp.CombatLevelTracker();

    self._aura_server:initialize();

    self._cc_tracker:connect(self._aura_server);
    self._cbt_lvl_tracker:connect(self._aura_server);

    self._socket:connect();

    self._countdown_timer.timeout:connect(self, self._onCountdownUpdate);

    opvp.event.GROUP_FORMED:connect(self, self._onGroupFormed);
    opvp.event.GROUP_JOINED:connect(self, self._onGroupJoined);
    opvp.event.GROUP_LEFT:connect(self, self._onGroupLeft);
    opvp.event.START_PLAYER_COUNTDOWN:connect(self, self._onCountdownBegin);
    opvp.event.CANCEL_PLAYER_COUNTDOWN:connect(self, self._onCountdownCanceled);

    opvp.OnLoadingScreenEnd:connect(self, self._onLoginReload);

    opvp.OnLogout:connect(self, self._onLogout);

    self._cc_tracker.memberCrowdControlAdded:connect(opvp.party.memberCrowdControlAdded);
    self._cc_tracker.memberCrowdControlRemoved:connect(opvp.party.memberCrowdControlRemoved);

    self._cbt_lvl_tracker.memberDefensiveAdded:connect(opvp.party.memberDefensiveAdded);
    self._cbt_lvl_tracker.memberDefensiveLevelUpdate:connect(opvp.party.memberDefensiveLevelUpdate);
    self._cbt_lvl_tracker.memberDefensiveRemoved:connect(opvp.party.memberDefensiveRemoved);

    self._cbt_lvl_tracker.memberOffensiveAdded:connect(opvp.party.memberOffensiveAdded);
    self._cbt_lvl_tracker.memberOffensiveLevelUpdate:connect(opvp.party.memberOffensiveLevelUpdate);
    self._cbt_lvl_tracker.memberOffensiveRemoved:connect(opvp.party.memberOffensiveRemoved);
end

function opvp.PartyManager:auraServer()
    return self._aura_server;
end

function opvp.PartyManager:ccTracker()
    return self._cc_tracker;
end

function opvp.PartyManager:combatLevelTracker()
    return self._cbt_lvl_tracker;
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
        return party:members();
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
    opvp.printDebug(
        "opvp.PartyManager:_onGroupFormed(%d, %s), party_home=%s, party_inst=%s",
        category,
        guid,
        tostring(self._party_home),
        tostring(self._party_inst)
    );

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
    opvp.printDebug(
        "opvp.PartyManager:_onGroupJoined(%d, %s), party_home=%s, party_inst=%s",
        category,
        guid,
        tostring(self._party_home),
        tostring(self._party_inst)
    );

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

            self._aura_server:removeParty(self._party_cur);
        end

        self._party_cur = party;

        self._aura_server:addParty(self._party_cur);
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
    opvp.printDebug(
        "opvp.PartyManager:_onGroupLeft(%d, %s), party_home=%s, party_inst=%s",
        category,
        guid,
        tostring(self._party_home),
        tostring(self._party_inst)
    );

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
        if self._party_home == nil then
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
        end
    else
        opvp.private.state.party.homeGuid:setValue("");
    end

    if opvp.party.utils.isInGroup(opvp.PartyCategory.INSTANCE) == true then
        if self._party_inst == nil then
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
        end
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
