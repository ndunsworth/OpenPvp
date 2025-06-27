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

local opvp_null_provider;

opvp.ContestableMatchObjectiveStatusProvider = opvp.CreateClass();

function opvp.ContestableMatchObjectiveStatusProvider:null()
    return opvp_null_provider;
end

function opvp.ContestableMatchObjectiveStatusProvider:init()
    self._status = opvp.MatchObjectiveStatus.NOT_CONTESTED;

    self.changed = opvp.Signal("opvp.ContestableMatchObjectiveStatusProvider.changed");
end

function opvp.ContestableMatchObjectiveStatusProvider:isAllianceContested()
    return self._status == opvp.MatchObjectiveStatus.ALLIANCE_CONTESTED;
end

function opvp.ContestableMatchObjectiveStatusProvider:isAllianceControlled()
    return self._status == opvp.MatchObjectiveStatus.ALLIANCE_CONTROLLED;
end

function opvp.ContestableMatchObjectiveStatusProvider:isContested()
    return (
        self._status == opvp.MatchObjectiveStatus.ALLIANCE_CONTESTED or
        self._status == opvp.MatchObjectiveStatus.HORDE_CONTESTED
    );
end

function opvp.ContestableMatchObjectiveStatusProvider:isDisabled()
    return self._status == opvp.MatchObjectiveStatus.DISABLED;
end

function opvp.ContestableMatchObjectiveStatusProvider:isHordeContested()
    return self._status == opvp.MatchObjectiveStatus.HORDE_CONTESTED;
end

function opvp.ContestableMatchObjectiveStatusProvider:isHordeControlled()
    return self._status == opvp.MatchObjectiveStatus.HORDE_CONTROLLED;
end

function opvp.ContestableMatchObjectiveStatusProvider:status()
    return self._status;
end

function opvp.ContestableMatchObjectiveStatusProvider:_onStatusChanged(newStatus, oldStatus)
    self.changed:emit(newStatus, oldStatus);
end

local opvp_null_provider = opvp.ContestableMatchObjectiveStatusProvider();
