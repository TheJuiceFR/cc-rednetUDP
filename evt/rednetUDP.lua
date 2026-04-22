local eventHandler = {}

function eventHandler.rednet_message(event, senderID, rawMessage, messageProtocol)
	if messageProtocol == "rednetUDP" then
		-- If it's not proper, drop the packet
		if type(rawMessage) ~= "table" or not (rawMessage[1] and rawMessage[2] and rawMessage[3]) then return true end
		
		return "rednetUDP_message", senderID, rawMessage[1], rawMessage[2], rawMessage[3]
	else
		return false
	end
end

return eventHandler

