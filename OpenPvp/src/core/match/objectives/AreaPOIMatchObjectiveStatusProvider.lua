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

opvp.AreaPOIMatchObjectiveStatusProvider = opvp.CreateClass(opvp.ContestableMatchObjectiveStatusProvider);

function opvp.AreaPOIMatchObjectiveStatusProvider:null()
    return opvp_null_provider;
end

function opvp.AreaPOIMatchObjectiveStatusProvider:init(poi, lookup)
    opvp.ContestableMatchObjectiveStatusProvider.init(self);

    if poi ~= nil and opvp.IsInstance(poi, opvp.AreaPOI) then
        self._poi = poi;
    else
        self._poi = opvp.AreaPOI:null();
    end

    if lookup ~= nil and opvp.IsInstance(lookup, opvp.AreaPOIMatchObjectiveStatusMap) then
        self._lookup = lookup;
    else
        self._lookup = opvp.AreaPOIMatchObjectiveStatusMap();
    end
end

function opvp.AreaPOIMatchObjectiveStatusProvider:lookup()
    return self._lookup;
end

function opvp.AreaPOIMatchObjectiveStatusProvider:name()
    return self._poi:name();
end

function opvp.AreaPOIMatchObjectiveStatusProvider:poi()
    return self._poi;
end

function opvp.AreaPOIMatchObjectiveStatusProvider:position()
    return self._poi:position();
end

function opvp.AreaPOIMatchObjectiveStatusProvider:type()
    return opvp.MatchObjectiveType.NODE;
end

function opvp.AreaPOIMatchObjectiveStatusProvider:x()
    return self._poi:y();
end

function opvp.AreaPOIMatchObjectiveStatusProvider:y()
    return self._poi:x();
end

function opvp.AreaPOIMatchObjectiveStatusProvider:z()
    return self._poi:z();
end

function opvp.AreaPOIMatchObjectiveStatusProvider:_onUpdatedPOI()
    local status = self._map:lookup(self._poi);

    if status ~= self:status() then
        self:_onStatusChanged(status, self:status());
    end
end

function opvp.AreaPOIMatchObjectiveStatusProvider:_setLookup(lookup)
    assert(opvp.IsInstance(poi, opvp.AreaPOIMatchObjectiveStatusMap));

    if lookup == self._lookup then
        return;
    end

    local status = self:status();

    self._lookup = lookup;

    local lookup_status = self._map:lookup(self._poi);

    if lookup_status ~= status then
        self:_onStatusChanged(lookup_status, status);
    end
end

function opvp.AreaPOIMatchObjectiveStatusProvider:_setPOI(poi)
    if poi == nil then
        poi = opvp.AreaPOI:null();
    else
        assert(opvp.IsInstance(poi, opvp.AreaPOI));
    end

    if poi == self._poi then
        return;
    end

    self._poi.updated:disconnect(self, self._onUpdatedPOI);

    self._poi = poi;

    self._poi.updated:connect(self, self._onUpdatedPOI);

    self:_onUpdatedPOI();
end

opvp_null_provider = opvp.AreaPOIMatchObjectiveStatusProvider();
