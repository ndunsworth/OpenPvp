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

opvp.PvpMap = opvp.CreateClass(opvp.InstanceMap);

function opvp.PvpMap:createFromCurrentInstance()
    if IsInInstance() == true then
        return opvp.PvpMap:createFromInstanceId(select(8, GetInstanceInfo()));
    else
        return opvp.PvpMap.UNKNOWN;
    end
end

function opvp.PvpMap:createFromInstanceId(id)
    for n=1, #opvp.PvpMap.MAPS do
        if opvp.PvpMap.MAPS[n]:instanceId() == id then
            return opvp.PvpMap.MAPS[n];
        end
    end

    return opvp.PvpMap.UNKNOWN;
end

function opvp.PvpMap:createFromMapId(id)
    for n=1, #opvp.PvpMap.MAPS do
        if opvp.PvpMap.MAPS[n]:id() == id then
            return opvp.PvpMap.MAPS[n];
        end
    end

    return opvp.PvpMap.UNKNOWN;
end

function opvp.PvpMap:createFromName(name)
    for n=1, #opvp.PvpMap.MAPS do
        if opvp.PvpMap.MAPS[n]:name() == name then
            return opvp.PvpMap.MAPS[n];
        end
    end

    return opvp.PvpMap.UNKNOWN;
end

function opvp.PvpMap:init(cfg)
    opvp.InstanceMap.init(
        self,
        cfg.instance_id,
        cfg.map_id
    );

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

    self._stats = opvp.table_else(cfg.stats);

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

    self._pvp_short_desc = "";
    self._pvp_long_desc  = "";
end

function opvp.PvpMap:descriptionPvpShort()
    return self._pvp_short_desc;
end

function opvp.PvpMap:descriptionPvpLong()
    return self._pvp_long_desc;
end

function opvp.PvpMap:hasMusic()
    return self._music:isNull() == false;
end

function opvp.PvpMap:hasMusic()
    return self._music:isNull() == false;
end

function opvp.PvpMap:hasMusicIntro()
    return self._music:isNull() == false;
end

function opvp.PvpMap:hasStatWithId(id)
    for _id, statId in pairs(self._stats) do
        if _id == id then
            return true;
        end
    end

    return false;
end

function opvp.PvpMap:hasStatWithStatId(id)
    for _id, statId in pairs(self._stats) do
        if statId == id then
            return true;
        end
    end

    return false;
end

function opvp.PvpMap:hasWidgets()
    return self._widgets:isEmpty() == false;
end

function opvp.PvpMap:isCity()
    return false;
end

function opvp.PvpMap:music()
    return self._music;
end

function opvp.PvpMap:musicIntro()
    return self._music_intro;
end

function opvp.PvpMap:stats()
    local stats = {};

    for id, statId in pairs(self._stats) do
        table.insert(
            stats,
            opvp.MatchStat(id, statId)
        );
    end

    return stats;
end

function opvp.PvpMap:widget(name)
    local widget;

    for n=1, self._widgets:size() do
        widget = self._widgets:item(n);

        if widget:name() == name then
            return widget;
        end
    end

    return nil;
end

function opvp.PvpMap:widgets()
    return self._widgets:items();
end

opvp.PvpMap.UNKNOWN = opvp.InstanceMap(
    {
        instance_id  = opvp.InstanceId.UNKNOWN,
        map_id       = 0,
        widgets      = {}
    }
);

opvp.PvpMap.ARENA_MAPS        = {};
opvp.PvpMap.BATTLEGROUND_MAPS = {};
opvp.PvpMap.MAPS              = {opvp.PvpMap.UNKNOWN};
