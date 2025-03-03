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

opvp.Emote.GOODBYE = opvp.Emote(
    {
        id     = opvp.EmoteId.GOODBYE,
        name   = "goodbye",
        sounds = {
            { --~ BLOOD_ELF
                female_id   = 9636,
                male_id     = 9654
            },
            { --~ DARK_IRON_DWARF
                female_id   = 101884,
                male_id     = 101958
            },
            { --~ DRACTHYR
                female_id   = 212773,
                male_id     = 212499
            },
            { --~ DRAENEI
                female_id   = 9679,
                male_id     = 9704
            },
            { --~ DWARF
                female_id   = 6095,
                male_id     = 6108
            },
            { --~ EARTHEN
                female_id   = 262350,
                male_id     = 262425
            },
            { --~ GNOME
                female_id   = 6117,
                male_id     = 6126
            },
            { --~ GOBLIN
                female_id   = 19242,
                male_id     = 19133
            },
            { --~ HIGHMOUNTAIN_TAUREN
                female_id   = 95539,
                male_id     = 95836
            },
            { --~ HUMAN
                female_id   = 6135,
                male_id     = 6163
            },
            { --~ KUL_TIRAN
                female_id   = 127033,
                male_id     = 127127
            },
            { --~ LIGHTFORGED_DRAENEI
                female_id   = 96175,
                male_id     = 96243
            },
            { --~ MAGHAR_ORC
                female_id   = 110320,
                male_id     = 110395
            },
            { --~ MECHAGNOME
                female_id   = 144271,
                male_id     = 143888
            },
            { --~ NIGHT_ELF
                female_id   = 6172,
                male_id     = 6181
            },
            { --~ NIGHTBORNE
                female_id   = 96311,
                male_id     = 96379
            },
            { --~ ORC
                female_id   = 6352,
                male_id     = 6361
            },
            { --~ PANDAREN
                female_id   = 29802,
                male_id     = 28917
            },
            { --~ TAUREN
                female_id   = 6370,
                male_id     = 6379
            },
            { --~ TROLL
                female_id   = 6388,
                male_id     = 6397
            },
            { --~ UNDEAD
                female_id   = 6406,
                male_id     = 6415
            },
            { --~ VOID_ELF
                female_id   = 95850,
                male_id     = 95661
            },
            { --~ VULPERA
                female_id   = 144015,
                male_id     = 144107
            },
            { --~ WORGEN
                female_id   = 19431,
                male_id     = 19340
            },
            { --~ ZANDALARI_TROLL
                female_id   = 126940,
                male_id     = 127314
            }
        }
    }
);

table.insert(opvp.Emote.EMOTES, opvp.Emote.GOODBYE);
