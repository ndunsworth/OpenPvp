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

opvp.Emote.WHOA = opvp.Emote(
    {
        id     = opvp.EmoteId.WHOA,
        name   = "whoa",
        sounds = {
            { --~ BLOOD_ELF
                female_id   = 67794,
                male_id     = 67799
            },
            { --~ DARK_IRON_DWARF
                female_id   = 101905,
                male_id     = 101979
            },
            { --~ DRACTHYR
                female_id   = 212797,
                male_id     = 212618
            },
            { --~ DRAENEI
                female_id   = 67804,
                male_id     = 67809
            },
            { --~ DWARF
                female_id   = 77018,
                male_id     = 77009
            },
            { --~ EARTHEN
                female_id   = 262372,
                male_id     = 262447
            },
            { --~ GNOME
                female_id   = 67814,
                male_id     = 77027
            },
            { --~ GOBLIN
                female_id   = 67819,
                male_id     = 67824
            },
            { --~ HIGHMOUNTAIN_TAUREN
                female_id   = 112561,
                male_id     = 115397
            },
            { --~ HUMAN
                female_id   = 67829,
                male_id     = 67834
            },
            { --~ KUL_TIRAN
                female_id   = 127055,
                male_id     = 127149
            },
            { --~ LIGHTFORGED_DRAENEI
                female_id   = 100898,
                male_id     = 67809
            },
            { --~ MAGHAR_ORC
                female_id   = 110342,
                male_id     = 110417
            },
            { --~ MECHAGNOME
                female_id   = 144293,
                male_id     = 143910
            },
            { --~ NIGHT_ELF
                female_id   = 67839,
                male_id     = 76961
            },
            { --~ NIGHTBORNE
                female_id   = 67839,
                male_id     = 76961
            },
            { --~ ORC
                female_id   = 67844,
                male_id     = 67849
            },
            { --~ PANDAREN
                female_id   = 67854,
                male_id     = 67859
            },
            { --~ TAUREN
                female_id   = 67864,
                male_id     = 67869
            },
            { --~ TROLL
                female_id   = 67874,
                male_id     = 76991
            },
            { --~ UNDEAD
                female_id   = 67879,
                male_id     = 67884
            },
            { --~ VOID_ELF
                female_id   = 67794,
                male_id     = 122859
            },
            { --~ VULPERA
                female_id   = 144034,
                male_id     = 144037
            },
            { --~ WORGEN
                female_id   = 144037,
                male_id     = 144129
            },
            { --~ ZANDALARI_TROLL
                female_id   = 67889,
                male_id     = 67894
            }
        }
    }
);

table.insert(opvp.Emote.EMOTES, opvp.Emote.WHOA);
