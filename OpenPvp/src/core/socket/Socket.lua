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

local HEADER_SINGLE        = "\001";
local HEADER_MULTIPART     = "\002";
local HEADER_MULTIPART_END = "\003";

local MSG_LENGTH_MAX       = 254;

local opvp_connected_sockets = {};

opvp.SocketError = {
    NONE                =  0,
    DUPLICATE_PREFIX    =  1,
    GENERAL_ERROR       =  2,
    INVALID_CHANNEL     =  3,
    INVALID_CHAT_TYPE   =  4,
    INVALID_MESSAGE     =  5,
    INVALID_PREFIX      =  6,
    NOT_IN_GROUP        =  7,
    SYSTEM_LIMIT        =  8,
    TARGET_REQUIRED     =  9,
    THROTTLED_CHANNEL   = 10,
    THROTTLED_SOCKET    = 11,
    UNKNOWN             = 12
};

opvp.SocketPriority = {
    ALERT  = "ALERT",
    BULK   = "BULK",
    NORMAL = "NORMAL"
};

local opvp_addon_connect_status_lookup = {
    [Enum.RegisterAddonMessagePrefixResult.Success + 1]         = opvp.SocketError.NONE,
    [Enum.RegisterAddonMessagePrefixResult.DuplicatePrefix + 1] = opvp.SocketError.DUPLICATE_PREFIX,
    [Enum.RegisterAddonMessagePrefixResult.InvalidPrefix + 1]   = opvp.SocketError.INVALID_PREFIX,
    [Enum.RegisterAddonMessagePrefixResult.MaxPrefixes + 1]     = opvp.SocketError.SYSTEM_LIMIT
};

local opvp_addon_send_msg_status_lookup = {
    [Enum.SendAddonMessageResult.Success + 1]                   = opvp.SocketError.NONE,
    [Enum.SendAddonMessageResult.InvalidPrefix + 1]             = opvp.SocketError.INVALID_PREFIX,
    [Enum.SendAddonMessageResult.InvalidMessage + 1]            = opvp.SocketError.INVALID_MESSAGE,
    [Enum.SendAddonMessageResult.AddonMessageThrottle + 1]      = opvp.SocketError.THROTTLED_SOCKET,
    [Enum.SendAddonMessageResult.InvalidChatType + 1]           = opvp.SocketError.INVALID_CHAT_TYPE,
    [Enum.SendAddonMessageResult.NotInGroup + 1]                = opvp.SocketError.NOT_IN_GROUP,
    [Enum.SendAddonMessageResult.TargetRequired + 1]            = opvp.SocketError.TARGET_REQUIRED,
    [Enum.SendAddonMessageResult.InvalidChannel + 1]            = opvp.SocketError.INVALID_CHANNEL,
    [Enum.SendAddonMessageResult.ChannelThrottle + 1]           = opvp.SocketError.THROTTLED_CHANNEL,
    [Enum.SendAddonMessageResult.GeneralError + 1]              = opvp.SocketError.GENERAL_ERROR
};

opvp.Socket = opvp.CreateClass();

function opvp.Socket:encodeFrom(data)
    return C_EncodingUtil:DecodeBase64(data);
end

function opvp.Socket:encodeTo(data)
    return C_EncodingUtil:EncodeBase64(data);
end

function opvp.Socket:init(prefix)
    self._prefix    = ""
    self._connected = false;
    self._compress  = true;
    self._error     = opvp.SocketError.NONE;
    self._error_msg = "";
    self._buffer    = {};
    self._data      = opvp.List();

    self.connected     = opvp.Signal("opvp.Socket.connected");
    self.disconnected  = opvp.Signal("opvp.Socket.disconnected");
    self.readyRead     = opvp.Signal("opvp.Socket.readyRead");

    if opvp.is_str(prefix) then
        self._prefix = prefix;
    end
end

function opvp.Socket:canRead()
    return self._data:isEmpty() == false;
end

function opvp.Socket:clear()
    self._data:clear();
end

