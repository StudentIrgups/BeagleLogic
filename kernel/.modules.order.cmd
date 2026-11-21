cmd_/opt/BeagleLogic/kernel/modules.order := {   echo /opt/BeagleLogic/kernel/beaglelogic.ko; :; } | awk '!x[$$0]++' - > /opt/BeagleLogic/kernel/modules.order
