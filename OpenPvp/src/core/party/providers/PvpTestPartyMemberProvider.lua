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

opvp.PvpTestPartyMemberProvider = opvp.CreateClass(opvp.TestPartyMemberProvider);

function opvp.PvpTestPartyMemberProvider:init(hasPlayer)
    opvp.TestPartyMemberProvider.init(self, hasPlayer);

    self._match = nil;
    self._tester = nil;

    self.scoreUpdate = opvp.Signal("opvp.PvpTestPartyMemberProvider.scoreUpdate");
end

function opvp.PvpTestPartyMemberProvider:isRated()
    return (
        self._match ~= nil and
        self._match:isRated() == true
    );
end

function opvp.PvpTestPartyMemberProvider:_connectSignals()
    opvp.event.UPDATE_BATTLEFIELD_SCORE:connect(self, self._onScoreUpdate);

    opvp.TestPartyMemberProvider._connectSignals(self);
end

function opvp.PvpTestPartyMemberProvider:_disconnectSignals()
    opvp.event.UPDATE_BATTLEFIELD_SCORE:disconnect(self, self._onScoreUpdate);

    opvp.TestPartyMemberProvider._disconnectSignals(self);
end

function opvp.PvpTestPartyMemberProvider:_onConnected()
    self._match = opvp.match.current();
    self._tester = opvp.match.manager():tester();

    if self._match:isArena() == true then
        self._healers_max = 1;
    elseif self._match:isBlitz() == true then
        self._healers_max = 2;
    elseif self._match:isBattlegroundEpic() == true then
        self._healers_max = 10;
    else
        self._healers_max = 3;
    end

    opvp.TestPartyMemberProvider._onConnected(self);
end

function opvp.PvpTestPartyMemberProvider:_onDisconnected()
    opvp.TestPartyMemberProvider._onDisconnected(self);

    self._match = nil;
    self._tester = nil;
end

function opvp.PvpTestPartyMemberProvider:_onScoreUpdate()
    local rated = self:isRated();

    local member;

    for n=1, self:size() do
        self:_updateMemberScore(self:member(n), rated);
    end

    self.scoreUpdate:emit();
end

function opvp.PvpTestPartyMemberProvider:_updateMember(unitId, member, created)
    if created == false then
        return 0;
    end

    member:_setStats(self._match:map():stats());

    member:trinketState():_setRacialFromRaceId(member:race());

    return 0;
end

function opvp.PvpTestPartyMemberProvider:_updateMemberScore(member, rated)
    if rated == true then
        if member:isRatingKnown() == false then
            local cr = math.random(2100, 2500);
            local mmr = max(cr, math.random(2100, 2500));

            member:_setRating(cr, mmr);
        elseif self._match:isComplete() == true then
            if member:team() == self._tester:outcomeTeam() then
                member:_setRatingGain(
                    math.random(0, 94),
                    math.random(0, 94)
                );

                if self._match:isShuffle() == true then
                    local stat = member:findStatById(opvp.PvpStatId.ROUNDS_WON);

                    if stat ~= nil then
                        stat:setValue(4);
                    end
                end
            else
                member:_setRatingGain(
                    math.random(-58, -10),
                    math.random(-58, -10)
                );

                if self._match:isShuffle() == true then
                    local stat = member:findStatById(opvp.PvpStatId.ROUNDS_WON);

                    if stat ~= nil then
                        stat:setValue(2);
                    end
                end
            end
        end
    end
end
