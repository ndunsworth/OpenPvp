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

function opvp.ClassSpec:instance()
    return opvp.Player:instance():specInfo()
end

function opvp.ClassSpec:init(class, id, role, traits, sound, icon)
    self._cls = class;
    self._id = id;
    self._role = role;
    self._icon = icon;
    self._sound = sound;
    self._traits = traits;

    if id ~= 0 then
        self._name = select(2, GetSpecializationInfoByID(id));
    else
        self._name = opvp.strs.UNKNOWN;
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

function opvp.ClassSpec:sound()
    return self._sound;
end

opvp.ClassSpec.UNKNOWN                = opvp.ClassSpec(opvp.UNKNOWN_CLASS, opvp.ClassSpecId.UNKNOWN, opvp.Role.NONE, 0, 0, "");

opvp.ClassSpec.BLOOD_DEATH_KNIGHT     = opvp.ClassSpec(opvp.DEATH_KNIGHT, opvp.ClassSpecId.BLOOD_DEATH_KNIGHT, opvp.Role.TANK, opvp.ClassSpecTrait.MELEE_MAGIC, 12874, "Interface/Icons/spell_deathknight_bloodpresence");
opvp.ClassSpec.FROST_DEATH_KNIGHT     = opvp.ClassSpec(opvp.DEATH_KNIGHT, opvp.ClassSpecId.FROST_DEATH_KNIGHT, opvp.Role.DPS, opvp.ClassSpecTrait.MELEE_MAGIC, 41021, "Interface/Icons/spell_deathknight_frostpresence");
opvp.ClassSpec.UNHOLY_DEATH_KNIGHT    = opvp.ClassSpec(opvp.DEATH_KNIGHT, opvp.ClassSpecId.UNHOLY_DEATH_KNIGHT, opvp.Role.DPS, opvp.ClassSpecTrait.MELEE_MAGIC, 164991, "Interface/Icons/spell_deathknight_unholypresence");

opvp.ClassSpec.HAVOC_DEMON_HUNTER     = opvp.ClassSpec(opvp.DEMON_HUNTER, opvp.ClassSpecId.HAVOC_DEMON_HUNTER, opvp.Role.DPS, opvp.ClassSpecTrait.MELEE_MAGIC, 170913, "Interface/Icons/ability_demonhunter_specdps");
opvp.ClassSpec.VENGANCE_DEMON_HUNTER  = opvp.ClassSpec(opvp.DEMON_HUNTER, opvp.ClassSpecId.VENGANCE_DEMON_HUNTER, opvp.Role.TANK, opvp.ClassSpecTrait.MELEE_MAGIC, 62555, "Interface/Icons/ability_demonhunter_spectank");

opvp.ClassSpec.BALANCE_DRUID          = opvp.ClassSpec(opvp.DRUID, opvp.ClassSpecId.BALANCE_DRUID, opvp.Role.DPS, opvp.ClassSpecTrait.RANGED_MAGIC, 83382, "Interface/Icons/spell_nature_starfall");
opvp.ClassSpec.FERAL_DRUID            = opvp.ClassSpec(opvp.DRUID, opvp.ClassSpecId.FERAL_DRUID, opvp.Role.DPS, opvp.ClassSpecTrait.MELEE_PHYSICAL, 143720, "Interface/Icons/ability_druid_catform");
opvp.ClassSpec.GUARDIAN_DRUID         = opvp.ClassSpec(opvp.DRUID, opvp.ClassSpecId.GUARDIAN_DRUID, opvp.Role.TANK, opvp.ClassSpecTrait.MELEE_PHYSICAL, 12121, "Interface/Icons/ability_racial_bearform");
opvp.ClassSpec.RESTORATION_DRUID      = opvp.ClassSpec(opvp.DRUID, opvp.ClassSpecId.RESTORATION_DRUID, opvp.Role.HEALER, opvp.ClassSpecTrait.RANGED_MAGIC, 5737, "Interface/Icons/spell_nature_healingtouch");

