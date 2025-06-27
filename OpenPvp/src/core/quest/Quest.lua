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

opvp.QuestClassification = {
    NONE            = -1,
    BONUS_OBJECTIVE = Enum.QuestClassification.BonusObjective,
    CALLING         = Enum.QuestClassification.Calling,
    CAMPAIGN        = Enum.QuestClassification.Campaign,
    IMPORTANT       = Enum.QuestClassification.Important,
    LEGENDARY       = Enum.QuestClassification.Legendary,
    META            = Enum.QuestClassification.Meta,
    NORMAL          = Enum.QuestClassification.Normal,
    QUESTLINE       = Enum.QuestClassification.Questline,
    RECURRING       = Enum.QuestClassification.Recurring,
    THREAT          = Enum.QuestClassification.Threat,
    WORLDQUEST      = Enum.QuestClassification.WorldQuest
};

opvp.QuestFrequency = {
    DEFAULT   = Enum.QuestFrequency.Default,
    DAILY     = Enum.QuestFrequency.Daily,
    WEEKLY    = Enum.QuestFrequency.Weekly,
    SCHEDULER = Enum.QuestFrequency.ResetByScheduler
};

opvp.QuestType = {
    ACCOUNT                               = 102,
    ALCHEMY_WORLD_QUEST                   = 118,
    ARCHAEOLOGY_WORLD_QUEST               = 129,
    ARTIFACT                              = 107,
    BLACKSMITHING_WORLD_QUEST             = 116,
    BONUS_OBJECTIVE_WITH_COMPLETION_TOAST = 283,
    CALLING_QUEST                         = 271,
    CAPSTONE_BLOCKER                      = 287,
    CAPSTONE_WORLD_QUEST                  = 286,
    CLASS                                 =  21,
    COMBAT_ALLY_QUEST                     = 266,
    COOKING_WORLD_QUEST                   = 131,
    DELVE                                 = 288,
    DRAGONRIDER_RACING                    = 281,
    DUNGEON                               =  81,
    DUNGEON_WORLD_QUEST                   = 137,
    ELITE_WORLD_QUEST                     = 111,
    EMISSARY_WORLD_QUEST                  = 128,
    ENCHANTING_WORLD_QUEST                = 123,
    ENGINEERING_WORLD_QUEST               = 122,
    EPIC_ELITE_WORLD_QUEST                = 112,
    EPIC_WORLD_QUEST                      = 110,
    ESCORT                                =  84,
    FACTION_ASSAULT_WORLD_ELITE_QUEST     = 260,
    FACTION_ASSAULT_WORLD_QUEST           = 259,
    FIRST_AID_WORLD_QUEST                 = 114,
    FISHING_WORLD_QUEST                   = 130,
    FORBIDDEN_REACH_ENVOY_TASK            = 279,
    GROUP                                 =   1,
    HERBALISM_WORLD_QUEST_1               = 119,
    HERBALISM_WORLD_QUEST_2               = 126,
    HEROIC                                =  85,
    HIDDEN_NYI                            = 291,
    HIDDEN_QUEST                          = 265,
    IMPORTANT                             = 282,
    IMPORTANT_QUEST                       = 292,
    ISLAND_QUEST                          = 254,
    ISLAND_WEEKLY_QUEST                   = 261,
    JEWELCRAFTING_WORLD_QUEST             = 125,
    LEATHERWORKING_WORLD_QUEST            = 117,
    LEGENDARY                             =  83,
    LEGION_INVASION_ELITE_WORLD_QUEST     = 142,
    LEGION_INVASION_WORLD_QUEST           = 139,
    LEGION_INVASION_WORLD_QUEST_WRAPPER   = 146,
    LEGIONFALL_CONTRIBUTION               = 143,
    LEGIONFALL_DUNGEON_WORLD_QUEST        = 145,
    LEGIONFALL_WORLD_QUEST                = 144,
    MAGNI_WORLD_QUEST_AZERITE             = 151,
    MAW_SOUL_SPAWN_TRACKER                = 273,
    META_QUEST                            = 284,
    MINING_WORLD_QUEST                    = 120,
    PET_BATTLE_WORLD_QUEST                = 115,
    PICKPOCKETING                         = 148,
    PROFESSIONS                           = 267,
    PUBLIC_QUEST                          = 263,
    PVP                                   =  41,
    PVP_CONQUEST                          = 256,
    PVP_ELITE_WORLD_QUEST                 = 278,
    PVP_WORLD_QUEST                       = 113,
    RAID                                  =  62,
    RAID_10                               =  88,
    RAID_25                               =  89,
    RAID_WORLD_QUEST                      = 141,
    RARE_ELITE_WORLD_QUEST                = 136,
    RARE_WORLD_QUEST                      = 135,
    RATED_REWARD_PVP                      = 140,
    SCENARIO                              =  98,
    SIDE_QUEST                            = 104,
    SKINNING_WORLD_QUEST                  = 124,
    TAILORING_WORLD_QUEST                 = 121,
    THREAT_EMISSARY_WORLD_QUEST           = 270,
    THREAT_QUEST                          = 264,
    THREAT_WRAPPER                        = 268,
    TORTOLLAN_WORLD_QUEST                 = 152,
    VENTHYR_PARTY_QUEST                   = 272,
    WAR_MODE_PVP                          = 255,
    WARFRONT_BARRENS                      = 147,
    WARFRONT_CONTRIBUTION                 = 153,
    WORLD_BOSS                            = 289,
    WORLD_EVENT                           =  82,
    WORLD_QUEST                           = 109
};

