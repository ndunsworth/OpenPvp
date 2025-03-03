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

opvp.LayoutOption = opvp.CreateClass(opvp.EnumOption);

function opvp.LayoutOption:init(key, name, description)
    local layout_names = {
        "- none -",
        "Modern (Preset)",
        "Classic (Preset)"
    };

    opvp.EnumOption.init(self, key, name, description, layout_names);

    opvp.layout.added:connect(self, self._onLayoutAdded);
    opvp.layout.deleted:connect(self, self._onLayoutDeleted);
    opvp.layout.renamed:connect(self, self._onLayoutRenamed);
end

function opvp.LayoutOption:type()
    return opvp.LayoutOption.TYPE;
end

function opvp.LayoutOption:_onLayoutAdded(layout)
    self._values:insert(layout:index() + 1, layout:name());

    if layout:index() <= self._index then
        self._index = self._index + 1;

        self.valuesChanged:emit();

        self.changed:emit();
    else
        self.valuesChanged:emit();
    end
end

function opvp.LayoutOption:_onLayoutDeleted(layout)
    self._values:removeIndex(layout:index() + 1);

    if layout:index() <= self._index then
        if layout:index() ~= self._index then
            self._index = 1;
        end

        self.valuesChanged:emit();

        self.changed:emit();
    else
        self.valuesChanged:emit();
    end
end

function opvp.LayoutOption:_onLayoutRenamed(layout)
    self._values:replaceIndex(layout:index() + 1, layout:name());

    self.valuesChanged:emit();
end

local function create_layout_option(...)
    return opvp.LayoutOption(...);
end

opvp.LayoutOption.TYPE = opvp.OptionType("layout", create_layout_option);