opvp.ClassSpec.AUGMENTATION_EVOKER    = opvp.ClassSpec(opvp.EVOKER, opvp.ClassSpecId.AUGMENTATION_EVOKER, opvp.Role.DPS, opvp.ClassSpecTrait.RANGED_MAGIC, 200748, "Interface/Icons/classicon_evoker_augmentation");
opvp.ClassSpec.DEVESTATION_EVOKER     = opvp.ClassSpec(opvp.EVOKER, opvp.ClassSpecId.DEVESTATION_EVOKER, opvp.Role.DPS, opvp.ClassSpecTrait.RANGED_MAGIC, 218711, "Interface/Icons/classicon_evoker_devastation");
opvp.ClassSpec.PRESERVATION_EVOKER    = opvp.ClassSpec(opvp.EVOKER, opvp.ClassSpecId.PRESERVATION_EVOKER, opvp.Role.HEALER, opvp.ClassSpecTrait.RANGED_MAGIC, 201157, "Interface/Icons/classicon_evoker_preservation");

opvp.ClassSpec.BEASTMASTER_HUNTER     = opvp.ClassSpec(opvp.HUNTER, opvp.ClassSpecId.BEASTMASTER_HUNTER, opvp.Role.DPS, opvp.ClassSpecTrait.RANGED_PHYSICAL, 84922, "Interface/Icons/ability_hunter_bestialdiscipline");
opvp.ClassSpec.MASTER_MARKSMAN_HUNTER = opvp.ClassSpec(opvp.HUNTER, opvp.ClassSpecId.MASTER_MARKSMAN_HUNTER, opvp.Role.DPS, opvp.ClassSpecTrait.RANGED_PHYSICAL, 15245, "Interface/Icons/ability_hunter_focusedaim");
opvp.ClassSpec.SURVIVAL_HUNTER        = opvp.ClassSpec(opvp.HUNTER, opvp.ClassSpecId.SURVIVAL_HUNTER, opvp.Role.DPS, opvp.ClassSpecTrait.MELEE_PHYSICAL, 72676, "Interface/Icons/ability_hunter_camouflage");

opvp.ClassSpec.ARCANE_MAGE            = opvp.ClassSpec(opvp.MAGE, opvp.ClassSpecId.ARCANE_MAGE, opvp.Role.DPS, opvp.ClassSpecTrait.RANGED_MAGIC, 85547, "Interface/Icons/spell_holy_magicalsentry");
opvp.ClassSpec.FIRE_MAGE              = opvp.ClassSpec(opvp.MAGE, opvp.ClassSpecId.FIRE_MAGE, opvp.Role.DPS, opvp.ClassSpecTrait.RANGED_MAGIC, 63318, "Interface/Icons/spell_fire_flamebolt");
opvp.ClassSpec.FROST_MAGE             = opvp.ClassSpec(opvp.MAGE, opvp.ClassSpecId.FROST_MAGE, opvp.Role.DPS, opvp.ClassSpecTrait.RANGED_MAGIC, 85506, "Interface/Icons/spell_frost_frostbolt02");

opvp.ClassSpec.BREWMASTER_MONK        = opvp.ClassSpec(opvp.MONK, opvp.ClassSpecId.BREWMASTER_MONK, opvp.Role.TANK, opvp.ClassSpecTrait.MELEE_PHYSICAL, 260813, "Interface/Icons/spell_monk_brewmaster_spec");
opvp.ClassSpec.MISTWEAVER_MONK        = opvp.ClassSpec(opvp.MONK, opvp.ClassSpecId.MISTWEAVER_MONK, opvp.Role.HEALER, opvp.ClassSpecTrait.MELEE_PHYSICAL, 34436, "Interface/Icons/spell_monk_mistweaver_spec");
opvp.ClassSpec.WINDWALKER_MONK        = opvp.ClassSpec(opvp.MONK, opvp.ClassSpecId.WINDWALKER_MONK, opvp.Role.DPS, opvp.ClassSpecTrait.MELEE_PHYSICAL, 26875, "Interface/Icons/spell_monk_windwalker_spec");