opvp.Quest = opvp.CreateClass();

function opvp.Quest:init(id)
    self._id = opvp.number_else(id);
end

function opvp.Quest:abandon()
    if self:isActive() == false then
        return;
    end

    self:select();

    C_QuestLog.SetAbandonQuest();

    C_QuestLog.AbandonQuest();
end

function opvp.Quest:classification()
    local info = self:info();

    if info ~= nil then
        return opvp.number_else(info.questClassification, opvp.QuestClassification.NONE);
    else
        return opvp.QuestClassification.NONE;
    end
end

function opvp.Quest:deselect()
    if self:isSelected() == true then
        C_QuestLog.SetSelectedQuest(0);
    end
end

function opvp.Quest:difficulty()
    return C_QuestLog.GetQuestDifficultyLevel(self._id);
end

function opvp.Quest:frequency()
    local info = self:info();

    if info ~= nil then
        return opvp.number_else(info.frequency, opvp.QuestFrequency.DEFAULT);
    else
        return opvp.QuestFrequency.DEFAULT;
    end
end

function opvp.Quest:hasFirstRepBonus()
    return C_QuestLog.QuestContainsFirstTimeRepBonusForPlayer(self._id);
end

function opvp.Quest:hasSessionBonus()
    return C_QuestLog.QuestHasQuestSessionBonus(self._id);
end

function opvp.Quest:hasTimeRemaining()
    return C_QuestLog.ShouldDisplayTimeRemaining(self._id);
end

function opvp.Quest:hasWarModeBonus()
    return C_QuestLog.QuestHasWarModeBonus(self._id);
end

function opvp.Quest:hyperlink()
    return opvp.str_else(GetQuestLink(self._id));
end

function opvp.Quest:icon(ignoreComplete)
    local complete = ignoreComplete ~= true and self:isComplete() or false;
    local repeateable = self:isRepeatable();

    if self:isCampaign() == true then
        if complete == true then
            if repeateable == true then
                return "Quest-DailyCampaign-TurnIn";
            else
                return "Quest-Campaign-TurnIn";
            end
        else
            if repeateable == true then
                return "Quest-DailyCampaign-Available";
            else
                return "Quest-Campaign-Available";
            end
        end
    end

    if self:isImportant() == true then
        if complete == true then
            return "quest-important-turnin";
        else
            return "quest-important-available";
        end
    end

    if self:isLegendary() == true then
        if complete == true then
            return "quest-important-turnin";
        else
            return "quest-important-available";
        end
    end

    if repeateable == true then
        if complete == true then
            return "quest-recurring-turnin";
        else
            return "quest-recurring-available";
        end
    end

    if complete == true then
        return "QuestTurnin";
    else
        return "QuestNormal";
    end
