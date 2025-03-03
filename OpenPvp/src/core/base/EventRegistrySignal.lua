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

opvp.EventRegistrySignal = opvp.CreateClass(opvp.Signal);

local opvp_registered_evenregistry_events = opvp.List();

function opvp.EventRegistrySignal:init(event, name, reverse)
    self._event = event;

    self._is_frame_event = string.find(self._event, "%.") == nil;

    if name == nil then
        name = event;
    end

    if self._is_frame_event == true then
        name = "wow.FrameEvent." .. name;
    else
        name = "wow.Callback." .. name;
    end

    opvp.Signal.init(self, name, reverse);

    self._owner = -1;
end

function opvp.EventRegistrySignal:connect(...)
    opvp.Signal.connect(self, ...);

    self:_registerCheck();
end

function opvp.EventRegistrySignal:disconnect(...)
    opvp.Signal.disconnect(self, ...);

    self:_unregisterCheck();
end

function opvp.EventRegistrySignal:_cleanup()
    opvp.Signal._cleanup(self)

    self:_unregisterCheck();
end

function opvp.EventRegistrySignal:_register()
    --~ opvp.printDebug(
        --~ "EventRegistrySignal(\"%s\"), registered",
        --~ self._event
    --~ );

    if self._is_frame_event == true then
        self._owner = EventRegistry:RegisterFrameEventAndCallback(
            self._event,
            function(owner, ...)
                if owner == self._owner then
                    self:emit(...);
                end
            end
        );
    else
        self._owner = EventRegistry:RegisterCallback(
            self._event,
            function(owner, ...)
                if owner == self._owner then
                    self:emit(...);
                end
            end
        );
    end
end

function opvp.EventRegistrySignal:_registerCheck()
    if (
        self._owner == -1 and
        self:hasConnections() == true
    ) then
        self:_register();
    end
end

function opvp.EventRegistrySignal:_unregister()
    --~ opvp.printDebug(
        --~ "EventRegistrySignal(\"%s\"), unregistered",
        --~ self._event
    --~ );

    if self._is_frame_event == true then
        EventRegistry:UnregisterFrameEventAndCallback(
            self._event,
            self._owner
        );
    else
        EventRegistry:UnregisterCallback(
            self._event,
            self._owner
        );
    end

    self._owner = -1;
end

function opvp.EventRegistrySignal:_unregisterCheck()
    if (
        self._owner ~= -1 and
        self:depth() == 0 and
        self:hasConnections() == false
    ) then
        self:_unregister();
    end
end
