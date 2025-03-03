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

opvp.Emote.FOLLOW_ME = opvp.Emote(
    {
        id     = opvp.EmoteId.FOLLOW_ME,
        name   = "followme",
        sounds = {
            { --~ BLOOD_ELF
                female_id   = 9629,
                male_id     = 9660
            },
            { --~ DARK_IRON_DWARF
                female_id   = 101882,
                male_id     = 101956
            },
            { --~ DRACTHYR
                female_id   = 212770,
                male_id     = 212496
            },
            { --~ DRAENEI
                female_id   = 9685,
                male_id     = 9710
            },
            { --~ DWARF
                female_id   = 2734,
                male_id     = 2722
            },
            { --~ EARTHEN
                female_id   = 262347,
                male_id     = 262422
            },
            { --~ GNOME
                female_id   = 2844,
                male_id     = 2832
            },
            { --~ GOBLIN
                female_id   = 19241,
                male_id     = 19132
            },
            { --~ HIGHMOUNTAIN_TAUREN
                female_id   = 95537,
                male_id     = 95833
            },
            { --~ HUMAN
                female_id   = 2686,
                male_id     = 2674
            },
            { --~ KUL_TIRAN
                female_id   = 127031,
                male_id     = 127125
            },
            { --~ LIGHTFORGED_DRAENEI
                female_id   = 96173,
                male_id     = 96241
            },
            { --~ MAGHAR_ORC
                female_id   = 110318,
                male_id     = 110393
            },
            { --~ MECHAGNOME
                female_id   = 144269,
                male_id     = 143886
            },
            { --~ NIGHT_ELF
                female_id   = 2758,
                male_id     = 2746
            },
            { --~ NIGHTBORNE
                female_id   = 96309,
                male_id     = 96377
            },
            { --~ ORC
                female_id   = 2710,
                male_id     = 2698
            },
            { --~ PANDAREN
                female_id   = 29800,
                male_id     = 28916
            },
            { --~ TAUREN
                female_id   = 2807,
                male_id     = 2794
            },
            { --~ TROLL
                female_id   = 2868,
                male_id     = 2856
            },
            { --~ UNDEAD
                female_id   = 2782,
                male_id     = 2770
            },
            { --~ VOID_ELF
                female_id   = 95847,
                male_id     = 95659
            },
            { --~ VULPERA
                female_id   = 144013,
                male_id     = 144105
            },
            { --~ WORGEN
                female_id   = 19429,
                male_id     = 19339
            },
            { --~ ZANDALARI_TROLL
                female_id   = 126938,
                male_id     = 127312
            }
        }
    }
);

table.insert(opvp.Emote.EMOTES, opvp.Emote.FOLLOW_ME);
