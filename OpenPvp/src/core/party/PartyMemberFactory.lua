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

opvp.PartyMemberFactory = opvp.CreateClass();

function opvp.PartyMemberFactory:init(cache)
    if cache ~= nil then
        assert(opvp.IsInstance(cache, opvp.PartyMemberFactoryCache));
    end

    self._cache = cache;
end

function opvp.PartyMemberFactory:create(unitId, guid)
    local member;

    if guid == nil or guid == "" then
        guid = opvp.unit.guid(unitId)
    end

    local cached = false;

    if self._cache ~= nil and guid ~= "" then
        member = self._cache:find(guid);

        if member ~= nil then
            cached = true;
        else
            member = self._cache:pop();
        end
    end

    if member == nil then
        member = self:_create();
    end

    self:initialize(member, unitId, guid, cached);

    return member;
end

function opvp.PartyMemberFactory:hasCache()
    return self._cache ~= nil;
end

function opvp.PartyMemberFactory:initialize(member, unitId, guid, cached)
    member:_setId(unitId);

    if cached == false then
        member:_setGUID(guid);
    end
end

function opvp.PartyMemberFactory:release(member)
    if self._cache ~= nil then
        member:auras():_clear();

        self._cache:release(member);
    else
        member:_reset(opvp.PartyMember.DESTROY_FLAGS);
    end
end

function opvp.PartyMemberFactory:setCache(cache)
    if cache ~= nil then
        assert(opvp.IsInstance(cache, opvp.PartyMemberFactoryCache));
    end

    self._cache = cache;
end

function opvp.PartyMemberFactory:_create()
    return opvp.PartyMember();
end
