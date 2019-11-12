BIND_PID1="1022 145f"
BIND_BDF1="0000:27:00.3"
#BIND_PID2="10de 0bee"
#BIND_BDF2="0000:01:00.1"

sudo modprobe vfio-pci
echo "$BIND_PID1" > /sys/bus/pci/drivers/vfio-pci/new_id
echo "$BIND_BDF1" > /sys/bus/pci/devices/$BIND_BDF1/driver/unbind
echo "$BIND_BDF1" > /sys/bus/pci/drivers/vfio-pci/bind
echo "$BIND_PID1" > /sys/bus/pci/drivers/vfio-pci/remove_id
