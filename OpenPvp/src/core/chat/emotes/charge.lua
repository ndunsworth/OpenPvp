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

opvp.Emote.CHARGE = opvp.Emote(
    {
        id     = opvp.EmoteId.CHARGE,
        name   = "charge",
        sounds = {
            { --~ BLOOD_ELF
                female_id   = 9625,
                male_id     = 9655
            },
            { --~ DARK_IRON_DWARF
                female_id   = 101837,
                male_id     = 101911
            },
            { --~ DRACTHYR
                female_id   = 212721,
                male_id     = 212445
            },
            { --~ DRAENEI
                female_id   = 9680,
                male_id     = 9705
            },
            { --~ DWARF
                female_id   = 2730,
                male_id     = 2718
            },
            { --~ EARTHEN
                female_id   = 262301,
                male_id     = 262378
            },
            { --~ GNOME
                female_id   = 2840,
                male_id     = 2828
            },
            { --~ GOBLIN
                female_id   = 19198,
                male_id     = 19088
            },
            { --~ HIGHMOUNTAIN_TAUREN
                female_id   = 95533,
                male_id     = 95889
            },
            { --~ HUMAN
                female_id   = 2682,
                male_id     = 2670
            },
            { --~ KUL_TIRAN
                female_id   = 126986,
                male_id     = 127080
            },
            { --~ LIGHTFORGED_DRAENEI
                female_id   = 96133,
                male_id     = 96201
            },
            { --~ MAGHAR_ORC
                female_id   = 110273,
                male_id     = 110348
            },
            { --~ MECHAGNOME
                female_id   = 144262,
                male_id     = 143841
            },
            { --~ NIGHT_ELF
                female_id = {
                    {data=541023, sound_type=opvp.SoundType.FileData},
                    {data=541025, sound_type=opvp.SoundType.FileData},
                    {data=541026, sound_type=opvp.SoundType.FileData}
                },
                female_id_type = opvp.SoundType.Synthetic,
                male_id     = 2742
            },
            { --~ NIGHTBORNE
                female_id   = 96269,
                male_id     = 96337
            },
            { --~ ORC
                female_id   = 2706,
                male_id     = 2694
            },
            { --~ PANDAREN
                female_id   = 29789,
                male_id     = 28923
            },
            { --~ TAUREN
                female_id   = 2803,
                male_id     = 2790
            },
            { --~ TROLL
                female_id = {
                    {data=543254, sound_type=opvp.SoundType.FileData},
                    {data=543266, sound_type=opvp.SoundType.FileData}
                },
                female_id_type = opvp.SoundType.Synthetic,
                male_id     = 2852
            },
            { --~ UNDEAD
                female_id   = 2778,
                male_id     = 2766
            },
            { --~ VOID_ELF
                female_id   = 95838,
                male_id     = 95617
            },
            { --~ VULPERA
                female_id   = 144006,
                male_id     = 144098
            },
            { --~ WORGEN
                female_id   = 19373,
                male_id     = 19296
            },
            { --~ ZANDALARI_TROLL
                female_id   = 126893,
                male_id     = 127267
            }
        }
    }
);

table.insert(opvp.Emote.EMOTES, opvp.Emote.CHARGE);