opvp.ClassSpec.HOLY_PALADIN           = opvp.ClassSpec(opvp.PALADIN, opvp.ClassSpecId.HOLY_PALADIN, opvp.Role.HEALER, opvp.ClassSpecTrait.MELEE_MAGIC, 96464, "Interface/Icons/paladin_holy");
opvp.ClassSpec.PROTECTION_PALADIN     = opvp.ClassSpec(opvp.PALADIN, opvp.ClassSpecId.PROTECTION_PALADIN, opvp.Role.TANK, opvp.ClassSpecTrait.MELEE_MAGIC, 24163, "Interface/Icons/ability_paladin_shieldofthetemplar");
opvp.ClassSpec.RETRIBUTION_PALADIN    = opvp.ClassSpec(opvp.PALADIN, opvp.ClassSpecId.RETRIBUTION_PALADIN, opvp.Role.DPS, opvp.ClassSpecTrait.MELEE_MAGIC, 120394, "Interface/Icons/paladin_retribution");

opvp.ClassSpec.DISCIPLINE_PRIEST      = opvp.ClassSpec(opvp.PRIEST, opvp.ClassSpecId.DISCIPLINE_PRIEST, opvp.Role.HEALER, opvp.ClassSpecTrait.RANGED_MAGIC, 238138, "Interface/Icons/spell_holy_powerwordshield");
opvp.ClassSpec.HOLY_PRIEST            = opvp.ClassSpec(opvp.PRIEST, opvp.ClassSpecId.HOLY_PRIEST, opvp.Role.HEALER, opvp.ClassSpecTrait.RANGED_MAGIC, 89332, "Interface/Icons/spell_holy_guardianspirit");
opvp.ClassSpec.SHADOW_PRIEST          = opvp.ClassSpec(opvp.PRIEST, opvp.ClassSpecId.SHADOW_PRIEST, opvp.Role.DPS, opvp.ClassSpecTrait.RANGED_MAGIC, 89829, "Interface/Icons/spell_shadow_shadowwordpain");

opvp.ClassSpec.ASSASSINATION_ROGUE    = opvp.ClassSpec(opvp.ROGUE, opvp.ClassSpecId.ASSASSINATION_ROGUE, opvp.Role.DPS, opvp.ClassSpecTrait.MELEE_PHYSICAL, 55696, "Interface/Icons/ability_rogue_deadlybrew");
opvp.ClassSpec.OUTLAW_ROGUE           = opvp.ClassSpec(opvp.ROGUE, opvp.ClassSpecId.OUTLAW_ROGUE, opvp.Role.DPS, opvp.ClassSpecTrait.MELEE_PHYSICAL, 79567, "Interface/Icons/inv_sword_30");
opvp.ClassSpec.SUBTLETY_ROGUE         = opvp.ClassSpec(opvp.ROGUE, opvp.ClassSpecId.SUBTLETY_ROGUE, opvp.Role.DPS, opvp.ClassSpecTrait.MELEE_PHYSICAL, 13279, "Interface/Icons/ability_ambush");

opvp.ClassSpec.ELEMENTAL_SHAMAN       = opvp.ClassSpec(opvp.SHAMAN, opvp.ClassSpecId.ELEMENTAL_SHAMAN, opvp.Role.DPS, opvp.ClassSpecTrait.RANGED_MAGIC, 138561, "Interface/Icons/spell_nature_lightning");
opvp.ClassSpec.ENHANCEMENT_SHAMAN     = opvp.ClassSpec(opvp.SHAMAN, opvp.ClassSpecId.ENHANCEMENT_SHAMAN, opvp.Role.DPS, opvp.ClassSpecTrait.MELEE_MAGIC, 240675, "Interface/Icons/spell_shaman_improvedstormstrike");
opvp.ClassSpec.RESTORATION_SHAMAN     = opvp.ClassSpec(opvp.SHAMAN, opvp.ClassSpecId.RESTORATION_SHAMAN, opvp.Role.HEALER, opvp.ClassSpecTrait.MELEE_MAGIC, 213054, "Interface/Icons/spell_nature_healingwavegreater");

