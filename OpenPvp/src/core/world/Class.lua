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

local function opvp_class_spells_init_category(cls, spells, cfg, parentMask)
    local base_mask, mask, spell_id, spell;

    if cfg.base ~= nil then
        for n=1, #cfg.base do
            spell_id, mask = unpack(cfg.base[n]);

            spell = opvp.SpellExt(
                cls,
                spell_id,
                bit.bor(parentMask, mask)
            );

            spells:append(spell);
        end
    end

    if cfg.talent ~= nil then
        parentMask = bit.bor(parentMask, opvp.SpellTrait.TALENT);

        for n=1, #cfg.talent do
            spell_id, mask = unpack(cfg.talent[n]);

            spell = opvp.SpellExt(
                cls,
                spell_id,
                bit.bor(parentMask, mask)
            );

            spells:append(spell);
        end
    end
end

local function opvp_class_spells_init(cls, cfg)
    spells = opvp.List();

    if cfg == nil then
        return spells;
    end

    local mask;

    if cfg.helpful ~= nil then
        mask = bit.bor(opvp.SpellTrait.BASE, opvp.SpellTrait.HELPFUL);

        opvp_class_spells_init_category(
            cls,
            spells,
            cfg.helpful,
            mask
        );
    end

    if cfg.harmful ~= nil then
        mask = bit.bor(opvp.SpellTrait.BASE, opvp.SpellTrait.HARMFUL);

        opvp_class_spells_init_category(
            cls,
            spells,
            cfg.harmful,
            mask
        );
    end

    return spells;
end

opvp.Class = opvp.CreateClass();

function opvp.Class:fromClassId(id)
    if opvp.is_number(id) == false then
        return opvp.Class.UNKNOWN;
    end

    local cls = opvp.Class.CLASSES[id + 1];

    if cls ~= nil then
        return cls;
    else
        return opvp.Class.UNKNOWN;
    end
end

function opvp.Class:fromFileId(id)
    local cls;

    for n=1, #opvp.Class.CLASSES do
        cls = opvp.Class.CLASSES[n];

        if cls:fileId() == name then
            return cls;
        end
    end

    return opvp.Class.UNKNOWN;
end

function opvp.Class:fromGUID(guid)
    return opvp.Class:fromPlayerLocation(
        PlayerLocation:CreateFromGUID(guid)
    );
end

function opvp.Class:fromPlayerLocation(location)
    if location:IsValid() == true then
        local class_name, class_filename, class_id = C_PlayerInfo.GetClass(location);

        if class_id ~= nil then
            return opvp.Class:fromClassId(class_id);
        end
    end

    return opvp.Class.UNKNOWN;
end

function opvp.Class:fromSpecId(id)
    return opvp.Class:fromClassId(GetClassIDFromSpecID(id));
end

function opvp.Class:init(id, fileId, races, specs, spells)
    self._id         = id;
    self._file_id    = fileId;
    self._races      = races;
    self._races_mask = 0;
    self._specs      = specs;
    self._role_mask  = 0;
    self._spells     = opvp_class_spells_init(self, spells);

    for index, race in ipairs(races) do
        self._races_mask = bit.bor(
            self._races_mask,
            bit.lshift(1, race:id())
        );
    end

    for index, spec in ipairs(specs) do
        self._role_mask = bit.bor(
            self._role_mask,
            bit.lshift(1, spec:role():id())
        );
    end
end

function opvp.Class:color()
    if self._id ~= opvp.UNKNOWN_CLASS then
        return C_ClassColor.GetClassColor(self._file_id);
    else
        return ITEM_QUALITY_COLORS[0].color;
    end
end

function opvp.Class:colorString(str)
    return self:color():WrapTextInColorCode(str);
end

function opvp.Class:id()
    return self._id;
end

function opvp.Class:fileId()
    return self._file_id;
end

function opvp.Class:hasRace(race)
    return (
        bit.band(
            self._races_mask,
            bit.lshift(1, race)
        ) ~= 0
    );
end

function opvp.Class:hasRole(role)
    return (
        bit.band(
            self._role_mask,
            bit.lshift(1, role)
        ) ~= 0
    );
end

function opvp.Class:isValid()
    return self._id ~= opvp.UNKNOWN_CLASS;
end

function opvp.Class:name()
    if self._id ~= opvp.UNKNOWN_CLASS then
        return C_CreatureInfo.GetClassInfo(self._id).className;
    else
        return "Unknown";
    end
end

function opvp.Class:raceNames()
    local result = {};

    for index, race in ipairs(self._races) do
        table.insert(result, race:name());
    end

    return result;
end

function opvp.Class:races()
    return {unpack(self._races)};
end

function opvp.Class:racesMask()
    return self._races_mask;
end

function opvp.Class:racesSize()
    return #self._races;
end

function opvp.Class:roleNames()
    local result = {};

    if bit.band(self._role_mask, bit.lshift(1, opvp.RoleType.DPS)) ~= 0 then
        table.insert(result, Role.DPS:name());
    end

    if bit.band(self._role_mask,  bit.lshift(1, opvp.RoleType.HEALER)) ~= 0 then
        table.insert(result, Role.HEALER:name());
    end

    if bit.band(self._role_mask,  bit.lshift(1, opvp.RoleType.SUPPORT)) ~= 0 then
        table.insert(result, Role.SUPPORT:name());
    end

    if bit.band(self._role_mask,  bit.lshift(1, opvp.RoleType.TANK)) ~= 0 then
        table.insert(result, Role.TANK:name());
    end

    return result;
end

function opvp.Class:rolesMask()
    return self._role_mask;
end

function opvp.Class:specNames()
    local result = {};

    for index, spec in ipairs(self._specs) do
        table.insert(result, spec:name());
    end

    return result;
end

function opvp.Class:specsSize()
    return #self._specs;
end

function opvp.Class:spec(specId)
    for n=1, self._specs:size() do
        local spec = self._specs:item(n);

        if spec:id() == specId then
            return spec;
        end
    end

    return opvp.ClassSpec.UKNOWN;
end

function opvp.Class:specs()
    return {unpack(self._specs)};
end
