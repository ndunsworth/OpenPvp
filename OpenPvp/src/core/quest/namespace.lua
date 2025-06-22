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

local opvp_questlog_singleton;

opvp.questlog = {};

function opvp.questlog.find(questId)
    return opvp_questlog_singleton:find(questId);
end

function opvp.questlog.instance()
    return opvp_questlog_singleton;
end

function opvp.questlog.maximum()
    return opvp_questlog_singleton:maximum();
end

function opvp.questlog.maximumAcceptable()
    return opvp_questlog_singleton:maximumAcceptable();
end

function opvp.questlog.poiMapId()
    return opvp_questlog_singleton:poiMapId();
end

function opvp.questlog.quest(index)
    return opvp_questlog_singleton:quest(index);
end

function opvp.questlog.quests()
    return opvp_questlog_singleton:quests();
end

function opvp.questlog.size(onlyVisible)
    return opvp_questlog_singleton:size(onlyVisible);
end

function opvp.questlog.sortWatched()
    opvp_questlog_singleton:sortWatched();
end

function opvp.questlog.trackedSize()
    return opvp_questlog_singleton:trackedSize();
end

function opvp.questlog.trackedWorldQuestSize()
    return opvp_questlog_singleton:trackedWorldQuestSize();
end

local function opvp_questlog_singleton_ctor()
    opvp_questlog_singleton = opvp.QuestLog();

    opvp.printDebug("QuestLog - Initialized");
end

opvp.OnAddonLoad:register(opvp_questlog_singleton_ctor);
