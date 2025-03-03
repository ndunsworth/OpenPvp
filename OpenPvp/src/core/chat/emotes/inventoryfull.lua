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

opvp.Emote.INVENTORY_FULL = opvp.Emote(
    {
        id     = opvp.EmoteId.INVENTORY_FULL,
        name   = "inventoryfull",
        sounds = {
            { --~ BLOOD_ELF
                female_id   = 9550,
                male_id     = 9549
            },
            { --~ DARK_IRON_DWARF
                female_id   = 101862,
                male_id     = 101936
            },
            { --~ DRACTHYR
                female_id   = 212736,
                male_id     = 212464
            },
            { --~ DRAENEI
                female_id   = 9466,
                male_id     = 9465
            },
            { --~ DWARF
                female_id   = 1654,
                male_id     = 1581
            },
            { --~ EARTHEN
                female_id   = 262315,
                male_id     = 262391
            },
            { --~ GNOME
                female_id   = 1709,
                male_id     = 1708
            },
            { --~ GOBLIN
                female_id   = 19221,
                male_id     = 19112
            },
            { --~ HIGHMOUNTAIN_TAUREN
                female_id   = 95513,
                male_id     = 95934
            },
            { --~ HUMAN
                female_id   = 1999,
                male_id     = 1875
            },
            { --~ KUL_TIRAN
                female_id   = 127011,
                male_id     = 127105
            },
            { --~ LIGHTFORGED_DRAENEI
                female_id   = 96155,
                male_id     = 96223
            },
            { --~ MAGHAR_ORC
                female_id   = 110298,
                male_id     = 110373
            },
            { --~ MECHAGNOME
                female_id   = 144226,
                male_id     = 143866
            },
            { --~ NIGHT_ELF
                female_id   = 2229,
                male_id     = 2118
            },
            { --~ NIGHTBORNE
                female_id   = 96291,
                male_id     = 96359
            },
            { --~ ORC
                female_id   = 2341,
                male_id     = 2284
            },
            { --~ PANDAREN
                female_id   = 29902,
                male_id     = 28849
            },
            { --~ TAUREN
                female_id   = 2397,
                male_id     = 2396
            },
            { --~ TROLL
                female_id   = 1930,
                male_id     = 1820
            },
            { --~ UNDEAD
                female_id   = 2173,
                male_id     = 2054
            },
            { --~ VOID_ELF
                female_id   = 95809,
                male_id     = 95639
            },
            { --~ VULPERA
                female_id   = 143984,
                male_id     = 144076
            },
            { --~ WORGEN
                female_id   = 19400,
                male_id     = 19319
            },
            { --~ ZANDALARI_TROLL
                female_id   = 126918,
                male_id     = 127292
            }
        }
    }
);

table.insert(opvp.Emote.EMOTES, opvp.Emote.INVENTORY_FULL);
