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

local opvp_areapoi_manager_singleton;

opvp.AreaPOIManager = opvp.CreateClass();

function opvp.AreaPOIManager:instance()
    return opvp_areapoi_manager_singleton;
end

function opvp.AreaPOIManager:init(info)
    self._map_id = 0;
    self._pois   = {};
    self._size   = 0;

    self.poiUpdate = opvp.Signal("opvp.AreaPOIManager.poiUpdate");

    opvp.event.AREA_POIS_UPDATED:connect(self, self.update);

    opvp.OnLoadingScreenEnd:connect(self, self.update);
end

function opvp.AreaPOIManager:find(poiId)
    return self._pois[poiId];
end

function opvp.AreaPOIManager:pois()
    return opvp.utils.copyTableShallow(self._pois);
end

function opvp.AreaPOIManager:size()
    return self._size;
end

function opvp.AreaPOIManager:update()
    local poi, id;
    local map_id = opvp.player.mapId();

    local pois = opvp.List();

    if map_id ~= 0 then
        pois:merge(C_AreaPoiInfo.GetAreaPOIForMap(map_id));
        pois:merge(C_AreaPoiInfo.GetDragonridingRacesForMap(map_id));
        pois:merge(C_AreaPoiInfo.GetDelvesForMap(map_id));
        pois:merge(C_AreaPoiInfo.GetEventsForMap(map_id));
        pois:merge(C_AreaPoiInfo.GetQuestHubsForMap(map_id));
    end

    self._size = pois:size();

    local old_pois    = self._pois;
    local new_pois    = {};
    local update_pois = {};
    local remove_pois = {};

    self._pois = {};

    if map_id ~= self._map_id then
        for n=1, pois:size() do
            id = pois:item(n);

            self._pois[id] = opvp.AreaPOI(map_id, id);
        end

        self._map_id = map_id;

        new_pois    = opvp.utils.copyTableShallow(self._pois);
        remove_pois = old_pois;
    else
        for n=1, pois:size() do
            id = pois:item(n);
            poi = old_pois[id];

            if poi == nil then
                poi = opvp.AreaPOI(map_id, id);

                self._pois[id] = poi;

                new_pois[id]   = poi
            else
                self._pois[id]  = poi;

                old_pois[id]    = nil;
                update_pois[id] = poi;
            end
        end

        remove_pois = old_pois;

        for id, poi in pairs(update_pois) do
            poi:update();
        end
    end

    self.poiUpdate:emit(new_pois, update_pois, remove_pois);
end

local function opvp_areapoi_manager_singleton_ctor()
    opvp_areapoi_manager_singleton = opvp.AreaPOIManager();

    opvp.printDebug("AreaPOIManager - Initialized");
end

opvp.OnAddonLoad:register(opvp_areapoi_manager_singleton_ctor);
