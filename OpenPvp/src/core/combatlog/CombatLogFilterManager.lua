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

local opvp_combat_log_filter_mgr_singleton = nil;
local null_filter = opvp.CombatLogFilter();

opvp.CombatLogFilterManager = opvp.CreateClass();

function opvp.CombatLogFilterManager:instance()
    if opvp_combat_log_filter_mgr_singleton ~= nil then
        return opvp_combat_log_filter_mgr_singleton;
    end

    opvp_combat_log_filter_mgr_singleton = opvp.CombatLogFilterManager();

    return opvp_combat_log_filter_mgr_singleton;
end

function opvp.CombatLogFilterManager:init()
    self._filters       = opvp.List();
    self._exec          = false;
    self._needs_cleanup = false;
    self._event         = opvp.CombatLogEvent();
end

function opvp.CombatLogFilterManager:addFilter(filter)
    if (
        filter == nil or
        opvp.IsInstance(filter, opvp.CombatLogFilter) == false
    ) then
        return false;
    end

    if self._filters:contains(filter) then
        return false;
    end

    self._filters:append(filter);

    if self._filters:size() == 1 then
        opvp.event.COMBAT_LOG_EVENT_UNFILTERED:connect(
            self,
            self._onEvent
        );
    end

    opvp.printDebug(
        "opvp.CombatLogFilterManager:addFilter, size=%d",
        self._filters:size()
    );

    return true;
end

function opvp.CombatLogFilterManager:isEmpty()
    return self._filters:isEmpty();
end

function opvp.CombatLogFilterManager:removeFilter(filter)

    if self._exec == true then
        local index = self._filters:index(filter);

        if index < 1 then
            return;
        end

        self._filters:replaceIndex(index, null_filter);

        self._needs_cleanup = true;

        return;
    end

    if (
        self._filters:removeItem(filter) == true and
        self._filters:isEmpty() == true
    ) then
        opvp.event.COMBAT_LOG_EVENT_UNFILTERED:disconnect(
            self,
            self._onEvent
        );
    end

    opvp.printDebug(
        "opvp.CombatLogFilterManager:removeFilter, size=%d",
        self._filters:size()
    );
end

function opvp.CombatLogFilterManager:size()
    return self._filters:size();
end

function opvp.CombatLogFilterManager:_cleanup()
    if self._needs_cleanup == false then
        return;
    end

    local index = self._filters:index(null_filter);

    while index > 0 do
        self._filters:removeIndex(index);

        index = self._filters:index(null_filter);
    end

    self._needs_cleanup = false;

    if self._filters:isEmpty() == true then
        opvp.event.COMBAT_LOG_EVENT_UNFILTERED:disconnect(
            self,
            self._onEvent
        );
    end

    opvp.printDebug(
        "opvp.CombatLogFilterManager:_cleanup, size=%d",
        self._filters:size()
    );
end

function opvp.CombatLogFilterManager:_onEvent()
    self._exec = true;

    self:_cleanup();

    self._event:update();

    --~ opvp.printMessage(
        --~ "CombatLogFilterManager[\"%s\"], %d filters",
        --~ opvp.utils.colorStringChatType(
            --~ self._event.subevent,
            --~ opvp.CHAT_TYPE_SYSTEM
        --~ ),
        --~ self._filters:size()
    --~ );

    for n=1, self._filters:size() do
        local filter = self._filters:item(n);

        local status, result = pcall(filter.eval, filter, self._event);

        if status == false then
            opvp.printWarning(result);
        elseif result == true then
            filter:triggered(self._event);
        end
    end

    self._exec = true;
end
