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

opvp.NotifyInspectQueueItem = opvp.CreateClass(opvp.Signal);

function opvp.NotifyInspectQueueItem:init()
    opvp.Signal.init(self, "NotifyInspect");

    self._id       = "";
    self._time     = 0;
    self._retries  = 0;
end

function opvp.NotifyInspectQueueItem:isStale(timeout)
    return self._time > 0 and GetTime() - self._time >= timeout;
end

function opvp.NotifyInspectQueueItem:id()
    return self._id;
end

function opvp.NotifyInspectQueueItem:notifyInspect(state)
    self:emit(self._id, state);

    if state == true then
        ClearInspectPlayer();
    end
end

function opvp.NotifyInspectQueueItem:register(...)
    if self:connect(...) == true then
        self._time = GetTime();

        return true;
    else
        return false;
    end
end

function opvp.NotifyInspectQueueItem:requestInspect()
    local token = opvp.party.utils.findUnitTokenForGuid(self._id);

    if token == "" then
        self._retries = self._retries - 1;

        if self._retries < 0 then
            return -1;
        else
            return 0;
        end
    end

    if CanInspect(token) == true then
        opvp.printDebug(
            "NotifyRequest(%s): Requested",
            self._id
        );

        NotifyInspect(token);

        return 1;
    else
        return 0;
    end
end

function opvp.NotifyInspectQueueItem:setId(guid, retries)
    self._id       = guid;
    self._time     = GetTime();
    self._retries  = retries;

    self:disconnectAll();
end

local opvp_inspect_queue_singleton = nil;

opvp.NotifyInspectQueue = opvp.CreateClass();

function opvp.NotifyInspectQueue:init()
    self._queue         = opvp.List();
    self._pool          = opvp.Pool(40, opvp.NotifyInspectQueueItem);
    self._timer         = opvp.Timer(5);
    self._timer_sleep   = opvp.Timer(90);
    self._req           = nil;
    self._req_index     = 0;
    self._timeout       = 30;
    self._retries       = 3;
    self._connected     = false;
    self._request_delay = 3;
    self._request_last  = GetTime();

    self._timer_sleep:setTriggerLimit(1);

    self._timer.timeout:connect(self, self._onTimer);
    self._timer_sleep.timeout:connect(self, self._onTimerSleep);
end

function opvp.NotifyInspectQueue:clear()
    if self._queue:isEmpty() == true then
        return;
    end

    self:_disconnect();

    if self._req ~= nil then
        ClearInspectPlayer();
    end

    while self._queue:isEmpty() == false do
        local item = self._queue:popFront();

        self._pool:release(item);
    end

    self._req        = nil;
    self._req_index  = 0;
end

function opvp.NotifyInspectQueue:register(guid, ...)
    --~ opvp.printDebug(
        --~ "NotifyRequest: Register \"%s\"",
        --~ guid
    --~ );

    if guid == nil or type(guid) ~= "string" then
        --~ opvp.printWarning(
            --~ "NotifyRequest: guid is nil or not a string!"
        --~ );

        return false;
    end

    local item, index, created = self:_findItem(guid, true);

    if item == nil then
        --~ opvp.printWarning(
            --~ "NotifyRequest(%s): Queue is full!",
            --~ guid
        --~ );

        return false;
    end

    if created == true then
        if item:register(...) == false then
            self:_removeItem(item, index);

            --~ opvp.printWarning(
                --~ "NotifyRequest(%s): register failed!",
                --~ guid
            --~ );

            return false;
        elseif (
            self._queue:size() == 1 and
            self:_canRequest() == true and
            self:_requestItem(item, index) == -1
        ) then
            return false;
        else
            return true;
        end
    else
        return item:register(...);
    end
end

function opvp.NotifyInspectQueue:setRetryLimit(limit)
    if opvp.is_number(limit) == false then
        return;
    end

    self._retries = max(0, limit);
end

function opvp.NotifyInspectQueue:setStaleTimeout(timeout)
    if opvp.is_number(timeout) == false then
        return;
    end

    self._timeout = max(0, timeout);
end

function opvp.NotifyInspectQueue:unregister(guid, ...)
    local item, index, _ = self:_findItem(guid, false);

    if item == nil then
        return;
    end

    item:disconnect(...);

    if item:hasConnections() == false then
        self:_removeItem(item, index);
    end
end

