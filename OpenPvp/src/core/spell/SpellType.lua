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

local opvp_debufftype_lookup;

opvp.DebuffTypeId = {
    NONE     = 0,
    CURSE    = bit.lshift(1, 0),
    DISEASE  = bit.lshift(1, 1),
    MAGIC    = bit.lshift(1, 2),
    PHYSICAL = bit.lshift(1, 3),
    POISON   = bit.lshift(1, 4)
};

opvp.DebuffType = opvp.CreateClass();

function opvp.DebuffType:fromName(name)
    local result = opvp_debufftype_lookup[name];

    if result ~= nil then
        return result;
    else
        return opvp.DebuffType.NONE;
    end
end

function opvp.DebuffType:init(id, name, color)
    self._id    = id;
    self._name  = name;
    self._color = CreateColor(color.r, color.g, color.b);
end

function opvp.DebuffType:id()
    return self._id;
end

function opvp.DebuffType:isAny(mask)
    return bit.band(self._id, mask);
end

function opvp.DebuffType:isCurse()
    return self._id == opvp.DebuffTypeId.CURSE;
end

function opvp.DebuffType:isDisease()
    return self._id == opvp.DebuffTypeId.DISEASE;
end

function opvp.DebuffType:isMagic()
    return self._id == opvp.DebuffTypeId.MAGIC;
end

function opvp.DebuffType:isNull()
    return self._id == opvp.DebuffTypeId.NONE;
end

function opvp.DebuffType:isPhysical()
    return self._id == opvp.DebuffTypeId.PHYSICAL;
end

function opvp.DebuffType:isPoison()
    return self._id == opvp.DebuffTypeId.POISON;
end

function opvp.DebuffType:name()
    return self._name;
end

opvp.DebuffType.NONE      = opvp.DebuffType(opvp.DebuffTypeId.NONE,     opvp.strs.NONE,     DebuffTypeColor["none"]);
opvp.DebuffType.CURSE     = opvp.DebuffType(opvp.DebuffTypeId.CURSE,    opvp.strs.CURSE,    DebuffTypeColor["Curse"]);
opvp.DebuffType.DISEASE   = opvp.DebuffType(opvp.DebuffTypeId.DISEASE,  opvp.strs.DISEASE,  DebuffTypeColor["Disease"]);
opvp.DebuffType.MAGIC     = opvp.DebuffType(opvp.DebuffTypeId.MAGIC,    opvp.strs.MAGIC,    DebuffTypeColor["Magic"]);
opvp.DebuffType.PHYSICAL  = opvp.DebuffType(opvp.DebuffTypeId.PHYSICAL, opvp.strs.PHYSICAL, DebuffTypeColor["none"]);
opvp.DebuffType.POISON    = opvp.DebuffType(opvp.DebuffTypeId.POISON,   opvp.strs.POISON,   DebuffTypeColor["Poison"]);

opvp.DebuffType.TYPES = {
    opvp.DebuffType.NONE,
    opvp.DebuffType.CURSE,
    opvp.DebuffType.DISEASE,
    opvp.DebuffType.MAGIC,
    opvp.DebuffType.PHYSICAL,
    opvp.DebuffType.POISON
};

opvp_debufftype_lookup = {
    "none"    = opvp.DebuffType.NONE,
    "Curse"   = opvp.DebuffType.CURSE,
    "Disease" = opvp.DebuffType.DISEASE,
    "Magic"   = opvp.DebuffType.MAGIC,
    "Poison"  = opvp.DebuffType.POISON
};
