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

opvp.ArenaSkirmishQueue = opvp.CreateClass(opvp.GenericPvpQueue);

function opvp.ArenaSkirmishQueue:init()
    opvp.GenericPvpQueue.init(
        self,
        4,
        opvp.PvpType.ARENA,
        bit.bor(
            opvp.PvpFlag.DAMPENING,
            opvp.PvpFlag.RANDOM_MAP,
            opvp.PvpFlag.SKIRMISH
        ),
        SKIRMISH,
        C_PvP.GetSkirmishInfo(4).shortDescription
    );
end

function opvp.ArenaSkirmishQueue:bonusRoles()
    local _, _, _, _, bonus = C_PvP.GetBrawlRewards(Enum.BrawlType.Arena)

    local role;
    local roles = {};

    if bonus ~= nil then
        for n=1, #bonus.validRoles do
            role = opvp.Role:fromRoleToken(bonus.validRoles[n]);

            if role:isValid() == true then
                table.insert(roles, role);
            end

        end
    end

    return roles;
end

function opvp.ArenaSkirmishQueue:canQueue()
    return opvp.player.level() >= self._player_level_min;
end

function opvp.ArenaSkirmishQueue:hasDailyWin()
    return C_PvP.HasArenaSkirmishWinToday();
end

function opvp.ArenaSkirmishQueue:join(asGroup)
    if self:isQueued() == false then
        JoinSkirmish(self:id(), asGroup);
    end
end

function opvp.ArenaSkirmishQueue:updateInfo()
    local info = C_PvP.GetSkirmishInfo(self:id());

    if info == nil then
        return;
    end

    self._desc             = BONUS_BUTTON_SKIRMISH_TITLE .. "\n\n"  .. BONUS_BUTTON_SKIRMISH_DESC;
    self._player_level_min = 15;
    self._player_level_max = GetMaxLevelForPlayerExpansion();
end

function opvp.ArenaSkirmishQueue:_createMatchDescription(map, mask)
    return opvp.ArenaMatchDescription(map, 3, mask);
end

local function opvp_arena_skirm_queue_ctor()
    opvp.Queue.ARENA_SKIRMISH = opvp.ArenaSkirmishQueue();
end

opvp.OnAddonLoad:register(opvp_arena_skirm_queue_ctor);
