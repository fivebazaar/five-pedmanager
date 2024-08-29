function GetWeather()
    if GetResourceState('Renewed-Weathersync') == 'started' then
        return GlobalState.weather.weather
    elseif GetResourceState('qb-weathersync') == 'started' then
        return exports['qb-weathersync']:getweather()
    end
end