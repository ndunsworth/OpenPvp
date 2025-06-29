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

local opvp_party_mgr_singleton;

local opvp_party_members_cmp_lookup_default = {};

opvp_party_members_cmp_lookup_default[opvp.RoleType.HEALER + 1] = 0;
opvp_party_members_cmp_lookup_default[opvp.RoleType.TANK + 1]   = 1;
opvp_party_members_cmp_lookup_default[opvp.RoleType.DPS + 1]    = 2;
opvp_party_members_cmp_lookup_default[opvp.RoleType.NONE + 1]   = 3;

local function opvp_party_member_cmp_by_role(a, b, lookup)
    local a_role = lookup[a:role():id() + 1];
    local b_role = lookup[b:role():id() + 1];

    if a_role > b_role then
        return false;
    elseif a_role < b_role then
        return true;
    else
        return a:nameOrId() < b:nameOrId();
    end
end

local function opvp_party_member_cmp_by_role_stat(a, b, lookup)
    local a_role1 = a:role();
    local b_role1 = b:role();
    local a_role2 = lookup[a_role1:id() + 1];
    local b_role2 = lookup[b_role1:id() + 1];

    if a_role2 > b_role2 then
        return false;
    elseif a_role2 < b_role2 then
        return true;
    else
        local a_stat;
        local b_stat;

        if a_role1:isHealer() == true then
            a_stat = a:healing();
            b_stat = b:healing();
        else
            a_stat = a:damage();
            b_stat = b:damage();
        end

        if a_stat > b_stat then
            return true;
        elseif a_stat < b_stat then
            return false;
        else
            return a:nameOrId() < b:nameOrId();
        end
    end
end

local function opvp_party_member_cmp_by_stat_ascend(a, b, id)
    local a_stat = a:findStatById(id);
    local b_stat = b:findStatById(id);

    if a_stat == nil or b_stat == nil then
        return fals
    end

    local a_val = a_stat:value();
    local b_val = b_stat:value();

    if a_val > b_val then
        return false;
    elseif a_val < b_val then
        return true;
    else
        return a:nameOrId() < b:nameOrId();
    end
end

local function opvp_party_member_cmp_by_stat_descend(a, b, id)
    local a_stat = a:findStatById(id);
    local b_stat = b:findStatById(id);

    if a_stat == nil or b_stat == nil then
        return fals
    end

    local a_val = a_stat:value();
    local b_val = b_stat:value();

    if a_val < b_val then
        return false;
    elseif a_val > b_val then
        return true;
    else
        return a:nameOrId() < b:nameOrId();
    end
end

opvp.party = {};

opvp.party.aboutToJoin                = opvp.Signal("opvp.party.aboutToJoin");
opvp.party.formed                     = opvp.Signal("opvp.party.formed");
opvp.party.joined                     = opvp.Signal("opvp.party.joined");
opvp.party.left                       = opvp.Signal("opvp.party.left");
opvp.party.memberDefensiveAdded       = opvp.Signal("opvp.party.memberDefensiveAdded");
opvp.party.memberDefensiveRemoved     = opvp.Signal("opvp.party.memberDefensiveRemoved");
opvp.party.memberDefensiveLevelUpdate = opvp.Signal("opvp.party.memberDefensiveLevelUpdate");
opvp.party.memberOffensiveAdded       = opvp.Signal("opvp.party.memberOffensiveAdded");
opvp.party.memberOffensiveLevelUpdate = opvp.Signal("opvp.party.memberOffensiveLevelUpdate");
opvp.party.memberOffensiveRemoved     = opvp.Signal("opvp.party.memberOffensiveRemoved");
opvp.party.memberCrowdControlAdded    = opvp.Signal("opvp.party.memberCrowdControlAdded");
opvp.party.memberCrowdControlRemoved  = opvp.Signal("opvp.party.memberCrowdControlRemoved");
opvp.party.memberInfoUpdate           = opvp.Signal("opvp.party.memberInfoUpdate");
opvp.party.memberSpecUpdate           = opvp.Signal("opvp.party.memberSpecUpdate");
opvp.party.memberSpellInterrupted     = opvp.Signal("opvp.party.memberSpellInterrupted");
opvp.party.memberTrinket              = opvp.Signal("opvp.party.memberTrinket");
opvp.party.memberTrinketUpdate        = opvp.Signal("opvp.party.playerTrinketUpdate");
opvp.party.countdown                  = opvp.Signal("opvp.party.countdown");

