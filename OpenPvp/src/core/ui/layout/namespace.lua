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

local opvp_layout_mgr_singleton;

opvp.layout = {};

opvp.layout.added          = opvp.Signal("opvp.layout.added");
opvp.layout.changed        = opvp.Signal("opvp.layout.changed");
opvp.layout.deleted        = opvp.Signal("opvp.layout.deleted");
opvp.layout.modified       = opvp.Signal("opvp.layout.modified");
opvp.layout.renamed        = opvp.Signal("opvp.layout.renamed");
opvp.layout.beginEditMode  = opvp.Signal("opvp.layout.beginEditMode");
opvp.layout.endEditMode    = opvp.Signal("opvp.layout.endEditMode");

function opvp.layout:active()
    return opvp_layout_mgr_singleton:active();
end

function opvp.layout:activeIndex()
    return opvp_layout_mgr_singleton:activeIndex();
end

function opvp.layout:findLayout(name)
    return opvp_layout_mgr_singleton:findLayout(name);
end

function opvp.layout.isEditing()
    return opvp_layout_mgr_singleton:isEditing();
end

function opvp.layout.isValidIndex(index)
    return opvp_layout_mgr_singleton:isValidIndex(index);
end

function opvp.layout.isValidName(name)
    return opvp_layout_mgr_singleton:isValidName(name);
end

function opvp.layout.layout(index)
    return opvp_layout_mgr_singleton:layout(index);
end

function opvp.layout.layouts()
    return opvp_layout_mgr_singleton:layouts();
end

function opvp.layout:manager()
    return opvp_layout_mgr_singleton;
end

function opvp.layout.name()
    return opvp_layout_mgr_singleton:active():name();
end

function opvp.layout.size()
    return opvp_layout_mgr_singleton:size();
end

local function opvp_layout_mgr_singleton_ctor()
    opvp_layout_mgr_singleton = opvp.LayoutManager();

    opvp.printDebug("LayoutManager - Initialized");
end

opvp.OnAddonLoad:register(opvp_layout_mgr_singleton_ctor);
