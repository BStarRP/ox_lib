---@alias NotificationPosition 'top' | 'top-right' | 'top-left' | 'bottom' | 'bottom-right' | 'bottom-left' | 'center-right' | 'center-left'
---@alias NotificationType 'info' | 'police' | 'ambulance' | 'warn' | 'success' | 'error'
---@alias IconAnimationType 'spin' | 'spinPulse' | 'spinReverse' | 'pulse' | 'beat' | 'fade' | 'beatFade' | 'bounce' | 'shake'

---@class NotifyProps
---@field id? string
---@field title? string
---@field description? string
---@field duration? number
---@field position? NotificationPosition
---@field type? NotificationType
---@field style? { [string]: any }
---@field icon? string | {[1]: IconProp, [2]: string};
---@field iconAnimation? IconAnimationType;
---@field iconColor? string;
---@field alignIcon? 'top' | 'center';
---@field sound? {bank?: string, set: string, name: string}

local enableSound = GetConvar('ox:enableSound', 'true') == 'true'

---`client`
---@param data NotifyProps
---@diagnostic disable-next-line: duplicate-set-field
function lib.notify(data)
    SendNUIMessage({
        action = 'notify',
        data = data
    })
    if not enableSound then return end
    if data.sound then
        if data.sound?.bank then
            lib.requestAudioBank(data.sound.bank)
        end
        local soundId = GetSoundId()
        PlaySoundFrontend(soundId, data.sound.name, data.sound.set, true)
        ReleaseSoundId(soundId)
        if data.sound?.bank then
            ReleaseNamedScriptAudioBank(data.sound.bank)
        end
    end
end

---@class DefaultNotifyProps
---@field title? string
---@field description? string
---@field duration? number
---@field position? NotificationPosition
---@field status? 'info' | 'police' | 'ambulance' | 'warn' | 'success' | 'error'
---@field id? number

---@param data DefaultNotifyProps
function lib.defaultNotify(data)
    -- Backwards compat for v3
    data.type = data.status
    if data.type == 'inform' then data.type = 'info' end
    return lib.notify(data --[[@as NotifyProps]])
end

RegisterNetEvent('ox_lib:notify', lib.notify)
RegisterNetEvent('ox_lib:defaultNotify', lib.defaultNotify)
