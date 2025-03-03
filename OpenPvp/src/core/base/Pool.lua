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

opvp.Pool = opvp.CreateClass();

function opvp.Pool:init(size, ctor, dtor)
    self._items = opvp.List();
    self._ctor = ctor;
    self._dtor = dtor;
    self._size = max(0, size);

    for n=1, self._size do
        local item = self._ctor();

        if item ~= nil then
            self._items:append(item);
        end
    end
end

function opvp.Pool:acquire()
    if self._items:isEmpty() == false then
        return self._items:popBack();
    else
        return nil;
    end
end

function opvp.Pool:available()
    return self._items:size();
end

function opvp.Pool:release(item)
    if (
        self._items:size() >= self._size or
        self._items:contains(item) == true
    ) then
        return;
    end

    if self._dtor ~= nil then
        self._dtor(item);
    end

    self._items:append(item);
end

function opvp.Pool:used()
    return self._size - self._items:size();
end

function opvp.Pool:size()
    return self._size;
end
