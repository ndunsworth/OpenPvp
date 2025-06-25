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
local opvp = OpenPvp

opvp.MatchManager = opvp.CreateClass();

function opvp.MatchManager:init()
    self._match         = nil;
    self._match_testing = false;
    self._joined        = false;
    self._match_test    = opvp.MatchTest();


    opvp.event.PLAYER_JOINED_PVP_MATCH:connect(
        self,
        self._onMatchJoined
    );

    opvp.event.PVP_MATCH_STATE_CHANGED:connect(
        self,
        self._onMatchStateChanged
    );

    opvp.event.PVP_MATCH_COMPLETE:connect(
        self,
        self._onMatchComplete
    );

    opvp.queue.statusChanged:connect(
        self,
        self._onQueueStatusChanged
    );

    opvp.party.aboutToJoin:connect(
        self,
        self._onPartyAboutToJoin
    );
end

function opvp.MatchManager:beginTest(pvpType, map, pvpFlags, simulate)
    if self:isTesting() == true or self:inMatch() == true then
        return;
    end

    self._match_test:initialize(pvpType, map, pvpFlags, simulate);

    self._match = self._match_test:match();

    if self._match ~= nil then
        self._match_testing = true;

        self._match_test:start();
    end
end

function opvp.MatchManager:dampening()
    if self._match ~= nil then
        return self._match:dampening();
    else
        return 0;
    end
end

function opvp.MatchManager:endTest()
    if self:isTesting() == false then
        return;
    end

    self._match_test:stop();

    self._match         = nil;
    self._match_testing = false;
end

function opvp.MatchManager:hasDampening()
    if self._match ~= nil then
        return self._match:hasDampening();
    else
        return false;
    end
end

function opvp.MatchManager:inMatch(ignoreTest)
    if ignoreTest == true then
        return self._match ~= nil and self:isTesting() == false;
    else
        return self._match ~= nil;
    end
end

function opvp.MatchManager:isRated()
    return (
        self._match ~= nil and
        self._match:isRated() == true
    );
end

function opvp.MatchManager:isSimulation()
    return self._match_test:isSimulation();
end

function opvp.MatchManager:isTesting()
    return self._match_testing;
end

function opvp.MatchManager:match()
    return self._match;
end

function opvp.MatchManager:tester()
    return self._match_test;
end

function opvp.MatchManager:_onMatchComplete()
    if self._match == nil then
        return;
    end

    if opvp.MatchStatus.COMPLETE ~= self._match:status() then
        self._match:_onMatchStateChanged(
            opvp.MatchStatus.COMPLETE,
            self._match:statusNext()
        );
    end
end

function opvp.MatchManager:_onMatchJoined()
    if self._match == nil or self._joined == true then
        return;
    end

    --~ Blizz strikes again! PLAYER_JOINED_PVP_MATCH is called when joining
    --~ as WELL AS upon match completion.  That makes sense when reading
    --~ the event name doesnt it?
    self._joined = true;

    self._match:_onMatchJoined();

    local match_status = opvp.Match:statusFromActiveMatchState();

    opvp.printDebug(
        "opvp.MatchManager._onMatchJoined, wow_status_id=%d, wow_status=%s, current_status=%s, expected_status=%s",
        C_PvP.GetActiveMatchState(),
        opvp.Match:nameForStatus(match_status),
        opvp.Match:nameForStatus(self._match:status()),
        opvp.Match:nameForStatus(self._match:statusNext())
    );

    if match_status ~= opvp.MatchStatus.INACTIVE then
        if self._match:_isAlreadyInProgress(match_status) == false then
            self._match:_onMatchStateChanged(
                match_status,
                self._match:statusNext()
            );
        else
            self._match._enter_in_prog = true;

            self._match:_onMatchJoinedInProgress(match_status);
        end
    end
end

function opvp.MatchManager:_onMatchStateChanged()
    if self._match == nil then
        return;
    end

    local match_status = opvp.Match:statusFromActiveMatchState();

    opvp.printDebug(
        "opvp.MatchManager._onMatchStateChanged, wow_status_id=%d, wow_status=%s, current_status=%s, expected_status=%s",
        C_PvP.GetActiveMatchState(),
        opvp.Match:nameForStatus(match_status),
        opvp.Match:nameForStatus(self._match:status()),
        opvp.Match:nameForStatus(self._match:statusNext())
    );

    if self._joined == false then
        self:_onMatchJoined();

        return;
    end

    if self._match:status() == opvp.MatchStatus.JOINED then
        if self._match:_isAlreadyInProgress(match_status) == false then
            self._match:_onMatchStateChanged(
                match_status,
                self._match:statusNext()
            );
        else
            self._match._enter_in_prog = true;

            self._match:_onMatchJoinedInProgress(match_status);
        end
    elseif (
        match_status ~= opvp.MatchStatus.COMPLETE and
        match_status ~= self._match:status()
    ) then
        --~ We let the PVP_MATCH_COMPLETE event handle this status because
        --~ the various functions for getting match winner etc dont return
        --~ valid values until PVP_MATCH_COMPLETE is emitted.

        self._match:_onMatchStateChanged(
            match_status,
            self._match:statusNext()
        );
    end
end

function opvp.MatchManager:_onPartyAboutToJoin(category, guid)
    if (
        category == opvp.PartyCategory.INSTANCE and
        self._match ~= nil
    ) then
        self._match:_onPartyAboutToJoin(category, guid);
    end
end

function opvp.MatchManager:_onQueueEnd(queue)
    opvp.printDebug(
        "opvp.MatchManager:_onQueueEnd(\"%s\"), status=%d",
        queue:name(),
        queue:status()
    );

    if self._match == nil then
        return;
    end

    if self._match:isComplete() == false then
        self._match:_onMatchStateChanged(
            opvp.MatchStatus.COMPLETE,
            self._match:statusNext()
        );
    end

    self._match:_onMatchExit();

    self._match:_close();

    self._match = nil;

    self._joined = false;
end

function opvp.MatchManager:_onQueueStart(queue)
    opvp.printDebug(
        "opvp.MatchManager:_onQueueStart(\"%s\"), status=%d",
        queue:name(),
        queue:status()
    );

    self:endTest();

    if self._match ~= nil then
        return;
    end

    local map = opvp.Map:createFromCurrentInstance();

    if map:isValid() == false then
        opvp.printWarning("opvp.MatchManager:_onQueueStart(), Invalid map");

        return;
    end

    self._match = queue:_createMatch(map);

    if self._match == nil then
        opvp.printWarning("opvp.MatchManager:_onQueueStart(), opvp.Queue._createMatch returned null");

        return;
    end

    self._match:_onMatchEntered();
end

function opvp.MatchManager:_onQueueStatusChanged(queue)
    if queue:isPvp() == false then
        return;
    end

    if queue:isActive() == true then
        self:_onQueueStart(queue);
    elseif (
        queue:isQueued() == false and
        self._match ~= nil and
        queue == self._match:queue()
    ) then
        self:_onQueueEnd(queue);
    end
end
