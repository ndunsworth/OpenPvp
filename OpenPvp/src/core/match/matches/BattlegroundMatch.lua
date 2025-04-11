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

opvp.BattlegroundMatch = opvp.CreateClass(opvp.GenericMatch);

function opvp.BattlegroundMatch:init(queue, description)
    opvp.GenericMatch.init(self, queue, description);

    if queue:isRated() == true then
        self._enemy_provider = opvp.ArenaPartyMemberProvider();

        self._enemy_provider:_setTeamSize(description:teamSize());
    else
        self._enemy_provider = opvp.BattlegroundPartyMemberProvider();
    end

    local cache = opvp.PartyMemberFactoryCache(description:teamSize() * 2);

    self._friendly_provider:_memberFactory():setCache(cache);
    self._enemy_provider:_memberFactory():setCache(cache);
end

function opvp.BattlegroundMatch:_onMatchComplete()
    opvp.GenericMatch._onMatchComplete(self);
end

function opvp.BattlegroundMatch:_onScoreUpdate()
    opvp.printDebug("opvp.BattlegroundMatch._onScoreUpdate");

    if (
        self:isOutcomeValid() == false and
        self._status == opvp.MatchStatus.COMPLETE
    ) then
        self:_updateOutcome();
    end
end
