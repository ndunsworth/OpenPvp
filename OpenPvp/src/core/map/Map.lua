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

opvp.Map = opvp.CreateClass();

opvp.Map.ARENA_MAPS        = {};
opvp.Map.BATTLEGROUND_MAPS = {};
opvp.Map.MAPS              = {};

function opvp.Map:createFromCurrentInstance()
    if IsInInstance() == true then
        return opvp.Map:createFromInstanceId(select(8, GetInstanceInfo()));
    else
        return opvp.Map.UNKNOWN;
    end
end

function opvp.Map:createFromInstanceId(id)
    for n=1, #opvp.Map.MAPS do
        if opvp.Map.MAPS[n]:id() == id then
            return opvp.Map.MAPS[n];
        end
    end

    return opvp.Map.UNKNOWN;
end

function opvp.Map:createFromMapId(id)
    for n=1, #opvp.Map.MAPS do
        if opvp.Map.MAPS[n]:map() == id then
            return opvp.Map.MAPS[n];
        end
    end

    return opvp.Map.UNKNOWN;
end

function opvp.Map:createFromName(name)
    for n=1, #opvp.Map.MAPS do
        if opvp.Map.MAPS[n]:name() == name then
            return opvp.Map.MAPS[n];
        end
    end

    return opvp.Map.UNKNOWN;
end

function opvp.Map:init(cfg)
    if cfg.instance_id ~= nil then
        self._inst_id = cfg.instance_id;
    else
        self._inst_id = 0;
    end

    if cfg.map_id ~= nil then
        self._map_id = cfg.map_id;
    else
        self._map_id = 0;
    end

    if self._inst_id ~= opvp.InstanceId.UNKNOWN then
        self._name = GetRealZoneText(self._inst_id);
    else
        self._name = "";
    end;

    self._widgets = opvp.List();

    if cfg.widgets ~= nil and #cfg.widgets > 0 then
        local widget;

        for n=1, #cfg.widgets do
            widget = opvp.UiWidget:createFromCfg(cfg.widgets[n]);

            if widget ~= nil then
                self._widgets:append(widget);
            end
        end
    end

    if cfg.stats ~= nil then
        self._stats = cfg.stats;
    else
        self._stats = {};
    end

    if cfg.music ~= nil then
        self._music = opvp.Sound:createFromCfgData(cfg.music);
    else
        self._music = opvp.Sound:null();
    end

    if cfg.music_intro ~= nil then
        self._music_intro = opvp.Sound:createFromCfgData(cfg.music_intro);
    else
        self._music_intro = opvp.Sound:null();
    end
end

function opvp.Map:hasMapId()
    return self._map_id ~= 0;
end

function opvp.Map:hasMusic()
    return self._music:isNull() == false;
end

function opvp.Map:hasMusic()
    return self._music:isNull() == false;
end

function opvp.Map:hasMusicIntro()
    return self._music:isNull() == false;
end

function opvp.Map:hasStatWithId(id)
    for _id, statId in pairs(self._stats) do
        if _id == id then
            return true;
        end
    end

    return false;
end

function opvp.Map:hasStatWithStatId(id)
    for _id, statId in pairs(self._stats) do
        if statId == id then
            return true;
        end
    end

    return false;
end

function opvp.Map:hasWidgets()
    return self._widgets:isEmpty() == false;
end

function opvp.Map:id()
    return self._inst_id;
end

function opvp.Map:instanceId()
    return self._inst_id;
end

function opvp.Map:isValid()
    return self._inst_id ~= opvp.UNKNOWN_MAP;
end

function opvp.Map:map()
    return self._map_id;
end

function opvp.Map:mapId()
    return self._map_id;
end

function opvp.Map:music()
    return self._music;
end

function opvp.Map:musicIntro()
    return self._music_intro;
end

function opvp.Map:name()
    return self._name;
end

function opvp.Map:stats()
    local stats = {};

    for id, statId in pairs(self._stats) do
        table.insert(
            stats,
            opvp.MatchStat(id, statId)
        );
    end

    return stats;
end

function opvp.Map:toStript()
    return self._inst_id;
end

function opvp.Map:widget(name)
    local widget;

    for n=1, self._widgets:size() do
        widget = self._widgets:item(n);

        if widget:name() == name then
            return widget;
        end
    end

    return nil;
end

function opvp.Map:widgets()
    return self._widgets:items();
end