function opvp.party.active()
    return opvp.party.party();
end

function opvp.party.auraServer()
    return opvp_party_mgr_singleton:auraServer();
end

function opvp.party.ccTracker()
    return opvp_party_mgr_singleton:ccTracker();
end

function opvp.party.combatLevelTracker()
    return opvp_party_mgr_singleton:combatLevelTracker();
end

function opvp.party.findMemberByGuid(guid, category)
    return opvp_party_mgr_singleton:findMemberByGuid(guid, category);
end

function opvp.party.findMemberByUnitId(unitId, category)
    return opvp_party_mgr_singleton:findMemberByUnitId(unitId, category);
end

function opvp.party.hasParty(category)
    return opvp_party_mgr_singleton:hasParty(category);
end

function opvp.party.hasHomeParty()
    return opvp_party_mgr_singleton:hasHomeParty();
end

function opvp.party.hasInstanceParty()
    return opvp_party_mgr_singleton:hasInstanceParty();
end

function opvp.party.home()
    return opvp_party_mgr_singleton:home();
end

function opvp.party.instance()
    return opvp_party_mgr_singleton:instance();
end

function opvp.party.isCountingDown()
    return opvp_party_mgr_singleton:isCountingDown();
end

function opvp.party.isParty()
    local party = opvp.party.active();

    if party ~= nil then
        return party:isParty();
    else
        return false;
    end
end

function opvp.party.isRaid()
    local party = opvp.party.active();

    if party ~= nil then
        return party:isRaid();
    else
        return false;
    end
end

function opvp.party.isReloading(category)
    return opvp_party_mgr_singleton:isReloading(category);
end

function opvp.party.manager()
    return opvp_party_mgr_singleton;
end

function opvp.party.logInfo()
    return opvp_party_mgr_singleton:logInfo();
end

function opvp.party.member(index, category)
    return opvp_party_mgr_singleton:member(index, category);
end

function opvp.party.members(category)
    return opvp_party_mgr_singleton:members(category);
end

function opvp.party.party(category)
    return opvp_party_mgr_singleton:party(category);
end

function opvp.party.size(category)
    return opvp_party_mgr_singleton:size();
end

opvp.party.utils = {};

function opvp.party.utils.isCrossFaction(category)
    return C_PartyInfo.IsCrossFactionParty(category);
end

function opvp.party.utils.hasHomeParty()
    return opvp.party.utils.isInGroup(opvp.PartyCategory.HOME);
end

function opvp.party.utils.hasInstanceParty()
    return opvp.party.utils.isInGroup(opvp.PartyCategory.INSTANCE);
end

function opvp.party.utils.isFull(category)
    return C_PartyInfo.IsPartyFull(category);
end

function opvp.party.utils.isGuidInGroup(guid, category)
    return IsGUIDInGroup(guid, category);
end

function opvp.party.utils.isGroupAssistant(unitId, category)
    return UnitIsGroupAssistant(unitId, category);
end

function opvp.party.utils.isGroupLeader(unitId, category)
    return UnitIsGroupLeader(unitId, category);
end

function opvp.party.utils.isGuidInGroup(guid, category)
    return IsGUIDInGroup(guid, category);
end

function opvp.party.utils.isInGroup(category)
    return IsInGroup(category);
end

function opvp.party.utils.isInRaid(category)
    return IsInRaid(category);
end

function opvp.party.utils.leader(category)
    if opvp.party.utils.isGroupLeader(opvp.unitid.PLAYER, category) then
        return opvp.unitid.PLAYER;
    end

    local grp_size = opvp.party.utils.size(category);
    local token = opvp.party.utils.token(category);

    for n=1, grp_size do
        if opvp.party.utils.isGroupLeader(token .. n, category) then
            return token .. n;
        end
    end

    return "";
