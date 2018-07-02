nodes = {}

-- Operators
-- Table operators

nodes.VALUE_NODE = 0x1
nodes.FUNCTION_NODE = 0x2
nodes.RETURN_NODE = 0x3
nodes.ASSIGN_NODE = 0x4
nodes.REFERENCE_NODE = 0x5
nodes.CONDITIONAL_NODE = 0x6
nodes.CALLFUNCTION_NODE = 0x7
nodes.EVALUATE_NODE = 0x8
nodes.FORLOOP_NODE = 0x9
nodes.WHILELOOP_NODE = 0xA
nodes.GENERICFORLOOP_NODE = 0xB
nodes.OPERATOR_NODE = 0xC
nodes.TABLEINDEX_NODE = 0xD


function nodes.newPlug (owner, type, getTextRepresentation, output)
    local plug = {}
    plug.owner = owner
    plug.type = type
    plug.output = output
    plug.connection = nil
    plug.getTextRepresentation = getTextRepresentation
    plug.connect = function (toConnect)
        toConnect.connection = plug
        plug.connection = toConnect
    end
    return plug
end

function nodes.holder () end

function nodes.baseNode ()
    local node = {}
    node.specialText = ""
    node.type = nil
    node.plugs = {}
    return node
end

function nodes.operatorNode ()
    local node = nodes.baseNode()
    node.type = nodes.OPERATOR_NODE 
    node.operator = nil
    local getRepresentation = function ()
        local repr = " ("
        repr = repr .. node.plugs["a"].connection.getTextRepresentation()
        repr = repr .. " " .. specialText
        repr = repr .. node.plugs["b"].connection.getTextRepresentation()
        repr = repr .. " )"
        return repr
    end
    node.plugs["a"] = nodes.newPlug(node, "DATA_CONNECTION", nil, false)
    node.plugs["b"] = nodes.newPlug(node, "DATA_CONNECTION", nil, false)
    node.plugs["out"] = nodes.newPlug(node, "DATA_CONNECTION", getRepresentation, true)
    return node
end

function nodes.tableIndexNode ()
    local node = nodes.baseNode()
    node.type = nodes.TABLEINDEX_NODE
    local getRepresentation = function()
        local repr = "["
        repr = repr .. node.plugs["index"].connection.getTextRepresentation()
        repr = repr .. "]"
        return repr
    end
    node.plugs["index"] = nodes.newPlug(node, "DATA_CONNECTION", nil, false)
    node.plugs["reference"] = nodes.newPlug(node, "REFERENCE_CONNECTION", getRepresentation, true)
    return node
end

function nodes.conditionalNode ()
    local node = nodes.baseNode()
    node.type = nodes.CONDITIONAL_NODE
    local getRepresentation = function ()
        local repr = " if"
        repr = repr .. node.plugs["condition"].connection.getTextRepresentation()
        repr = repr .. " then"
        repr = repr .. node.plugs["true"].connection.getTextRepresentation()
        repr = repr .. " else"
        repr = repr .. node.plug["false"].connection.getTextRepresentation()
        repr = repr .. " end"
        repr = repr .. node.plug["after"].connection.getTextRepresentation()
        return repr
    end
    node.plugs["before"] = nodes.newPlug(node, "EXECUTION_CONNECTION", getRepresentation, false)
    node.plugs["condition"] = nodes.newPlug(node, "DATA_CONNECTION", nil, false)
    node.plugs["true"] = nodes.newPlug(node, "EXECUTION_CONNECTION", nil, true)
    node.plugs["false"] = nodes.newPlug(node, "EXECUTION_CONNECTION", nil, true)
    node.plugs["after"] = nodes.newPlug(node, "EXECUTION_CONNECTION", nil, true)
    return node
end

function nodes.functionNode ()
    local node = nodes.baseNode()
    node.type = nodes.FUNCTION_NODE
    local argsAdded = 1
    local getFunctionRepresentation = function ()
        local repr = " "
        repr = repr .. "function ("
        local argCount = 1
        for k, v in pairs(node.plugs) do
            if v.type == "REFERENCE_CONNECTION" then 
                if argCount ~= 1 then
                    repr = repr .. ", "
                end
                argCount = argCount + 1
                repr = repr .. k
            end
        end
        repr = repr .. ") "
        repr = repr .. node.plugs["body"].connection.getTextRepresentation()
        repr = repr .. " end"
        return repr
    end
    node.plugs["value"] = nodes.newPlug(node, "VALUE_CONNECTION", getFunctionRepresentation, true)
    node.plugs["body"] = nodes.newPlug(node, "EXECUTION_CONNECTION", nil, true)
    node.addArgument = function ()
        node.plugs["arg" .. argsAdded] = nodes.newPlug(node, "REFERENCE_CONNECTION", nil, false)
        argsAdded = argsAdded + 1
        return node.plugs["arg" .. argsAdded]
    end
    return node
