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

opvp.AreaPOI = opvp.CreateClass();

function opvp.AreaPOI:init(mapId, poiId)
    self._map_id = mapId;
    self._id     = poiId;

    self:update();
end

function opvp.AreaPOI:atlas()
    return self._atlas;
end

function opvp.AreaPOI:description()
    return self._description;
end

function opvp.AreaPOI:faction()
    return self._faction;
end

function opvp.AreaPOI:hasTooltipPadding()
    return self._add_tooltip_pad;
end

function opvp.AreaPOI:hasHoverHighlight()
    return self._quest_hover_highlight;
end

function opvp.AreaPOI:isAlwaysOnFlightmap()
    return self._always_flight_map;
end

function opvp.AreaPOI:isCurrentEvent()
    return self._is_cur_event;
end

function opvp.AreaPOI:isMapPrimary()
    return self._is_map_primary;
end

function opvp.AreaPOI:isTimed()
    return C_AreaPoiInfo.IsAreaPOITimed(self._id);
end

function opvp.AreaPOI:iconWidgetSet()
    return self._icon_widget_set;
end

function opvp.AreaPOI:id()
    return self._id;
end

function opvp.AreaPOI:idLink()
    return self._linked_id;
end

function opvp.AreaPOI:map()
    return self._map_id;
end

function opvp.AreaPOI:name()
    return self._name;
end

function opvp.AreaPOI:position()
    return self._pos:Copy();
end

function opvp.AreaPOI:texture()
    return self._tex;
end

function opvp.AreaPOI:textureIndex()
    return self._tex_index;
end

function opvp.AreaPOI:timeLeft()
    return opvp.number_else(
        C_AreaPoiInfo.GetAreaPOISecondsLeft(self._id)
    );
end

function opvp.AreaPOI:tooltipWidgetSet()
    return self._tooltip_widget_set;
end

function opvp.AreaPOI:textureIndex()
    return self._tex_index;
end

function opvp.AreaPOI:update(info)
    if info == nil then
        info = C_AreaPoiInfo.GetAreaPOIInfo(self._map_id, self._id);
    end

    self._id                    = info.areaPoiID;
    self._pos                   = info.position;
    self._name                  = info.name;
    self._description           = opvp.str_else(info.description);
    self._linked_id             = opvp.number_else(info.linkedUiMapID);
    self._tex_index             = opvp.number_else(info.textureIndex);
    self._tooltip_widget_set    = opvp.number_else(info.tooltipWidgetSet);
    self._icon_widget_set       = opvp.number_else(info.iconWidgetSet);
    self._atlas                 = opvp.str_else(info.atlasName);
    self._tex                   = opvp.str_else(info.uiTextureKit);
    self._faction               = opvp.number_else(info.factionID);
    self._is_map_primary        = info.isPrimaryMapForPOI;
    self._always_flight_map     = info.isAlwaysOnFlightmap;
    self._add_tooltip_pad       = opvp.bool_else(info.addPaddingAboveTooltipWidgets);
    self._quest_hover_highlight = info.highlightWorldQuestsOnHover;
    self._is_cur_event          = info.isCurrentEvent;

    self._old = info;
end
