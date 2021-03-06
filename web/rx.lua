
local http = beerchat.http
local recv_loop

function handle_data(data)
	if not data or not data.username or not data.message or not data.name then
		return
	end

	local name = data.username .. "@" .. data.name

	if data.channel and data.channel ~= "" then
		-- channel message
		beerchat.send_on_channel(name, data.channel, data.message)

	elseif data.direct then
			-- direct message
			beerchat.executor(data.message, name)

			-- TODO:  return value
	end
end


recv_loop = function()
	http.fetch({
		url = beerchat.url,
		timeout = 30,
	}, function(res)
		if res.succeeded and res.code == 200 then
			local data = minetest.parse_json(res.data)
			if #data > 0 then
				-- array received
				for _, item in ipairs(data) do
					handle_data(item)
				end
			else
				-- single item received
				handle_data(data)
			end

			minetest.after(0.5, recv_loop)
		else
			-- ignore errors
			minetest.log("error", "[beerchat] http request to " ..
				beerchat.url .. " failed with code " .. res.code)

			minetest.after(5, recv_loop)
		end

	end)
end

-- start loop
recv_loop()
