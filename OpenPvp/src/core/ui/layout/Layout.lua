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

opvp.Layout = opvp.CreateClass();

function opvp.Layout:init(index, info)
    self._index = index;
    self._info  = info;
end

function opvp.Layout:index()
    return self._index;
end

function opvp.Layout:isActive()
    return opvp.layout.activeIndex() == self._index;
end

function opvp.Layout:load()
    C_EditMode.SetActiveLayout(self._index);
end

function opvp.Layout:name()
    return self._info.layoutName;
end

function opvp.Layout:systems()
    return self._info.systems;
end

function opvp.Layout:type()
    return self._info.layoutType;
end

function opvp.Layout:_setIndex(index)
    self._index = index;
end

function opvp.Layout:_update(info)
    local name_changed = info.layoutName ~= self._info.layoutName;
    local layout_changed = not opvp.utils.compareTable(self._info.systems, info.systems);

    self._info = info;

    if name_changed == true and layout_changed == true then
        opvp.layout.modified:emit(self);
        opvp.layout.renamed:emit(self);
    elseif name_changed == true then
        opvp.layout.renamed:emit(self);
    elseif layout_changed == true then
        opvp.layout.modified:emit(self);
    end
end
