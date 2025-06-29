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

local opvp_combat_log_connection_sig_singleton;
local opvp_combat_log_server_singleton;

local null_connection = opvp.CombatLogConnection();
local null_provider;

opvp.private.CombatLogSignal = opvp.CreateClass(opvp.Signal);

function opvp.private.CombatLogSignal:init()
    opvp.Signal.init(self, "opvp.combatlog.event");
end

function opvp.private.CombatLogSignal:_onConnected()
    opvp_combat_log_connection_sig_singleton:connect();
end

function opvp.private.CombatLogSignal:_onDisconnected()
    opvp_combat_log_connection_sig_singleton:disconnect();
end

opvp.private.CombatLogConnectionPriv = opvp.CreateClass(opvp.CombatLogConnection);

function opvp.private.CombatLogConnectionPriv:init()
    opvp.CombatLogConnection.init(self);
end

function opvp.private.CombatLogConnectionPriv:event(event)
    opvp.combatlog.event:emit(event);
end

opvp.CombatLogServer = opvp.CreateClass(opvp.Object);

function opvp.CombatLogServer:instance()
    return opvp_combat_log_server_singleton;
end

function opvp.CombatLogServer:__del__()
    while self._connections:isEmpty() == false do
        self._connections:item(1):disconnect();
    end
end

function opvp.CombatLogServer:init()
    opvp.Object.init(self);

    self._connections      = opvp.List();
    self._providers        = opvp.List();
    self._exec             = false;
    self._needs_cleanup    = false;
    self._signal_connected = false;
    self._event            = opvp.CombatLogEvent();
end

function opvp.CombatLogServer:isEmpty()
    return (
        self._connections:isEmpty() and
        self._providers:isEmpty()
    );
end

function opvp.CombatLogServer:size()
    return (
        self._connections:size() +
        self._providers:size()
    );
end

function opvp.CombatLogServer:_cleanup()
    if self._needs_cleanup == false then
        return;
    end

    local index = self._connections:index(null_connection);

    while index > 0 do
        self._connections:removeIndex(index);

        index = self._connections:index(null_connection);
    end

    index = self._providers:index(null_provider);

    while index > 0 do
        self._providers:removeIndex(index);

        index = self._providers:index(null_provider);
    end

    self._needs_cleanup = false;

    if self:isEmpty() == true then
        opvp.event.COMBAT_LOG_EVENT_UNFILTERED:disconnect(
            self,
            self._onEvent
        );

        self._signal_connected = false;
    end

    opvp.printDebug(
        "opvp.CombatLogServer:_cleanup, size=%d",
        self:size()
    );
end

function opvp.CombatLogServer:_addConnection(connection)
    if (
        connection == nil or
        opvp.IsInstance(connection, opvp.CombatLogConnection) == false
    ) then
        return false;
    end

    self._connections:append(connection);

    if self._signal_connected == false then
        opvp.event.COMBAT_LOG_EVENT_UNFILTERED:connect(
            self,
            self._onEvent
        );

        self._signal_connected = true;
    end

    opvp.printDebug(
        "opvp.CombatLogServer:_addConnection, size=%d",
        self:size()
    );

    return true;
end

function opvp.CombatLogServer:_addPartyMemberProvider(provider)
    self._providers:append(provider);

    if self._signal_connected == false then
        opvp.event.COMBAT_LOG_EVENT_UNFILTERED:connect(
            self,
            self._onEvent
        );

        self._signal_connected = true;
    end

    opvp.printDebug(
        "opvp.CombatLogServer:_addPartyMemberProvider, size=%d",
        self:size()
    );
end

function opvp.CombatLogServer:_removeConnection(connection)
    if self._exec == true then
        local index = self._connections:index(connection);

        if index < 1 then
            return;
        end

        self._connections:replaceIndex(index, null_connection);

        self._needs_cleanup = true;

        return;
    end

    if (
        self._connections:removeItem(connection) == true and
        self:isEmpty() == true
    ) then
        opvp.event.COMBAT_LOG_EVENT_UNFILTERED:disconnect(
            self,
            self._onEvent
        );

        self._signal_connected = false;
    end

    opvp.printDebug(
        "opvp.CombatLogServer:_removeConnection, size=%d",
        self:size()
    );
end

function opvp.CombatLogServer:_removePartyMemberProvider(provider)
    if self._exec == true then
        local index = self._providers:index(provider);

        if index < 1 then
            return;
        end

        self._providers:replaceIndex(index, null_provider);

        self._needs_cleanup = true;

        return;
    end

    if (
        self._providers:removeItem(provider) == true and
        self:isEmpty() == true
    ) then
        opvp.event.COMBAT_LOG_EVENT_UNFILTERED:disconnect(
            self,
            self._onEvent
        );

        self._signal_connected = false;
    end

    opvp.printDebug(
        "opvp.CombatLogServer:_removePartyMemberProvider, size=%d",
        self:size()
    );
end

function opvp.CombatLogServer:_onEvent()
    self._exec = true;

    self:_cleanup();

    self._event:update();

    --~ opvp.printMessage(
        --~ "CombatLogServer[\"%s\"], %d connection",
        --~ opvp.utils.colorStringChatType(
            --~ self._event.subevent,
            --~ opvp.CHAT_TYPE_SYSTEM
        --~ ),
        --~ self._connections:size()
    --~ );

    local connection;

    for n=1, self._connections:size() do
        connection = self._connections:item(n);

        local status, err = pcall(connection.event, connection, self._event);

        if status == false then
            opvp.printWarning(result);
        end
    end

    local provider;

    for n=1, self._providers:size() do
        provider = self._providers:item(n);

        provider:_onCombatLogEvent(self._event);

        --~ local status, err = pcall(provider._onCombatLogEvent, provider, self._event);

        --~ if status == false then
            --~ opvp.printWarning(result);
        --~ end
    end

    self._exec = false;
end

local function opvp_combat_log_server_singleton_ctor()
    null_provider                            = opvp.PartyMemberProvider();
    opvp_combat_log_connection_sig_singleton = opvp.private.CombatLogConnectionPriv();
    opvp_combat_log_server_singleton         = opvp.CombatLogServer();

    opvp.printDebug("CombatLogServer - Initialized");

    opvp.combatlog.event = opvp.private.CombatLogSignal();
end

opvp.OnAddonLoad:register(opvp_combat_log_server_singleton_ctor);