end

function nodes.evaluateNode ()
    local node = nodes.baseNode()
    node.type = nodes.EVALUATE_NODE
    local getRepresentation = function ()
        local repr = " "
        repr = repr .. node.plugs['toEvaluate'].connection.getTextRepresentation()
        repr = repr .. node.plugs['after'].connection.getTextRepresentation()
        return repr
    end
    node.plugs["toEvaluate"] = nodes.newPlug(node, "REFERENCE_CONNECTION", nil, false)
    node.plugs["before"] = nodes.newPlug(node, "EXECUTION_CONNECTION", getRepresentation, false)
    node.plugs["after"] = nodes.newPlug(node, "EXECUTION_CONNECTION", nil, true)
    return node
end

function nodes.referenceNode ()
    local node = nodes.baseNode()
    node.type = nodes.REFERENCE_NODE
    node.reference = nil
    local getRepresentation = function ()
        if node.plugs["children"].connection == nil then
            return " " .. node.specialText
        else
            return node.plugs["children"].connection.getTextRepresentation() .. "." .. node.specialText
        end
    end
    node.plugs["reference"] = nodes.newPlug(node, "REFERENCE_CONNECTION", getRepresentation, true)
    node.plugs["parent"] = nodes.newPlug(node, "REFERENCE_CONNECTION", nil, false)
    return node
end

function nodes.forLoopNode ()
    local node = nodes.baseNode()
    node.type = nodes.FORLOOP_NODE
    local getRepresentation = function ()
        local repr = " for"
        repr = repr .. node.plugs["counter"].connection.getTextRepresentation()
        repr = repr .. "=" 
        repr = repr .. node.plugs["init"].connection.getTextRepresentation()
        repr = repr .. ","
        repr = repr .. node.plugs["control"].connection.getTextRepresentation()
        repr = repr .. ","
        repr = repr .. node.plugs["state"].connection.getTextRepresentation()
        repr = repr .. " do"
        repr = repr .. node.plugs["body"].connection.getTextRepresentation()
        repr = repr .. " end"
        repr = repr .. node.plugs["after"].connection.getTextRepresentation()
        return repr
    end
    node.plugs["counter"] = nodes.newPlug(node, "REFERENCE_CONNECTION", nil, false)
    node.plugs["init"] = nodes.newPlug(node, "DATA_CONNECTION", nil, false)
    node.plugs["state"] = nodes.newPlug(node, "DATA_CONNECTION", nil, false)
    node.plugs["control"] = nodes.newPlug(node, "DATA_CONNECTION", nil, false)
    node.plugs["body"] = nodes.newPlug(node, "EXECUTION_CONNECTION", nil, true)
    node.plugs["after"] = nodes.newPlug(node, "EXECUTION_CONNECTION", nil, true)
    node.plugs["before"] = nodes.newPlug(node, "EXECUTION_CONNECTION", getRepresentation, false)
    return node
end

function nodes.genericForLoopNode ()
    local node = nodes.baseNode()
    node.type = nodes.GENERICFORLOOP_NODE
    local argsAdded = 1
    local getRepresentation = function ()
        local repr = " for"
        local argCount = 1
        for k, v in pairs(node.plugs) do
            if v.type == "REFERENCE_CONNECTION" then 
                if argCount ~= 1 then
                    repr = repr .. ", "
                else
                    repr = repr .. " "
                end
                argCount = argCount + 1
                repr = repr .. k
            end
        end
        repr = repr .. " in"
        repr = repr .. node.plugs["iterator"].connection.getTextRepresentation()
        repr = repr .. " do"
        repr = repr .. node.plugs["body"].connection.getTextRepresentation()
        repr = repr .. " end"
        repr = repr .. node.plugs["after"].connection.getTextRepresentation()
        return repr
    end
    node.plugs["iterator"] = nodes.newPlug(node, "DATA_CONNECTION", nil, false)
    node.plugs["body"] = nodes.newPlug(node, "EXECUTION_CONNECTION", nil, true)
    node.plugs["after"] = nodes.newPlug(node, "EXECUTION_CONNECTION", nil, true)
    node.plugs["before"] = nodes.newPlug(node, "EXECUTION_CONNECTION", getRepresentation, false)
    node.addArgument = function ()
        node.plugs["iter" .. argsAdded] = nodes.newPlug(node, "REFERENCE_CONNECTION", nil, false)
        argsAdded = argsAdded + 1
        return node.plugs["iter" .. argsAdded]
    end
    node.addArgument()
    return node
end

