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

function opvp.private.hyperlink.createPartyMemberSpellInterrupted(
    member,
    sourceName,
    sourceGUID,
    spellId,
    spellName,
    spellSchool,
    extraSpellId,
    extraSpellName,
    extraSpellSchool,
    castLength,
    castProgress
)
    return string.format(
        "%s%s|r",
        LINK_FONT_COLOR:GenerateHexColorMarkup(),
        opvp.CallbackHyperlinkProcessor:instance():createLink(
            opvp.private.HyperlinkId.PARTY_MEMBER_CC,
            string.format(
                "[%s - %s]",
                ccCategoryState:categoryName(),
                ccCategoryState:drName()
            ),
            {
                source            = sourceName,
                source_spell      = spellId,
                destination       = member:nameOrId(),
                destination_spell = extraSpellId,
                cast_length       = castLength,
                cast_progress     = castProgress
                cast_school       = extraSpellSchool
            }
        )
    );
end

function opvp.private.hyperlink.handlePartyMemberSpellInterrupted(id, data, chatFrame, button)
    local tooltip = opvp.private.hyperlinkTooltipWidget();

    local cc_cat = opvp.CrowdControlCategory:fromType(data.category);

    tooltip:SetOwner(UIParent, "ANCHOR_CURSOR");

    tooltip:AddLine(data.destination .. " - Crowd Control", 1, 1, 1);

    tooltip:AddLine(" ");

    tooltip:AddDoubleLine(
        "Category",
        cc_cat:name()
    );

    tooltip:AddDoubleLine(
        "DR",
        cc_cat:nameForStatus(data.dr)
    );

    tooltip:AddDoubleLine(
        "Duration",
        string.format(
            "%0.1f Secs",
            data.duration
        )
    );

    tooltip:AddDoubleLine(
        "Dispell Type",
        opvp.spell.dispellName(data.dispell)
    );

    tooltip:AddDoubleLine(
        "Source",
        data.source
    );

    tooltip:AddDoubleLine(
        "Spell",
        C_Spell.GetSpellName(data.spell)
    );

    tooltip:Show();
end

local function opvp_init()
    opvp.CallbackHyperlinkProcessor:instance():register(
        opvp.private.HyperlinkId.PARTY_MEMBER_SPELL_INTERRUPTED,
        opvp.private.hyperlink.handlePartyMemberSpellInterrupted
    );
end

opvp.OnAddonLoad:register(opvp_init);
