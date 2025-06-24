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

opvp.PvpTestPartyMemberProvider = opvp.CreateClass(opvp.TestPartyMemberProvider);

function opvp.PvpTestPartyMemberProvider:init(hasPlayer)
    opvp.TestPartyMemberProvider.init(self, hasPlayer);

    self._match  = nil;
    self._tester = nil;
    self._rating = 0;

    self.scoreUpdate = opvp.Signal("opvp.PvpTestPartyMemberProvider.scoreUpdate");
end

function opvp.PvpTestPartyMemberProvider:isRated()
    return (
        self._match ~= nil and
        self._match:isRated() == true
    );
end

function opvp.PvpTestPartyMemberProvider:_connectSignals()
    opvp.event.UPDATE_BATTLEFIELD_SCORE:connect(self, self._onScoreUpdate);

    opvp.event.UNIT_SPELLCAST_CHANNEL_START:connect(self, self._onUnitSpellCastChannelStart);
    opvp.event.UNIT_SPELLCAST_CHANNEL_STOP:connect(self, self._onUnitSpellCastChannelStop);
    opvp.event.UNIT_SPELLCAST_CHANNEL_UPDATE:connect(self, self._onUnitSpellCastChannelUpdate);
    opvp.event.UNIT_SPELLCAST_EMPOWER_START:connect(self, self._onUnitSpellCastEmpowerStart);
    opvp.event.UNIT_SPELLCAST_EMPOWER_STOP:connect(self, self._onUnitSpellCastEmpowerStop);
    opvp.event.UNIT_SPELLCAST_EMPOWER_UPDATE:connect(self, self._onUnitSpellCastEmpowerUpdate);
    opvp.event.UNIT_SPELLCAST_FAILED:connect(self, self._onUnitSpellCastFailed);
    opvp.event.UNIT_SPELLCAST_FAILED_QUIET:connect(self, self._onUnitSpellCastFailedQuiet);
    opvp.event.UNIT_SPELLCAST_INTERRUPTED:connect(self, self._onUnitSpellCastInterrupted);
    opvp.event.UNIT_SPELLCAST_START:connect(self, self._onUnitSpellCastStart);
    opvp.event.UNIT_SPELLCAST_STOP:connect(self, self._onUnitSpellCastStop);
    opvp.event.UNIT_SPELLCAST_SUCCEEDED:connect(self, self._onUnitSpellCastSucceeded);

    opvp.TestPartyMemberProvider._connectSignals(self);
end

function opvp.PvpTestPartyMemberProvider:_disconnectSignals()
    opvp.event.UPDATE_BATTLEFIELD_SCORE:disconnect(self, self._onScoreUpdate);

    opvp.event.UNIT_SPELLCAST_CHANNEL_START:disconnect(self, self._onUnitSpellCastChannelStart);
    opvp.event.UNIT_SPELLCAST_CHANNEL_STOP:disconnect(self, self._onUnitSpellCastChannelStop);
    opvp.event.UNIT_SPELLCAST_CHANNEL_UPDATE:disconnect(self, self._onUnitSpellCastChannelUpdate);
    opvp.event.UNIT_SPELLCAST_EMPOWER_START:disconnect(self, self._onUnitSpellCastEmpowerStart);
    opvp.event.UNIT_SPELLCAST_EMPOWER_STOP:disconnect(self, self._onUnitSpellCastEmpowerStop);
    opvp.event.UNIT_SPELLCAST_EMPOWER_UPDATE:disconnect(self, self._onUnitSpellCastEmpowerUpdate);
    opvp.event.UNIT_SPELLCAST_FAILED:disconnect(self, self._onUnitSpellCastFailed);
    opvp.event.UNIT_SPELLCAST_FAILED_QUIET:disconnect(self, self._onUnitSpellCastFailedQuiet);
    opvp.event.UNIT_SPELLCAST_INTERRUPTED:disconnect(self, self._onUnitSpellCastInterrupted);
    opvp.event.UNIT_SPELLCAST_START:disconnect(self, self._onUnitSpellCastStart);
    opvp.event.UNIT_SPELLCAST_STOP:disconnect(self, self._onUnitSpellCastStop);
    opvp.event.UNIT_SPELLCAST_SUCCEEDED:disconnect(self, self._onUnitSpellCastSucceeded);

    opvp.TestPartyMemberProvider._disconnectSignals(self);
end

function opvp.PvpTestPartyMemberProvider:_onConnected()
    self._match  = opvp.match.current();
    self._tester = opvp.match.manager():tester();
    self._rating = 2400;

    if self._match:isRated() == true then
        local rating = self._match:bracket():rating();

        if rating > 0 then
            self._rating = rating;
        end
    end

    if self._match:isArena() == true then
        self._healers_max = 1;
    elseif self._match:isBlitz() == true then
        self._healers_max = 2;
    elseif self._match:isBattlegroundEpic() == true then
        self._healers_max = 10;
    else
        self._healers_max = 3;
    end

    opvp.TestPartyMemberProvider._onConnected(self);
end

function opvp.PvpTestPartyMemberProvider:_onDisconnected()
    opvp.TestPartyMemberProvider._onDisconnected(self);

    self._match = nil;
    self._tester = nil;
end

function opvp.PvpTestPartyMemberProvider:_onScoreUpdate()
    local rated = self:isRated();

    local member;

    for n=1, self:size() do
        self:_updateMemberScore(self:member(n), rated);
    end

    self.scoreUpdate:emit();
end

function opvp.PvpTestPartyMemberProvider:_updateMember(unitId, member, created)
    if created == false then
        return 0;
    end

    member:_setStats(self._match:map():stats());

    return 0;
end

function opvp.PvpTestPartyMemberProvider:_updateMemberScore(member, rated)
    if rated == true then
        if member:isRatingKnown() == false then
            local cr = math.random(max(0, self._rating - 100), self._rating + 75);
            local mmr = max(cr, math.random(max(0, self._rating - 75), self._rating + 100));

            member:_setRating(cr, mmr);
        elseif self._match:isActive() == true then
            if member:role():isDps() == true then
                member:_setDamage(math.random(35, 120) * 1000000);
                member:_setHealing(math.random(5, 25) * 1000000);
            else
                member:_setDamage(math.random(10, 28) * 1000000);
                member:_setHealing(math.random(80, 320) * 1000000);
            end
        elseif self._match:isComplete() == true then
            if member:team() == self._tester:outcomeTeam() then
                local gain = math.random(10, 40);

                member:_setRatingGain(gain, gain);

                if self._match:isShuffle() == true then
                    local stat = member:findStatById(opvp.PvpStatId.ROUNDS_WON);

                    if stat ~= nil then
                        stat:setValue(4);
                    end
                end
            else
                local gain = math.random(-48, -25);

                member:_setRatingGain(gain, gain);

                if self._match:isShuffle() == true then
                    local stat = member:findStatById(opvp.PvpStatId.ROUNDS_WON);

                    if stat ~= nil then
                        stat:setValue(2);
                    end
                end
            end
        end
    end
end
