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

local _, OpenPvpPlugin = ...
local opvpplugin = OpenPvpPlugin;

local opvp = _G.OpenPvp;

opvpplugin.PARTY_JOINED_WA_EVENT               = "OPVP_PARTY_JOINED";
opvpplugin.PARTY_LEFT_WA_EVENT                 = "OPVP_PARTY_LEFT";
opvpplugin.PARTY_ROSTER_BEGIN_UPDATE_WA_EVENT  = "OPVP_PARTY_ROSTER_BEGIN_UPDATE";
opvpplugin.PARTY_ROSTER_END_UPDATE             = "OPVP_PARTY_ROSTER_END_UPDATE";
opvpplugin.PARTY_MEMBER_INFO_UPDATE_WA_EVENT   = "OPVP_PARTY_MEMBER_INFO_UPDATE";
opvpplugin.PARTY_MEMBER_SPELL_INTERRUPTED      = "OPVP_PARTY_MEMBER_SPELL_INTERRUPTED";

opvpplugin.QUEUE_ACTIVE_WA_EVENT               = "OPVP_QUEUE_ACTIVE";
opvpplugin.QUEUE_READY_CHECK_BEGIN_WA_EVENT    = "OPVP_QUEUE_READY_CHECK_BEGIN";
opvpplugin.QUEUE_READY_CHECK_END_WA_EVENT      = "OPVP_QUEUE_READY_CHECK_END";
opvpplugin.QUEUE_READY_CHECK_UPDATE_WA_EVENT   = "OPVP_QUEUE_READY_CHECK_UPDATE";
opvpplugin.QUEUE_STATUS_CHANGED_WA_EVENT       = "OPVP_QUEUE_STATUS_CHANGED";

opvpplugin.USER_IN_COMBAT_CHANGED_WA_EVENT     = "OPVP_USER_IN_COMBAT_CHANGED";
opvpplugin.USER_SPEC_CHANGED_WA_EVENT          = "OPVP_USER_SPEC_CHANGED";
opvpplugin.USER_WARMODE_CHANGED_WA_EVENT       = "OPVP_USER_WARMODE_CHANGED";

opvpplugin.MATCH_PLAYER_SPELL_INTERRUPTED      = "OPVP_MATCH_PLAYER_SPELL_INTERRUPTED";

opvpplugin.COUNTDOWN_WA_EVENT                  = "OPVP_COUNTDOWN";

opvpplugin.OPVP_TIMER_UPDATE_WA_EVENT          = "OPVP_TIMER_UPDATE";

opvpplugin.weakAuraEvent = WeakAuras.ScanEvents;

local function opvp_connect_signal_to_wa_event(signal, event)
    signal:connect(
        function(...)
            opvpplugin.weakAuraEvent(event, ...)
        end
    );
end

local function opvp_party_member_info_update_wa(...)
    opvpplugin.weakAuraEvent(
        opvpplugin.PARTY_MEMBER_INFO_UPDATE_WA_EVENT,
        ...
    );
end

local function opvp_party_roster_begin_update_wa(...)
    opvpplugin.weakAuraEvent(
        opvpplugin.PARTY_ROSTER_BEGIN_UPDATE_WA_EVENT,
        ...
    );
end

local function opvp_party_roster_end_update_wa(...)
    opvpplugin.weakAuraEvent(
        opvpplugin.PARTY_ROSTER_END_UPDATE,
        ...
    );
end

local function opvp_party_joined_wa(party)
    opvpplugin.weakAuraEvent(
        opvpplugin.PARTY_JOINED_WA_EVENT,
        party
    );

    party.memberInfoUpdate:connect(opvp_party_member_info_update_wa);
    party.rosterBeginUpdate:connect(opvp_party_roster_begin_update_wa);
    party.rosterEndUpdate:connect(opvp_party_roster_end_update_wa);
end

local function opvp_party_left_wa(party)
    opvpplugin.weakAuraEvent(
        opvpplugin.PARTY_LEFT_WA_EVENT,
        party
    );

    party.memberInfoUpdate:disconnect(opvp_party_member_info_update_wa);
    party.rosterBeginUpdate:disconnect(opvp_party_roster_begin_update_wa);
    party.rosterEndUpdate:disconnect(opvp_party_roster_end_update_wa);
end

local function opvp_weakaura_init()
    local user = opvp.Player:instance();
    local party_mgr = opvp.party.manager();

    opvp_connect_signal_to_wa_event(opvp.queue.activeChanged,          opvpplugin.QUEUE_ACTIVE_WA_EVENT);
    opvp_connect_signal_to_wa_event(opvp.queue.statusChanged,          opvpplugin.QUEUE_STATUS_CHANGED_WA_EVENT);

    opvp_connect_signal_to_wa_event(opvp.party.countdown,              opvpplugin.COUNTDOWN_WA_EVENT);

    opvp_connect_signal_to_wa_event(user.inCombatChanged,              opvpplugin.USER_IN_COMBAT_CHANGED_WA_EVENT);
    opvp_connect_signal_to_wa_event(user.specChanged,                  opvpplugin.USER_SPEC_CHANGED_WA_EVENT);
    opvp_connect_signal_to_wa_event(user.warmodeChanged,               opvpplugin.USER_WARMODE_CHANGED_WA_EVENT);

    opvp_connect_signal_to_wa_event(opvp.queue.readyCheckBegin,        opvpplugin.QUEUE_READY_CHECK_BEGIN_WA_EVENT);
    opvp_connect_signal_to_wa_event(opvp.queue.readyCheckUpdate,       opvpplugin.QUEUE_READY_CHECK_END_WA_EVENT);
    opvp_connect_signal_to_wa_event(opvp.queue.readyCheckEnd,          opvpplugin.QUEUE_READY_CHECK_UPDATE_WA_EVENT);

    opvp_connect_signal_to_wa_event(opvp.match.playerSpellInterrupted, opvpplugin.MATCH_PLAYER_SPELL_INTERRUPTED);
    opvp_connect_signal_to_wa_event(opvp.party.memberSpellInterrupted, opvpplugin.PARTY_MEMBER_SPELL_INTERRUPTED);
end

opvpplugin.OnAddonLoad:register(opvp_weakaura_init);
