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

opvp.Emote.HELLO = opvp.Emote(
    {
        id     = opvp.EmoteId.HELLO,
        name   = "hello",
        sounds = {
            { --~ BLOOD_ELF
                female_id   = 9635,
                male_id     = 9662
            },
            { --~ DARK_IRON_DWARF
                female_id   = 101886,
                male_id     = 101960
            },
            { --~ DRACTHYR
                female_id   = 212775,
                male_id     = 212501
            },
            { --~ DRAENEI
                female_id   = 9687,
                male_id     = 9712
            },
            { --~ DWARF
                female_id   = 6094,
                male_id     = 6107
            },
            { --~ EARTHEN
                female_id   = 262352,
                male_id     = 262427
            },
            { --~ GNOME
                female_id   = 6116,
                male_id     = 6125
            },
            { --~ GOBLIN
                female_id   = 19244,
                male_id     = 19135
            },
            { --~ HIGHMOUNTAIN_TAUREN
                female_id   = 95541,
                male_id     = 95841
            },
            { --~ HUMAN
                female_id   = 6134,
                male_id     = 6162
            },
            { --~ KUL_TIRAN
                female_id   = 127035,
                male_id     = 127129
            },
            { --~ LIGHTFORGED_DRAENEI
                female_id   = 96177,
                male_id     = 96245
            },
            { --~ MAGHAR_ORC
                female_id   = 110322,
                male_id     = 110397
            },
            { --~ MECHAGNOME
                female_id   = 144273,
                male_id     = 143890
            },
            { --~ NIGHT_ELF
                female_id   = 6171,
                male_id     = 6180
            },
            { --~ NIGHTBORNE
                female_id   = 96313,
                male_id     = 96381
            },
            { --~ ORC
                female_id   = 6351,
                male_id     = 6360
            },
            { --~ PANDAREN
                female_id   = 29807,
                male_id     = 28920
            },
            { --~ TAUREN
                female_id   = 6369,
                male_id     = 6378
            },
            { --~ TROLL
                female_id   = 6387,
                male_id     = 6396
            },
            { --~ UNDEAD
                female_id   = 6405,
                male_id     = 6414
            },
            { --~ VOID_ELF
                female_id   = 95855,
                male_id     = 95663
            },
            { --~ VULPERA
                female_id   = 144017,
                male_id     = 144109
            },
            { --~ WORGEN
                female_id   = 19434,
                male_id     = 19343
            },
            { --~ ZANDALARI_TROLL
                female_id   = 126942,
                male_id     = 127316
            }
        }
    }
);

table.insert(opvp.Emote.EMOTES, opvp.Emote.HELLO);
