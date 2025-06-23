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

local opvp_calendar_pvp_event_ids = opvp.List:createFromArray(
    {
         561, -- Arena Skirmish Bonus Event
         563, -- Battleground Bonus Event
         666, -- PvP Brawl: Arathi Blizzard
        1452, -- PvP Brawl: Battleground Blitz
        1120, -- PvP Brawl: Classic Ashran
        1235, -- PvP Brawl: Comp Stomp
        1047, -- PvP Brawl: Cooking Impossible
         702, -- PvP Brawl: Deep Six
        1240, -- PvP Brawl: Deepwind Dunk
         663, -- PvP Brawl: Gravity Lapse
         667, -- PvP Brawl: Packed House
        1233, -- PvP Brawl: Shado-Pan Showdown
        1311, -- PvP Brawl: Solo Shuffle
         662, -- PvP Brawl: Southshore vs. Tarren Mill
        1170, -- PvP Brawl: Temple of Hotmogu
         664  -- PvP Brawl: Warsong Scramble
    }
);

opvp.calendar = {};

function opvp.calendar.findPvpEvents(refTime)
    local cal_state = C_Calendar.GetMonthInfo();

    C_Calendar.SetAbsMonth(refTime.month, refTime.year);

    local events       = {};
    local events_size  = C_Calendar.GetNumDayEvents(0, refTime.monthDay);

    if events_size == 0 then
        C_Calendar.SetAbsMonth(cal_state.month, cal_state.year);

        return events;
    end

    refTime.day = refTime.monthDay;

    local event_info;

    for n=1, events_size do
        event_info = C_Calendar.GetDayEvent(0, refTime.monthDay, n);

        if (
            event_info ~= nil and (
                event_info.eventType == Enum.CalendarEventType.PvP or
                opvp_calendar_pvp_event_ids:contains(event_info.eventID) == true
            )
        ) then
            event_info.startTime.day = event_info.startTime.monthDay;
            event_info.endTime.day   = event_info.endTime.monthDay;

            if time(event_info.endTime) > time(refTime) then
                table.insert(events, event_info);
            end
        end
    end

    C_Calendar.SetAbsMonth(cal_state.month, cal_state.year);

    return events;
end
