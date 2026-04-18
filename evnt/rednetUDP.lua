function processEvent(event, senderID, rawMessage, messageProtocol)
    if event == "rednet_message" and messageProtocol == "rednetUDP" then
	if type(rawMessage) ~= "table" then return true end
        return "rednetUDP_message", senderID, rawMessage[1], rawMessage[2], rawMessage[3]
    else
	return false
    end
end

return processEvent