function nodes.whileLoopNode ()
    local node = nodes.baseNode()
    node.type = nodes.WHILELOOP_NODE
    local getRepresentation = function ()
        local repr = " while"
        repr = repr .. node.plugs["condition"].connection.getTextRepresentation()
        repr = repr .. " do"
        repr = repr .. node.plugs["body"].connection.getTextRepresentation()
        repr = repr .. " end"
        repr = repr .. node.plugs["after"].connection.getTextRepresentation()
        return repr
    end
    node.plugs["condition"] = nodes.newPlug(node, "DATA_CONNECTION", nil, false)
    node.plugs["body"] = nodes.newPlug(node, "EXECUTION_CONNECTION", nil, true)
    node.plugs["after"] = nodes.newPlug(node, "EXECUTION_CONNECTION", nil, true)
    node.plugs["before"] = nodes.newPlug(node, "EXECUTION_CONNECTION", getRepresentation, false)
    return node
end

function nodes.valueNode ()
    local node = nodes.baseNode()
    node.type = nodes.VALUE_NODE
    node.value = nil
    local getTextRepresentation = function ()
        return "" .. node.specialText
    end
    node.plugs["value"] = nodes.newPlug(node, "VALUE_CONNECTION", getTextRepresentation, true)
    return node
end

function nodes.callFunctionNode ()
    local node = nodes.baseNode()
    node.type = nodes.CALLFUNCTION_NODE
    local argsAdded = 1
    local getFunctionRepresentation = function ()
        local repr = node.plugs["toCall"].getTextRepresentation()
        repr = repr .. "("
        local argCount = 1
        for k, v in pairs(node.plugs) do
            if v.type == "REFERENCE_CONNECTION" then 
                if argCount ~= 1 then
                    repr = repr .. ", "
                end
                argCount = argCount + 1
                repr = repr .. k
            end
        end
        repr = repr .. ")"
        return repr
    end
    node.plugs["toCall"] = nodes.newPlug(node, "REFERENCE_CONNECTION", nil, false)
    node.plugs["reference"] = nodes.newPlug(node, "REFERENCE_CONNECTION", getFunctionRepresentation, true)
    node.addArgument = function ()
        node.plugs["arg" .. argsAdded] = nodes.newPlug(node, "REFERENCE_CONNECTION", nil, false)
        argsAdded = argsAdded + 1
        return node.plugs["arg" .. argsAdded]
    end
    node.addArgument()
    return node
end

function nodes.returnNode ()
    local node = nodes.baseNode()
    node.type = nodes.RETURN_NODE
    node.returned = 1
    local getRepresentation = function ()
        local repr = " "
        repr = "" .. "return "
        local valueCount = 1
        for k, v in pairs(node.plugs) do
            if v.type == "REFERENCE_CONNECTION" then
                if valueCount ~= 1 then
                    repr = repr .. ", "
                end
                valueCount = valueCount + 1
                repr = repr .. v.connection.getTextRepresentation()
            end
        end
        return repr
    end
    node.plugs["before"] = nodes.newPlug(node, "EXECUTION_CONNECTION", getRepresentation, false)
    node.addToReturn = function ()
        node.plugs["toReturn" .. node.returned] = nodes.newPlug(node, "DATA_CONNECTION", nil, false)
        return node.plugs["toReturn" .. node.returned] 
    end
    node.addToReturn()
    return node
end

function nodes.assignNode ()
    local node = nodes.baseNode()
    node.assigned = 1
    node.type = nodes.ASSIGN_NODE
    local getRepresentation = function ()
        local repr = " "
        local valueCount = 1
        for k, v in pairs(node.plugs) do
            if v.type == "REFERENCE_CONNECTION" then
                if valueCount ~= 1 then
                    repr = repr .. ", "
                end
                valueCount = valueCount + 1
                repr = repr .. v.connection.getTextRepresentation()
            end
        end
        repr = repr .. " ="
        repr = repr .. node.plugs["value_or_ref"].connection.getTextRepresentation()
        if node.plugs["after"].connection ~= nil then
            repr = repr .. node.plugs["after"].connection.getTextRepresentation()
        end
        return repr
    end
    node.plugs["before"] = nodes.newPlug(node, "EXECUTION_CONNECTION", getRepresentation, false)
    node.plugs["after"] = nodes.newPlug(node, "EXECUTION_CONNECTION", nil, true)
    node.plugs["value_or_ref"] = nodes.newPlug(node, "DATA_CONNECTION", nil, false)
    node.addToAssign = function ()
        node.plugs["toAssign" .. node.assigned] = nodes.newPlug(node, "REFERENCE_CONNECTION", nil, false)
        return node.plugs["toAssign" .. node.assigned] 
    end
    node.addToAssign()
    return node
end

return nodes