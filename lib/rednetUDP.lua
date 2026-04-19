
--[[
rednetUDP

API on top of rednet that allows for not only a sender port, but a way to specify which port should be used to return communication

Other than that, rednet already had every feature of UDP. But this one addition is crucial for network address translation.

]]


local rednetUDP = {}


function rednetUDP.send(recipient, message, port, replyPort)
    assert(port, "port is nil")
    assert(replyPort, "replyPort is nil")
    if type(recipient) == "number" then
        return rednet.send(recipient, {message, port, replyPort}, "rednetUDP")
    elseif recipient == nil then
        return rednet.broadcast({message, port, replyPort}, "rednetUDP")
    end
    error("recipient is not a number or nil")
end

function rednetUDP.broadcast(message, port, replyPort)
    return rednetUDP.send(nil, message, port, replyPort)
end

function rednetUDP.receive(portFilter, replyPortFilter, senderFilter, timeout)
    local timer
    if type(timeout) == number and timeout > 0 then
        timer=os.startTimer(timeout)
    end
    while true do
        event, s1, s2, s3 = os.pullEvent()
        if timer and event == "timer" then
            if s1 == timer then return false end
        elseif event == "rednet_message" then
            local senderID, rawMessage, messageProtocol = s1, s2, s3
            
            if messageProtocol == "rednetUDP"
                and (not senderFilter or senderID == senderFilter)
                and (not portFilter or rawMessage[2] == portFilter)
                and (not replyPortFilter or rawMessage[3] == replyPortFilter)
                and type(rawMessage) == "table"
                and (rawMessage[1] and rawMessage[2] and rawMessage[3])
            then
                return senderID, rawMessage[1], rawMessage[2], rawMessage[3]
            end
        end
    end
    return nil
end


return rednetUDP