function opvp.Socket:connect()
    if self._connected == true then
        return;
    end

    self:_clearError();

    if opvp_connected_sockets[self._prefix] ~= nil then
        self:_setError(opvp.SocketError.DUPLICATE_PREFIX, "duplicate socket");
    end

    if C_ChatInfo.IsAddonMessagePrefixRegistered(self._prefix) == false then
        local status = C_ChatInfo.RegisterAddonMessagePrefix(self._prefix);

        if status ~= 0 then
            local err = opvp_addon_send_msg_status_lookup[status + 1];

            if err == nil then
                err = opvp.SocketError.UNKNOWN;
            end

            self:_setError(err, "");

            return;
        end
    end

    self._connected = opvp.event.CHAT_MSG_ADDON:connect(self, self._onMessageEvent);

    if self._connected == true then
        opvp_connected_sockets[self._prefix] = self;

        self.connected:emit();
    end
end

function opvp.Socket:disconnect()
    if self._connected == false then
        return;
    end

    opvp.event.CHAT_MSG_ADDON:disconnect(self, self._onMessageEvent);

    self._buffer    = {};
    self._connected = false;

    opvp_connected_sockets[self._prefix] = nil;

    self.disconnected:emit();
end

function opvp.Socket:error()
    return self._error;
end

function opvp.Socket:errorMessage()
    return self._error_msg;
end

function opvp.Socket:hasError()
    return self._error ~= opvp.SocketError.NONE;
end

function opvp.Socket:prefix()
    return self._prefix;
end

function opvp.Socket:read()
    return self._data:popFront();
end

function opvp.Socket:readAll()
    return self._data:release();
end

function opvp.Socket:readsAvailable()
    return self._data:size();
end

function opvp.Socket:write(data, channel, target, priority)
    if self._connected == false then
        return;
    end

    if self._compress == true then
        data = opvp.utils.compress(data);
    end

    data = opvp.Socket:encodeTo(data);

    local size     = #data;
    local pkg_name = self._prefix .. channel .. (target or "");

    if priority == nil then
        priority = opvp.SocketPriority.NORMAL;
    end

    if size + 1 < MSG_LENGTH_MAX then
        ChatThrottleLib:SendAddonMessage(
            priority,
            self._prefix,
            HEADER_SINGLE .. data,
            channel,
            target,
            pkg_name
        );

        return;
    end

    local chunk = strsub(data, 1, MSG_LENGTH_MAX);
    local pos   = MSG_LENGTH_MAX + 1;

    ChatThrottleLib:SendAddonMessage(
        priority,
        self._prefix,
        HEADER_MULTIPART .. chunk,
        channel,
        target,
        pkg_name
    );

    while pos + MSG_LENGTH_MAX <= size do
        chunk = strsub(data, pos, pos + MSG_LENGTH_MAX - 1);
        pos   = pos + MSG_LENGTH_MAX + 1;

        ChatThrottleLib:SendAddonMessage(
            priority,
            self._prefix,
            HEADER_MULTIPART .. chunk,
            channel,
            target,
            pkg_name
        );
    end

    chunk = strsub(data, pos);

    ChatThrottleLib:SendAddonMessage(
        priority,
        self._prefix,
        HEADER_MULTIPART_END .. chunk,
        channel,
        target,
        pkg_name
    );
end

function opvp.Socket:_clearError()
    self._error     = opvp.SocketError.NONE;
    self._error_msg = "";
end

function opvp.Socket:_onMessageEvent(
    prefix,
    message,
    channel,
    sender
)
    if (
        prefix ~= self._prefix or
        UnitIsUnit(Ambiguate(sender, "none"), "player")
    ) then
        return;
    end

    local header, msg = string.match(message, "^([\001-\003])(.*)");

    if header == nil then
        return;
    end

    if header == HEADER_SINGLE then
        msg = opvp.Socket:encodeFrom(msg);

        if self._compress == true then
            msg = opvp.utils.decompress(msg);
        end

        self._data:append(msg);

        self.readyRead:emit();

        return;
    end

    local key = prefix .. channel .. sender;
    local buffer = self._buffer[key];

    if buffer == nil then
        if header == HEADER_MULTIPART_END then
            return;
        end

        self._buffer[key] = {msg};
    elseif header == HEADER_MULTIPART then
        table.insert(buffer, msg);
    else
        local data = opvp.Socket:encodeFrom(table.concat(self._buffer[key], ""));

        if self._compress == true then
            data = opvp.utils.decompress(data);
        end

        self._data:append(data);

        self.readyRead:emit();

        self._buffer[key] = nil;
    end
end

function opvp.Socket:_setError(err, msg)
    opvp.printDebug(
        "opvp.Socket(\"%s\"):error[%d], %s",
        self._prefix,
        err,
        msg
    );

    self._error = err;

    if msg ~= nil then
        self._error_msg = msg;
    end
end