end

function opvp.party.utils.leave(category, prompt)
    if prompt == nil or prompt == true then
        C_PartyInfo.LeaveParty(category);
    else
        C_PartyInfo.ConfirmLeaveParty(category);
    end;
end

function opvp.party.utils.minimumPlayerLevel(category)
    return C_PartyInfo.GetMinLevel(category);
end

function opvp.party.utils.size(category)
    return GetNumGroupMembers(category);
end

function opvp.party.utils.sortMembersByName(members)
    local result;

    if opvp.IsInstance(members, opvp.List) == true then
        result = opvp.List:createFromArray(members:items());
    elseif opvp.is_table(members) == true then
        result = opvp.List:createCopyFromArray(members);
    else
        --~ ERROR!
        return {};
    end

    result:sort(
        function(a, b)
            return a:nameOrId() < b:nameOrId();
        end
    );

    return result:release();
end

function opvp.party.utils.sortMembersByRole(members, lookup)
    local result;

    if opvp.IsInstance(members, opvp.List) == true then
        result = opvp.List:createFromArray(members:items());
    elseif opvp.is_table(members) == true then
        result = opvp.List:createCopyFromArray(members);
    else
        --~ ERROR!
        return {};
    end

    if lookup == nil or opvp.is_func(lookup) == false then
        lookup = opvp_party_members_cmp_lookup_default;
    end

    result:sort(
        function(a, b)
            return opvp_party_member_cmp_by_role(a, b, lookup)
        end
    );

    return result:release();
end

function opvp.party.utils.sortMembersByRoleStat(members, lookup)
    local result;

    if opvp.IsInstance(members, opvp.List) == true then
        result = opvp.List:createFromArray(members:items());
    elseif opvp.is_table(members) == true then
        result = opvp.List:createCopyFromArray(members);
    else
        --~ ERROR!
        return {};
    end

    if lookup == nil or opvp.is_func(lookup) == false then
        lookup = opvp_party_members_cmp_lookup_default;
    end

    result:sort(
        function(a, b)
            return opvp_party_member_cmp_by_role_stat(a, b, lookup)
        end
    );

    return result:release();
end

function opvp.party.utils.sortMembersByStat(members, id, order)
    local result;

    if opvp.IsInstance(members, opvp.List) == true then
        result = opvp.List:createFromArray(members:items());
    elseif opvp.is_table(members) == true then
        result = opvp.List:createCopyFromArray(members);
    else
        --~ ERROR!
        return {};
    end

    if order == opvp.SortOrder.ASCENDING then
        result:sort(
            function(a, b)
                return opvp_party_member_cmp_by_stat_ascend(a, b, id)
            end
        );
    else
        result:sort(
            function(a, b)
                return opvp_party_member_cmp_by_stat_descend(a, b, id)
            end
        );
    end

    return result:release();
end

function opvp.party.utils.token(category)
    local party_type = opvp.party.utils.type(category);

    if party_type == opvp.PartyType.RAID then
        return "raid";
    elseif party_type == opvp.PartyType.PARTY then
        return "party";
    else
        return "";
    end
end

function opvp.party.utils.type(category)
    if opvp.party.utils.isInRaid(category) == true then
        return opvp.PartyType.RAID;
    elseif opvp.party.utils.isInGroup(category) == true then
        return opvp.PartyType.PARTY;
    else
        return opvp.PartyType.NONE;
    end
end

local function opvp_party_mgr_singleton_ctor()
    opvp_party_mgr_singleton = opvp.PartyManager();

    opvp_party_mgr_singleton:setAuraServerEnabled(true);

    local aura_server = opvp_party_mgr_singleton:auraServer();

    aura_server.started:connect(
        function()
            opvp.printDebug("AuraServer - Initialized");
        end
    );

    aura_server.stopped:connect(
        function()
            opvp.printDebug("AuraServer - Shutdown");
        end
    );

    opvp.printDebug("PartyManager - Initialized");
end

opvp.OnAddonLoad:register(opvp_party_mgr_singleton_ctor);
