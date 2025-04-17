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

opvp.ClassSpecCounter = opvp.CreateClass();

function opvp.ClassSpecCounter:init()
    self._map         = {};
    self._class_count = 1; --~ Set to one so clear does init of map
    self._spec_count  = 0;

    self.added        = opvp.Signal("opvp.ClassSpecCounter.added");
    self.incr         = opvp.Signal("opvp.ClassSpecCounter.incr");
    self.removed      = opvp.Signal("opvp.ClassSpecCounter.removed");

    self:clear();
end

function opvp.ClassSpecCounter:classCount(class)
    local count = 0;

    local info = self:_findClass(class);

    if info == nil then
        return count;
    end

    for k, v in pairs(info) do
        count = count + v;
    end
end

function opvp.ClassSpecCounter:classesWithNoRefs()
    local result = {};
    local class;

    for n=1, #opvp.Class.CLASSES do
        if self._map[n][-1] == 0 then
            table.insert(self._map, opvp.Class.CLASSES[n]);
        end
    end

    return result;
end

function opvp.ClassSpecCounter:classesWithRefs()
    local result = {};
    local class;

    for n=1, #opvp.Class.CLASSES do
        if self._map[n][-1] > 0 then
            table.insert(self._map, opvp.Class.CLASSES[n]);
        end
    end

    return result;
end

function opvp.ClassSpecCounter:clear()
    if self._class_count == 0 then
        return;
    end

    local class;
    local class_specs;
    local specs;

    for n=1, #opvp.Class.CLASSES do
        class = opvp.Class.CLASSES[n];
        class_specs = class:specs();

        specs = {
            [-1] = 0
        };

        for x=1, #class_specs do
            specs[class_specs[x]:id()] = 0;
        end

        table.insert(self._map, specs);
    end

    self._class_count = 0;
    self._spec_count  = 0;
end

function opvp.ClassSpecCounter:deref(spec)
    if opvp.is_number(spec) then
        spec = opvp.ClassSpec:fromSpecId(spec);
    elseif opvp.IsInstance(spec, opvp.ClassSpec) == false then
        return -1, -1;
    end

    local info = self:_findClass(spec);

    assert(info ~= nil);

    local id = spec:id();

    local count_class = info[-1];
    local count_spec  = info[id];

    if count_spec > 0 then
        count_class = count_class - 1;
        count_spec = count_spec - 1;

        info[-1] = count_class;
        info[id] = count_spec;

        self.incr:emit(spec, -1, count_class);

        if count_spec == 0 then
            self._spec_count = self._spec_count - 1;

            self.removed:emit(spec, count_class);
        end

        if count_class == 0 then
            self._class_count = self._class_count - 1;
        end
    end;

    return count_spec, count_class;
end

function opvp.ClassSpecCounter:isEmpty()
    return self._class_count == 0;
end

function opvp.ClassSpecCounter:logClasses(onlyRefs)
    local spec;

    for k, class_info in pairs(self._map) do
        for spec_id, refs in pairs(class_info) do
            spec = opvp.ClassSpec:fromSpecId(spec_id);

            if onlyRefs ~= true or refs > 0 then
                opvp.printDebug(
                    "%s %s %s x%d",
                    opvp.utils.textureIdMarkup(spec:icon()),
                    spec:name(),
                    spec:classInfo():name(),
                    refs
                );
            end
        end
    end
end

function opvp.ClassSpecCounter:ref(spec)
    if opvp.is_number(spec) then
        spec = opvp.ClassSpec:fromSpecId(spec);
    elseif opvp.IsInstance(spec, opvp.ClassSpec) == false then
        return -1, -1;
    end

    local info = self:_findClass(spec);

    assert(info ~= nil);

    local id = spec:id();

    local count_class = info[-1] + 1;
    local count_spec  = info[id] + 1;

    info[-1] = count_class;
    info[id] = count_spec;

    self.incr:emit(spec, 1);

    if count_spec == 1 then
        self._spec_count = self._spec_count + 1;

        self.added:emit(spec, count_class);
    end

    if count_class == 1 then
        self._class_count = self._class_count + 1;
    end

    return count_spec, count_class;
end

function opvp.ClassSpecCounter:specCount(spec)
    if opvp.is_number(spec) then
        spec = opvp.ClassSpec:fromSpecId(spec);
    elseif opvp.IsInstance(spec, opvp.ClassSpec) == false then
        return 0;
    end

    local info = self:_findClass(spec);

    if info ~= nil then
        return info[spec:id()];
    else
        return 0;
    end
end

function opvp.ClassSpecCounter:_findClass(class)
    local id;

    if opvp.is_number(class) then
        id = class;
    elseif opvp.IsInstance(class, opvp.Class) then
        id = class:id();
    elseif opvp.IsInstance(class, opvp.ClassSpec) then
        id = class:class();
    else
        return nil;
    end

    return self._map[id + 1];
end
