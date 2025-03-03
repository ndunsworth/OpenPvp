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

opvp.RandomBattlegroundQueue = opvp.CreateClass(opvp.GenericPvpQueue);

function opvp.RandomBattlegroundQueue:init(flags, name, description)
    opvp.GenericPvpQueue.init(
        self,
        0,
        opvp.PvpType.BATTLEGROUND,
        bit.bor(flags, opvp.PvpFlag.RANDOM, opvp.PvpFlag.RANDOM_MAP),
        name,
        description
    );
end

function opvp.RandomBattlegroundQueue:bonusRoles()
    local bonus;

    if self:isBattlegroundEpic() == true then
        bonus = select(5, C_PvP.GetRandomEpicBGRewards());
    else
        bonus = select(5, C_PvP.GetRandomBGRewards());
    end

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

function opvp.RandomBattlegroundQueue:canQueue()
    local info = self:_info();

    return (info ~= nil and info.canQueue == true);
end

function opvp.RandomBattlegroundQueue:hasDailyWin()
    local info = self:_info();

    if info ~= nil then
        return info.hasRandomWinToday;
    else
        return false;
    end
end

function opvp.RandomBattlegroundQueue:hasEnlistmentBonus()
    if self:isBattlegroundEpic() == false then
        local bg, brawl = C_PvP.IsBattlegroundEnlistmentBonusActive();

        return bg;
    else
        return false;
    end
end

function opvp.RandomBattlegroundQueue:updateInfo()
    local info = self:_info();

    if info == nil then
        return;
    end

    self._id               = info.bgID;
    self._player_level_min = info.minLevel;
    self._player_level_max = info.maxLevel;
end

function opvp.RandomBattlegroundQueue:_createMatchDescription(map)
    return opvp.BattlegroundMatchDescription(map);
end

function opvp.RandomBattlegroundQueue:_info()
    if self:isBattlegroundEpic() == true then
        return C_PvP.GetRandomEpicBGInfo();
    else
        return C_PvP.GetRandomBGInfo();
    end
end

local function opvp_rand_bg_queue_ctor()
    opvp.Queue.RANDOM_BATTLEGROUND      = opvp.RandomBattlegroundQueue(0,                 RANDOM_BATTLEGROUND,      BONUS_BUTTON_RANDOM_BG_DESC);
    opvp.Queue.RANDOM_EPIC_BATTLEGROUND = opvp.RandomBattlegroundQueue(opvp.PvpFlag.EPIC, RANDOM_EPIC_BATTLEGROUND, BONUS_BUTTON_RANDOM_LARGE_BG_DESC);

    opvp.OnLoadingScreenEnd:connect(
        opvp.Queue.RANDOM_BATTLEGROUND,
        opvp.Queue.RANDOM_BATTLEGROUND.updateInfo
    );

    opvp.OnLoadingScreenEnd:connect(
        opvp.Queue.RANDOM_EPIC_BATTLEGROUND,
        opvp.Queue.RANDOM_EPIC_BATTLEGROUND.updateInfo
    );

    RequestRandomBattlegroundInstanceInfo();
    RequestPVPRewards();
end

opvp.OnAddonLoad:register(opvp_rand_bg_queue_ctor);
