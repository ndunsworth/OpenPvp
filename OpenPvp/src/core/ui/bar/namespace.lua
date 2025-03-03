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

local opvp_actionbar_mgr_singleton;
local opvp_bagbar_singleton;
local opvp_micromenu_singleton;

opvp.actionbar = {};

function opvp.actionbar.bar(id)
    return opvp_actionbar_mgr_singleton:bar(id);
end

function opvp.actionbar.bars()
    return opvp_actionbar_mgr_singleton:bars();
end

function opvp.actionbar.isDisabled(id)
    return opvp_actionbar_mgr_singleton:isDisabled(id);
end

function opvp.actionbar.isEnabled(id)
    return opvp_actionbar_mgr_singleton:isEnabled(id);
end

function opvp.actionbar.setEnabled(id, state)
    return opvp_actionbar_mgr_singleton:setEnabled(id, state);
end

opvp.bagbar = {};

function opvp.bagbar.bar()
    return opvp_bagbar_singleton;
end

function opvp.bagbar.isDisabled()
    return opvp_bagbar_singleton:isDisabled();
end

function opvp.bagbar.isEnabled()
    return opvp_bagbar_singleton:isEnabled();
end

function opvp.bagbar.setEnabled(state)
    return opvp_bagbar_singleton:setEnabled(state);
end

opvp.micromenu = {};

function opvp.micromenu.bar()
    return opvp_micromenu_singleton;
end

function opvp.micromenu.isDisabled()
    return opvp_micromenu_singleton:isDisabled();
end

function opvp.micromenu.isEnabled()
    return opvp_micromenu_singleton:isEnabled();
end

function opvp.micromenu.setEnabled(state)
    return opvp_micromenu_singleton:setEnabled(state);
end

local function opvp_actionbar_mgr_singleton_ctor()
    opvp_actionbar_mgr_singleton = opvp.ActionBarManager();

    opvp.printDebug("ActionBarManager - Initialized");

    opvp_bagbar_singleton = opvp.BagBar();
    opvp_micromenu_singleton = opvp.MicroMenu();
end

opvp.OnAddonLoad:register(opvp_actionbar_mgr_singleton_ctor);
