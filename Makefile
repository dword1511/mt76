CONFIG_MT7603E = m
CONFIG_MT76x02_LIB = m
CONFIG_MT76x02_USB = m
CONFIG_MT76_USB = m
CONFIG_MT76x2_COMMON = m
CONFIG_MT76x0_COMMON = m
CONFIG_MT76x2E = m
CONFIG_MT76x2U = m
CONFIG_MT76x0E = m
CONFIG_MT76x0U = m
export CONFIG_MT76x2_COMMON CONFIG_MT76x0_COMMON CONFIG_MT76x2E CONFIG_MT76x2U CONFIG_MT76x0E CONFIG_MT76x0U


EXTRA_CFLAGS += -Werror -DCONFIG_MT76_LEDS

obj-m := mt76.o
obj-$(CONFIG_MT7603E) += mt7603/
obj-$(CONFIG_MT76x02_LIB) += mt76x02-lib.o
obj-$(CONFIG_MT76x02_USB) += mt76x02-usb.o
obj-$(CONFIG_MT76_USB) += mt76-usb.o
obj-$(CONFIG_MT76x2_COMMON) += mt76x2/
obj-$(CONFIG_MT76x0_COMMON) += mt76x0/

mt76-y := \
	mmio.o util.o trace.o dma.o mac80211.o debugfs.o eeprom.o tx.o agg-rx.o

mt76-usb-y := usb.o usb_trace.o usb_mcu.o

mt76x02-lib-y := mt76x02_util.o mt76x02_mac.o mt76x02_mcu.o \
		 mt76x02_eeprom.o mt76x02_phy.o mt76x02_mmio.o \
		 mt76x02_txrx.o mt76x02_trace.o mt76x02_debugfs.o \
		 mt76x02_dfs.o

mt76x02-usb-y := mt76x02_usb_mcu.o mt76x02_usb_core.o


.PHONY: modules clean install
KSRC    = /lib/modules/$(shell uname -r)/build/
DEST    = /lib/modules/$(shell uname -r)/kernel/drivers/net/wireless/mt76/
DEST_FW = /lib/firmware/
MDIR    = $(CURDIR)
modules:
	make -C $(KSRC) M=$(MDIR) modules

clean:
	make -C $(KSRC) M=$(MDIR) clean

install:
	mkdir -p $(DEST)
	cp -a *.ko $(DEST)
	cp -a */*.ko $(DEST)
	cp -a firmware/*.bin $(DEST_FW)
	depmod -a
