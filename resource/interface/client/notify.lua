--[[
    https://github.com/overextended/ox_lib

    This file is licensed under LGPL-3.0 or higher <https://www.gnu.org/licenses/lgpl-3.0.en.html>

    Copyright © 2025 Linden <https://github.com/thelindat>
]]

---@alias NotificationPosition 'top' | 'top-right' | 'top-left' | 'bottom' | 'bottom-right' | 'bottom-left' | 'center-right' | 'center-left'
---@alias NotificationType 'info' | 'police' | 'ambulance' | 'warn' | 'success' | 'error'
---@alias IconAnimationType 'spin' | 'spinPulse' | 'spinReverse' | 'pulse' | 'beat' | 'fade' | 'beatFade' | 'bounce' | 'shake'

---@class NotifyProps
---@field id? string
---@field title? string
---@field description? string
---@field duration? number
---@field showDuration? boolean
---@field position? NotificationPosition
---@field type? NotificationType
---@field style? { [string]: any }
---@field icon? string | { [1]: IconProp, [2]: string }
---@field iconAnimation? IconAnimationType
---@field iconColor? string
---@field alignIcon? 'top' | 'center'
---@field sound? { bank?: string, set: string, name: string }

local settings = require 'resource.settings'

---`client`
---@param data NotifyProps
---@diagnostic disable-next-line: duplicate-set-field
function lib.notify(data)
    local sound = settings.notification_audio and data.sound
    data.sound = nil
    data.position = data.position or settings.notification_position

    --default icon color
    local defaultIconColor = {
        info = '#1c75d2',
        police = '#1c75d2',
        ambulance = '#bf1d1d',
        warn = '#ee8a08',
        success = '#20bb44',
        error = '#bf1d1d'
    }

    data.iconColor = data.iconColor or defaultIconColor[data.type] or '#1c75d2' -- Use custom icon color if provided, else use predefined icon color, default to blue

    --default icon animations
    local iconAnimations = {
        info = 'beatFade',
        police = 'pulse',
        ambulance = 'pulse',
        warn = 'bounce',
        success = 'beat',
        error = 'shake'
    }

    data.iconAnimation = data.iconAnimation or iconAnimations[data.type] or 'beatFade' -- Use custom icon animation if provided, else use predefined icon animation, default to beatFade

    --default styling
    local style = {
        borderRadius = '4px 4px 0 0',
        borderBottom = '2px solid ' .. data.iconColor, -- Use selected color for the border
        backgroundColor = '#2b2b2bE0',
        color = 'white'
    }

    data.style = data.style or style

    SendNUIMessage({
        action = 'notify',
        data = data
    })

    if not sound then return end

    if sound.bank then lib.requestAudioBank(sound.bank) end

    local soundId = GetSoundId()
    PlaySoundFrontend(soundId, sound.name, sound.set, true)
    ReleaseSoundId(soundId)

    if sound.bank then ReleaseNamedScriptAudioBank(sound.bank) end
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
