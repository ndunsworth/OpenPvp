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

opvp.MatchObjectiveStatus = {
    NOT_CONTESTED       = 1,
    DISABLED            = 2,
    ALLIANCE_CONTESTED  = 3,
    ALLIANCE_CONTROLLED = 4,
    HORDE_CONTESTED     = 5,
    HORDE_CONTROLLED    = 6
};

opvp.ContestableMatchObjective = opvp.CreateClass(opvp.MatchObjective);

function opvp.ContestableMatchObjective:init(provider)
    opvp.MatchObjective.init(self);

    if provider == nil then
        provider = opvp.ContestableMatchObjectiveStatusProvider:null();
    else
        assert(
            opvp.IsInstance(
                provider,
                opvp.ContestableMatchObjectiveStatusProvider
            )
        );
    end

    self._status_provider = provider;

    self._status_provider.changed:connect(self, self._onStatusChanged);

    self.statusChanged = opvp.Signal("opvp.MatchObjectiveStatusProvider.changed");
end

function opvp.ContestableMatchObjective:isAllianceContested()
    return self._status_provider:isAllianceContested();
end

function opvp.ContestableMatchObjective:isAllianceControlled()
    return self._status_provider:isAllianceControlled();
end

function opvp.ContestableMatchObjective:isContested()
    return self._status_provider:isContested();
end

function opvp.ContestableMatchObjective:isDisabled()
    return self._status_provider:isDisabled();
end

function opvp.ContestableMatchObjective:isHordeContested()
    return self._status_provider:isHordeContested();
end

function opvp.ContestableMatchObjective:isHordeControlled()
    return self._status_provider:isHordeControlled();
end

function opvp.ContestableMatchObjective:isValidStatusProvider(provider)
    return opvp.IsInstance(
        provider,
        opvp.ContestableMatchObjectiveStatusProvider
    );
end

function opvp.ContestableMatchObjective:position()
    return CreateVector3D(0, 0, 0);
end

function opvp.ContestableMatchObjective:status()
    return self._status_provider:status();
end

function opvp.ContestableMatchObjective:statusProvider()
    return self._status_provider;
end

function opvp.ContestableMatchObjective:x()
    return 0;
end

function opvp.ContestableMatchObjective:y()
    return 0;
end

function opvp.ContestableMatchObjective:z()
    return 0;
end

function opvp.ContestableMatchObjective:_onStatusChanged(newStatus, oldStatus)
    self._status = newStatus;

    self.statusChanged:emit(newStatus, oldStatus);
end

function opvp.ContestableMatchObjective:_setStatusProvider(provider)
    assert(opvp.IsInstance(provider, opvp.ContestableMatchObjectiveStatusProvider));

    if provider == self._status_provider then
        return;
    end

    local old_status = self._status_provider:status();

    self._status_provider.changed:disconnect(self, self._onStatusChanged);

    self._status_provider = provider;

    self._status_provider.changed:connect(self, self._onStatusChanged);

    if self:status() ~= old_status then
        self:_onStatusChanged(self:status(), old_status);
    end
end
