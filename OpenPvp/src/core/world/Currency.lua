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

local function cmp_currency_obj(a, b)
    return (
        a == b or
        a:id() == b:id()
    );
end

opvp.Currency = opvp.CreateClass();

function opvp.Currency:init(id)
    self._id = id;

    self.changed = opvp.Signal("Currency.changed");

    opvp.CurrencyManager:instance():_addCurrency(self);
end

function opvp.Currency:description()
    return self:info().description;
end

function opvp.Currency:earned()
    return self:info().earned;
end

function opvp.Currency:hasMax()
    return self:info().limit > 0;
end

function opvp.Currency:icon()
    return self:info().icon;
end

function opvp.Currency:id()
    return self._id;
end

function opvp.Currency:info()
    local info = C_CurrencyInfo.GetCurrencyInfo(self._id);

    if info ~= nil then
        return {
            description = info.description,
            earned      = info.totalEarned,
            icon        = info.iconFileID,
            limit       = info.maxQuantity,
            name        = info.name,
            quantity    = info.quantity
        };
    else
        return {
            description = "",
            earned      = 0,
            icon        = 0,
            limit       = 0,
            name        = "",
            quantity    = 0
        };
    end
end

function opvp.Currency:isCapped()
    local info = self:info();

    local free_cur = info.limit - info.quantity;

    return (info.limit > 0 and info.limit == info.quantity);
end

function opvp.Currency:name()
    return self:info().name;
end

function opvp.Currency:quantity()
    return self:info().quantity;
end

function opvp.Currency:quantityMax()
    return self:info().limit;
end

function opvp.Currency:_onUpdate(quantity, quantityChange, quantityGainSource, quantityLostSource)
    self.changed:emit(self, quantity, quantityChange, quantityGainSource, quantityLostSource);
end

local currency_mgr_singleton = nil;

opvp.CurrencyManager = opvp.CreateClass();

function opvp.CurrencyManager:instance()
    if currency_mgr_singleton ~= nil then
        return currency_mgr_singleton;
    end

    currency_mgr_singleton = opvp.CurrencyManager();

    return currency_mgr_singleton;
end

function opvp.CurrencyManager:init(id)
    self._curs         = opvp.List();
    self._alert_bloody = true;
    self._alert_conq   = true;
    self._alert_honor  = true;

    self.changed = opvp.Signal("CurrencyManager.changed");

    opvp.event.CURRENCY_DISPLAY_UPDATE:connect(
        self,
        opvp.CurrencyManager._onUpdate
    );

    opvp.match.exit:connect(self, self._onMatchExit);

    opvp.OnLogin:register(self, self._onLogin);
end

function opvp.CurrencyManager:currency(id)
    local currency;

    for n=1, self._curs:size() do
        currency = self._curs:item(n);

        if currency:id() == id then
            return currency;
        end
    end

    return nil;
end

function opvp.CurrencyManager:_addCurrency(currency)
    if currency == nil or self._curs:contains(currency, cmp_currency_obj) then
        return false;
    end

    self._curs:append(currency);

    opvp.printDebug(
        "Currency - Registered id=%d, name=\"%s\"",
        currency:id(),
        currency:name()
    );

    return true;
end

function opvp.CurrencyManager:_checkBloodyToken()
    if opvp.Currency.BLOODY_TOKEN:isCapped() == true then
        if self._alert_bloody == true then
            self._alert_bloody = false;

            return true;
        end
    else
        self._alert_bloody = true;
    end

    return false;
end

function opvp.CurrencyManager:_checkConquest()
    if opvp.Currency.CONQUEST:isCapped() == true then
        if self._alert_conq == true then
            self._alert_conq = false;

            return true;
        end
    else
        self._alert_conq = true;
    end

    return false;
end

function opvp.CurrencyManager:_checkHonor()
    if opvp.Currency.HONOR:isCapped() == true then
        if self._alert_honor == true then
            self._alert_honor = false;

            return true;
        end
    else
        self._alert_honor = true;
    end

    return false;
end

