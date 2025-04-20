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

opvp.Option = opvp.CreateClass();

opvp.Option.BITMASK    =  1;
opvp.Option.BOOL       =  2;
opvp.Option.BUTTON     =  3;
opvp.Option.ENUM       =  4;
opvp.Option.FLOAT      =  5;
opvp.Option.INT        =  6;
opvp.Option.LABEL      =  7;
opvp.Option.LAYOUT     =  8;
opvp.Option.MATCH_TYPE =  9;
opvp.Option.ROLEMASK   = 10;
opvp.Option.STRING     = 11;

opvp.Option.DISABLED               = bit.lshift(1, 0);
opvp.Option.DONT_SAVE_FLAG         = bit.lshift(1, 1);
opvp.Option.HIDDEN_FLAG            = bit.lshift(1, 2);
opvp.Option.LOCKED_DURING_COMBAT   = bit.lshift(1, 3);
opvp.Option.NEW_LINE_FLAG          = bit.lshift(1, 4);

function opvp.Option:init(key, name, description)
    self._category = nil;
    self._frame    = nil;
    self._key      = key;
    self._name     = name;
    self._desc     = description;
    self._loading  = false;
    self._flags    = opvp.Option.NEW_LINE_FLAG;
end

function opvp.Option:category()
    return self._category;
end

function opvp.Option:createWidget(name, parent)
    return nil;
end

function opvp.Option:createWidgetTooltip(frame, callback)
    frame:SetScript(
        "OnEnter",
        function()
            GameTooltip:SetOwner(frame, "ANCHOR_TOPLEFT");

            GameTooltip:AddLine(self:description());

            GameTooltip:Show();

            if callback ~= nil then
                callback();
            end
        end
    );

    frame:SetScript(
        "OnLeave",
        function()
            GameTooltip:Hide();
        end
    );
end

function opvp.Option:description()
    return self._desc;
end

function opvp.Option:flags()
    return self._flags
end

function opvp.Option:fromScript(data)
end

function opvp.Option:inCombatLockdown()
    return (
        self:isEditableDuringCombat() == false and
        InCombatLockdown() == true
    );
end

function opvp.Option:isDisabled()
    return bit.band(self._flags, opvp.Option.DISABLED) ~= 0;
end

function opvp.Option:isEditableDuringCombat()
    return bit.band(self._flags, opvp.Option.LOCKED_DURING_COMBAT) == 0;
end

function opvp.Option:isEnabled()
    return bit.band(self._flags, opvp.Option.DISABLED) == 0;
end

function opvp.Option:isHidden()
    return bit.band(self._flags, opvp.Option.HIDDEN_FLAG) ~= 0;
end

function opvp.Option:isLoading()
    return self._loading;
end

function opvp.Option:isSavable()
    return bit.band(self._flags, opvp.Option.DONT_SAVE_FLAG) == 0;
end

function opvp.Option:key()
    return self._key;
end

function opvp.Option:name()
    return self._name;
end

function opvp.Option:setDescription(description)
    self._desc = description;
end

function opvp.Option:setEnabled(state)
    if state == self:isEnabled() then
        return;
    end

    if state == true then
        self:setFlags(opvp.Option.DISABLED, false);
    else
        self:setFlags(opvp.Option.DISABLED, true);
    end

    self:_onEnableChanged(state);
end

function opvp.Option:setFlags(flags, state)
    local combat_state = self:isEditableDuringCombat();

    if state == nil then
        self._flags = flags;
    else
        if state == true then
            self._flags = bit.bor(self._flags, flags);
        else
            self._flags = bit.band(self._flags, bit.bnot(flags));
        end
    end

    if combat_state ~= self:isEditableDuringCombat() then
        if combat_state == true then
            opvp.player.instance().inCombatChanged:connect(
                self,
                self._onCombatChanged
            );
        else
            opvp.player.instance().inCombatChanged:disconnect(
                self,
                self._onCombatChanged
            );
        end
    end
end

function opvp.Option:setName(name)
    self._name = name;
end

function opvp.Option:startLine()
    return bit.band(self._flags, opvp.Option.NEW_LINE_FLAG) ~= 0;
end

function opvp.Option:toScript()
    return nil;
end

function opvp.Option:type()
    return nil;
end

function opvp.Option:_onCombatChanged(state)
    self:setEnabled(not state);
end

function opvp.Option:_onEnableChanged(state)

end
