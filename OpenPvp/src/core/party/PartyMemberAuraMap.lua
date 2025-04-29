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

opvp.PartyMemberAuraMap = opvp.CreateClass(opvp.AuraMap);

function opvp.PartyMemberAuraMap:init()
    opvp.AuraMap.init(self);
end

function opvp.PartyMemberAuraMap:add(aura)

end

function opvp.PartyMemberAuraMap:clear()

end

function opvp.PartyMemberAuraMap:remove(aura)

end

function opvp.PartyMemberAuraMap:update(unitId)
    self:clear();

    local callback = function(info)
        local aura = opvp.Aura:acquire();

        aura:set(info);

        self._auras[aura:id()] = aura;
    end

    AuraUtil.ForEachAura(unitId, "HARMFUL", nil, callback, true);
    AuraUtil.ForEachAura(unitId, "HELPFUL", nil, callback, true);
    AuraUtil.ForEachAura(unitId, "HARMFUL|RAID", nil, callback, true);
end

function opvp.PartyMemberAuraMap:updateFromEvent(
    unitId,
    info,
    aurasNew,
    aurasModified,
    aurasRemoved
)
    local index, aura, tmp;

    if info.isFullUpdate == true then
        auras = {};

        local callback = function(data)
            aura = self._auras[data.auraInstanceID];

            if aura ~= nil then
                aura:update(data);

                aurasModified:add(aura);

                self._auras[data.auraInstanceID] = nil;
            else
                local aura = opvp.Aura:acquire();

                assert(aura ~= nil);

                aura:set(data);

                aurasNew:add(aura);
            end

            auras[data.auraInstanceID] = aura;
        end

        AuraUtil.ForEachAura(unitId, "HARMFUL", nil, callback, true);
        AuraUtil.ForEachAura(unitId, "HELPFUL", nil, callback, true);
        AuraUtil.ForEachAura(unitId, "HARMFUL|RAID", nil, callback, true);

        aurasRemoved:swap(self);

        self._auras = auras;
    else
        if info.removedAuraInstanceIDs then
            for n=1, #info.removedAuraInstanceIDs do
                aura = self._auras[info.removedAuraInstanceIDs[n]];

                if aura ~= nil then
                    self._auras[aura:id()] = nil;

                    aurasRemoved:add(aura);
                end
            end
        end

        if info.addedAuras then
            for n=1, #info.addedAuras do
                aura = opvp.Aura:acquire();

                aura:set(info.addedAuras[n]);

                self._auras[aura:id()] = aura;

                aurasNew:add(aura);
            end
        end

        if info.updatedAuraInstanceIDs then
            for n=1, #info.updatedAuraInstanceIDs do
                tmp = C_UnitAuras.GetAuraDataByAuraInstanceID(unitId, info.updatedAuraInstanceIDs[n]);

                if tmp ~= nil then
                    aura = self._auras[tmp.auraInstanceID];

                    if aura ~= nil then
                        aura:update(tmp);

                        aurasModified:add(aura);
                    else
                        aura = opvp.Aura:acquire();

                        assert(aura ~= nil);

                        aura:set(tmp);

                        self._auras[aura:id()] = aura;

                        aurasNew:add(aura);
                    end
                end
            end
        end
    end

    return info.isFullUpdate;
end

function opvp.PartyMemberAuraMap:_clear()
    for id, aura in pairs(self._auras) do
        opvp.Aura:release(aura);
    end

    self._auras = {};
end
