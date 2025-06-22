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

local opvp_hyperlink_proc_singleton;

opvp.CallbackHyperlinkProcessor = opvp.CreateClass(opvp.HyperlinkProcessor);

function opvp.CallbackHyperlinkProcessor:instance()
    return opvp_hyperlink_proc_singleton;
end

function opvp.CallbackHyperlinkProcessor:init(name)
    opvp.HyperlinkProcessor.init(self, name)

    self._funcs = {};
end

function opvp.CallbackHyperlinkProcessor:createLink(id, text, data)
    return opvp.hyperlink.createAddon(
        self._name,
        text,
        id .. ":" .. opvp.utils.serializeToJSON(data)
    );
end

function opvp.CallbackHyperlinkProcessor:isRegistered(id)
    return self._funcs[id] ~= nil;
end

function opvp.CallbackHyperlinkProcessor:register(id, func)
    if opvp.is_number(id) == false then
        return;
    end

    if opvp.is_func(func) or func == nil then
        self._funcs[id] = func;
    end
end

function opvp.CallbackHyperlinkProcessor:unregister(id)
    self._funcs[id] = nil;
end

function opvp.CallbackHyperlinkProcessor:_onEvent(id, data, chatFrame, button)
    local cb = self._funcs[id];

    if cb == nil then
        return;
    end

    local status, err = pcall(cb, id, data, chatFrame, button);

    if status == false then
        opvp.printWarning(
            "opvp.CallbackHyperlinkProcessor(\"%s\"):_onEvent, %s",
            self._name,
            err
        );
    end
end

local function opvp_hyperlink_proc_ctor()
    opvp_hyperlink_proc_singleton = opvp.CallbackHyperlinkProcessor(opvp.LIB_NAME);

    opvp_hyperlink_proc_singleton:connect();

    --~ ChatFrame1:AddMessage(
        --~ opvp_hyperlink_proc_singleton:createLink(
            --~ opvp.private.HyperlinkId.PARTY_MEMBER_CC,
            --~ "Incapacitate - Full",
            --~ {
                --~ source="Nrgy",
                --~ destination="Melixi",
                --~ category=opvp.CrowdControlType.INCAPACITATE,
                --~ dr=opvp.CrowdControlStatus.FULL,
                --~ duration=8,
                --~ spell=118,
                --~ dispell=opvp.DispellType.MAGIC
            --~ }
        --~ )
    --~ );
end

opvp.OnAddonLoad:register(opvp_hyperlink_proc_ctor);
