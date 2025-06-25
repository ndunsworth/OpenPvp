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

opvp.MatchAuraServerConfig = opvp.CreateClass();

function opvp.MatchAuraServerConfig:init(match)
    self._match        = match;
    self._affiliation  = opvp.Affiliation.FRIENDLY;
end

function opvp.MatchAuraServerConfig:addTeams(teams)
    opvp.printDebug("opvp.MatchAuraServerConfig.addTeams");

    local server = opvp.party.auraServer();

    for n=1, #teams do
        if self:isPartySupported(teams[n]) == true then
            server:addParty(teams[n]);
        end
    end
end

function opvp.MatchAuraServerConfig:initialize()
    if self._match == nil then
        return;
    end

    local cc_tracker      = opvp.party.ccTracker();
    local cbt_lvl_tracker = opvp.party.combatLevelTracker();

    cc_tracker.memberCrowdControlAdded:connect(opvp.match.playerCrowdControlAdded);
    cc_tracker.memberCrowdControlRemoved:connect(opvp.match.playerCrowdControlRemoved);

    cbt_lvl_tracker.memberDefensiveAdded:connect(opvp.match.playerDefensiveAdded);
    cbt_lvl_tracker.memberDefensiveLevelUpdate:connect(opvp.match.playerDefensiveLevelUpdate);
    cbt_lvl_tracker.memberDefensiveRemoved:connect(opvp.match.playerDefensiveRemoved);

    cbt_lvl_tracker.memberOffensiveAdded:connect(opvp.match.playerOffensiveAdded);
    cbt_lvl_tracker.memberOffensiveLevelUpdate:connect(opvp.match.playerOffensiveLevelUpdate);
    cbt_lvl_tracker.memberOffensiveRemoved:connect(opvp.match.playerOffensiveRemoved);
end

function opvp.MatchAuraServerConfig:removeTeams(teams)
    opvp.printDebug("opvp.MatchAuraServerConfig.removeTeams");

    local server = opvp.party.auraServer();

    for n=1, #teams do
        if self:isPartySupported(teams[n]) == true then
            server:removeParty(teams[n]);
        end
    end
end

function opvp.MatchAuraServerConfig:shutdown()
    if self._match == nil then
        return;
    end

    local cc_tracker      = opvp.party.ccTracker();
    local cbt_lvl_tracker = opvp.party.combatLevelTracker();

    cc_tracker.memberCrowdControlAdded:disconnect(opvp.match.playerCrowdControlAdded);
    cc_tracker.memberCrowdControlRemoved:disconnect(opvp.match.playerCrowdControlRemoved);

    cbt_lvl_tracker.memberDefensiveAdded:disconnect(opvp.match.playerDefensiveAdded);
    cbt_lvl_tracker.memberDefensiveLevelUpdate:disconnect(opvp.match.playerDefensiveLevelUpdate);
    cbt_lvl_tracker.memberDefensiveRemoved:disconnect(opvp.match.playerDefensiveRemoved);

    cbt_lvl_tracker.memberOffensiveAdded:disconnect(opvp.match.playerOffensiveAdded);
    cbt_lvl_tracker.memberOffensiveLevelUpdate:disconnect(opvp.match.playerOffensiveLevelUpdate);
    cbt_lvl_tracker.memberOffensiveRemoved:disconnect(opvp.match.playerOffensiveRemoved);

    self._match = nil;
end

function opvp.MatchAuraServerConfig:isPartySupported(party)
    return bit.band(self._affiliation, party:affiliation()) ~= 0;
end

function opvp.MatchAuraServerConfig:setAffiliation(mask)
    self._affiliation = mask;
end