function opvp.NotifyInspectQueue:_advance()
    local n = 1;
    local item;
    local status;

    if self:_canRequest() == false then
        return;
    end

    while n <= self._queue:size() do
        item = self._queue:item(n);

        status = self:_requestItem(item, n);

        if status == 1 then
            return;
        elseif status ~= -1 then
            n = n + 1;
        end
    end
end

function opvp.NotifyInspectQueue:_canRequest()
    return GetTime() - self._request_last >= self._request_delay;
end

function opvp.NotifyInspectQueue:_connect()
    if self._connected == true then
        return;
    end

    opvp.event.INSPECT_READY:connect(
        self,
        self._onRequestReady
    );

    self._timer_sleep:stop();
    self._timer:start();

    self._connected = true;

    --~ opvp.printDebug("NotifyRequest: Connected");
end

function opvp.NotifyInspectQueue:_disconnect()
    if self._connected == false then
        return;
    end

    self._timer:stop();
    self._timer_sleep:stop();

    opvp.event.INSPECT_READY:disconnect(
        self,
        self._onRequestReady
    );

    --~ opvp.printDebug("NotifyRequest: Disconnected");

    self._connected = false;
end

function opvp.NotifyInspectQueue:_sleep()
    self._timer:stop();
    self._timer_sleep:start();
end

function opvp.NotifyInspectQueue:_findItem(guid, create)
    for n=1, self._queue:size() do
        local item = self._queue:item(n);

        if item:id() == guid then
            return item, n, false;
        end
    end

    if create == false then
        return nil, 0, false;
    end

    local item = self._pool:acquire();
    local index = 0;

    if item ~= nil then
        self._queue:append(item);

        index = self._queue:size();

        item:setId(guid, self._retries);

        if self._queue:size() == 1 then
            self:_connect();
        end
    end

    return item, index, item ~= nil;
end

function opvp.NotifyInspectQueue:_onRequestReady(guid)
    --~ opvp.printDebug(
        --~ "NotifyRequest(%s):_onRequestReady",
        --~ guid
    --~ );

    local item = nil;
    local index = 0;
    local not_ours = false;

    if self._req ~= nil then
        if self._req:id() == guid then
            item = self._req;
            index = self._req_index;
        end
    else
        item, index = self:_findItem(guid, false);
    end

    if item ~= nil then
        --~ opvp.printDebug(
            --~ "NotifyRequest(%s): Ready",
            --~ item:id()
        --~ );

        self:_removeItem(item, index);

        item:notifyInspect(true);

        self._request_last = 0;

        self:_advance();
    end
end

function opvp.NotifyInspectQueue:_onTimer()
    local item;

    if self._req ~= nil then
        local status = self:_requestItem(self._req, self._req_index);

        if status == 1 then
            return;
        end
    end

    self:_advance();
end

function opvp.NotifyInspectQueue:_onTimerSleep()
    if self._connected == false or self._queue:isEmpty() == false then
        return;
    end

    self:_disconnect();
end

function opvp.NotifyInspectQueue:_removeItem(item, index)
    self._queue:removeItem(item);

    self._pool:release(item);

    if self._req == item then
        self._req = nil;
        self._req_index = 0;
    end

    if self._queue:isEmpty() == true then
        self:_sleep();
    end

    --~ opvp.printDebug(
        --~ "NotifyRequest(%s): Removed",
        --~ item:id()
    --~ );
end

function opvp.NotifyInspectQueue:_requestItem(item, index)
    if item:isStale(self._timeout) == true then
        --~ opvp.printWarning(
            --~ "NotifyRequest(%s): onTimer is stale!",
            --~ item:id()
        --~ );

        self:_removeItem(item, index);

        item:notifyInspect(false);

        return -1;
    end

    local status = item:requestInspect();

    if status == -1 then
        self:_removeItem(item, index);

        item:notifyInspect(false);

        return -1;
    end

    if status == 1 then
        self._req          = item;
        self._req_index    = index;
        self._request_last = GetTime();
    else
        self._req          = nil;
        self._req_index    = 0;
    end

    self._timer:start();

    return status;
end

opvp.inspect = nil;

local function opvp_inspect_queue_singleton_ctor()
    opvp_inspect_queue_singleton = opvp.NotifyInspectQueue();

    opvp.inspect = opvp_inspect_queue_singleton;

    --~ opvp.printDebug("InspectQueue - Initialized");
end

opvp.OnAddonLoad:register(opvp_inspect_queue_singleton_ctor);
