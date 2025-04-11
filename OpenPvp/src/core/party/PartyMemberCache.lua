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

opvp.PartyMemberFactoryCache = opvp.CreateClass(opvp.PartyMemberFactory);

function opvp.PartyMemberFactoryCache:init(limit)
    self._cache      = opvp.List();
    self._reset_mask = opvp.PartyMember.ALL_FLAGS;
    self._clean_mask = bit.bor(
        opvp.PartyMember.STATE_FLAGS,
        opvp.PartyMember.SPEC_FLAG,
        opvp.PartyMember.ID_FLAG
    );

    if opvp.is_number(limit) then
        self._limit = max(0, limit);
    else
        self._limit = 0;
    end
end

function opvp.PartyMemberFactoryCache:find(guid)
    local member;

    for n=1, self._cache:size() do
        member = self._cache:item(n);

        if (
            member:isGuidKnown() == true and
            member:guid() == guid
        ) then
            self:_cleanMember(member);

            return member;
        end
    end

    member = self._cache:popFront();

    if member ~= nil then
        self:_resetMember(member);
    end

    return member;
end

function opvp.PartyMemberFactoryCache:limit()
    return self._limit
end

function opvp.PartyMemberFactoryCache:memberClearFlags(mask)
    return self._clean_mask;
end

function opvp.PartyMemberFactoryCache:memberResetFlags(mask)
    return self._reset_mask;
end

function opvp.PartyMemberFactoryCache:release(member)
    if self._limit == 0 then
        self:_destroyMember(member);

        return;
    end

    if self._cache:size() == self._limit then
        local member = self._cache:popFront();

        self:_destroyMember(member);
    end

    self._cache:append(member);
end

function opvp.PartyMemberFactoryCache:setLimit(limit)
    limit = max(0, limit);

    if limit == self._limit then
        return;
    end

    local member;

    if limit == 0 then
        for n=1, self._cache:size() do
            member = self._cache:item(n);

            self:_destroyMember(member);
        end
    elseif limit < self._cache:size() then
        local last_index = self._cache:size();
        local index = limit + 1;

        for n=limit + 1, last_index do
            member = self._cache:popBack();

            self._destroyMember(member);
        end
    end

    self._limit = limit;
end

function opvp.PartyMemberFactoryCache:setMemberClearFlags(mask)
    self._clean_mask = mask;
end

function opvp.PartyMemberFactoryCache:setMemberResetFlags(mask)
    self._reset_mask = mask;
end

function opvp.PartyMemberFactoryCache:size()
    self._cache:size();
end

function opvp.PartyMemberFactoryCache:_cleanMember(member)
    member:_reset(self._clean_mask);
end

function opvp.PartyMemberFactoryCache:_destroyMember(member)
    member:_reset(opvp.PartyMember.DESTROY_FLAGS);
end

function opvp.PartyMemberFactoryCache:_resetMember(member)
    member:_reset(self._reset_mask);
end
