---Load a scaleform movie. When called from a thread, it will yield until it has loaded.
---@param time number? time in seconds for timer bar to run.
---@param text Title of the timer bar.
---@param cb Callback to run when finished.
function lib.timerBar(time, text, cb)
    RequestStreamedTextureDict('timerbars', true)
    while not HasStreamedTextureDictLoaded('timerbars') do
        Citizen.Wait(50)
    end
    timer = true
    percent = 1700
    width = 0.005
    w = width * (percent / 100)
    x = (0.95 - (width * (percent / 100)) / 2) - width / 2
    while timer do
        percent = percent - (1700 / (time * 100))
        width = 0.005
        w = width * (percent / 100)
        x = (0.91 - (width * (percent / 100)) / 2) - width / 2
        DrawSprite('TimerBars', 'ALL_BLACK_bg', 0.95, 0.95, 0.15, 0.0305, 0.0, 255, 255, 255, 180)
        DrawRect(0.95, 0.95, 0.085, 0.0109, 100, 0, 0, 180)
        DrawRect(x + w, 0.95, w, 0.0109, 150, 0, 0, 255)
        SetTextColour(255, 255, 255, 180)
        SetTextFont(0)
        SetTextScale(0.3, 0.3)
        SetTextCentre(true)
        SetTextEntry('STRING')
        AddTextComponentString(text)
        DrawText(0.878, 0.938)
        if percent <= 0 then
            cb(true)
            break
        end
        Wait(0)
    end
    SetStreamedTextureDictAsNoLongerNeeded('timerbars')
end

return lib.timerBar
