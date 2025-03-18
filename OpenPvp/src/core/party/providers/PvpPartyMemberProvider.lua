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

opvp.PvpPartyMemberProvider = opvp.CreateClass(opvp.GenericPartyMemberProvider);

function opvp.PvpPartyMemberProvider:init(factory)
    if factory == nil then
        factory = opvp.PvpPartyMemberFactory();
    end

    opvp.GenericPartyMemberProvider.init(self);

    assert(
        factory ~= nil and
        opvp.IsInstance(factory, opvp.PvpPartyMemberFactory)
    );

    self:_setFactory(factory);
end

function opvp.PvpPartyMemberProvider:_connectSignals()
    if self:hasPlayer() == true then
        opvp.GenericPartyMemberProvider._connectSignals(self);
    end

    --~ opvp.event.UPDATE_BATTLEFIELD_SCORE:connect(
        --~ self,
        --~ self._onUpdateScore
    --~ );
end

function opvp.PvpPartyMemberProvider:_disconnectSignals()
    if self:hasPlayer() == true then
        opvp.GenericPartyMemberProvider._disconnectSignals(self);
    end

    --~ opvp.event.UPDATE_BATTLEFIELD_SCORE:disconnect(
        --~ self,
        --~ self._onUpdateScore
    --~ );
end

function opvp.PvpPartyMemberProvider:_onUpdateScore()

end

function opvp.PvpPartyMemberProvider:_updateMemberScore(member)
    local mask = 0;

    if member:isGuidKnown() == false then
        return mask;
    end

    local info = C_PvP.GetScoreInfoByPlayerGuid(member:guid());

    if info == nil then
        return mask;
    end

    if member:isNameKnown() == false then
        member:_setName(info.name);

        mask = bit.bor(mask, opvp.PartyMember.NAME_FLAG);
    end

    if member:isRaceKnown() == false then
        member:_setRace(opvp.Race:fromRaceName(info.raceName));

        mask = bit.bor(mask, opvp.PartyMember.RACE_FLAG);
    end

    return mask;
end
