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

local _, OpenPvpLib = ...
local opvp = OpenPvpLib;

_G["BINDING_NAME_CLICK OpenPvpArenaFocusUpButton:LeftButton"] = "Arena Focus Up";
_G["BINDING_NAME_CLICK OpenPvpArenaFocusDownButton:LeftButton"] = "Arena Focus Down";
_G["BINDING_NAME_CLICK OpenPvpArenaTargetUpButton:LeftButton"] = "Arena Target Up";
_G["BINDING_NAME_CLICK OpenPvpArenaTargetDownButton:LeftButton"] = "Arena Target Down";

local FocusFollower = {}

function FocusFollower.create(targetType)
    local frame = CreateFrame("Frame", "OpenPvpFocusFollower", nil, "SecureHandlerBaseTemplate")

    frame.init                  = FocusFollower.init;
    frame.findArenaFrame        = FocusFollower.findArenaFrame;
    frame.findPartyFrame        = FocusFollower.findPartyFrame;
    frame.splitNameAndServer    = FocusFollower.splitNameAndServer;
    frame.type                  = FocusFollower.type;
    frame._changed              = FocusFollower._changed;
    frame.PLAYER_FOCUS_CHANGED  = FocusFollower.PLAYER_FOCUS_CHANGED;
    frame.PLAYER_TARGET_CHANGED = FocusFollower.PLAYER_TARGET_CHANGED;

    frame:init(targetType);

    return frame;
end

function FocusFollower.init(self, targetType)
    self:SetScript(
        "OnEvent",
        function(self, event, ...)
            return FocusFollower[event] and FocusFollower[event](self, ...);
        end
    );

    if targetType == "focus" then
        self:RegisterEvent("PLAYER_FOCUS_CHANGED");
    else
        self:RegisterEvent("PLAYER_TARGET_CHANGED");
    end

    self._arena_frames = {
        CompactArenaFrameMember1,
        CompactArenaFrameMember2,
        CompactArenaFrameMember3
    };

    self._party_frames = {
        CompactPartyFrameMember2,
        CompactPartyFrameMember3,
        CompactPartyFrameMember4,
        CompactPartyFrameMember5
    };

    self:SetAttribute("CompactArenaFrameMember1", 1);
    self:SetAttribute("CompactArenaFrameMember2", 2);
    self:SetAttribute("CompactArenaFrameMember3", 3);

    self:SetAttribute("CompactPartyFrameMember2", 1);
    self:SetAttribute("CompactPartyFrameMember3", 2);
    self:SetAttribute("CompactPartyFrameMember4", 3);
    self:SetAttribute("CompactPartyFrameMember5", 4);

    self:SetFrameRef("Arena1Frame", self._arena_frames[1]);
    self:SetFrameRef("Arena2Frame", self._arena_frames[2]);
    self:SetFrameRef("Arena3Frame", self._arena_frames[3]);

    self:SetFrameRef("Party1Frame", self._party_frames[1]);
    self:SetFrameRef("Party2Frame", self._party_frames[2]);
    self:SetFrameRef("Party3Frame", self._party_frames[3]);
    self:SetFrameRef("Party4Frame", self._party_frames[4]);

    self._type = targetType;
end

function FocusFollower.findArenaFrame(self, name, server)
    for n=1,3 do
        local frame_name = self._arena_frames[n].name:GetText();

        if frame_name ~= nil then
            local arena_name, arena_realm = self:splitNameAndServer(frame_name);

            if arena_name == name and arena_realm == server then
                return n, self._arena_frames[n];
            end
        end
    end

    return 0, nil;
end

function FocusFollower.findPartyFrame(self, name, server)
    for n=1,4 do
        local frame_name = self._party_frames[n].name:GetText();

        if frame_name ~= nil then
            frame_name = string.gsub(frame_name, "\*", "");

            local party_name, party_realm = self:splitNameAndServer(frame_name);

            if party_name == name and party_realm == server then
                return n, self._party_frames[n];
            end
        end
    end

    return 0, nil;