end

function opvp.Quest:id()
    return self._id;
end

function opvp.Quest:index()
    return opvp.number_else(C_QuestLog.GetLogIndexForQuestID(self._id));
end

function opvp.Quest:indexHeader()
    return opvp.number_else(C_QuestLog.GetHeaderIndexForQuest(self._id));
end

function opvp.Quest:info()
    return C_QuestLog.GetInfo(self:index());
end

function opvp.Quest:isAbandonable()
    return C_QuestLog.CanAbandonQuest(self._id);
end

function opvp.Quest:isActive()
    return C_QuestLog.IsOnQuest(self._id);
end

function opvp.Quest:isActiveForUnit(unitId)
    return C_QuestLog.IsUnitOnQuest(unitId, self._id);
end

function opvp.Quest:isAccountWide()
    return C_QuestLog.IsAccountQuest(self._id);
end

function opvp.Quest:isBounty()
    return C_QuestLog.IsQuestBounty(self._id);
end

function opvp.Quest:isCalling()
    return C_QuestLog.IsQuestCalling(self._id);
end

function opvp.Quest:isCampaign()
    return self:classification() == opvp.QuestClassification.CAMPAIGN;
end

function opvp.Quest:isComplete()
    return C_QuestLog.IsComplete(self._id);
end

function opvp.Quest:isCompleted()
    return C_QuestLog.IsQuestFlaggedCompleted(self._id);
end

function opvp.Quest:isCompletedOnAccount()
    return C_QuestLog.IsQuestFlaggedCompletedOnAccount(self._id);
end

function opvp.Quest:isDaily()
    return self:frequency() == opvp.QuestFrequency.DAILY;
end

function opvp.Quest:isFromContentPush()
    return C_QuestLog.IsQuestFromContentPush(self._id);
end

function opvp.Quest:isCriteriaForBounty(questId)
    return C_QuestLog.IsQuestCriteriaForBounty(self._id, questId);
end

function opvp.Quest:isDisabledForSession()
    return C_QuestLog.IsQuestDisabledForSession(self._id);
end

function opvp.Quest:isFailed()
    return C_QuestLog.IsFailed(self._id);
end

function opvp.Quest:isHidden()
    local info = self:info();

    return (
        info ~= nil and
        info.isHidden == true
    );
end

function opvp.Quest:isImportant()
    return C_QuestLog.IsImportantQuest(self._id);
end

function opvp.Quest:isInvasion()
    return C_QuestLog.IsQuestInvasion(self._id);
end

function opvp.Quest:isLegendary()
    return C_QuestLog.IsLegendaryQuest(self._id);
end

function opvp.Quest:isMeta()
    return C_QuestLog.IsMetaQuest(self._id);
end

function opvp.Quest:isNull()
    return self._id == 0;
end

function opvp.Quest:isOnMap()
    C_QuestLog.IsOnMap(self._id);
end

function opvp.Quest:isPvp()
    local quest_type = self:type();

    return (
        quest_type == opvp.QuestType.PVP or
        quest_type == opvp.QuestType.PVP_CONQUEST or
        quest_type == opvp.QuestType.PVP_ELITE_WORLD_QUEST or
        quest_type == opvp.QuestType.PVP_WORLD_QUEST or
        quest_type == opvp.QuestType.RATED_REWARD_PVP or
        quest_type == opvp.QuestType.WAR_MODE_PVP
    );
end

function opvp.Quest:isReadyForTurnIn()
    return C_QuestLog.ReadyForTurnIn(self._id);
end

function opvp.Quest:isRepeatable()
    return C_QuestLog.IsQuestRepeatableType(self._id) == true;
end

function opvp.Quest:isReplayable()
    return C_QuestLog.IsQuestReplayable(self._id);
end

function opvp.Quest:isSelected()
    return (
        self._id ~= 0 and
        self._id == C_QuestLog.GetSelectedQuest()
    );
end

