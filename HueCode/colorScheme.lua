local nodes = require("nodes")
colorScheme = {}
colorScheme.red = {}
colorScheme.green = {}
colorScheme.blue = {}
colorScheme.red[nodes.EXECUTION_CONNECTION] = 176 / 255
colorScheme.green[nodes.EXECUTION_CONNECTION] = 63 / 255
colorScheme.blue[nodes.EXECUTION_CONNECTION] = 63 / 255
colorScheme.red[nodes.VALUE_CONNECTION] =	176 / 255
colorScheme.green[nodes.VALUE_CONNECTION] = 176 / 255
colorScheme.blue[nodes.VALUE_CONNECTION] =	176 / 255
colorScheme.red[nodes.REFERENCE_CONNECTION] = 121 / 255
colorScheme.green[nodes.REFERENCE_CONNECTION] = 176 / 255
colorScheme.blue[nodes.REFERENCE_CONNECTION] = 64 / 255
colorScheme.red[nodes.DATA_CONNECTION] = 62 / 255
colorScheme.green[nodes.DATA_CONNECTION] = 172 / 255
colorScheme.blue[nodes.DATA_CONNECTION] = 150 / 255
return colorScheme