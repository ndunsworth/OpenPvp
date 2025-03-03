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

opvp.Emote.OOPS = opvp.Emote(
    {
        id     = opvp.EmoteId.OOPS,
        name   = "oops",
        sounds = {
            { --~ BLOOD_ELF
                female_id   = 67790,
                male_id     = 67795
            },
            { --~ DARK_IRON_DWARF
                female_id   = 101893,
                male_id     = 101967
            },
            { --~ DRACTHYR
                female_id   = 212783,
                male_id     = 212508
            },
            { --~ DRAENEI
                female_id   = 67800,
                male_id     = 67805
            },
            { --~ DWARF
                female_id   = 77014,
                male_id     = 77005
            },
            { --~ EARTHEN
                female_id   = 243959,
                male_id     = 262433
            },
            { --~ GNOME
                female_id   = 67810,
                male_id     = 77023
            },
            { --~ GOBLIN
                female_id   = 67815,
                male_id     = 67820
            },
            { --~ HIGHMOUNTAIN_TAUREN
                female_id   = 112557,
                male_id     = 115393
            },
            { --~ HUMAN
                female_id   = 67825,
                male_id     = 67830
            },
            { --~ KUL_TIRAN
                female_id   = 127042,
                male_id     = 127136
            },
            { --~ LIGHTFORGED_DRAENEI
                female_id   = 100894,
                male_id     = 67805
            },
            { --~ MAGHAR_ORC
                female_id   = 110329,
                male_id     = 110404
            },
            { --~ MECHAGNOME
                female_id   = 144280,
                male_id     = 143897
            },
            { --~ NIGHT_ELF
                female_id   = 67835,
                male_id     = 76957
            },
            { --~ NIGHTBORNE
                female_id   = 96453,
                male_id     = 96399
            },
            { --~ ORC
                female_id   = 67840,
                male_id     = 67845
            },
            { --~ PANDAREN
                female_id   = 67850,
                male_id     = 67855
            },
            { --~ TAUREN
                female_id   = 67860,
                male_id     = 67865
            },
            { --~ TROLL
                female_id   = 67870,
                male_id     = 76987
            },
            { --~ UNDEAD
                female_id   = 67875,
                male_id     = 67880
            },
            { --~ VOID_ELF
                female_id   = 95886,
                male_id     = 122855
            },
            { --~ VULPERA
                female_id   = 144024,
                male_id     = 144116
            },
            { --~ WORGEN
                female_id   = 67885,
                male_id     = 67890
            },
            { --~ ZANDALARI_TROLL
                female_id   = 126949,
                male_id     = 127323
            }
        }
    }
);

table.insert(opvp.Emote.EMOTES, opvp.Emote.OOPS);
