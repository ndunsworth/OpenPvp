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

local _, OpenPvpLib = ...
local opvp = OpenPvpLib;

opvp.BrawlQueue = opvp.CreateClass(opvp.GenericPvpQueue);

function opvp.BrawlQueue:init(pvpType, flags, name, description)
    opvp.GenericPvpQueue.init(self, 0, pvpType, flags, name, description);

    self._expires    = -1;
    self._lfg        = false;
    self._brawl_type = Enum.BrawlType.None;

    if bit.band(flags, opvp.PvpFlag.EVENT) ~= 0 then
        opvp.event.PVP_SPECIAL_EVENT_INFO_UPDATED:connect(
            self,
            self.updateInfo
        );
    else
        opvp.event.PVP_BRAWL_INFO_UPDATED:connect(
            self,
            self.updateInfo
        );
    end
end

function opvp.BrawlQueue:bonusRoles()
    if self._brawl_type == Enum.BrawlType.None then
        return {};
    end

    local _, _, _, _, bonus = C_PvP.GetBrawlRewards(self._brawl_type)

    local role;
    local roles = {};

    if bonus ~= nil then
        for n=1, #bonus.validRoles do
            role = opvp.Role:fromRoleString(bonus.validRoles[n]);

            if role:isValid() == true then
                table.insert(roles, role);
            end

        end
    end

    return roles;
end

function opvp.BrawlQueue:canQueue()
    local info = self:_info();

    return (info ~= nil and info.canQueue == true);
end

function opvp.BrawlQueue:hasDailyWin()
    if self._brawl_type == Enum.BrawlType.None then
        return false;
    end

    local _, _, _, _, _, daily_win = C_PvP.GetBrawlRewards(self._brawl_type);

    return (
        daily_win ~= nil and
        daily_win
    );
end

function opvp.BrawlQueue:hasEnlistmentBonus()
    local bg, brawl = C_PvP.IsBattlegroundEnlistmentBonusActive();

    return brawl;
end

function opvp.BrawlQueue:isLFG()
    return self._lfg;
end

function opvp.BrawlQueue:join()
    if self:isQueued() == false then
        C_PvP.JoinBrawl(self:isEvent());
    end
end

function opvp.BrawlQueue:timeUntilExpires()
    return self._expires;
end

function opvp.BrawlQueue:updateInfo()
    local info = self:_info();

    if info == nil then
        return;
    end

    self._id               = info.brawlID;
    self._name             = info.name;
    self._desc             = info.shortDescription .. "\n\n" .. info.longDescription;
    self._player_level_min = info.minLevel;
    self._player_level_max = info.maxLevel;
    self._expires          = info.timeLeftUntilNextChange;
    self._groups_allowed   = info.groupsAllowed;
    self._xfaction         = info.crossFactionAllowed;
    self._lfg              = false;
    self._brawl_type       = info.brawlType;

    C_PvP.GetBrawlRewards(self._brawl_type);

    local lfg_maps = opvp.List:createFromArray(
        {
            opvp.Map.ARATHI_BASIN_COMP_STOMP:name()
        }
    );

    for n=1, #info.mapNames do
        if lfg_maps:contains(info.mapNames[n]) == true then
            self._lfg = true;

            break;
        end
    end
end

function opvp.BrawlQueue:_createMatchDescription(map)
    return opvp.BattlegroundMatchDescription(map);
end

function opvp.BrawlQueue:_info()
    if self:isEvent() == true then
        return C_PvP.GetSpecialEventBrawlInfo();
    elseif self:isBrawl() == true then
        return C_PvP.GetAvailableBrawlInfo();
    else
        return nil;
    end
end

local function opvp_brawl_queue_ctor()
    opvp.Queue.BRAWL = opvp.BrawlQueue(opvp.PvpType.BATTLEGROUND, opvp.PvpFlag.BRAWL, "", "");
    opvp.Queue.EVENT = opvp.BrawlQueue(opvp.PvpType.BATTLEGROUND, bit.bor(opvp.PvpFlag.BRAWL, opvp.PvpFlag.EVENT), "", "");

    opvp.Queue.BRAWL:updateInfo();
    opvp.Queue.EVENT:updateInfo();

    --~ opvp.OnLoadingScreenEnd:connect(
        --~ opvp.Queue.BRAWL,
        --~ opvp.Queue.BRAWL.updateInfo
    --~ );

    --~ opvp.OnLoadingScreenEnd:connect(
        --~ opvp.Queue.EVENT,
        --~ opvp.Queue.EVENT.updateInfo
    --~ );
end

opvp.OnAddonLoad:register(opvp_brawl_queue_ctor);
