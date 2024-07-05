local inspect = require("inspect")
local json = require("json")

local tools_2807_api_base = "https://tools.2807.eu/api/"
local markzynk_api_base = "https://api.markzynk.com/twitch/"

local function mods(ctx)
    table.remove(ctx.words, 1)
    local channel = ctx.channel:get_name()
    local url = tools_2807_api_base .. "getmods/" .. channel

    c2.log(c2.LogLevel.Debug, "loading mods for " .. channel .. "...")
    local req = c2.HTTPRequest.create(c2.HTTPMethod.Get, url)
    req:on_success(function(res)
        local json_res = json.decode(res.data(res))

        c2.log(c2.LogLevel.Debug, "loaded " .. #json_res .. " mods")
        if #json_res == 0 then
            ctx.channel:add_system_message("There are no channel moderators!")
        else
            local display_names = {}
            for i, user in ipairs(json_res) do
                table.insert(display_names, user.displayName)
            end
            ctx.channel:add_system_message("The moderators (" ..
                #display_names .. ") of this channel are " .. table.concat(display_names, ", "))
        end
    end)
    req:on_error(function(res)
        local status_code = res.status(res)

        if status_code == 400 then
            ctx.channel:add_system_message("There are no moderators in this channel!")
        else
            ctx.channel:add_system_message("There was an error getting the moderators of this channel!")
        end
    end)
    req:execute()
end

local function vips(ctx)
    table.remove(ctx.words, 1)
    local channel = ctx.channel:get_name()
    local url = tools_2807_api_base .. "getvips/" .. channel

    c2.log(c2.LogLevel.Debug, "loading vips for " .. channel .. "...")
    local req = c2.HTTPRequest.create(c2.HTTPMethod.Get, url)
    req:on_success(function(res)
        local json_res = json.decode(res.data(res))

        c2.log(c2.LogLevel.Debug, "loaded " .. #json_res .. " vips")
        if #json_res == 0 then
            ctx.channel:add_system_message("There are no VIPs in this channel!")
        else
            local display_names = {}
            for i, user in ipairs(json_res) do
                table.insert(display_names, user.displayName)
            end
            ctx.channel:add_system_message("The VIPS (" ..
                #display_names .. ") of this channel are " .. table.concat(display_names, ", "))
        end
    end)
    req:on_error(function(res)
        local status_code = res.status(res)

        if status_code == 400 then
            ctx.channel:add_system_message("There are no VIPs in this channel!")
        else
            ctx.channel:add_system_message("There was an error getting the VIPs of this channel!")
        end
    end)
    req:execute()
end

local function founders(ctx)
    table.remove(ctx.words, 1)
    local channel = ctx.channel:get_name()
    local url = tools_2807_api_base .. "getfounders/" .. channel

    c2.log(c2.LogLevel.Debug, "loading founders for " .. channel .. "...")
    local req = c2.HTTPRequest.create(c2.HTTPMethod.Get, url)
    req:on_success(function(res)
        local json_res = json.decode(res.data(res))

        c2.log(c2.LogLevel.Debug, "loaded " .. #json_res .. " founders")
        if #json_res == 0 then
            ctx.channel:add_system_message("There are no founders in this channel!")
        else
            local display_names = {}
            for i, user in ipairs(json_res) do
                table.insert(display_names, user.displayName)
            end
            ctx.channel:add_system_message("The founders (" ..
                #display_names .. ") of this channel are " .. table.concat(display_names, ", "))
        end
    end)
    req:on_error(function(res)
        local status_code = res.status(res)

        if status_code == 400 then
            ctx.channel:add_system_message("There are no founders in this channel!")
        else
            ctx.channel:add_system_message("There was an error getting the founders of this channel!")
        end
    end)
    req:execute()
end

local function chatters(ctx)
    table.remove(ctx.words, 1)
    local channel = ctx.channel:get_name()
    local url = markzynk_api_base .. "chatters/" .. channel .. "/count"

    c2.log(c2.LogLevel.Debug, "loading chatters count for " .. channel .. "...")
    local req = c2.HTTPRequest.create(c2.HTTPMethod.Get, url)
    req:on_success(function(res)
        local json_res = json.decode(res.data(res))
        local count = json_res.count

        c2.log(c2.LogLevel.Debug, "loaded chatters count: " .. count)
        ctx.channel:add_system_message("Chatter count: " .. count)
    end)
    req:on_error(function(res)
        ctx.channel:add_system_message("There was an error getting the chatters count of this channel!")
    end)
    req:execute()
end

c2.register_command("/getmods", mods)
c2.register_command("/getvips", vips)
c2.register_command("/getfounders", founders)
c2.register_command("/getchatters", chatters)