opvp.ClassSpec.AFFLICTION_WARLOCK     = opvp.ClassSpec(opvp.WARLOCK, opvp.ClassSpecId.AFFLICTION_WARLOCK, opvp.Role.DPS, opvp.ClassSpecTrait.RANGED_MAGIC, 114131, "Interface/Icons/spell_shadow_deathcoil");
opvp.ClassSpec.DEMONOLOGY_WARLOCK     = opvp.ClassSpec(opvp.WARLOCK, opvp.ClassSpecId.DEMONOLOGY_WARLOCK, opvp.Role.DPS, opvp.ClassSpecTrait.RANGED_MAGIC, 6097, "Interface/Icons/spell_shadow_metamorphosis");
opvp.ClassSpec.DESTRUCTION_WARLOCK    = opvp.ClassSpec(opvp.WARLOCK, opvp.ClassSpecId.DESTRUCTION_WARLOCK, opvp.Role.DPS, opvp.ClassSpecTrait.RANGED_MAGIC, 260690, "Interface/Icons/spell_shadow_rainoffire");

opvp.ClassSpec.ARMS_WARRIOR           = opvp.ClassSpec(opvp.WARRIOR, opvp.ClassSpecId.ARMS_WARRIOR, opvp.Role.DPS, opvp.ClassSpecTrait.MELEE_PHYSICAL, 12981, "Interface/Icons/ability_warrior_savageblow");
opvp.ClassSpec.FURY_WARRIOR           = opvp.ClassSpec(opvp.WARRIOR, opvp.ClassSpecId.FURY_WARRIOR, opvp.Role.DPS, opvp.ClassSpecTrait.MELEE_PHYSICAL, 49435, "Interface/Icons/ability_warrior_innerrage");
opvp.ClassSpec.PROTECTION_WARRIOR     = opvp.ClassSpec(opvp.WARRIOR, opvp.ClassSpecId.PROTECTION_WARRIOR, opvp.Role.TANK, opvp.ClassSpecTrait.MELEE_PHYSICAL, 59081, "Interface/Icons/ability_warrior_defensivestance");

opvp.ClassSpec.SPECS = {
    opvp.ClassSpec.UNKNOWN,
    opvp.ClassSpec.BLOOD_DEATH_KNIGHT,
    opvp.ClassSpec.FROST_DEATH_KNIGHT,
    opvp.ClassSpec.UNHOLY_DEATH_KNIGHT,
    opvp.ClassSpec.HAVOC_DEMON_HUNTER,
    opvp.ClassSpec.VENGANCE_DEMON_HUNTER,
    opvp.ClassSpec.BALANCE_DRUID,
    opvp.ClassSpec.FERAL_DRUID,
    opvp.ClassSpec.GUARDIAN_DRUID,
    opvp.ClassSpec.RESTORATION_DRUID,
    opvp.ClassSpec.AUGMENTATION_EVOKER,
    opvp.ClassSpec.DEVESTATION_EVOKER,
    opvp.ClassSpec.PRESERVATION_EVOKER,
    opvp.ClassSpec.BEASTMASTER_HUNTER,
    opvp.ClassSpec.MASTER_MARKSMAN_HUNTER,
    opvp.ClassSpec.SURVIVAL_HUNTER,
    opvp.ClassSpec.ARCANE_MAGE,
    opvp.ClassSpec.FIRE_MAGE,
    opvp.ClassSpec.FROST_MAGE,
    opvp.ClassSpec.BREWMASTER_MONK,
    opvp.ClassSpec.MISTWEAVER_MONK,
    opvp.ClassSpec.WINDWALKER_MONK,
    opvp.ClassSpec.HOLY_PALADIN,
    opvp.ClassSpec.PROTECTION_PALADIN,
    opvp.ClassSpec.RETRIBUTION_PALADIN,
    opvp.ClassSpec.DISCIPLINE_PRIEST,
    opvp.ClassSpec.HOLY_PRIEST,
    opvp.ClassSpec.SHADOW_PRIEST,
    opvp.ClassSpec.ASSASSINATION_ROGUE,
    opvp.ClassSpec.OUTLAW_ROGUE,
    opvp.ClassSpec.SUBTLETY_ROGUE,
    opvp.ClassSpec.ELEMENTAL_SHAMAN,
    opvp.ClassSpec.ENHANCEMENT_SHAMAN,
    opvp.ClassSpec.RESTORATION_SHAMAN,
    opvp.ClassSpec.AFFLICTION_WARLOCK,
    opvp.ClassSpec.DEMONOLOGY_WARLOCK,
    opvp.ClassSpec.DESTRUCTION_WARLOCK,
    opvp.ClassSpec.ARMS_WARRIOR,
    opvp.ClassSpec.FURY_WARRIOR,
    opvp.ClassSpec.PROTECTION_WARRIOR
};

