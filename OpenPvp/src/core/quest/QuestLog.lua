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

opvp.QuestLog = opvp.CreateClass();

function opvp.QuestLog:init()
    self._quest_map  = {};
    self._quest_list = opvp.List();

    self.accepted  = opvp.Signal("opvp.QuestLog.accepted");
    self.completed = opvp.Signal("opvp.QuestLog.completed");
    self.removed   = opvp.Signal("opvp.QuestLog.removed");

    opvp.event.QUEST_ACCEPTED:connect(self, self._onQuestAccepted);
    opvp.event.QUEST_REMOVED:connect(self, self._removeQuest);
    opvp.event.QUEST_TURNED_IN:connect(self, self._onQuestTurnedIn);

    self:_refresh();
end

function opvp.QuestLog:find(questId)
    return self._quest_map[questId];
end

function opvp.QuestLog:maximum()
    return C_QuestLog.GetMaxNumQuests();
end

function opvp.QuestLog:maximumAcceptable()
    return C_QuestLog.GetMaxNumQuestsCanAccept();
end

function opvp.QuestLog:poiMapId()
    return C_QuestLog.GetMapForQuestPOIs();
end

function opvp.QuestLog:pvpQuests()
    local result = {};

    for id, quest in pairs(self._quest_map) do
        if quest:isPvp() == true then
            table.insert(result, quest);
        end
    end

    return result;
end

function opvp.QuestLog:quest(index)
    return self._quest_list:item(index);
end

function opvp.QuestLog:quests()
    return self._quest_list:items();
end

function opvp.QuestLog:questsActiveOnMap(mapId)
    if mapId == nil then
        mapId = opvp.player.mapId();
    end

    local result = {};
    local quest;

    for _, id in ipairs(C_QuestLog.GetQuestsOnMap(mapId)) do
        quest = self._quest_map[id];

        if quest == nil then
            quest = opvp.Quest(id);
        end

        table.insert(result, quest);
    end

    return result;
end

function opvp.QuestLog:questsAvailableOnMap(mapId)
    if mapId == nil then
        mapId = opvp.player.mapId();
    end

    local result = {};
    local quest;

    for _, task in ipairs(C_TaskQuest.GetQuestsOnMap(mapId)) do
        quest = self._quest_map[task.questID];

        if quest == nil then
            quest = opvp.Quest(task.questID);
        end

        result[task.questID] = quest;
    end

    for _, qline in ipairs(C_QuestLine.GetAvailableQuestLines(mapId)) do
        if result[qline.questID] == nile then
            quest = self._quest_map[qline.questID];

            if quest == nil then
                quest = opvp.Quest(qline.questID);
            end

            result[qline.questID] = quest;
        end
    end

    for _, id in ipairs(C_QuestLine.GetForceVisibleQuests(mapId)) do
        if result[id] == nile then
            quest = self._quest_map[id];

            if quest == nil then
                quest = opvp.Quest(id);
            end

            result[id] = quest;
        end
    end

    return result;
end

function opvp.QuestLog:size(onlyVisible)
    if onlyVisible == false then
        return self._size_vis;
    end

    local result = 0;

    for id, quest in pairs(self._quest_map) do
        if quest:isHidden() == false then
            result = result + 1;
        end
    end

    return result;
end

function opvp.QuestLog:sortWatched()
    return C_QuestLog.SortQuestWatches();
end

function opvp.QuestLog:trackedSize()
    return C_QuestLog.GetNumQuestWatches();
end

function opvp.QuestLog:trackedWorldQuestSize()
    return C_QuestLog.GetNumWorldQuestWatches();
end

function opvp.QuestLog:_addQuest(questId)
    if self._quest_map[questId] ~= nil then
        return self._quest_map[questId];
    end

    local quest = self:_createQuest(questId);

    if quest == nil then
        return nil;
    end

    self._quest_map[questId] = quest;

    self._quest_list:append(quest);

    self:_onQuestAdded(quest);

    return quest;
end

function opvp.QuestLog:_clear()
    self._quest_map = {};
    self._quest_list:clear();
end

function opvp.QuestLog:_createQuest(questId)
    return opvp.Quest(questId);
end

function opvp.QuestLog:_destroyQuest(quest)

end

function opvp.QuestLog:_onQuestAdded(quest)
    opvp.printDebug(
        "opvp.QuestLog:_onQuestAdded, [%d] \"%s\"",
        quest:id(),
        quest:name()
    );
end

function opvp.QuestLog:_onQuestAccepted(questId)
    local quest = self:_addQuest(questId);

    if quest ~= nil then
        self.accepted:emit(quest);
    end
end

function opvp.QuestLog:_onQuestRemoved(quest)
    opvp.printDebug(
        "opvp.QuestLog:_onQuestRemoved, [%d] \"%s\"",
        quest:id(),
        quest:name()
    );

    self.removed:emit(quest);
end

function opvp.QuestLog:_onQuestTurnedIn(questId, xpReward, moneyReward)
    local quest = self._quest_map[questId];

    if quest == nil then
        return;
    end

    opvp.printDebug(
        "opvp.QuestLog:_onQuestTurnedIn[%d] \"%s\"",
        quest:id(),
        quest:name()
    );

    self.completed:emit(quest, xpReward, moneyReward);
end

function opvp.QuestLog:_refresh()
    self._quest_map = {};

    self._quest_list:clear();

    local id;

    for i=1, C_QuestLog.GetNumQuestLogEntries() do
        id = C_QuestLog.GetQuestIDForLogIndex(i);

        if id ~= nil and id > 0 then
            self:_addQuest(id);
        end
    end
end

function opvp.QuestLog:_removeQuest(questId)
    local quest = self._quest_map[questId];

    if quest == nil then
        return;
    end

    self._quest_map[quest:id()] = nil;

    self._quest_list:removeItem(quest);

    self:_onQuestRemoved(quest);

    self:_destroyQuest(quest);
end
