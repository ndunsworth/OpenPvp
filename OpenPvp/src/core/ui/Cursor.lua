
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

opvp.Cursor = opvp.CreateClass();

function opvp.Cursor:init()

end

function opvp.Cursor:clear()
    ClearCursor();
end

function opvp.Cursor:equipItem(slot)
    return EquipCursorItem(slot);
end

function opvp.Cursor:hasItem()
    return CursorHasItem();
end

function opvp.Cursor:hasMacro()
    return CursorHasMacro();
end

function opvp.Cursor:hasMoney()
    return CursorHasMoney();
end

function opvp.Cursor:hasSpell()
    return CursorHasSpell();
end

function opvp.Cursor:info()
    return GetCursorInfo();
end

function opvp.Cursor:item()
    return C_Cursor.GetCursorItem();
end

function opvp.Cursor:money()
    return GetCursorMoney();
end

function opvp.Cursor:pickupMoney(copper)
    PickupPlayerMoney(copper);
end

function opvp.Cursor:position()
    return CreateVector2D(GetCursorPosition());
end

function opvp.Cursor:reset()
    ResetCursor();
end

function opvp.Cursor:sell()
    SellCursorItem();
end

function opvp.Cursor:set(cursor)
    SetCursor(cursor);
end

function opvp.Cursor:setHoverItem(item)
    SetCursorHoveredItem(item);
end

function opvp.Cursor:setVirtualItem(item, cursorType)
    SetCursorVirtualItem(item, cursorType);
end
