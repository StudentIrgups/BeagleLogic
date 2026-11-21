cmd_/opt/BeagleLogic/kernel/Module.symvers := sed 's/ko$$/o/' /opt/BeagleLogic/kernel/modules.order | scripts/mod/modpost -m    -o /opt/BeagleLogic/kernel/Module.symvers -e -i Module.symvers   -T -
