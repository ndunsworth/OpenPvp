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

opvp.RatedQueue = opvp.CreateClass(opvp.PvpQueue);

function opvp.RatedQueue:fromBracketIndex(index)
    for n=1, #opvp.RatedQueue.QUEUES do
        local queue = opvp.RatedQueue.QUEUES[n];

        if queue:bracket():id() == index then
            return queue;
        end
    end

    return nil;
end

function opvp.RatedQueue:init(id, bracket)
    opvp.PvpQueue.init(self, id, bracket:type(), bracket:mask());

    self._bracket = bracket;
end

function opvp.RatedQueue:bonusRoles()
    return self._bracket:bonusRoles();
end

function opvp.RatedQueue:bracket()
    return self._bracket;
end

function opvp.RatedQueue:canQueue()
    return self._bracket:isEnabled();
end

function opvp.RatedQueue:hasDailyWin()
    return self._bracket:hasDailyWin();
end

function opvp.RatedQueue:hasMinimumItemLevel()
    return self._bracket:hasMinimumItemLevel();
end

function opvp.Queue:hasReadyCheck()
    return (
        self:isBlitz() == true or
        self:isShuffle() == true
    );
end

function opvp.RatedQueue:name()
    return self._bracket:name();
end

function opvp.RatedQueue:minimumItemLevel()
    return self._bracket:minimumItemLevel();
end

function opvp.RatedQueue:teamSizeMaximum()
    return self._bracket:teamSize();
end

function opvp.RatedQueue:_createMatchDescription(map)
    if self:isArena() == true then
        if self:isShuffle() == true then
            return opvp.ShuffleMatchDescription(map);
        elseif self == opvp.RatedQueue.ARENA_2v2 then
            return opvp.ArenaMatchDescription(map, 2);
        else
            return opvp.ArenaMatchDescription(map, 3);
        end
    elseif self:isBlitz() == true then
        return opvp.BlitzMatchDescription(map);
    elseif self:isRBG() == true then
        return opvp.RBGMatchDescription(map);
    end

    return nil;
end

local function opvp_rated_queue_ctor()
    opvp.RatedQueue.QUEUES = {
        opvp.Queue.ARENA_2V2,
        opvp.Queue.ARENA_3V3,
        opvp.Queue.BLITZ,
        opvp.Queue.RATED_BATTLEGROUND,
        opvp.Queue.SHUFFLE
    };

    opvp.Queue.ARENA_2V2          = opvp.RatedQueue( 2, opvp.RatingBracket.ARENA_2V2);
    opvp.Queue.ARENA_3V3          = opvp.RatedQueue( 3, opvp.RatingBracket.ARENA_3V3);
    opvp.Queue.BLITZ              = opvp.RatedQueue( 5, opvp.RatingBracket.BLITZ);
    opvp.Queue.RATED_BATTLEGROUND = opvp.RatedQueue(10, opvp.RatingBracket.RBG);
    opvp.Queue.SHUFFLE            = opvp.RatedQueue(11, opvp.RatingBracket.SHUFFLE);
end

opvp.OnAddonLoad:register(opvp_rated_queue_ctor);
