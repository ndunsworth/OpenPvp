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

opvp.UnitAuras = opvp.CreateClass();

function opvp.UnitAuras:init()
    self._id = "";

    self._auras = opvp.List();
end

function opvp.UnitAuras:auras()
    return self._auras:items();
end

function opvp.UnitAuras:clear()
    return self._auras:clear();
end

function opvp.UnitAuras:findById(id)
    local aura;

    for n=1, self._auras:size() do
        aura = self._auras:item(n);

        if aura:id() == id then
            return aura;
        end
    end

    return nil;
end

function opvp.UnitAuras:findBySpellId(spellId)
    local aura;

    for n=1, self._auras:size() do
        aura = self._auras:item(n);

        if aura:spellId() == spellId then
            return aura;
        end
    end

    return nil;
end

function opvp.UnitAuras:id()
    return self._id;
end

function opvp.UnitAuras:isEmpty()
    return self._auras:isEmpty();
end

function opvp.UnitAuras:isNull()
    return self._id == "";
end

function opvp.UnitAuras:setId(unitId)
    if unitId == self._id then
        return;
    end

    assert(opvp.is_str(unitId));

    self._id = unitId;

    self._auras:clear();

    self:update();
end

function opvp.UnitAuras:size()
    return self._auras:size();
end

function opvp.UnitAuras:update()
    if self:isNull() == true then
        return;
    end

    local callback = function(info)
        local aura = opvp.Aura:acquire();

        aura:set(info);

        self._auras:append(aura);
    end

    AuraUtil.ForEachAura(self._id, "HARMFUL", nil, callback, true);
    AuraUtil.ForEachAura(self._id, "HELPFUL", nil, callback, true);
    AuraUtil.ForEachAura(self._id, "HARMFUL|RAID", nil, callback, true);
end

function opvp.UnitAuras:updateFromEvent(info)
    local auras_new = {};
    local auras_mod = {};
    local auras_rem = {};

    if self:isNull() == true then
        return false, auras_new, auras_mod, auras_rem, false;
    end

    local index, aura, tmp;

    if info.isFullUpdate == true then
        auras = opvp.List();

        local callback = function(data)
            local index, aura = self:_findById(data.auraInstanceID);

            if aura ~= nil then
                self._auras:removeIndex(index);

                aura:update(data);

                table.insert(auras_mod, aura);
            else
                local aura = opvp.Aura:acquire();

                assert(aura ~= nil);

                aura:set(data);

                table.insert(auras_new, aura);
            end

            auras:append(aura);
        end

        AuraUtil.ForEachAura(self._id, "HARMFUL", nil, callback, true);
        AuraUtil.ForEachAura(self._id, "HELPFUL", nil, callback, true);
        AuraUtil.ForEachAura(self._id, "HARMFUL|RAID", nil, callback, true);

        self._auras:swap(auras);

        auras_rem = auras:release();

        for n=1, #auras_rem do
            opvp.Aura:release(auras_rem[n]);
        end
    else
        if info.addedAuras then
            for n=1, #info.addedAuras do
                aura = opvp.Aura:acquire();

                aura:set(info.addedAuras[n]);

                self._auras:append(aura);

                table.insert(auras_new, aura);
            end
        end

        if info.updatedAuraInstanceIDs then
            for n=1, #info.updatedAuraInstanceIDs do
                tmp = C_UnitAuras.GetAuraDataByAuraInstanceID(self._id, info.updatedAuraInstanceIDs[n]);

                if tmp ~= nil then
                    aura = self:findById(tmp.auraInstanceID);

                    if aura ~= nil then
                        if tmp ~= nil then
                            aura:update(tmp);

                            table.insert(auras_mod, aura);
                        end
                    else
                        aura = opvp.Aura:acquire();

                        assert(aura ~= nil);

                        aura:set(tmp);

                        self._auras:append(aura);

                        table.insert(auras_new, aura);
                    end
                end
            end
        end

        if info.removedAuraInstanceIDs then
            for n=1, #info.removedAuraInstanceIDs do
                index, aura = self:_findById(info.removedAuraInstanceIDs[n]);

                if aura ~= nil then
                    self._auras:removeIndex(index);

                    table.insert(auras_rem, aura);

                    opvp.Aura:release(aura);
                end
            end
        end
    end

    local valid = (
        #auras_new > 0 or
        #auras_mod > 0 or
        #auras_rem > 0
    );

    return valid, auras_new, auras_mod, auras_rem, info.isFullUpdate;
end

function opvp.UnitAuras:_findById(id)
    local aura;

    for n=1, self._auras:size() do
        aura = self._auras:item(n);

        if aura:id() == id then
            return n, aura;
        end
    end

    return -1, nil;
end

function opvp.UnitAuras:_findBySpellId(spellId)
    local aura;

    for n=1, self._auras:size() do
        aura = self._auras:item(n);

        if aura:spellId() == spellId then
            return n, aura;
        end
    end

    return -1, nil;
end
