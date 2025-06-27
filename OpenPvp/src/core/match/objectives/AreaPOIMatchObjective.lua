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

opvp.AreaPOIMatchObjective = opvp.CreateClass(opvp.ContestableMatchObjective);

function opvp.AreaPOIMatchObjective:init(provider)
    if provider == nil then
        provider = opvp.AreaPOIMatchObjectiveStatusProvider:null();
    else
        assert(
            opvp.IsInstance(
                provider,
                opvp.AreaPOIMatchObjectiveStatusProvider
            )
        );
    end

    opvp.ContestableMatchObjective.init(self, provider);
end

function opvp.AreaPOIMatchObjective:isValidStatusProvider(provider)
    return opvp.IsInstance(
        provider,
        opvp.AreaPOIMatchObjectiveStatusProvider
    );
end

function opvp.AreaPOIMatchObjective:name()
    return self._status_provider:name();
end

function opvp.AreaPOIMatchObjective:poi()
    return self._status_provider:poi();
end

function opvp.AreaPOIMatchObjective:position()
    return self._status_provider:position();
end

function opvp.AreaPOIMatchObjective:type()
    return opvp.MatchObjectiveType.NODE;
end

function opvp.AreaPOIMatchObjective:x()
    return self._status_provider:x();
end

function opvp.AreaPOIMatchObjective:y()
    return self._status_provider:y();
end

function opvp.AreaPOIMatchObjective:z()
    return self._status_provider:x();
end
