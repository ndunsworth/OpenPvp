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

opvp.Emote.BATTLESHOUT = opvp.Emote(
    {
        id     = opvp.EmoteId.BATTLESHOUT,
        name   = "battleshout",
        sounds = {
            { --~ BLOOD_ELF
                female_id   = 62470,
                male_id     = 62474
            },
            { --~ DARK_IRON_DWARF
                female_id   = 101481,
                male_id     = 101497
            },
            { --~ DRACTHYR
                female_id   = 212717,
                male_id     = 212527
            },
            { --~ DRAENEI
                female_id   = 62478,
                male_id     = 62482
            },
            { --~ DWARF
                female_id   = 77019,
                male_id     = 77010
            },
            { --~ EARTHEN
                female_id   = 258496,
                male_id     = 258488
            },
            { --~ GNOME
                female_id   = 62486,
                male_id     = 77028
            },
            { --~ GOBLIN
                female_id   = 62490,
                male_id     = 256154
            },
            { --~ HIGHMOUNTAIN_TAUREN
                female_id   = 95485,
                male_id     = 95699
            },
            { --~ HUMAN
                female_id   = 256095,
                male_id     = 232997
            },
            { --~ KUL_TIRAN
                female_id   = 108096,
                male_id     = 108102
            },
            { --~ LIGHTFORGED_DRAENEI
                female_id   = 95717,
                male_id     = 95735
            },
            { --~ MAGHAR_ORC
                female_id   = 110552,
                male_id     = 110527
            },
            { --~ MECHAGNOME
                female_id   = 144186,
                male_id     = 143789
            },
            { --~ NIGHT_ELF
                female_id   = 62498,
                male_id     = 76962
            },
            { --~ NIGHTBORNE
                female_id   = 95756,
                male_id     = 95771
            },
            { --~ ORC
                female_id   = 62502,
                male_id     = 62506
            },
            { --~ PANDAREN
                female_id   = 62510,
                male_id     = 62514
            },
            { --~ TAUREN
                female_id   = 62518,
                male_id     = 74677
            },
            { --~ TROLL
                female_id   = 232217,
                male_id     = 76992
            },
            { --~ UNDEAD
                female_id   = 62522,
                male_id     = 62526
            },
            { --~ VOID_ELF
                female_id   = 95614,
                male_id     = 95613
            },
            { --~ VULPERA
                female_id   = 115247,
                male_id     = 115238
            },
            { --~ WORGEN
                female_id   = 74683,
                male_id     = 74688
            },
            { --~ ZANDALARI_TROLL
                female_id   = 126969,
                male_id     = 127341
            }
        }
    }
);

table.insert(opvp.Emote.EMOTES, opvp.Emote.BATTLESHOUT);
