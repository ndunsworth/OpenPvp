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

opvp.PartyCrowdControlTracker = opvp.CreateClass();

function opvp.PartyCrowdControlTracker:init()
    self._connected = false;
    self._parties   = opvp.List();
end

function opvp.PartyCrowdControlTracker:connect()
    if self._connected == true then
        return;
    end

    self:_connect();

    self._connected = true;

    self:_onConnected();
end

function opvp.PartyCrowdControlTracker:disconnect()
    if self._connected == false then
        return;
    end

    self:_disconnect();

    self._connected = false;

    self:_onDisconnected();
end

function opvp.PartyCrowdControlTracker:isConnected()
    return self._connected;
end

function opvp.PartyCrowdControlTracker:isPartySupported(party)
    return true;
end

function opvp.PartyCrowdControlTracker:_addParty(party)
    if (
        self:isPartySupported(party) == false or
        self._parties:contains(party) == true
    ) then
        return;
    end

    party.memberAuraUpdate:connect(self, self._onMemberAuraUpdate);
    party.memberInfoUpdate:connect(self, self._onMemberInfoUpdate);
    party.rosterEndUpdate:connect(self, self._onRosterEndUpdate);

    self._parties:append(party);
end

function opvp.PartyCrowdControlTracker:_connect()

end

function opvp.PartyCrowdControlTracker:_createTracker(tracker)
    return nil;
end

function opvp.PartyCrowdControlTracker:_disconnect()
    local party;

    while self._parties:isEmpty() == false do
        self:_removeParty(self._parties:back());
    end
end

function opvp.PartyCrowdControlTracker:_onMemberAuraUpdate(member, aurasAdded, aurasUpdated, aurasRemoved, fullUpdate)
    local tracker = member:crowdControlTracker();

    if tracker == nil then
        return;
    end

    tracker:_onAuraUpdate(aurasAdded, aurasUpdated, aurasRemoved, fullUpdate);
end

function opvp.PartyCrowdControlTracker:_onConnected()

end

function opvp.PartyCrowdControlTracker:_onDisconnected()

end

function opvp.PartyCrowdControlTracker:_onMemberInfoUpdate(member, mask)
    if bit.band(mask, opvp.PartyMember.SPEC_FLAG) == 0 then
        return;
    end
end

function opvp.PartyCrowdControlTracker:_onRosterEndUpdate(party, newMembers, updatedMembers, removedMembers)
    if #newMembers == 0 and #removedMembers == 0 then
        return;
    end

    local trackers = {};
    local member;
    local tracker;

    for n=1, #removedMembers do
        member = removedMembers[n];

        tracker = member:_crowdControlTracker();

        if tracker ~= nil then
            member:_setCrowdControlTracker(nil);

            table.insert(trackers, tracker);
        end
    end

    for n=1, #newMembers do
        if #trackers == 0 then
            tracker = self:_createTracker();
        else
            tracker = trackers[#trackers];

            table.remove(trackers, #trackers)
        end

        assert(tracker ~= nil);

        newMembers[n]:_setCrowdControlTracker(tracker);
    end

    for n=1, #trackers do
        self:_releaseTracker(trackers[n]);
    end
end

function opvp.PartyCrowdControlTracker:_releaseTracker(tracker)

end

function opvp.PartyCrowdControlTracker:_removeParty(party)
    if self._parties:removeItem(party) == false then
        return;
    end

    party.memberAuraUpdate:disconnect(self, self._onMemberAuraUpdate);
    party.memberInfoUpdate:disconnect(self, self._onMemberInfoUpdate);
    party.rosterEndUpdate:disconnect(self, self._onRosterEndUpdate);
end
