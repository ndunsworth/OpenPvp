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

local opvp_spec_tooltip;
local opvp_spec_tooltip_lookup;

opvp.PvpTalentSlot = {
    SLOT_1 = 1,
    SLOT_2 = 2,
    SLOT_3 = 3,
};

opvp.ClassSpecId = {
    UNKNOWN                =  0,

    BLOOD_DEATH_KNIGHT     = 250,
    FROST_DEATH_KNIGHT     = 251,
    UNHOLY_DEATH_KNIGHT    = 252,

    HAVOC_DEMON_HUNTER     = 577,
    VENGANCE_DEMON_HUNTER  = 581,

    BALANCE_DRUID          = 102,
    FERAL_DRUID            = 103,
    GUARDIAN_DRUID         = 104,
    RESTORATION_DRUID      = 105,

    AUGMENTATION_EVOKER    = 1473,
    DEVESTATION_EVOKER     = 1467,
    PRESERVATION_EVOKER    = 1468,

    BEASTMASTER_HUNTER     = 253,
    MASTER_MARKSMAN_HUNTER = 254,
    SURVIVAL_HUNTER        = 255,

    ARCANE_MAGE            = 62,
    FIRE_MAGE              = 63,
    FROST_MAGE             = 64,

    BREWMASTER_MONK        = 268,
    MISTWEAVER_MONK        = 270,
    WINDWALKER_MONK        = 269,

    HOLY_PALADIN           = 65,
    PROTECTION_PALADIN     = 66,
    RETRIBUTION_PALADIN    = 70,

    DISCIPLINE_PRIEST      = 256,
    HOLY_PRIEST            = 257,
    SHADOW_PRIEST          = 258,

    ASSASSINATION_ROGUE    = 259,
    OUTLAW_ROGUE           = 260,
    SUBTLETY_ROGUE         = 261,

    ELEMENTAL_SHAMAN       = 262,
    ENHANCEMENT_SHAMAN     = 263,
    RESTORATION_SHAMAN     = 264,

    AFFLICTION_WARLOCK     = 265,
    DEMONOLOGY_WARLOCK     = 266,
    DESTRUCTION_WARLOCK    = 267,

    ARMS_WARRIOR           = 71,
    FURY_WARRIOR           = 72,
    PROTECTION_WARRIOR     = 73
};

opvp.ClassSpecTrait = {
    MAGIC     = bit.lshift(1, 0),
    MELEE     = bit.lshift(1, 1),
    PHYSICAL  = bit.lshift(1, 2),
    RANGED    = bit.lshift(1, 3)
};

opvp.ClassSpecTrait.MELEE_MAGIC     = bit.bor(opvp.ClassSpecTrait.MELEE, opvp.ClassSpecTrait.MAGIC);
opvp.ClassSpecTrait.MELEE_PHYSICAL  = bit.bor(opvp.ClassSpecTrait.MELEE, opvp.ClassSpecTrait.PHYSICAL);
opvp.ClassSpecTrait.RANGED_MAGIC    = bit.bor(opvp.ClassSpecTrait.RANGED, opvp.ClassSpecTrait.MAGIC);
opvp.ClassSpecTrait.RANGED_PHYSICAL = bit.bor(opvp.ClassSpecTrait.RANGED, opvp.ClassSpecTrait.PHYSICAL);

opvp.ClassSpec = opvp.CreateClass();

function opvp.ClassSpec:fromSpecName(name)
    for n=1, #opvp.ClassSpec.SPECS do
        if opvp.ClassSpec.SPECS[n]:name() == name then
            return opvp.ClassSpec.SPECS[n]
        end
    end

    return opvp.ClassSpec.UNKNOWN;
end

function opvp.ClassSpec:fromSpecId(id)
    for n=1, #opvp.ClassSpec.SPECS do
        if opvp.ClassSpec.SPECS[n]:id() == id then
            return opvp.ClassSpec.SPECS[n]
        end
    end

    return opvp.ClassSpec.UNKNOWN;
end

function opvp.ClassSpec:fromTooltip(unitId, tooltip)
    if tooltip == nil then
        if opvp_spec_tooltip == nil then
            opvp_spec_tooltip = CreateFrame("GameTooltip", nil, nil, "GameTooltipTemplate")
        end

        tooltip = opvp_spec_tooltip;
    end

    tooltip:SetUnit(unitId);

    if tooltip:IsTooltipType(Enum.TooltipDataType.Unit) == false then
        return opvp.ClassSpec.UNKNOWN;
    end

    local data = tooltip:GetPrimaryTooltipData();

    local spec;

    if opvp_spec_tooltip_lookup == nil then
        opvp_spec_tooltip_lookup = {};

        local name;

        for n=1, #opvp.ClassSpec.SPECS do
            spec = opvp.ClassSpec.SPECS[n];
            name = spec:name() .. " " .. spec:classInfo():name();

            opvp_spec_tooltip_lookup[name] = spec;
        end
    end

    for n=1, #data.lines do
        text = data.lines[n].leftText;

        if text ~= nil then
            spec = opvp_spec_tooltip_lookup[text];

            if spec ~= nil then
                return spec;
            end
        end
    end

    return opvp.ClassSpec.UNKNOWN;
end

function opvp.ClassSpec:instance()
    return opvp.Player:instance():specInfo()
