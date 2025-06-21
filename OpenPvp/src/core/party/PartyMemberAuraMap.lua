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

function opvp.PartyMemberAuraMap.__iter__(self)
    return next, self._auras, nil;
end

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
    self:_clear();

    local callback = function(info)
        if self._auras[info.auraInstanceID] == nil then
            local aura = opvp.Aura:acquire();

            aura:set(info);

            assert(aura:id() > 0);

            self._auras[aura:id()] = aura;
            self._size = self._size + 1;
        end
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
    assert (
        aurasNew:isEmpty() == true and
        aurasModified:isEmpty() == true and
        aurasRemoved:isEmpty() == true
    )

    local aura, aura_info, id;

    if info.isFullUpdate == true then
        local auras = {};
        local size = 0;

        local callback = function(data)
            if auras[data.auraInstanceID] ~= nil then
                return;
            end

            aura = self._auras[data.auraInstanceID];

            if aura ~= nil then
                aura:update(data);

                aurasModified:add(aura);

                self._auras[data.auraInstanceID] = nil;
                self._size = self._size - 1;
            else
                aura = opvp.Aura:acquire();

                aura:set(data);

                aurasNew:add(aura);
            end

            auras[data.auraInstanceID] = aura;

            size = size + 1;
        end

        AuraUtil.ForEachAura(unitId, "HARMFUL", nil, callback, true);
        AuraUtil.ForEachAura(unitId, "HELPFUL", nil, callback, true);
        AuraUtil.ForEachAura(unitId, "HARMFUL|RAID", nil, callback, true);

        aurasRemoved:swap(self);

        self._auras = auras;
        self._size = size;
    else
        --~ Why we are recieving duplicates from UNIT_AURA I have no idea

        if info.removedAuraInstanceIDs then
            for n=1, #info.removedAuraInstanceIDs do
                aura = self._auras[info.removedAuraInstanceIDs[n]];

                if aura ~= nil then
                    self._auras[aura:id()] = nil;
                    self._size = self._size - 1;

                    assert(aurasRemoved:add(aura));
                end
            end
        end

        if info.addedAuras then
            for n=1, #info.addedAuras do
                aura_info = info.addedAuras[n];

                aura = self._auras[aura_info.auraInstanceID];

                if aura == nil then
                    aura = opvp.Aura:acquire();

                    aura:set(aura_info);

                    self._auras[aura_info.auraInstanceID] = aura;
                    self._size = self._size + 1;

                    assert(aurasNew:add(aura));
                elseif aurasModified:contains(aura_info.auraInstanceID) == false then
                    aura:update(aura_info);

                    assert(aurasModified:add(aura));
                end
            end
        end

        if info.updatedAuraInstanceIDs then
            for n=1, #info.updatedAuraInstanceIDs do
                id = info.updatedAuraInstanceIDs[n];

                if aurasModified:contains(id) == false then
                    aura_info = C_UnitAuras.GetAuraDataByAuraInstanceID(unitId, info.updatedAuraInstanceIDs[n]);

                    if aura_info ~= nil then
                        aura = self._auras[aura_info.auraInstanceID];

                        if aura ~= nil then
                            aura:update(aura_info);

                            assert(aurasModified:add(aura));
                        else
                            aura = opvp.Aura:acquire();

                            aura:set(aura_info);

                            self._auras[aura_info.auraInstanceID] = aura;
                            self._size = self._size + 1;

                            assert(aurasNew:add(aura));
                        end
                    end
                end
            end
        end
    end

    return info.isFullUpdate;
end

function opvp.PartyMemberAuraMap:_clear()
    if self:isEmpty() == false then
        opvp.Aura:release(self);

        table.wipe(self._auras);

        self._size = 0;
    end
end
