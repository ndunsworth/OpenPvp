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

local opvp_pvp_trinket_state_null;

local function opvp_is_slot_pending(unitId, slot)
    local data = C_TooltipInfo.GetInventoryItem(unitId, slot);

    if data == nil or data.lines == nil then
        return false;
    end

    local line;

    for n=1, #data.lines do
        line = data.lines[n];

        if (
            line.type == Enum.TooltipDataLineType.None and
            line.leftText == RETRIEVING_ITEM_INFO
        ) then
            return true;
        end
    end

    return false;
end

local function opvp_is_slot_pvp_trinket_spell(unitId, slot)
    if opvp_is_slot_pending(unitId, slot) == true then
        return -1;
    end

    local item_id = GetInventoryItemID(unitId, slot);

    if item_id == nil then
        return -1;
    end

    local spell_name, spell_id = GetItemSpell(item_id);

    if opvp.spell.isPvpTrinket(spell_id) == true then
        return spell_id;
    elseif C_Item.GetItemIconByID(item_id) == 895886 then
        return 336135;
    else
        return 0;
    end
end

local function opvp_pvp_trinket_spell(unitId)
    local spell_id = opvp_is_slot_pvp_trinket_spell(unitId, INVSLOT_TRINKET1);

    if spell_id > 0 then
        return spell_id;
    elseif spell_id == 0 then
        return opvp_is_slot_pvp_trinket_spell(unitId, INVSLOT_TRINKET2);
    end

    spell_id = opvp_is_slot_pvp_trinket_spell(unitId, INVSLOT_TRINKET2);

    if spell_id > 0 then
        return spell_id;
    else
        return -1;
    end
end

opvp.PvpTrinketState = opvp.CreateClass();

function opvp.PvpTrinketState:null()
    return opvp_pvp_trinket_state_null;
end

function opvp.PvpTrinketState:init()
    self._dual_timeout     = 0;
    self._racial_spell_id  = 0;
    self._racial_used      = 0;
    self._racial_duration  = 0;
    self._trinket_spell_id = 0;
    self._trinket_used     = 0;
    self._trinket_duration = 0;
end

function opvp.PvpTrinketState:isAnyOffCooldown()
    return (
        self:isTrinketOffCooldown() or
        self:isRacialOffCooldown()
    );
end

function opvp.PvpTrinketState:isAnySpellId(spellId)
    return (
        self._trinket_spell_id == spellId or
        self._racial_spell_id == spellId
    );
end

function opvp.PvpTrinketState:isRacialOffCooldown()
    return (
        self._racial_spell_id ~= 0 and
        GetTime() > self:racialOffCooldownTime()
    );
end

function opvp.PvpTrinketState:isRacialSpellId(spellId)
    return self._racial_spell_id == spellId;
end

function opvp.PvpTrinketState:isTrinketOffCooldown()
    return (
        self._trinket_spell_id ~= 0 and
        GetTime() > self:trinketOffCooldownTime()
    );
end

function opvp.PvpTrinketState:isTrinketSpellId(spellId)
    return self._trinket_spell_id == spellId;
end

function opvp.PvpTrinketState:hasAny()
    return (
        self._trinket_spell_id ~= 0 or
        self._racial_spell_id ~= 0
    );
end

function opvp.PvpTrinketState:hasRacial()
    return self._racial_spell_id ~= 0;
end

function opvp.PvpTrinketState:hasTrinket()
    return self._trinket_spell_id ~= 0;
end

function opvp.PvpTrinketState:racialOffCooldownTime()
    return self._racial_used + self._racial_duration;
end

function opvp.PvpTrinketState:racialSpellId()
    return self._racial_spell_id;
end

function opvp.PvpTrinketState:timeUsedRacial()
    return self._racial_used;
end

function opvp.PvpTrinketState:timeUsedTrinket()
    return self._trinket_used;
end

function opvp.PvpTrinketState:trinketOffCooldownTime()
    return self._trinket_used + self._trinket_duration;
end

function opvp.PvpTrinketState:trinketSpellId()
    return self._trinket_spell_id;
end

function opvp.PvpTrinketState:_clear()
    self._racial_used      = 0;
    self._racial_duration  = 0;
    self._trinket_used     = 0;
    self._trinket_duration = 0;
end

function opvp.PvpTrinketState:_onUpdate(spellId, startTime, duration)
    if (
        self:hasAny() == false or
        self:isAnySpellId(spellId) == false
    ) then
        if opvp.spell.isPvpTrinket(spellId) == true then
            self._trinket_spell_id = spellId;
        elseif opvp.spell.isPvpRacialTrinket(spellId) == true then
            self._racial_spell_id = spellId;
        else
            return false;
        end
    end

    if spellId == self._trinket_spell_id then
        local old_used         = self._trinket_used;

        self._trinket_used     = startTime;
        self._trinket_duration = duration;

        self:_onTrinketUsed();

        if old_used ~= self._trinket_used then
            self:_onTrinketUsed();

            return true;
        end
    elseif spellId == self._racial_spell_id then
        local old_used        = self._racial_used;

        self._racial_used     = startTime;
        self._racial_duration = duration;

        if old_used ~= self._racial_used then
            self:_onRacialUsed();

            return true;
        end
    end

    return false;
end

function opvp.PvpTrinketState:_onRacialUsed()
    if self._trinket_spell_id == 0 then
        return;
    end

    if self._racial_used - self._trinket_used <= self._dual_timeout then
        self._trinket_used     = self._racial_used;
        self._trinket_duration = self._dual_timeout;
    end
end

function opvp.PvpTrinketState:_onTrinketUsed()
    if self._racial_spell_id == 0 then
        return;
    end

    if self._trinket_used - self._racial_used <= self._dual_timeout then
        self._racial_used     = self._trinket_used;
        self._racial_duration = self._dual_timeout;
    end
end

function opvp.PvpTrinketState:_reset()
    self._dual_timeout     = 0;
    self._racial_spell_id  = 0;
    self._racial_used      = 0;
    self._racial_duration  = 0;
    self._trinket_spell_id = 0;
    self._trinket_used     = 0;
    self._trinket_duration = 0;
end

function opvp.PvpTrinketState:_setRacial(spellId)
    if spellId == self._racial_spell_id then
        return false;
    end

    self._racial_spell_id = spellId;

    if self._racial_spell_id == 0 then
        self._dual_timeout    = 0;
        self._racial_used     = 0;
        self._racial_duration = 0;
    elseif self._racial_spell_id == 7744 then
        self._dual_timeout = 30;
    else
        self._dual_timeout = 90;
    end

    return true;
end

function opvp.PvpTrinketState:_setRacialFromRaceId(raceId)
    if raceId == opvp.HUMAN then
        return self:_setRacial(59752);
    elseif raceId == opvp.UNDEAD then
        return self:_setRacial(7744);
    else
        return false;
    end
end

function opvp.PvpTrinketState:_setTrinket(spellId)
    if spellId == self._trinket_spell_id then
        return false;
    end

    self._trinket_spell_id = spellId;

    if self._trinket_spell_id == 0 then
        self._trinket_used     = 0;
        self._trinket_duration = 0;
    end

    return true;
end

function opvp.PvpTrinketState:_setTrinketFromInspect(unitId)
    if self._trinket_spell_id ~= 0 then
        return 1;
    end

    local spell_id = opvp_pvp_trinket_spell(unitId);

    if spell_id > 0 then
        self:_setTrinket(spell_id);

        return 1;
    elseif spell_id == 0 then
        return 0;
    else
        return -1;
    end
end

local opvp_pvp_trinket_state_null = opvp.PvpTrinketState();