function opvp.CurrencyManager:_checkPvpCurrencies()
    if (
        opvp.options.announcements.player.pvpCurrencyCapped:value() == false or
        opvp.match.inMatch() == true
    ) then
        return;
    end

    local currencies = {};

    if self:_checkHonor() == true then
        table.insert(
            currencies,
            {opvp.Currency.HONOR:name(), opvp.Currency.HONOR:quantity()}
        );
    end

    if self:_checkBloodyToken() == true then
        table.insert(
            currencies,
            {opvp.Currency.BLOODY_TOKEN:name(), opvp.Currency.BLOODY_TOKEN:quantity()}
        );
    end

    if self:_checkConquest() == true then
        table.insert(
            currencies,
            {opvp.Currency.CONQUEST:name(), opvp.Currency.CONQUEST:quantity()}
        );
    end

    if #currencies == 1 then
        local currency = currencies[1];

        opvp.notify.pvp(
            currency[1] .. " " .. opvp.strs.CAPPED,
            string.format(
                "%d/%d",
                currency[2],
                currency[2]
            )
        );
    elseif #currencies > 1 then
        local msgs = {};
        local currency;

        for n=1, #currencies do
            currency = currencies[n];

            table.insert(
                msgs,
                currency[1]
            );
        end

        opvp.notify.pvp(
            opvp.strs.PVP_CURRENCIES_CAPPED,
            table.concat(msgs, ", w")
        );
    end
end

function opvp.CurrencyManager:_onLogin()
    opvp.OnLoadingScreenEnd:connect(
        function()
            opvp.Timer:singleShot(
                10,
                function()
                    self:_checkPvpCurrencies()
                end
            )
        end
    );
end

function opvp.CurrencyManager:_onMatchExit()
    if opvp.match.isTest() == false then
        opvp.OnLoadingScreenEnd:connect(self, self._checkPvpCurrencies);
    end
end

function opvp.CurrencyManager:_onUpdate(
    id,
    quantity,
    quantityChange,
    quantityGainSource,
    quantityLostSource
)
    local currency = self:currency(id);

    if currency == nil then
        return;
    end

    currency:_onUpdate(quantity, quantityChange, quantityGainSource, quantityLostSource);

    opvp.currency.changed:emit(
        currency,
        quantity,
        quantityChange,
        quantityGainSource,
        quantityLostSource
    );

    self:_checkPvpCurrencies();
end

opvp.currency = {};

opvp.currency.changed = opvp.Signal("opvp.currency.changed");

function opvp.currency.bloodyToken()
    return opvp.Currency.BLOODY_TOKEN:quantity();
end

function opvp.currency.bloodyTokenEarned()
    return opvp.Currency.BLOODY_TOKEN:earned();
end

function opvp.currency.bloodyTokenInfo()
    return opvp.Currency.BLOODY_TOKEN:info();
end

function opvp.currency.bloodyTokenMax()
    return opvp.Currency.BLOODY_TOKEN:quantityMax();
end

function opvp.currency.conquest()
    return opvp.Currency.CONQUEST:quantity();
end

function opvp.currency.conquestEarned()
    return opvp.Currency.CONQUEST:earned();
end

function opvp.currency.conquestInfo()
    return opvp.Currency.CONQUEST:info();
end

function opvp.currency.conquestMax()
    return opvp.Currency.CONQUEST:quantityMax();
end

function opvp.currency.honor()
    return opvp.Currency.HONOR:quantity();
end

function opvp.currency.honorInfo()
    return opvp.Currency.HONOR:info();
end

function opvp.currency.honorMax()
    return opvp.Currency.HONOR:quantityMax();
end

local function opvp_init_currencies()
    opvp.Currency.BLOODY_TOKEN = opvp.Currency(2123);
    opvp.Currency.CONQUEST     = opvp.Currency(Constants.CurrencyConsts.CONQUEST_CURRENCY_ID);
    opvp.Currency.HONOR        = opvp.Currency(Constants.CurrencyConsts.HONOR_CURRENCY_ID);
end

opvp.OnAddonLoad:register(opvp_init_currencies);