end

function opvp.ClassSpec:init(cfg)
    self._cls    = cfg.class;
    self._id     = cfg.id;
    self._role   = cfg.role;
    self._index  = cfg.index;
    self._icon   = cfg.icon;
    self._sound  = cfg.sound;
    self._traits = cfg.traits;

    self._spells     = opvp.SpellMap();
    self._auras      = opvp.SpellMap();

    opvp.SpellMap:createFromClassConfig(
        cls,
        cfg.spells,
        cfg.auras,
        self._spells,
        self._auras,
        opvp.SpellProperty.SPEC
    );

    if self._id ~= 0 then
        self._name = select(2, GetSpecializationInfoByID(self._id));
    else
        self._name = opvp.strs.UNKNOWN;
    end
end

function opvp.ClassSpec:auras(includeBase)
    if includeBase ~= true then
        return self._auras;
    else
        local auras = self._auras:clone();

        auras:merge(self:classInfo():auras());

        return auras;
    end
end

function opvp.ClassSpec:class()
    return self._cls;
end

function opvp.ClassSpec:classInfo()
    return opvp.Class:fromClassId(self._cls);
end

function opvp.ClassSpec:color()
    return self:classInfo():color();
end

function opvp.ClassSpec:colorString(str)
    return self:classInfo():colorString(str);
end

function opvp.ClassSpec:icon()
    return self._icon;
end

function opvp.ClassSpec:id()
    return self._id;
end

function opvp.ClassSpec:isDps()
    return self._role:isDps();
end

function opvp.ClassSpec:isHealer()
    return self._role:isHealer();
end

function opvp.ClassSpec:isMelee()
    return bit.band(self._traits, opvp.ClassSpecTrait.MELEE) ~= 0;
end

function opvp.ClassSpec:isRanged()
    return bit.band(self._traits, opvp.ClassSpecTrait.RANGED) ~= 0;
end

function opvp.ClassSpec:isTank()
    return self._role:isTank();
end

function opvp.ClassSpec:isValid()
    return self._id ~= opvp.ClassSpecId.UNKNOWN;
end

function opvp.ClassSpec:name()
    return self._name;
end

function opvp.ClassSpec:role()
    return self._role;
end

function opvp.ClassSpec:set()
    if self._index > 0 and self._cls == opvp.player.class() then
        opvp.spec.setSpec(self._index)
    end
end

function opvp.ClassSpec:sound()
    return self._sound;
end

function opvp.ClassSpec:spells()
    return self._spells;
end

opvp.spec = {};

function opvp.spec.hasNewPvpTalent()
    local unspent, talent = C_SpecializationInfo.GetPvpTalentAlertStatus();

    return talent;
end

function opvp.spec.hasUnspentPvpTalent()
    local unspent, talent = C_SpecializationInfo.GetPvpTalentAlertStatus();

    return unspent;
end

function opvp.spec.isPvpTalentsEnabled()
    local valid, err = C_SpecializationInfo.CanPlayerUsePVPTalentUI();

    return valid;
end

function opvp.spec.isPvpTalentLocked(talentId)
    return C_SpecializationInfo.IsPvpTalentLocked(talentId);
end

function opvp.spec.isPvpTalentSlotEnabled(talentSlot)
    return opvp.spec.pvpTalentSlotInfo(talentSlot).enabled;
end

function opvp.spec.isSpecTalentsEnabled()
    local valid, err = C_SpecializationInfo.CanPlayerUseTalentSpecUI();

    return valid;
end

function opvp.spec.isTalentsEnabled()
    local valid, err = C_SpecializationInfo.CanPlayerUseTalentUI();

    return valid;
end

function opvp.spec.class(specId)
    return opvp.Class:fromSpecId(specId);
end

function opvp.spec.pvpTalents()
    return C_SpecializationInfo.GetAllSelectedPvpTalentIDs();
end

function opvp.spec.pvpTalentInfo(talentId)
    return C_SpecializationInfo.GetPvpTalentInfo(talentId);
end

function opvp.spec.pvpTalentLevel(talentId)
    return opvp.number_else(
        C_SpecializationInfo.GetPvpTalentUnlockLevel(talentId),
        0
    );
end

function opvp.spec.pvpTalentSlotLevel(talentSlot)
    return opvp.number_else(
        C_SpecializationInfo.GetPvpTalentSlotUnlockLevel(talentSlot),
        0
    );
end

function opvp.spec.pvpTalentSlotInfo(talentSlot)
    local info = C_SpecializationInfo.GetPvpTalentSlotInfo(talentSlot);

    if info ~= nil then
        return info;
    else
        return {
            enabled = false,
            level   = 0,
            availableTalentIDs = {}
        };
    end
end

function opvp.spec.setPvpTalent(talentSlot, talentId)
    if opvp.isPvpTalentSlotEnabled(talentSlot) == true then
        LearnPvpTalent(talentId, talentSlot);
    end
end

function opvp.spec.setSpec(specIndex)
    return C_SpecializationInfo.SetSpecialization(specIndex);
end

opvp.ClassSpec.SPECS        = {};
opvp.ClassSpec.DPS_SPECS    = {};
opvp.ClassSpec.HEALER_SPECS = {};
opvp.ClassSpec.TANK_SPECS   = {};