end

function FocusFollower.splitNameAndServer(self, characterName)
    local server, name = strsplit("-", strrev(characterName), 2);

    if name ~= nil then
        return strrev(name), strrev(server)
    else
        return characterName, nil
    end
end

function FocusFollower.type(self)
    return self._type;
end

function FocusFollower._changed(self)
    local focus_name, focus_realm = UnitName(self._type);

    if focus_name == nil then
        self:SetParent(nil);

        return;
    end

    local index, frame;

    if UnitIsEnemy("player", "focus") then
        index, frame = self:findArenaFrame(focus_name, focus_realm);
    elseif IsInGroup() == true then
        index, frame = self:findPartyFrame(focus_name, focus_realm);
    end

    self:SetParent(frame);
end

function FocusFollower.PLAYER_FOCUS_CHANGED(self)
    self:_changed();
end

function FocusFollower.PLAYER_TARGET_CHANGED(self)
    self:_changed();
end

local FocusButton = {};

function FocusButton.create(name, direction, follower)
    local button = CreateFrame("Button", name, follower, "SecureActionButtonTemplate");

    button.init = FocusButton.init;
    button.PLAYER_JOINED_PVP_MATCH = FocusButton.PLAYER_JOINED_PVP_MATCH;

    button:init(name, direction, follower);

    return button;
end;

function FocusButton.init(self, name, direction, follower)
    self._follower = follower;

    self:SetScript(
        "OnEvent",
        function(self, event, ...)
            return FocusButton[event] and FocusButton[event](self, ...);
        end
    );

    self:RegisterForClicks("AnyDown");

    self:SetAttribute("type", follower:type());
    self:SetAttribute("unit", "arena1");
    self:SetAttribute("focus_prefix", "arena");
    self:SetAttribute("focus_direction", direction);
    self:SetAttribute("focus_index", 1);
    self:SetAttribute("focus_index_max", 3);

    local focus_get_index_func = [[
        local follower_frame = self:GetParent();
        local focus_frame = follower_frame:GetParent();
        local index = 0;

        if focus_frame ~= nil then
            local tmp = follower_frame:GetAttribute(focus_frame:GetName());

            if tmp ~= nil then
                index = tmp;
            end
        end

        self:SetAttribute("focus_index", index);
    ]]

    self:SetAttribute("focus_get_index", focus_get_index_func);

    SecureHandlerWrapScript(
        self,
        "OnClick",
        self,
        [[
            self:RunAttribute("focus_get_index");

            local cur_index = self:GetAttribute("focus_index");
            local max_index = self:GetAttribute("focus_index_max");
            local dir = self:GetAttribute("focus_direction");
            local prefix = self:GetAttribute("focus_prefix");
            local new_index = max(1, min(max_index, cur_index + dir));
            local target = prefix .. tostring(new_index);

            while UnitExists(target) == false do
                new_index = new_index + dir;

                if new_index < 1 or new_index > max_index then
                    return;
                end
            end

            self:SetAttribute("focus_index", new_index);
            self:SetAttribute("unit", target);
        ]]
    );
end

FocusFollower.FOCUS  = FocusFollower.create("focus");
FocusFollower.TARGET = FocusFollower.create("target");

FocusButton.ARENA_ENEMY_FOCUS_DOWN  = FocusButton.create("OpenPvpArenaFocusDownButton", 1, FocusFollower.FOCUS);
FocusButton.ARENA_ENEMY_FOCUS_UP    = FocusButton.create("OpenPvpArenaFocusUpButton", -1, FocusFollower.FOCUS);
FocusButton.ARENA_ENEMY_TARGET_DOWN = FocusButton.create("OpenPvpArenaTargetDownButton", 1, FocusFollower.TARGET);
FocusButton.ARENA_ENEMY_TARGET_UP   = FocusButton.create("OpenPvpArenaTargetUpButton", -1, FocusFollower.TARGET);
