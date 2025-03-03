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

opvp.Emote.VICTORY = opvp.Emote(
    {
        id   = opvp.EmoteId.VICTORY,
        name = "victory",
        sounds = {
            { --~ BLOOD_ELF
                female_id   = 9632, --~ missing
                male_id     = 9656 --~ missing
            },
            { --~ DARK_IRON_DWARF
                female_id   = 101492,
                male_id     = 101510
            },
            { --~ DRACTHYR
                female_id   = 212795,
                male_id     = 212520
            },
            { --~ DRAENEI
                female_id   = 9681, --~ missing
                male_id     = 9706 --~ missing
            },
            { --~ DWARF
                female_id   = 2737, --~ missing
                male_id     = 2725 --~ missing
            },
            { --~ EARTHEN
                female_id   = 262302, --~ missing
                male_id     = 262379 --~ missing
            },
            { --~ GNOME
                female_id   = 2847, --~ missing
                male_id     = 2835 --~ missing
            },
            { --~ GOBLIN
                female_id   = 19202, --~ missing
                male_id     = 19089 --~ missing
            },
            { --~ HIGHMOUNTAIN_TAUREN
                female_id = {
                    {id=1835409, sound_type=opvp.SoundType.FileData}
                },
                female_id_type = opvp.SoundType.Synthetic,
                male_id = {
                    {id=1835484, sound_type=opvp.SoundType.FileData}
                },
                male_id_type = opvp.SoundType.Synthetic
            },
            { --~ HUMAN
                female_id = 2689, --~ missing
                male_id   = 2677 --~ missing
            },
            { --~ KUL_TIRAN
                female_id = 127072,
                male_id   = 127168
            },
            { --~ LIGHTFORGED_DRAENEI
                female_id = {
                    {id=1835571, sound_type=opvp.SoundType.FileData},
                    {id=1835572, sound_type=opvp.SoundType.FileData},
                    {id=1835573, sound_type=opvp.SoundType.FileData}
                },
                female_id_type = opvp.SoundType.Synthetic,
                male_id = {
                    {id=1835668, sound_type=opvp.SoundType.FileData},
                    {id=1835669, sound_type=opvp.SoundType.FileData},
                    {id=1835670, sound_type=opvp.SoundType.FileData}
                },
                male_id_type = opvp.SoundType.Synthetic
            },
            { --~ MAGHAR_ORC
                female_id = 110563,
                male_id   = 110538
            },
            { --~ MECHAGNOME
                female_id = 144196,
                male_id   = 143799
            },
            { --~ NIGHT_ELF
                female_id = 2761, --~ missing
                male_id   = 2749 --~ missing
            },
            { --~ NIGHTBORNE
                female_id = {
                    {id=1835766, sound_type=opvp.SoundType.FileData},
                    {id=1835767, sound_type=opvp.SoundType.FileData},
                    {id=1835768, sound_type=opvp.SoundType.FileData},
                    {id=1835874, sound_type=opvp.SoundType.FileData}
                },
                female_id_type = opvp.SoundType.Synthetic,
                male_id = {
                    {id=1835870, sound_type=opvp.SoundType.FileData},
                    {id=1835872, sound_type=opvp.SoundType.FileData},
                    {id=1835873, sound_type=opvp.SoundType.FileData},
                    {id=1835874, sound_type=opvp.SoundType.FileData}
                },
                male_id_type = opvp.SoundType.Synthetic
            },
            { --~ ORC
                female_id   = 2713, --~ missing
                male_id     = 2701 --~ missing
            },
            { --~ PANDAREN
                female_id   = 29791, --~ missing
                male_id     = 28926 --~ missing
            },
            { --~ TAUREN
                female_id   = 2810, --~ missing
                male_id     = 2797 --~ missing
            },
            { --~ TROLL
                female_id   = 2871, --~ missing
                male_id     = 2859 --~ missing
            },
            { --~ UNDEAD
                female_id   = 2785, --~ missing
                male_id     = 2773 --~ missing
            },
            { --~ VOID_ELF
                female_id = {
                    {id=1835972, sound_type=opvp.SoundType.FileData},
                    {id=1835973, sound_type=opvp.SoundType.FileData},
                    {id=1835974, sound_type=opvp.SoundType.FileData},
                    {id=1835975, sound_type=opvp.SoundType.FileData}
                },
                female_id_type = opvp.SoundType.Synthetic,
                male_id = {
                    {id=1836080, sound_type=opvp.SoundType.FileData},
                    {id=1836081, sound_type=opvp.SoundType.FileData},
                    {id=1836082, sound_type=opvp.SoundType.FileData}
                },
                male_id_type = opvp.SoundType.Synthetic
            },
            { --~ VULPERA
                female_id = 143960,
                male_id   = 144052
            },
            { --~ WORGEN
                female_id = 19517, --~ missing
                male_id   = 19297 --~ missing
            },
            { --~ ZANDALARI_TROLL
                female_id = 126981,
                male_id   = 127352
            }
        }
    }
);

table.insert(opvp.Emote.EMOTES, opvp.Emote.VICTORY);