opvp.ClassSpec.SPECS_DPS = {
    opvp.ClassSpec.BLOOD_DEATH_KNIGHT,
    opvp.ClassSpec.FROST_DEATH_KNIGHT,
    opvp.ClassSpec.UNHOLY_DEATH_KNIGHT,
    opvp.ClassSpec.HAVOC_DEMON_HUNTER,
    opvp.ClassSpec.VENGANCE_DEMON_HUNTER,
    opvp.ClassSpec.BALANCE_DRUID,
    opvp.ClassSpec.FERAL_DRUID,
    opvp.ClassSpec.AUGMENTATION_EVOKER,
    opvp.ClassSpec.DEVESTATION_EVOKER,
    opvp.ClassSpec.BEASTMASTER_HUNTER,
    opvp.ClassSpec.MASTER_MARKSMAN_HUNTER,
    opvp.ClassSpec.SURVIVAL_HUNTER,
    opvp.ClassSpec.ARCANE_MAGE,
    opvp.ClassSpec.FIRE_MAGE,
    opvp.ClassSpec.FROST_MAGE,
    opvp.ClassSpec.WINDWALKER_MONK,
    opvp.ClassSpec.RETRIBUTION_PALADIN,
    opvp.ClassSpec.SHADOW_PRIEST,
    opvp.ClassSpec.ASSASSINATION_ROGUE,
    opvp.ClassSpec.OUTLAW_ROGUE,
    opvp.ClassSpec.SUBTLETY_ROGUE,
    opvp.ClassSpec.ELEMENTAL_SHAMAN,
    opvp.ClassSpec.ENHANCEMENT_SHAMAN,
    opvp.ClassSpec.AFFLICTION_WARLOCK,
    opvp.ClassSpec.DEMONOLOGY_WARLOCK,
    opvp.ClassSpec.DESTRUCTION_WARLOCK,
    opvp.ClassSpec.ARMS_WARRIOR,
    opvp.ClassSpec.FURY_WARRIOR
};

opvp.ClassSpec.SPECS_HEALER = {
    opvp.ClassSpec.RESTORATION_DRUID,
    opvp.ClassSpec.PRESERVATION_EVOKER,
    opvp.ClassSpec.MISTWEAVER_MONK,
    opvp.ClassSpec.HOLY_PALADIN,
    opvp.ClassSpec.DISCIPLINE_PRIEST,
    opvp.ClassSpec.HOLY_PRIEST,
    opvp.ClassSpec.RESTORATION_SHAMAN
};

opvp.ClassSpec.SPECS_TANK = {
    opvp.ClassSpec.BLOOD_DEATH_KNIGHT,
    opvp.ClassSpec.VENGANCE_DEMON_HUNTER,
    opvp.ClassSpec.GUARDIAN_DRUID,
    opvp.ClassSpec.BREWMASTER_MONK,
    opvp.ClassSpec.PROTECTION_PALADIN,
    opvp.ClassSpec.PROTECTION_WARRIOR
};
