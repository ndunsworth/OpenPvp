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

opvp.Emote.DEFEAT = opvp.Emote(
    {
        id     = opvp.EmoteId.DEFEAT,
        name   = "defeat",
        sounds = {
            { --~ BLOOD_ELF
                female_id   = 0000,
                male_id     = 0000
            },
            { --~ DARK_IRON_DWARF
                female_id   = 101487,
                male_id     = 101502
            },
            { --~ DRACTHYR
                female_id   = 212727,
                male_id     = 212453
            },
            { --~ DRAENEI
                female_id   = 0000,
                male_id     = 0000
            },
            { --~ DWARF
                female_id   = 0000,
                male_id     = 0000
            },
            { --~ EARTHEN
                female_id   = 0000,
                male_id     = 0000
            },
            { --~ GNOME
                female_id   = 0000,
                male_id     = 0000
            },
            { --~ GOBLIN
                female_id   = 0000,
                male_id     = 0000
            },
            { --~ HIGHMOUNTAIN_TAUREN
                female_id   = 0000,
                male_id     = 0000
            },
            { --~ HUMAN
                female_id   = 0000,
                male_id     = 0000
            },
            { --~ KUL_TIRAN
                female_id   = 127073,
                male_id     = 127169
            },
            { --~ LIGHTFORGED_DRAENEI
                female_id = {
                    {data=1835545, sound_type=opvp.SoundType.FileData},
                    {data=1835546, sound_type=opvp.SoundType.FileData},
                    {data=1835547, sound_type=opvp.SoundType.FileData}
                },
                female_id_type = opvp.SoundType.Synthetic,
                male_id = {
                    {data=1835640, sound_type=opvp.SoundType.FileData},
                    {data=1835642, sound_type=opvp.SoundType.FileData},
                    {data=1835643, sound_type=opvp.SoundType.FileData}
                },
                male_id_type = opvp.SoundType.Synthetic
            },
            { --~ MAGHAR_ORC
                female_id   = 110558,
                male_id     = 0000
            },
            { --~ MECHAGNOME
                female_id   = 144190,
                male_id     = 143792
            },
            { --~ NIGHT_ELF
                female_id   = 0000,
                male_id     = 0000
            },
            { --~ NIGHTBORNE
                female_id   = 0000,
                male_id     = 0000
            },
            { --~ ORC
                female_id   = 0000,
                male_id     = 0000
            },
            { --~ PANDAREN
                female_id   = 0000,
                male_id     = 0000
            },
            { --~ TAUREN
                female_id   = 0000,
                male_id     = 0000
            },
            { --~ TROLL
                female_id   = 0000,
                male_id     = 0000
            },
            { --~ UNDEAD
                female_id   = 0000,
                male_id     = 0000
            },
            { --~ VOID_ELF
                female_id = {
                    {data=1835947, sound_type=opvp.SoundType.FileData},
                    {data=1835948, sound_type=opvp.SoundType.FileData},
                    {data=1835949, sound_type=opvp.SoundType.FileData}
                },
                female_id_type = opvp.SoundType.Synthetic,
                male_id = {
                    {data=1836049, sound_type=opvp.SoundType.FileData},
                    {data=1836050, sound_type=opvp.SoundType.FileData},
                    {data=1836051, sound_type=opvp.SoundType.FileData}
                },
                male_id_type = opvp.SoundType.Synthetic
            },
            { --~ VULPERA
                female_id   = 143954,
                male_id     = 144046
            },
            { --~ WORGEN
                female_id   = 0000,
                male_id     = 0000
            },
            { --~ ZANDALARI_TROLL
                female_id   = 126976,
                male_id     = 127347
            }
        }
    }
);

table.insert(opvp.Emote.EMOTES, opvp.Emote.DEFEAT);
