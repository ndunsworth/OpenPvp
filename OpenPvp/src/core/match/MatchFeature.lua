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

opvp.MatchFeature = opvp.CreateClass(opvp.Feature);

function opvp.MatchFeature:init()
    opvp.Feature.init(self);

    self._ignore_test      = false;
    self._match_mask       = bit.bor(opvp.PvpType.ARENA, opvp.PvpType.BATTLEGROUND);
    self._match_activate   = opvp.MatchStatus.ENTERED;
    self._match_deactivate = opvp.MatchStatus.EXIT;
end

function opvp.MatchFeature:broadcast()
    return true;
end

function opvp.MatchFeature:canActivate()
    return (
        opvp.match.inMatch() == true and
        self:isValidMatch(opvp.match.current()) == true and
        self:isActiveMatchStatus(opvp.match.current():status()) == true
    );
end

function opvp.MatchFeature:ignoreTestMatch()
    return self._ignore_test;
end

function opvp.MatchFeature:isActiveMatchStatus(status)
    if status == self._match_deactivate then
        return false;
    else
        return (
            self._match_activate == status or
            (
                self._match_activate <= status and
                self._match_deactivate > status
            )
        );
    end
end

function opvp.MatchFeature:isValidMatch(match)
    return (
        match ~= nil and
        bit.band(self._match_mask, match:pvpType()) ~= 0 and
        (
            match:isTest() == false or
            self._ignore_test == false
        )
    );
end

function opvp.MatchFeature:_onFeatureDisabled()
    opvp.match.statusChanged:disconnect(self, self._onMatchStateChanged);

    opvp.Feature._onFeatureDisabled(self);
end

function opvp.MatchFeature:_onFeatureEnabled()
    opvp.match.statusChanged:connect(self, self._onMatchStateChanged);

    opvp.Feature._onFeatureEnabled(self);
end

function opvp.MatchFeature:_onMatchComplete()

end

function opvp.MatchFeature:_onMatchEntered()

end

function opvp.MatchFeature:_onMatchExit()

end

function opvp.MatchFeature:_onMatchRoundActive()

end

function opvp.MatchFeature:_onMatchRoundComplete()

end

function opvp.MatchFeature:_onMatchRoundWarmup()

end

function opvp.MatchFeature:_onMatchStateChanged(newStatus, oldStatus)
    if (
        self:isActiveMatchStatus(newStatus) == true and
        self:isValidMatch(opvp.match.current()) == true
    ) then
        self:_setActive(true);
    else
        self:_setActive(false);
    end
end