function opvp.Quest:isSelectedAbandon()
    return (
        self._id > 0 and
        C_QuestLog.GetAbandonQuest() == self._id
    );
end

function opvp.Quest:isShareable()
    return C_QuestLog.IsPushableQuest(self._id);
end

function opvp.Quest:isSuperTracked()
    return (
        self._id ~= 0 and
        C_SuperTrack.GetSuperTrackedQuestID() == self._id
    );
end

function opvp.Quest:superTrack()
    if self:isActive() == true then
        C_SuperTrack.SetSuperTrackedQuestID(self._id)
    end
end

function opvp.Quest:isTask()
    return C_QuestLog.IsQuestTask(self._id);
end

function opvp.Quest:isThreat()
    return C_QuestLog.IsThreatQuest(self._id);
end

function opvp.Quest:isTrivial()
    return C_QuestLog.IsQuestTrivial(self._id);
end

function opvp.Quest:isWatching()
    if self:isWorld() == true then
        local size = C_QuestLog.GetNumWorldQuestWatches();

        for n=1, size do
            if self._id == C_QuestLog.GetQuestIDForWorldQuestWatchIndex(n) then
                return true;
            end
        end

        return false;
    else
        local size = C_QuestLog.GetNumQuestWatches();

        for n=1, size do
            if self._id == C_QuestLog.GetQuestIDForQuestWatchIndex(n) then
                return true;
            end
        end

        return false;
    end
end

function opvp.Quest:isWeekly()
    return self:frequency() == opvp.QuestFrequency.WEEKLY;
end

function opvp.Quest:isWorld()
    return C_QuestLog.IsWorldQuest(self._id);
end

function opvp.Quest:name()
    return opvp.str_else(C_QuestLog.GetTitleForQuestID(self._id));
end

function opvp.Quest:nextWaypoint()
    local map, x, y = C_QuestLog.GetNextWaypoint(self._id);

    return opvp.Waypoint(map, x, y);
end

function opvp.Quest:nextWaypointText()
    return C_QuestLog.GetNextWaypointText(self._id);
end

function opvp.Quest:nextWaypointForMap(mapId)
    local x, y = C_QuestLog.GetNextWaypointForMap(self._id, mapId);

    return opvp.Waypoint(mapId, x, y);
end

function opvp.Quest:objectives()
    local result = {};
    local infos = C_QuestLog.GetQuestObjectives(self._id);

    for n=1, #infos do
        table.insert(result, opvp.QuestObjective(infos[n]));
    end

    return result;
end

function opvp.Quest:objectivesSize()
    return C_QuestLog.GetNumQuestObjectives(self._id);
end

function opvp.Quest:requestData()
    return C_QuestLog.RequestLoadQuestByID(self._id);
end

function opvp.Quest:select()
    C_QuestLog.SetSelectedQuest(self._id);
end

function opvp.Quest:setSelected(state)
    if state == true then
        return self:watch();
    else
        return self:unwatch();
    end
end

function opvp.Quest:setWatched(state)
    if state == true then
        return self:watch();
    else
        return self:unwatch();
    end
end

function opvp.Quest:suggestedGroupSize()
    local info = self:info();

    if info ~= nil then
        return opvp.number_else(info.suggestedGroup, 0);
    else
        return opvp.QuestFrequency.DEFAULT;
    end
end

function opvp.Quest:timeRemaining()
    return opvp.number_else(C_QuestLog.GetTimeAllowed(self._id), -1);
end

function opvp.Quest:type()
    return C_QuestLog.GetQuestType(self._id);
end

function opvp.Quest:unwatch()
    if self:isWorld() == true then
        return C_QuestLog.RemoveWorldQuestWatch(self._id)
    else
        return C_QuestLog.RemoveQuestWatch(self._id);
    end
end

function opvp.Quest:watch()
    if self:isWorld() == true then
        return C_QuestLog.AddWorldQuestWatch(self._id)
    else
        return C_QuestLog.AddQuestWatch(self._id);
    end
end

function opvp.Quest:zone()
    C_QuestLog.GetQuestZoneID(self._id);
end
