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

local opvp_queue_mgr_singleton;

opvp.queue = {};

opvp.queue.activeChanged    = opvp.Signal("opvp.queue.activeChanged");
opvp.queue.statusChanged    = opvp.Signal("opvp.queue.statusChanged");

opvp.queue.readyCheckBegin  = opvp.Signal("opvp.queue.readyCheckBegin");
opvp.queue.readyCheckUpdate = opvp.Signal("opvp.queue.readyCheckUpdate");
opvp.queue.readyCheckEnd    = opvp.Signal("opvp.queue.readyCheckEnd");

function opvp.queue.active()
    return opvp_queue_mgr_singleton:active();
end

function opvp.queue.hasActive()
    return opvp_queue_mgr_singleton:hasActive();
end

function opvp.queue.hasPending()
    return opvp_queue_mgr_singleton:hasPending();
end

function opvp.queue.isEnteringMatch()
    return opvp_queue_mgr_singleton:isEnteringMatch();
end

function opvp.queue.logPendingStatus()
    return opvp_queue_mgr_singleton:logPendingStatus();
end

function opvp.queue.manager()
    return opvp_queue_mgr_singleton;
end

function opvp.queue.pending()
    return opvp_queue_mgr_singleton:pendingQueues();
end

function opvp.queue.pendingSize()
    return opvp_queue_mgr_singleton:pendingSize();
end

local function opvp_queue_mgr_singleton_ctor()
    opvp_queue_mgr_singleton = opvp.QueueManager();

    opvp.printDebug("QueueManager - Initialized");
end

opvp.OnAddonLoad:register(opvp_queue_mgr_singleton_ctor);
