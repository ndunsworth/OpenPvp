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

opvp.List = opvp.CreateClass();

function opvp.List:createFromArray(items)
    local list = opvp.List();

    if items ~= nil then
        list._items = items;
    end

    return list;
end

function opvp.List:createCopyFromArray(items)
    local list = opvp.List();

    if items ~= nil then
        for n=1, #items do
            list:append(items[n]);
        end
    end

    return list;
end

function opvp.List:init()
    self._items = {};
end

function opvp.List.__metatable__.__eq(self, other)
    if opvp.IsInstance(other, opvp.List) then
        if self ~= other then
            return opvp.utils.compareTable(self._items, other._items);
        else
            return true;
        end
    elseif opvp.is_table(other) then
        return self._items == other;
    else
        return false;
    end
end

function opvp.List:append(item)
    return self:insert(-1, item);
end

function opvp.List:clear()
    if #self._items > 0 then
        self._items = {};
    end
end

function opvp.List:contains(item, cmp)
    return self:hasItem(item, cmp);
end

function opvp.List:first()
    return self._items[1];
end

function opvp.List:hasItem(item, cmp)
    return self:index(item, cmp) ~= 0;
end

function opvp.List:index(item, cmp)
    local index = 0;

    if cmp == nil then
        for i = 1, #self._items do
            if self._items[i] == item then
                index = i;

                break
            end
        end
    else
        for i = 1, #self._items do
            if cmp(self._items[i], item) == true then
                index = i;

                break
            end
        end
    end

    return index;
end

function opvp.List:insert(index, item)
    if index < 1 or index > #self._items then
        table.insert(self._items, item);
    else
        table.insert(self._items, index, item);
    end
end

function opvp.List:isEmpty()
    return self:size() == 0;
end

function opvp.List:item(index)
    return self._items[index];
end

function opvp.List:items()
    local result = {};

    for i = 1, #self._items do
        table.insert(result, self._items[i]);
    end

    return result;
end

function opvp.List:last()
    return self._items[#self._items];
end

function opvp.List:merge(items)
    if opvp.IsInstance(items, opvp.List) and items ~= self then
        for n=1, #items._items do
            table.insert(self._items, items._items[n]);
        end
    elseif opvp.is_table(items) == true then
        for n=1, #items do
            table.insert(self._items, items[n]);
        end
    end

    --~ if opvp.IsInstance(items, opvp.List) and items ~= self then
        --~ items = items._items;
    --~ elseif opvp.is_table(items) == false then
        --~ return;
    --~ end

    --~ for n=1, #items do
        --~ table.insert(self._items, items[n]);
    --~ end
end

function opvp.List:pop(index)
    local item = self:item(index);

    if not item then
        return nil;
    end

    table.remove(self._items, index);

    return item;
end

function opvp.List:popBack()
    return self:pop(self:size());
end

function opvp.List:popFront()
    return self:pop(1);
end

function opvp.List:prepend(item)
    return self:insert(1, item);
end

function opvp.List:release()
    local data = self._items;

    self._items = {};

    return data;
end

function opvp.List:removeIndex(index, count)
    if (self:size() == 0 or index > self:size()) then
        return false;
    end

    if count == nil then
        table.remove(self._items, index);

        return true;
    end

    count = min(max(0, count), self:size());

    if count == 0 then
        return false;
    end

    while count > 0 do
        table.remove(self._items, index);

        count = count - 1;
    end

    return true;
end

function opvp.List:removeItem(item, cmp)
    if cmp == nil then
        for i = 1, #self._items do
            if self._items[i] == item then
                table.remove(self._items, i);

                return true;
            end
        end
    else
        for i = 1, #self._items do
            if cmp(self._items[i], item) == true then
                table.remove(self._items, i);

                return true;
            end
        end
    end

    return false;
end

function opvp.List:removeItems(items, cmp)
    if opvp.IsInstance(items, opvp.List) and items ~= self then
        for n=1, items:size() do
            self:removeItem(items:item(n), cmp);
        end
    elseif opvp.is_table(items) == true then
        for n=1, #items do
            self:removeItem(items[n], cmp);
        end
    end
end

function opvp.List:replaceIndex(index, item)
    if index > 0 and index <= #self._items then
        self._items[index] = item;

        return true;
    else
        return false;
    end
end

function opvp.List:reverse()
    local result = {}

    for i = #self._items, 1, -1 do
        table.insert(result, self._items[i]);
    end

    self._items = result;
end

function opvp.List:shuffle()
    local m = self:size();
    local t, i;

    while m > 1 do
        i = math.floor(math.random(1, m));

        m = m - 1;

        t = self._items[m];

        self._items[m] = self._items[i];
        self._items[i] = t;
    end
end

function opvp.List:size()
    return #self._items;
end

function opvp.List:sort(cmp)
    if cmp == nil then
        table.sort(self._items)
    else
        table.sort(self._items, cmp)
    end
end

function opvp.List:swap(other)
    if (
        other == nil or
        other == self or
        opvp.IsInstance(other, opvp.List) == false
    ) then
        return;
    end

    local tmp = self._items;

    self._items = other._items;
    other._items = tmp;
end

function opvp.List:take(index)
    local result = nil;

    if (self:size() > 0 and index <= self:size()) then
        result = self._items[index];
    end

    return result;
end
