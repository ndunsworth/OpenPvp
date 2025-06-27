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

opvp.MatchDescription = opvp.CreateClass();

function opvp.MatchDescription:createFromCurrentInstance()
    if IsInInstance() == false then
        return false;
    end

    local map = opvp.PvpMap:fromCurrentInstance();

    if map:isValid() == false then
        return false;
    end

    if C_PvP.IsMatchConsideredArena() == true and C_PvP.IsInBrawl() == false then
        if C_PvP.IsSoloShuffle() == true then
            return opvp.MatchDescription:createShuffleDescription();
        end

        return opvp.MatchDescription:createArenaDescription(
            3,
            C_PvP.IsRatedArena()
        );
    end

    if C_PvP.IsRatedSoloRBG() then
        local map = opvp.PvpMap:fromCurrentInstance();

        if map ~= nil then
            return opvp.MatchDescription:createBlitzDescription(map);
        end
    end

    if C_PvP.IsRatedBattleground() then
        local map = opvp.PvpMap:fromCurrentInstance();

        if map ~= nil then
            return opvp.MatchDescription:createRBGDescription(map, false);
        end
    end

    return nil;
end

function opvp.MatchDescription:init(map)
    self._map = map;
end

function opvp.MatchDescription:createMatch(queue)
    return nil;
end

function opvp.MatchDescription:hasDampening()
    return bit.band(self:mask(), opvp.PvpFlag.DAMPENING) ~= 0;
end

function opvp.MatchDescription:isArena()
    return self:type() == opvp.PvpType.ARENA;
end

function opvp.MatchDescription:isBattleground()
    return self:type() == opvp.PvpType.BATTLEGROUND;
end

function opvp.MatchDescription:isBattlegroundEpic()
    return (
        self:type() == opvp.PvpType.BATTLEGROUND and
        bit.band(self:mask(), opvp.PvpFlag.EPIC) ~= 0
    );
end

function opvp.MatchDescription:isBrawl()
    return bit.band(self:mask(), opvp.PvpFlag.BRAWL) ~= 0;
end

function opvp.MatchDescription:isBlitz()
    return (
        self._type == opvp.PvpType.BATTLEGROUND and
        bit.band(self:mask(), opvp.PvpFlag.BLITZ) ~= 0
    );
end

function opvp.MatchDescription:isEvent()
    return bit.band(self:mask(), opvp.PvpFlag.EVENT) ~= 0;
end

function opvp.MatchDescription:isRated()
    return bit.band(self:mask(), opvp.PvpFlag.RATED) ~= 0;
end

function opvp.MatchDescription:isRBG()
    return bit.band(self:mask(), opvp.PvpFlag.RBG) ~= 0;
end

function opvp.MatchDescription:isRoundBased()
    return bit.band(self:mask(), opvp.PvpFlag.ROUND) ~= 0;
end

function opvp.MatchDescription:isShuffle()
    return bit.band(self:mask(), opvp.PvpFlag.SHUFFLE) ~= 0;
end

function opvp.MatchDescription:isSimulation()
    return bit.band(self:mask(), opvp.PvpFlag.SIMULATION) ~= 0;
end

function opvp.MatchDescription:isSkirmish()
    return bit.band(self:mask(), opvp.PvpFlag.SKIRMISH) ~= 0;
end

function opvp.MatchDescription:isTest()
    return bit.band(self:mask(), opvp.PvpFlag.TEST) ~= 0;
end

function opvp.MatchDescription:map()
    return self._map;
end

function opvp.MatchDescription:mask()
    return 0;
end

function opvp.MatchDescription:rounds()
    return 1;
end

function opvp.MatchDescription:teamSize()
    return 1;
end

function opvp.MatchDescription:testType()
    if self:isTest() == true then
        if self:isSimulation() == true then
            return opvp.MatchTestType.SIMULATION;
        else
            return opvp.MatchTestType.FEATURE;
        end
    else
        return opvp.MatchTestType.NONE;
    end
end

function opvp.MatchDescription:type()
    return opvp.PvpType.NONE;
end
