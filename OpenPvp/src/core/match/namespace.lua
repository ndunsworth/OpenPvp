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

local opvp_match_mgr_singleton;

opvp.match = {};

--~ State and status signals
opvp.match.complete                   = opvp.Signal("opvp.match.complete");
opvp.match.countdown                  = opvp.Signal("opvp.match.countdown");
opvp.match.dampeningUpdate            = opvp.Signal("opvp.match.dampeningUpdate");
opvp.match.entered                    = opvp.Signal("opvp.match.entered");
opvp.match.joined                     = opvp.Signal("opvp.match.joined");
opvp.match.exit                       = opvp.Signal("opvp.match.exit");
opvp.match.outcomeReady               = opvp.Signal("opvp.match.outcomeReady");
opvp.match.playerDefensiveAdded       = opvp.Signal("opvp.match.playerDefensiveAdded");
opvp.match.playerDefensiveRemoved     = opvp.Signal("opvp.match.playerDefensiveRemoved");
opvp.match.playerDefensiveLevelUpdate = opvp.Signal("opvp.match.playerDefensiveLevelUpdate");
opvp.match.playerOffensiveAdded       = opvp.Signal("opvp.match.playerOffensiveAdded");
opvp.match.playerOffensiveLevelUpdate = opvp.Signal("opvp.match.playerOffensiveLevelUpdate");
opvp.match.playerOffensiveRemoved     = opvp.Signal("opvp.match.playerOffensiveRemoved");
opvp.match.playerCrowdControlAdded    = opvp.Signal("opvp.match.playerCrowdControlAdded");
opvp.match.playerCrowdControlRemoved  = opvp.Signal("opvp.match.playerCrowdControlRemoved");
opvp.match.playerInfoUpdate           = opvp.Signal("opvp.match.playerInfoUpdate");
opvp.match.playerSpecUpdate           = opvp.Signal("opvp.match.playerSpecUpdate");
opvp.match.playerSpellInterrupted     = opvp.Signal("opvp.match.playerSpellInterrupted");
opvp.match.playerTrinket              = opvp.Signal("opvp.match.playerTrinket");
opvp.match.playerTrinketUpdate        = opvp.Signal("opvp.match.playerTrinketUpdate");
opvp.match.rosterBeginUpdate          = opvp.Signal("opvp.match.rosterBeginUpdate");
opvp.match.rosterEndUpdate            = opvp.Signal("opvp.match.rosterEndUpdate");
opvp.match.roundWarmup                = opvp.Signal("opvp.match.roundWarmup");
opvp.match.roundActive                = opvp.Signal("opvp.match.roundActive");
opvp.match.roundComplete              = opvp.Signal("opvp.match.roundComplete");
opvp.match.statusChanged              = opvp.Signal("opvp.match.statusChanged");

function opvp.match.current()
    return opvp_match_mgr_singleton:match();
end

function opvp.match.dampening()
    return opvp_match_mgr_singleton:dampening();
end

function opvp.match.faction()
    local faction = GetBattlefieldArenaFaction();

    if faction == 0 then
        return opvp.HORDE;
    else
        return opvp.ALLIANCE;
    end
end

function opvp.match.hasDampening()
    return opvp_match_mgr_singleton:hasDampening();
end

function opvp.match.inMatch(ignoreTest)
    return opvp_match_mgr_singleton:inMatch(ignoreTest);
end

function opvp.match.isArena()
    return opvp_match_mgr_singleton:isArena();
end

function opvp.match.isBattleground()
    return opvp_match_mgr_singleton:isBattleground();
end

function opvp.match.isRated()
    return opvp_match_mgr_singleton:isRated();
end

function opvp.match.isSimulation()
    return opvp_match_mgr_singleton:isSimulation();
end

function opvp.match.isTest()
    return opvp_match_mgr_singleton:isTesting();
end

function opvp.match.manager()
    return opvp_match_mgr_singleton;
end

function opvp.match.tester()
    return opvp_match_mgr_singleton:tester();
end

opvp.match.utils = {};

local opvp_wow_to_match_status_lookup = {
    [Enum.PvPMatchState.Inactive]   = opvp.MatchStatus.INACTIVE;
    [Enum.PvPMatchState.Waiting]    = opvp.MatchStatus.ROUND_WARMUP;
    [Enum.PvPMatchState.StartUp]    = opvp.MatchStatus.ROUND_WARMUP;
    [Enum.PvPMatchState.Engaged]    = opvp.MatchStatus.ROUND_ACTIVE;
    [Enum.PvPMatchState.PostRound]  = opvp.MatchStatus.ROUND_COMPLETE;
    [Enum.PvPMatchState.Complete]   = opvp.MatchStatus.COMPLETE;
};

function opvp.match.utils.dampening()
    return C_Commentator.GetDampeningPercent();
end

function opvp.match.utils.state()
    local match_state = C_PvP.GetActiveMatchState();

    if match_state == nil then
        return opvp.MatchStatus.INACTIVE;
    end

    local status = opvp_wow_to_match_status_lookup[match_state];

    if status ~= nil then
        return status;
    else
        opvp.printWarning(
            "opvp.Match:statusFromActiveMatchState(), unknown Match State %d",
            match_state
        );

        return opvp.MatchStatus.INACTIVE;
    end
end

function opvp.match.utils.opponentSpec(index)
    local spec_id, sex = GetArenaOpponentSpec(index);

    if spec_id ~= nil then
        if sex == 2 then
            sex = opvp.Sex.MALE;
        elseif sex == 3 then
            sex = opvp.Sex.FEMALE;
        else
            sex = opvp.Sex.NEUTRAL;
        end

        return opvp.ClassSpec:fromSpecId(spec_id), sex;
    else
        return opvp.ClassSpec.UNKNOWN, opvp.Sex.NEUTRAL;
    end
end

function opvp.match.utils.opponentSpecs()
    local count = GetNumArenaOpponentSpecs()

    if count ~= nil then
        return count;
    else
        return 0;
    end
end

function opvp.match.utils.winner()
    local winner = C_PvP.GetActiveMatchWinner();

    if winner == nil then
        return opvp.MatchWinner.NONE;
    elseif winner == 255 then
        return opvp.MatchWinner.DRAW;
    elseif winner == GetBattlefieldArenaFaction() then
        return opvp.MatchWinner.WON;
    else
        return opvp.MatchWinner.LOST;
    end
end

local function opvp_match_mgr_singleton_ctor()
    opvp_match_mgr_singleton = opvp.MatchManager();

    opvp.printDebug("MatchManager - Initialized");
end

opvp.OnAddonLoad:register(opvp_match_mgr_singleton_ctor);
