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

opvp.private.HyperlinkId = {
    PARTY_MEMBER_CC = 1
}

--~ See for util functions
--~ https://github.com/Gethe/wow-ui-source/blob/live/Interface/AddOns/Blizzard_UIPanels_Game/Mainline/ItemRef.lua

opvp.hyperlink = {};

function opvp.hyperlink.createAddon(addon, text, data)
    if data ~= nil then
        return string.format(
            "|Haddon:%s:%s|h[%s]|h",
            addon,
            data,
            text
        );
    else
        return string.format(
            "|Haddon:%s|h[%s]|h",
            addon,
            text
        );
    end
end

function opvp.hyperlink.createCalendarEvent(monthOffset, monthDay, index, text)
    return string.format(
        "|HcalendarEvent:%d:%d:%d|h[%s]|h",
        monthOffset,
        monthDay,
        index,
        text
    );
end

function opvp.hyperlink.createChannel(chatType, text)
    local color = opvp.chat.channelColor(chatType);

    if color ~= nil then
        return string.format(
            "%s|Hchannel:%s|h[%s]|h|r",
            color:GenerateHexColorMarkup(),
            chatType,
            text
        );
    else
        return string.format(
            "|Hchannel:%s|h[%s]|h",
            chatType,
            text
        );
    end
end

function opvp.hyperlink.createDeathRecap(recapId)
    return GetDeathRecapLink(name);
end

function opvp.hyperlink.createDeathRecap(spellId, glyphId)
    return C_Spell.GetSpellLink(spellId, glyphId);
end

function opvp.hyperlink.createPlayer(name, lineId, text)
    if lineId ~= nil then
        return string.format(
            "|Hplayer:%s:%d:MESSAGE|h[%s]|h",
            name,
            lineId,
            text ~= nil and text or name
        );
    else
        return string.format(
            "|Hplayer:%s:MESSAGE|h[%s]|h",
            name,
            text ~= nil and text or name
        );
    end
end

function opvp.hyperlink.createPvpRating()
    return GetPvpRatingLink(opvp.player.name());
end

function opvp.hyperlink.createTradeSkill(guid, spellId, skillLineId, text)
    return string.format(
        "|Htrade:%s:%d:%d|h[%s]|h",
        guid,
        spellId,
        skillLineId,
        text
    );
end

function opvp.hyperlink.createTransmogAppearance(itemId, text)
    return string.format(
        "|Htransmogappearance:%d|h[%s]|h",
        sourceId,
        text
    );
end

function opvp.hyperlink.createTransmogIllusion(sourceId, text)
    return string.format(
        "|Htransmogillusion:%d|h[%s]|h",
        sourceId,
        text
    );
end

function opvp.hyperlink.createUnit(guid, name)
    return string.format(
        "|Hunit:%s:%s|h[%s]|h",
        guid,
        name,
        name
    );
end

local opvp_hyperlink_tooltip_singleton;

function opvp.private.hyperlinkTooltipWidget()
    if opvp_hyperlink_tooltip_singleton ~= nil then
        return opvp_hyperlink_tooltip_singleton;
    end

    local tooltip = CreateFrame("GameTooltip", "OpenPvpHypelinkTooltip", UIParent, "GameTooltipTemplate")
    local button  = CreateFrame("Button", nil, tooltip, "UIPanelCloseButtonNoScripts");

    tooltip.textLeft1Font  = CreateFont("GameTooltipHeaderText");
    tooltip.textLeft2Font  = CreateFont("GameTooltipText");
    tooltip.textRight1Font = CreateFont("GameTooltipHeaderText");
    tooltip.textRight2Font = CreateFont("GameTooltipText");

    tooltip.TextLeft1:SetFontObject(tooltip.textLeft1Font);
    tooltip.TextLeft2:SetFontObject(tooltip.textLeft2Font);
    tooltip.TextRight1:SetFontObject(tooltip.textRight1Font);
    tooltip.TextRight2:SetFontObject(tooltip.textRight2Font);

    --~ tooltip.TextLeft1:SetFontObject(CreateFont("GameTooltipHeaderText"));
    --~ tooltip.TextLeft2:SetFontObject(CreateFont("GameTooltipText"));
    --~ tooltip.TextRight1:SetFontObject(CreateFont("GameTooltipHeaderText"));
    --~ tooltip.TextRight2:SetFontObject(CreateFont("GameTooltipText"));

    button:SetPoint("TOPRIGHT", 2, 2);

    tooltip.close_button = button;

    opvp_hyperlink_tooltip_singleton = tooltip;

    return opvp_hyperlink_tooltip_singleton;
end
