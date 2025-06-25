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

opvp.GroupAddonCommand = opvp.CreateClass(opvp.AddonCommand);

function opvp.GroupAddonCommand:init(name, description)
    opvp.AddonCommand.init(self, name, description)

    self._cmds = opvp.List();
    self._cmd_default = "";
end

function opvp.GroupAddonCommand:addCommand(cmd)
    if (
        opvp.IsInstance(cmd, opvp.AddonCommand) == true and
        self._cmds:contains(cmd) == false
    ) then
        self._cmds:append(cmd);
    end
end

function opvp.GroupAddonCommand:clear()
    return self._cmds:clear();
end

function opvp.GroupAddonCommand:commands()
    return self._cmds:items();
end

function opvp.GroupAddonCommand:eval(editbox, args)
    if args == "" then
        if self._cmd_default == "" then
            self:help();

            return;
        end

        args = self._cmd_default;
    end

    local cmd_name, cmd_args = strsplit(" ", opvp.string.stripTrailingSpace(args), 2);

    if cmd_name == "help" then
        self:help();

        return;
    end

    local cmd = self:findCommand(cmd_name);

    if cmd ~= nil then
        if cmd_args == nil then
            cmd_args = "";
        end

        cmd:eval(editbox, cmd_args);
    end
end

function opvp.GroupAddonCommand:findCommand(name)
    local cmd;

    for n=1, self._cmds:size() do
        cmd = self._cmds:item(n);

        if cmd:name() == name then
            return cmd;
        end
    end

    return nil;
end

function opvp.GroupAddonCommand:help()
    opvp.printMessage(opvp.strs.CMD_GROUP_HELP, self._name, self._desc);

    local cmd;

    for n=1, self._cmds:size() do
        cmd = self._cmds:item(n);

        opvp.printMessage(opvp.strs.CMD_GROUP_CMD_HELP, n, cmd:name(), cmd:description());
    end
end

function opvp.GroupAddonCommand:isEmpty()
    return self._cmds:isEmpty();
end

function opvp.GroupAddonCommand:removeCommand(cmd)
    if opvp.IsInstance(cmd, opvp.AddonCommand) == true then
        self._cmds:removeItem(cmd);

        return;
    end

    local c;

    for n=1, self._cmds:size() do
        c = self._cmds:item(n);

        if c:name() == cmd then
            self._cmds:removeIndex(n);

            return;
        end
    end
end

function opvp.GroupAddonCommand:setDefaultCommad(cmd)
    if cmd == nil then
        cmd = "";
    end

    self._cmd_default = cmd;
end

function opvp.GroupAddonCommand:show()
    self:help();
end

function opvp.GroupAddonCommand:size()
    return self._cmds:size();
end
