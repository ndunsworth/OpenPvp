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

opvp.BattleNetStatus = {
    AVAILABLE = 1,
    AFK       = 2,
    DND       = 3
};

opvp.battlenet = {};

function opvp.battlenet.isAFK()
    return opvp.battlenet.status() == opvp.BattleNetStatus.AFK;
end

function opvp.battlenet.isAvailable()
    return opvp.battlenet.status() == opvp.BattleNetStatus.AVAILABLE;
end

function opvp.battlenet.isDND()
    return opvp.battlenet.status() == opvp.BattleNetStatus.DND;
end

function opvp.battlenet.setAvailable()
    local info = C_BattleNet.GetAccountInfoByGUID(opvp.player.guid());

    if info == nil then
        return;
    end

    if info.isAFK == true then
        BNSetAFK(false);
    elseif info.isDND == true then
        BNSetDND(false);
    end
end

function opvp.battlenet.setStatus(status)
    if status == opvp.battlenet.status() then
        return;
    elseif status == oopvp.BattleNetStatus.AFK then
        BNSetAFK(true);
    elseif info.isDND == true then
        BNSetDND(true);
    end
end

function opvp.battlenet.setAFK()
    BNSetAFK(true);
end

function opvp.battlenet.setDND()
    BNSetDND(true);
end

function opvp.battlenet.status()
    local info = C_BattleNet.GetAccountInfoByGUID(opvp.player.guid());

    if info == nil then
        return opvp.BattleNetStatus.AVAILABLE;
    end

    if info.isAFK == true then
        return opvp.BattleNetStatus.AFK;
    elseif info.isDND == true then
        return opvp.BattleNetStatus.DND;
    else
        return opvp.BattleNetStatus.AVAILABLE;
    end;
end

opvp.friends = {};

function opvp.friends.addIgnore(name)
    return C_FriendList.AddIgnore(name);
end

function opvp.friends.isAnyFriendByGuid(guid)
    return (
        opvp.friends.isBattleNetFriendByGuid(guid) or
        opvp.friends.isFriendByGuid(guid)
    );
end

function opvp.friends.isAnyFriendByName(name)
    return (
        opvp.friends.isBattleNetFriendByName(name) or
        opvp.friends.isFriendByName(name)
    );
end

function opvp.friends.isAnyFriendByUnitId(unitId)
    return (
        opvp.friends.isAnyFriendByGuid(opvp.unit.guid(unitId)) or
        opvp.friends.isAnyFriendByName(opvp.unit.name(unitId))
    );
end

function opvp.friends.isBattleNetFriendByGuid(guid)
    return C_BattleNet.GetAccountInfoByGUID(guid) ~= nil;
end

function opvp.friends.isBattleNetFriendByName(name)
    local character, server = opvp.unit.splitNameAndServer(name);
    local info;

    for n=1, BNGetNumFriends() do
        info = C_BattleNet.GetFriendAccountInfo(n);

        if (
            info ~= nil and
            info.gameAccountInfo ~= nil and
            info.gameAccountInfo.characterName == character and
            info.gameAccountInfo.realmName == server
        ) then
            return true;
        end
    end

    return false;
end

function opvp.friends.isFriendByUnitId(unitId)
    return opvp.friends.isGuidFriend(opvp.unit.guid(unitId));
end

function opvp.friends.isFriendByGuid(guid)
    return C_FriendList.IsFriend(guid);
end

function opvp.friends.isFriendByName(name)
    return C_FriendList.GetFriendInfo(name) ~= nil;
end

function opvp.friends.isIgnored(name)
    return C_FriendList.IsIgnored(name);
end

function opvp.friends.isIgnoredGuid(guid)
    return C_FriendList.IsIgnoredByGuid(name);
end

function opvp.friends.removeIgnore(name)
    return C_FriendList.DelIgnore(name);
end
