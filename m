From: David Howells <dhowells@redhat.com>
Subject: [PATCH] Lock down drivers that can have io ports, io mem, irqs and dma changed
Date: Mon, 21 Nov 2016 23:10:52 +0000
Message-ID: <26173.1479769852@warthog.procyon.org.uk>
References: <20161116222731.563fb85e@lxorguk.ukuu.org.uk> <147933283664.19316.12454053022687659937.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20161116222731.563fb85e@lxorguk.ukuu.org.uk>
Content-ID: <26172.1479769852.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: dhowells@redhat.com, keyrings@vger.kernel.org, matthew.garrett@nebula.com, linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk> wrote:

> You need to filter or lock down kernel module options because a lot of
> modules let you set the I/O port or similar (eg mmio) which means you can
> hack the entire machine with say the 8250 driver just by using it with an
> mmio of the right location to patch the secure state to zero just by
> getting the ability to write to the modules conf file.

Is the attached patch the right sort of idea?  [Note that I haven't actually
compiled most of these drivers to check my changes yet.]

David
---
commit 8613a9655dad98c3358d82a9c4310cebdcb852ae
Author: David Howells <dhowells@redhat.com>
Date:   Mon Nov 21 22:43:27 2016 +0000

    Lock down drivers that can have io ports, io mem, irqs and dma changed
    
    Lock down drivers that can have io ports, io mem, irqs and dma channels
    changed so that they can't be used to cause hardware to access the kernel
    image.
    
    Notes:
    
     (1) module_isa_driver() gets an extra parameter that, if true, will cause
         the module load to be rejected if the kernel is locked down.
    
     (2) module_driver() calls module_lockdown_check() to ask if the module
         load should be rejected if the kernel is locked down.  This is a macro
         that should be #undef'd and then redefined right before
         module_driver() is called.
    
     (3) module_pci_driver() is a wrapper around module_driver(), so the same
         macro is used as in (2).
    
     (4) A number of drivers use parport 'ports' - so I haven't touched those.

diff --git a/arch/x86/mm/testmmiotrace.c b/arch/x86/mm/testmmiotrace.c
index 38868adf07ea..235493f9e205 100644
--- a/arch/x86/mm/testmmiotrace.c
+++ b/arch/x86/mm/testmmiotrace.c
@@ -115,6 +115,11 @@ static int __init init(void)
 {
 	unsigned long size = (read_far) ? (8 << 20) : (16 << 10);
 
+	if (kernel_is_locked_down()) {
+		pr_err("Kernel is locked down\n");
+		return -EPERM;
+	}
+	
 	if (mmio_address == 0) {
 		pr_err("you have to use the module argument mmio_address.\n");
 		pr_err("DO NOT LOAD THIS MODULE UNLESS YOU REALLY KNOW WHAT YOU ARE DOING!\n");
diff --git a/drivers/char/applicom.c b/drivers/char/applicom.c
index 14790304b84b..1c0a3878a440 100644
--- a/drivers/char/applicom.c
+++ b/drivers/char/applicom.c
@@ -192,6 +192,11 @@ static int __init applicom_init(void)
 
 	printk(KERN_INFO "Applicom driver: $Id: ac.c,v 1.30 2000/03/22 16:03:57 dwmw2 Exp $\n");
 
+	if ((irq || mem) && kernel_is_locked_down()) {
+		pr_err("Kernel is locked down\n");
+		return -EPERM;
+	}
+	
 	/* No mem and irq given - check for a PCI card */
 
 	while ( (dev = pci_get_class(PCI_CLASS_OTHERS << 16, dev))) {
diff --git a/drivers/char/ipmi/ipmi_si_intf.c b/drivers/char/ipmi/ipmi_si_intf.c
index a112c0146012..7fb9c299a183 100644
--- a/drivers/char/ipmi/ipmi_si_intf.c
+++ b/drivers/char/ipmi/ipmi_si_intf.c
@@ -3725,6 +3725,12 @@ static int init_ipmi_si(void)
 	struct smi_info *e;
 	enum ipmi_addr_src type = SI_INVALID;
 
+	if ((num_addrs || num_ports || num_irqs) &&
+	    kernel_is_locked_down()) {
+		pr_err(PFX "Kernel is locked down\n");
+		return -EPERM;
+	}
+
 	if (initialized)
 		return 0;
 	initialized = 1;
diff --git a/drivers/char/mwave/mwavedd.c b/drivers/char/mwave/mwavedd.c
index 3a3ff2eb6cba..ce573ffc5858 100644
--- a/drivers/char/mwave/mwavedd.c
+++ b/drivers/char/mwave/mwavedd.c
@@ -572,6 +572,11 @@ static int __init mwave_init(void)
 	int retval = 0;
 	pMWAVE_DEVICE_DATA pDrvData = &mwave_s_mdd;
 
+	if (kernel_is_locked_down()) {
+		pr_err("Kernel is locked down\n");
+		return -EPERM;
+	}
+
 	PRINTK_1(TRACE_MWAVE, "mwavedd::mwave_init entry\n");
 
 	memset(&mwave_s_mdd, 0, sizeof(MWAVE_DEVICE_DATA));
diff --git a/drivers/clocksource/cs5535-clockevt.c b/drivers/clocksource/cs5535-clockevt.c
index 9a7e37cf56b0..5facfc6b6e3b 100644
--- a/drivers/clocksource/cs5535-clockevt.c
+++ b/drivers/clocksource/cs5535-clockevt.c
@@ -145,6 +145,11 @@ static int __init cs5535_mfgpt_init(void)
 	int ret;
 	uint16_t val;
 
+	if (timer_irq != 0 && kernel_is_locked_down()) {
+		pr_err(DRV_NAME ": Kernel is locked down\n");
+		return -EPERM;
+	}
+	
 	timer = cs5535_mfgpt_alloc_timer(MFGPT_TIMER_ANY, MFGPT_DOMAIN_WORKING);
 	if (!timer) {
 		printk(KERN_ERR DRV_NAME ": Could not allocate MFGPT timer\n");
diff --git a/drivers/cpufreq/speedstep-smi.c b/drivers/cpufreq/speedstep-smi.c
index 770a9ae1999a..c4cc1cd68d0e 100644
--- a/drivers/cpufreq/speedstep-smi.c
+++ b/drivers/cpufreq/speedstep-smi.c
@@ -318,6 +318,11 @@ MODULE_DEVICE_TABLE(x86cpu, ss_smi_ids);
  */
 static int __init speedstep_init(void)
 {
+	if (smi_port != 0 && kernel_is_locked_down()) {
+		pr_err("Kernel is locked down\n");
+		return -EPERM;
+	}
+	
 	if (!x86_match_cpu(ss_smi_ids))
 		return -ENODEV;
 
diff --git a/drivers/gpio/gpio-104-dio-48e.c b/drivers/gpio/gpio-104-dio-48e.c
index fcf776971ca9..cfb0db2d7c9f 100644
--- a/drivers/gpio/gpio-104-dio-48e.c
+++ b/drivers/gpio/gpio-104-dio-48e.c
@@ -393,7 +393,7 @@ static struct isa_driver dio48e_driver = {
 	},
 	.remove = dio48e_remove
 };
-module_isa_driver(dio48e_driver, num_dio48e);
+module_isa_driver(dio48e_driver, num_dio48e, num_dio48e > 0);
 
 MODULE_AUTHOR("William Breathitt Gray <vilhelm.gray@gmail.com>");
 MODULE_DESCRIPTION("ACCES 104-DIO-48E GPIO driver");
diff --git a/drivers/gpio/gpio-104-idi-48.c b/drivers/gpio/gpio-104-idi-48.c
index 2d2763ea1a68..12b57a2e39cf 100644
--- a/drivers/gpio/gpio-104-idi-48.c
+++ b/drivers/gpio/gpio-104-idi-48.c
@@ -299,7 +299,7 @@ static struct isa_driver idi_48_driver = {
 	},
 	.remove = idi_48_remove
 };
-module_isa_driver(idi_48_driver, num_idi_48);
+module_isa_driver(idi_48_driver, num_idi_48, num_idi_48 > 0);
 
 MODULE_AUTHOR("William Breathitt Gray <vilhelm.gray@gmail.com>");
 MODULE_DESCRIPTION("ACCES 104-IDI-48 GPIO driver");
diff --git a/drivers/gpio/gpio-104-idio-16.c b/drivers/gpio/gpio-104-idio-16.c
index 6787b8fcf0d8..2348c6c7cb11 100644
--- a/drivers/gpio/gpio-104-idio-16.c
+++ b/drivers/gpio/gpio-104-idio-16.c
@@ -275,7 +275,7 @@ static struct isa_driver idio_16_driver = {
 	.remove = idio_16_remove
 };
 
-module_isa_driver(idio_16_driver, num_idio_16);
+module_isa_driver(idio_16_driver, num_idio_16, num_idio_16 > 0);
 
 MODULE_AUTHOR("William Breathitt Gray <vilhelm.gray@gmail.com>");
 MODULE_DESCRIPTION("ACCES 104-IDIO-16 GPIO driver");
diff --git a/drivers/gpio/gpio-gpio-mm.c b/drivers/gpio/gpio-gpio-mm.c
index 1e7def9449ce..6507a88fe02d 100644
--- a/drivers/gpio/gpio-gpio-mm.c
+++ b/drivers/gpio/gpio-gpio-mm.c
@@ -260,7 +260,7 @@ static struct isa_driver gpiomm_driver = {
 	.remove = gpiomm_remove
 };
 
-module_isa_driver(gpiomm_driver, num_gpiomm);
+module_isa_driver(gpiomm_driver, num_gpiomm, num_gpiomm > 0);
 
 MODULE_AUTHOR("William Breathitt Gray <vilhelm.gray@gmail.com>");
 MODULE_DESCRIPTION("Diamond Systems GPIO-MM GPIO driver");
diff --git a/drivers/gpio/gpio-ws16c48.c b/drivers/gpio/gpio-ws16c48.c
index eaa71d440ccf..9d72a3446278 100644
--- a/drivers/gpio/gpio-ws16c48.c
+++ b/drivers/gpio/gpio-ws16c48.c
@@ -388,7 +388,7 @@ static struct isa_driver ws16c48_driver = {
 	.remove = ws16c48_remove
 };
 
-module_isa_driver(ws16c48_driver, num_ws16c48);
+module_isa_driver(ws16c48_driver, num_ws16c48, num_ws16c48 > 0);
 
 MODULE_AUTHOR("William Breathitt Gray <vilhelm.gray@gmail.com>");
 MODULE_DESCRIPTION("WinSystems WS16C48 GPIO driver");
diff --git a/drivers/i2c/busses/i2c-elektor.c b/drivers/i2c/busses/i2c-elektor.c
index 8af62fb3fe41..10d9cdee64d9 100644
--- a/drivers/i2c/busses/i2c-elektor.c
+++ b/drivers/i2c/busses/i2c-elektor.c
@@ -328,4 +328,4 @@ module_param(irq, int, 0);
 module_param(clock, int, 0);
 module_param(own, int, 0);
 module_param(mmapped, int, 0);
-module_isa_driver(i2c_elektor_driver, 1);
+module_isa_driver(i2c_elektor_driver, 1, true);
diff --git a/drivers/i2c/busses/i2c-parport-light.c b/drivers/i2c/busses/i2c-parport-light.c
index 1bcdd10b68b9..d880a159d433 100644
--- a/drivers/i2c/busses/i2c-parport-light.c
+++ b/drivers/i2c/busses/i2c-parport-light.c
@@ -219,6 +219,11 @@ static int __init i2c_parport_init(void)
 {
 	int err;
 
+	if ((base || irq) && kernel_is_locked_down()) {
+		pr_err(DRVNAME ": Kernel is locked down\n");
+		return -EPERM;
+	}
+
 	if (type < 0) {
 		printk(KERN_ERR DRVNAME ": adapter type unspecified\n");
 		return -ENODEV;
diff --git a/drivers/i2c/busses/i2c-pca-isa.c b/drivers/i2c/busses/i2c-pca-isa.c
index ba88f17f636c..7b6764279e49 100644
--- a/drivers/i2c/busses/i2c-pca-isa.c
+++ b/drivers/i2c/busses/i2c-pca-isa.c
@@ -209,4 +209,4 @@ MODULE_PARM_DESC(clock, "Clock rate in hertz.\n\t\t"
 		"\t\t\t\tFast: 100100 - 400099\n"
 		"\t\t\t\tFast+: 400100 - 10000099\n"
 		"\t\t\t\tTurbo: Up to 1265800");
-module_isa_driver(pca_isa_driver, 1);
+module_isa_driver(pca_isa_driver, 1, true);
diff --git a/drivers/i2c/busses/scx200_acb.c b/drivers/i2c/busses/scx200_acb.c
index 0a7e410b6195..3506c0c571e9 100644
--- a/drivers/i2c/busses/scx200_acb.c
+++ b/drivers/i2c/busses/scx200_acb.c
@@ -41,8 +41,9 @@ MODULE_ALIAS("platform:cs5535-smb");
 MODULE_LICENSE("GPL");
 
 #define MAX_DEVICES 4
+static unsigned int nr_base = 0;
 static int base[MAX_DEVICES] = { 0x820, 0x840 };
-module_param_array(base, int, NULL, 0);
+module_param_array(base, int, &nr_base, 0);
 MODULE_PARM_DESC(base, "Base addresses for the ACCESS.bus controllers");
 
 #define POLL_TIMEOUT	(HZ/5)
@@ -573,6 +574,11 @@ static __init void scx200_scan_isa(void)
 
 static int __init scx200_acb_init(void)
 {
+	if (nr_base > 0 && kernel_is_locked_down()) {
+		pr_err("Kernel is locked down\n");
+		return -EPERM;
+	}
+
 	pr_debug("NatSemi SCx200 ACCESS.bus Driver\n");
 
 	/* First scan for ISA-based devices */
diff --git a/drivers/iio/adc/stx104.c b/drivers/iio/adc/stx104.c
index 7e3645749eaf..e4f1b28e9cc3 100644
--- a/drivers/iio/adc/stx104.c
+++ b/drivers/iio/adc/stx104.c
@@ -373,7 +373,7 @@ static struct isa_driver stx104_driver = {
 	.remove = stx104_remove
 };
 
-module_isa_driver(stx104_driver, num_stx104);
+module_isa_driver(stx104_driver, num_stx104, num_stx104 > 0);
 
 MODULE_AUTHOR("William Breathitt Gray <vilhelm.gray@gmail.com>");
 MODULE_DESCRIPTION("Apex Embedded Systems STX104 IIO driver");
diff --git a/drivers/iio/dac/cio-dac.c b/drivers/iio/dac/cio-dac.c
index 5a743e2a779d..acd82c64531c 100644
--- a/drivers/iio/dac/cio-dac.c
+++ b/drivers/iio/dac/cio-dac.c
@@ -137,7 +137,7 @@ static struct isa_driver cio_dac_driver = {
 	}
 };
 
-module_isa_driver(cio_dac_driver, num_cio_dac);
+module_isa_driver(cio_dac_driver, num_cio_dac, num_cio_dac > 0);
 
 MODULE_AUTHOR("William Breathitt Gray <vilhelm.gray@gmail.com>");
 MODULE_DESCRIPTION("Measurement Computing CIO-DAC IIO driver");
diff --git a/drivers/input/mouse/inport.c b/drivers/input/mouse/inport.c
index 3827a22362de..8d1b90fa8abd 100644
--- a/drivers/input/mouse/inport.c
+++ b/drivers/input/mouse/inport.c
@@ -132,6 +132,11 @@ static int __init inport_init(void)
 	unsigned char a, b, c;
 	int err;
 
+	if (inport_irq != INPORT_IRQ && kernel_is_locked_down()) {
+		pr_err("Kernel is locked down\n");
+		return -EPERM;
+	}
+
 	if (!request_region(INPORT_BASE, INPORT_EXTENT, "inport")) {
 		printk(KERN_ERR "inport.c: Can't allocate ports at %#x\n", INPORT_BASE);
 		return -EBUSY;
diff --git a/drivers/input/mouse/logibm.c b/drivers/input/mouse/logibm.c
index e2413113df22..5f7b9a18a276 100644
--- a/drivers/input/mouse/logibm.c
+++ b/drivers/input/mouse/logibm.c
@@ -121,6 +121,11 @@ static int __init logibm_init(void)
 {
 	int err;
 
+	if (logibm_irq != LOGIBM_IRQ && kernel_is_locked_down()) {
+		pr_err("Kernel is locked down\n");
+		return -EPERM;
+	}
+
 	if (!request_region(LOGIBM_BASE, LOGIBM_EXTENT, "logibm")) {
 		printk(KERN_ERR "logibm.c: Can't allocate ports at %#x\n", LOGIBM_BASE);
 		return -EBUSY;
diff --git a/drivers/input/touchscreen/mk712.c b/drivers/input/touchscreen/mk712.c
index 36e57deacd03..213d5f8555f8 100644
--- a/drivers/input/touchscreen/mk712.c
+++ b/drivers/input/touchscreen/mk712.c
@@ -153,6 +153,12 @@ static int __init mk712_init(void)
 {
 	int err;
 
+	if ((mk712_io != 0x260  || mk712_irq != 10) &&
+	    kernel_is_locked_down()) {
+		pr_err("Kernel is locked down\n");
+		return -EPERM;
+	}
+
 	if (!request_region(mk712_io, 8, "mk712")) {
 		printk(KERN_WARNING "mk712: unable to get IO region\n");
 		return -ENODEV;
diff --git a/drivers/isdn/hardware/avm/b1isa.c b/drivers/isdn/hardware/avm/b1isa.c
index 31ef8130a87f..47426c820c92 100644
--- a/drivers/isdn/hardware/avm/b1isa.c
+++ b/drivers/isdn/hardware/avm/b1isa.c
@@ -166,10 +166,11 @@ static char *b1isa_procinfo(struct capi_ctr *ctrl)
 
 #define MAX_CARDS 4
 static struct pci_dev isa_dev[MAX_CARDS];
+static unsigned int nr_io;
 static int io[MAX_CARDS];
 static int irq[MAX_CARDS];
 
-module_param_array(io, int, NULL, 0);
+module_param_array(io, int, &nr_io, 0);
 module_param_array(irq, int, NULL, 0);
 MODULE_PARM_DESC(io, "I/O base address(es)");
 MODULE_PARM_DESC(irq, "IRQ number(s) (assigned)");
@@ -203,6 +204,11 @@ static int __init b1isa_init(void)
 	char rev[32];
 	int i;
 
+	if (nr_io > 0 && kernel_is_locked_down()) {
+		pr_err("Kernel is locked down\n");
+		return -EPERM;
+	}
+
 	if ((p = strchr(revision, ':')) != NULL && p[1]) {
 		strlcpy(rev, p + 2, 32);
 		if ((p = strchr(rev, '$')) != NULL && p > rev)
diff --git a/drivers/isdn/hardware/avm/t1isa.c b/drivers/isdn/hardware/avm/t1isa.c
index 72ef18853951..1d6cb9de374b 100644
--- a/drivers/isdn/hardware/avm/t1isa.c
+++ b/drivers/isdn/hardware/avm/t1isa.c
@@ -512,11 +512,12 @@ static char *t1isa_procinfo(struct capi_ctr *ctrl)
 
 #define MAX_CARDS 4
 static struct pci_dev isa_dev[MAX_CARDS];
+static unsigned int nr_io;
 static int io[MAX_CARDS];
 static int irq[MAX_CARDS];
 static int cardnr[MAX_CARDS];
 
-module_param_array(io, int, NULL, 0);
+module_param_array(io, int, &nr_io, 0);
 module_param_array(irq, int, NULL, 0);
 module_param_array(cardnr, int, NULL, 0);
 MODULE_PARM_DESC(io, "I/O base address(es)");
@@ -552,6 +553,11 @@ static int __init t1isa_init(void)
 	char *p;
 	int i;
 
+	if (nr_io > 0 && kernel_is_locked_down()) {
+		pr_err("Kernel is locked down\n");
+		return -EPERM;
+	}
+
 	if ((p = strchr(revision, ':')) != NULL && p[1]) {
 		strlcpy(rev, p + 2, 32);
 		if ((p = strchr(rev, '$')) != NULL && p > rev)
diff --git a/drivers/isdn/hisax/config.c b/drivers/isdn/hisax/config.c
index bf04d2a3cf4a..6486174ff804 100644
--- a/drivers/isdn/hisax/config.c
+++ b/drivers/isdn/hisax/config.c
@@ -328,6 +328,7 @@ static char *HiSax_id = HiSaxID;
 /* Variables for insmod */
 static int type[HISAX_MAX_CARDS] = { 0, };
 static int protocol[HISAX_MAX_CARDS] = { 0, };
+static int nr_io;
 static int io[HISAX_MAX_CARDS] = { 0, };
 #undef IO0_IO1
 #ifdef CONFIG_HISAX_16_3
@@ -338,10 +339,12 @@ static int io[HISAX_MAX_CARDS] = { 0, };
 #define IO0_IO1
 #endif
 #ifdef IO0_IO1
+static int nr_io0, nr_io1;
 static int io0[HISAX_MAX_CARDS] = { 0, };
 static int io1[HISAX_MAX_CARDS] = { 0, };
 #endif
 static int irq[HISAX_MAX_CARDS] = { 0, };
+static int nr_mem;
 static int mem[HISAX_MAX_CARDS] = { 0, };
 static char *id = HiSaxID;
 
@@ -350,13 +353,13 @@ MODULE_AUTHOR("Karsten Keil");
 MODULE_LICENSE("GPL");
 module_param_array(type, int, NULL, 0);
 module_param_array(protocol, int, NULL, 0);
-module_param_array(io, int, NULL, 0);
+module_param_array(io, int, &nr_io, 0);
 module_param_array(irq, int, NULL, 0);
-module_param_array(mem, int, NULL, 0);
+module_param_array(mem, int, &nr_mem, 0);
 module_param(id, charp, 0);
 #ifdef IO0_IO1
-module_param_array(io0, int, NULL, 0);
-module_param_array(io1, int, NULL, 0);
+module_param_array(io0, int, &nr_io0, 0);
+module_param_array(io1, int, &nr_io1, 0);
 #endif
 #endif /* MODULE */
 
@@ -1338,6 +1341,15 @@ static int __init HiSax_init(void)
 	int nzproto = 0;
 #endif
 
+	if ((nr_io > 0 || nr_mem > 0
+#ifdef IO0_IO1
+	     || nr_io0 > 0 || nr_io1 > 0
+#endif
+	     ) && kernel_is_locked_down()) {
+		pr_err("Kernel is locked down\n");
+		return -EPERM;
+	}
+	
 	HiSaxVersion();
 	retval = CallcNew();
 	if (retval)
diff --git a/drivers/media/pci/zoran/zoran_card.c b/drivers/media/pci/zoran/zoran_card.c
index 9d2697f5b455..6576df6ae4fd 100644
--- a/drivers/media/pci/zoran/zoran_card.c
+++ b/drivers/media/pci/zoran/zoran_card.c
@@ -1466,6 +1466,11 @@ static int __init zoran_init(void)
 {
 	int res;
 
+	if (vidmem && kernel_is_locked_down()) {
+		pr_err("Kernel is locked down\n");
+		return -EPERM;
+	}
+
 	printk(KERN_INFO "Zoran MJPEG board driver version %s\n",
 	       ZORAN_VERSION);
 
diff --git a/drivers/misc/dummy-irq.c b/drivers/misc/dummy-irq.c
index acbbe0390be4..88a56e38d615 100644
--- a/drivers/misc/dummy-irq.c
+++ b/drivers/misc/dummy-irq.c
@@ -40,6 +40,12 @@ static int __init dummy_irq_init(void)
 		printk(KERN_ERR "dummy-irq: no IRQ given.  Use irq=N\n");
 		return -EIO;
 	}
+
+	if (kernel_is_locked_down()) {
+		pr_err("Kernel is locked down\n");
+		return -EPERM;
+	}
+
 	if (request_irq(irq, &dummy_interrupt, IRQF_SHARED, "dummy_irq", &irq)) {
 		printk(KERN_ERR "dummy-irq: cannot register IRQ %d\n", irq);
 		return -EIO;
diff --git a/drivers/mmc/host/wbsd.c b/drivers/mmc/host/wbsd.c
index c3fd16d997ca..860e0452fd70 100644
--- a/drivers/mmc/host/wbsd.c
+++ b/drivers/mmc/host/wbsd.c
@@ -1939,6 +1939,12 @@ static int __init wbsd_drv_init(void)
 {
 	int result;
 
+	if ((param_io != 0x248 || param_irq != 6 || param_dma != 2) &&
+	    kernel_is_locked_down()) {
+		pr_err("Kernel is locked down\n");
+		return -EPERM;
+	}
+
 	pr_info(DRIVER_NAME
 		": Winbond W83L51xD SD/MMC card interface driver\n");
 	pr_info(DRIVER_NAME ": Copyright(c) Pierre Ossman\n");
diff --git a/drivers/net/appletalk/cops.c b/drivers/net/appletalk/cops.c
index 1b2e9217ec78..819120cd7f0d 100644
--- a/drivers/net/appletalk/cops.c
+++ b/drivers/net/appletalk/cops.c
@@ -992,6 +992,12 @@ module_param(board_type, int, 0);
 
 static int __init cops_module_init(void)
 {
+	if ((io != 0x240 || irq != 5) &&
+	    kernel_is_locked_down()) {
+		pr_err("Kernel is locked down\n");
+		return -EPERM;
+	}
+
 	if (io == 0)
 		printk(KERN_WARNING "%s: You shouldn't autoprobe with insmod\n",
 			cardname);
diff --git a/drivers/net/appletalk/ltpc.c b/drivers/net/appletalk/ltpc.c
index 01e2ac55c137..25a4c244bb1d 100644
--- a/drivers/net/appletalk/ltpc.c
+++ b/drivers/net/appletalk/ltpc.c
@@ -1238,6 +1238,11 @@ module_param(dma, int, 0);
 
 static int __init ltpc_module_init(void)
 {
+	if ((io || irq || dma) && kernel_is_locked_down()) {
+		pr_err("Kernel is locked down\n");
+		return -EPERM;
+	}
+
         if(io == 0)
 		printk(KERN_NOTICE
 		       "ltpc: Autoprobing is not recommended for modules\n");
diff --git a/drivers/net/arcnet/com20020-isa.c b/drivers/net/arcnet/com20020-isa.c
index b9e9931353b2..9578bc7bbee4 100644
--- a/drivers/net/arcnet/com20020-isa.c
+++ b/drivers/net/arcnet/com20020-isa.c
@@ -146,6 +146,11 @@ static int __init com20020_init(void)
 	struct net_device *dev;
 	struct arcnet_local *lp;
 
+	if ((io || irq) && kernel_is_locked_down()) {
+		pr_err("Kernel is locked down\n");
+		return -EPERM;
+	}
+
 	dev = alloc_arcdev(device);
 	if (!dev)
 		return -ENOMEM;
diff --git a/drivers/net/arcnet/com90io.c b/drivers/net/arcnet/com90io.c
index b57863df5bf5..49b43df591ec 100644
--- a/drivers/net/arcnet/com90io.c
+++ b/drivers/net/arcnet/com90io.c
@@ -382,6 +382,11 @@ static int __init com90io_init(void)
 	struct net_device *dev;
 	int err;
 
+	if ((io || irq) && kernel_is_locked_down()) {
+		pr_err("Kernel is locked down\n");
+		return -EPERM;
+	}
+
 	dev = alloc_arcdev(device);
 	if (!dev)
 		return -ENOMEM;
diff --git a/drivers/net/arcnet/com90xx.c b/drivers/net/arcnet/com90xx.c
index 81f90c4703ae..567fc40ed272 100644
--- a/drivers/net/arcnet/com90xx.c
+++ b/drivers/net/arcnet/com90xx.c
@@ -648,6 +648,11 @@ MODULE_LICENSE("GPL");
 
 static int __init com90xx_init(void)
 {
+	if ((io || irq || shmem) && kernel_is_locked_down()) {
+		pr_err("Kernel is locked down\n");
+		return -EPERM;
+	}
+
 	if (irq == 2)
 		irq = 9;
 	com90xx_probe();
diff --git a/drivers/net/can/cc770/cc770_isa.c b/drivers/net/can/cc770/cc770_isa.c
index e0d15711e9ac..355b15850406 100644
--- a/drivers/net/can/cc770/cc770_isa.c
+++ b/drivers/net/can/cc770/cc770_isa.c
@@ -73,6 +73,7 @@ MODULE_LICENSE("GPL v2");
 #define COR_DEFAULT	0x00
 #define BCR_DEFAULT	BUSCFG_CBY
 
+static unsigned int nr_port, nr_mem;
 static unsigned long port[MAXDEV];
 static unsigned long mem[MAXDEV];
 static int irq[MAXDEV];
@@ -82,10 +83,10 @@ static u8 cor[MAXDEV] = {[0 ... (MAXDEV - 1)] = 0xff};
 static u8 bcr[MAXDEV] = {[0 ... (MAXDEV - 1)] = 0xff};
 static int indirect[MAXDEV] = {[0 ... (MAXDEV - 1)] = -1};
 
-module_param_array(port, ulong, NULL, S_IRUGO);
+module_param_array(port, ulong, &nr_port, S_IRUGO);
 MODULE_PARM_DESC(port, "I/O port number");
 
-module_param_array(mem, ulong, NULL, S_IRUGO);
+module_param_array(mem, ulong, &nr_mem, S_IRUGO);
 MODULE_PARM_DESC(mem, "I/O memory address");
 
 module_param_array(indirect, int, NULL, S_IRUGO);
@@ -325,6 +326,11 @@ static int __init cc770_isa_init(void)
 {
 	int idx, err;
 
+	if ((nr_port > 0 || nr_mem > 0) && kernel_is_locked_down()) {
+		pr_err("Kernel is locked down\n");
+		return -EPERM;
+	}
+
 	for (idx = 0; idx < ARRAY_SIZE(cc770_isa_devs); idx++) {
 		if ((port[idx] || mem[idx]) && irq[idx]) {
 			cc770_isa_devs[idx] =
diff --git a/drivers/net/can/sja1000/sja1000_isa.c b/drivers/net/can/sja1000/sja1000_isa.c
index e97e6d35b300..9cd0ffca6aad 100644
--- a/drivers/net/can/sja1000/sja1000_isa.c
+++ b/drivers/net/can/sja1000/sja1000_isa.c
@@ -39,6 +39,7 @@ MODULE_LICENSE("GPL v2");
 #define CDR_DEFAULT	(CDR_CBP | CDR_CLK_OFF)
 #define OCR_DEFAULT	OCR_TX0_PUSHPULL
 
+static unsigned int nr_port, nr_mem;
 static unsigned long port[MAXDEV];
 static unsigned long mem[MAXDEV];
 static int irq[MAXDEV];
@@ -48,10 +49,10 @@ static unsigned char ocr[MAXDEV] = {[0 ... (MAXDEV - 1)] = 0xff};
 static int indirect[MAXDEV] = {[0 ... (MAXDEV - 1)] = -1};
 static spinlock_t indirect_lock[MAXDEV];  /* lock for indirect access mode */
 
-module_param_array(port, ulong, NULL, S_IRUGO);
+module_param_array(port, ulong, &nr_port, S_IRUGO);
 MODULE_PARM_DESC(port, "I/O port number");
 
-module_param_array(mem, ulong, NULL, S_IRUGO);
+module_param_array(mem, ulong, &nr_mem, S_IRUGO);
 MODULE_PARM_DESC(mem, "I/O memory address");
 
 module_param_array(indirect, int, NULL, S_IRUGO);
@@ -266,6 +267,11 @@ static int __init sja1000_isa_init(void)
 {
 	int idx, err;
 
+	if ((nr_port > 0 || nr_mem > 0) && kernel_is_locked_down()) {
+		pr_err("Kernel is locked down\n");
+		return -EPERM;
+	}
+
 	for (idx = 0; idx < MAXDEV; idx++) {
 		if ((port[idx] || mem[idx]) && irq[idx]) {
 			sja1000_isa_devs[idx] =
diff --git a/drivers/net/ethernet/3com/3c509.c b/drivers/net/ethernet/3com/3c509.c
index 91ada52f776b..8f5a4915dac9 100644
--- a/drivers/net/ethernet/3com/3c509.c
+++ b/drivers/net/ethernet/3com/3c509.c
@@ -177,6 +177,7 @@ static struct net_device *el3_devs[EL3_MAX_CARDS];
 
 /* Parameters that may be passed into the module. */
 static int debug = -1;
+static unsigned int nr_irq;
 static int irq[] = {-1, -1, -1, -1, -1, -1, -1, -1};
 /* Maximum events (Rx packets, etc.) to handle at each interrupt. */
 static int max_interrupt_work = 10;
@@ -1369,7 +1370,7 @@ el3_resume(struct device *pdev)
 #endif /* CONFIG_PM */
 
 module_param(debug,int, 0);
-module_param_array(irq, int, NULL, 0);
+module_param_array(irq, int, &nr_irq, 0);
 module_param(max_interrupt_work, int, 0);
 MODULE_PARM_DESC(debug, "debug level (0-6)");
 MODULE_PARM_DESC(irq, "IRQ number(s) (assigned)");
@@ -1385,6 +1386,11 @@ static int __init el3_init_module(void)
 {
 	int ret = 0;
 
+	if (nr_irq > 0 && kernel_is_locked_down()) {
+		pr_err("Kernel is locked down\n");
+		return -EPERM;
+	}
+
 	if (debug >= 0)
 		el3_debug = debug;
 
diff --git a/drivers/net/ethernet/3com/3c59x.c b/drivers/net/ethernet/3com/3c59x.c
index 9133e7926da5..02fc41e9d3d0 100644
--- a/drivers/net/ethernet/3com/3c59x.c
+++ b/drivers/net/ethernet/3com/3c59x.c
@@ -3330,6 +3330,11 @@ static int __init vortex_init(void)
 {
 	int pci_rc, eisa_rc;
 
+	if ((compaq_ioaddr || compaq_irq) && kernel_is_locked_down()) {
+		pr_err("Kernel is locked down\n");
+		return -EPERM;
+	}
+
 	pci_rc = pci_register_driver(&vortex_driver);
 	eisa_rc = vortex_eisa_init();
 
diff --git a/drivers/net/ethernet/8390/ne.c b/drivers/net/ethernet/8390/ne.c
index c063b410a163..ee2945c17ceb 100644
--- a/drivers/net/ethernet/8390/ne.c
+++ b/drivers/net/ethernet/8390/ne.c
@@ -74,8 +74,9 @@ static int bad[MAX_NE_CARDS];
 static u32 ne_msg_enable;
 
 #ifdef MODULE
-module_param_array(io, int, NULL, 0);
-module_param_array(irq, int, NULL, 0);
+static unsigned int nr_io, nr_irq;
+module_param_array(io, int, &nr_io, 0);
+module_param_array(irq, int, &nr_irq, 0);
 module_param_array(bad, int, NULL, 0);
 module_param_named(msg_enable, ne_msg_enable, uint, (S_IRUSR|S_IRGRP|S_IROTH));
 MODULE_PARM_DESC(io, "I/O base address(es),required");
@@ -943,6 +944,12 @@ static void __init ne_add_devices(void)
 int __init init_module(void)
 {
 	int retval;
+
+	if ((nr_io > 0 || nr_irq > 0) && kernel_is_locked_down()) {
+		pr_err("Kernel is locked down\n");
+		return -EPERM;
+	}
+
 	ne_add_devices();
 	retval = platform_driver_probe(&ne_driver, ne_drv_probe);
 	if (retval) {
diff --git a/drivers/net/ethernet/8390/smc-ultra.c b/drivers/net/ethernet/8390/smc-ultra.c
index 139385dcdaa7..f469e008ad78 100644
--- a/drivers/net/ethernet/8390/smc-ultra.c
+++ b/drivers/net/ethernet/8390/smc-ultra.c
@@ -559,10 +559,11 @@ ultra_close_card(struct net_device *dev)
 #ifdef MODULE
 #define MAX_ULTRA_CARDS	4	/* Max number of Ultra cards per module */
 static struct net_device *dev_ultra[MAX_ULTRA_CARDS];
+static unsigned int nr_io;
 static int io[MAX_ULTRA_CARDS];
 static int irq[MAX_ULTRA_CARDS];
 
-module_param_array(io, int, NULL, 0);
+module_param_array(io, int, &nr_io, 0);
 module_param_array(irq, int, NULL, 0);
 module_param_named(msg_enable, ultra_msg_enable, uint, (S_IRUSR|S_IRGRP|S_IROTH));
 MODULE_PARM_DESC(io, "I/O base address(es)");
@@ -579,6 +580,11 @@ init_module(void)
 	struct net_device *dev;
 	int this_dev, found = 0;
 
+	if (nr_io > 0 && kernel_is_locked_down()) {
+		pr_err("Kernel is locked down\n");
+		return -EPERM;
+	}
+
 	for (this_dev = 0; this_dev < MAX_ULTRA_CARDS; this_dev++) {
 		if (io[this_dev] == 0)  {
 			if (this_dev != 0) break; /* only autoprobe 1st one */
diff --git a/drivers/net/ethernet/8390/wd.c b/drivers/net/ethernet/8390/wd.c
index dd7d816bde52..fefa27e42865 100644
--- a/drivers/net/ethernet/8390/wd.c
+++ b/drivers/net/ethernet/8390/wd.c
@@ -499,12 +499,13 @@ wd_close(struct net_device *dev)
 #ifdef MODULE
 #define MAX_WD_CARDS	4	/* Max number of wd cards per module */
 static struct net_device *dev_wd[MAX_WD_CARDS];
+static int nr_io;
 static int io[MAX_WD_CARDS];
 static int irq[MAX_WD_CARDS];
 static int mem[MAX_WD_CARDS];
 static int mem_end[MAX_WD_CARDS];	/* for non std. mem size */
 
-module_param_array(io, int, NULL, 0);
+module_param_array(io, int, &nr_io, 0);
 module_param_array(irq, int, NULL, 0);
 module_param_array(mem, int, NULL, 0);
 module_param_array(mem_end, int, NULL, 0);
@@ -525,6 +526,11 @@ int __init init_module(void)
 	struct net_device *dev;
 	int this_dev, found = 0;
 
+	if (nr_io > 0 && kernel_is_locked_down()) {
+		pr_err("Kernel is locked down\n");
+		return -EPERM;
+	}
+
 	for (this_dev = 0; this_dev < MAX_WD_CARDS; this_dev++) {
 		if (io[this_dev] == 0)  {
 			if (this_dev != 0) break; /* only autoprobe 1st one */
diff --git a/drivers/net/ethernet/amd/lance.c b/drivers/net/ethernet/amd/lance.c
index abb1ba228b26..80d860bcb4ea 100644
--- a/drivers/net/ethernet/amd/lance.c
+++ b/drivers/net/ethernet/amd/lance.c
@@ -314,11 +314,12 @@ static void lance_tx_timeout (struct net_device *dev);
 #define MAX_CARDS		8	/* Max number of interfaces (cards) per module */
 
 static struct net_device *dev_lance[MAX_CARDS];
+static int nr_io;
 static int io[MAX_CARDS];
 static int dma[MAX_CARDS];
 static int irq[MAX_CARDS];
 
-module_param_array(io, int, NULL, 0);
+module_param_array(io, int, &nr_io, 0);
 module_param_array(dma, int, NULL, 0);
 module_param_array(irq, int, NULL, 0);
 module_param(lance_debug, int, 0);
@@ -332,6 +333,11 @@ int __init init_module(void)
 	struct net_device *dev;
 	int this_dev, found = 0;
 
+	if (nr_io > 0 && kernel_is_locked_down()) {
+		pr_err("Kernel is locked down\n");
+		return -EPERM;
+	}
+
 	for (this_dev = 0; this_dev < MAX_CARDS; this_dev++) {
 		if (io[this_dev] == 0)  {
 			if (this_dev != 0) /* only complain once */
diff --git a/drivers/net/ethernet/amd/ni65.c b/drivers/net/ethernet/amd/ni65.c
index cda53db75f17..33b724658bb0 100644
--- a/drivers/net/ethernet/amd/ni65.c
+++ b/drivers/net/ethernet/amd/ni65.c
@@ -1237,6 +1237,11 @@ MODULE_PARM_DESC(dma, "ni6510 ISA DMA channel (ignored for some cards)");
 
 int __init init_module(void)
 {
+	if ((irq || io || dma) && kernel_is_locked_down()) {
+		pr_err("Kernel is locked down\n");
+		return -EPERM;
+	}
+
  	dev_ni65 = ni65_probe(-1);
 	return PTR_ERR_OR_ZERO(dev_ni65);
 }
diff --git a/drivers/net/ethernet/cirrus/cs89x0.c b/drivers/net/ethernet/cirrus/cs89x0.c
index c363b58552e9..8b069d25461f 100644
--- a/drivers/net/ethernet/cirrus/cs89x0.c
+++ b/drivers/net/ethernet/cirrus/cs89x0.c
@@ -1765,6 +1765,11 @@ int __init init_module(void)
 	struct net_local *lp;
 	int ret = 0;
 
+	if ((io || irq || dma) && kernel_is_locked_down()) {
+		pr_err("Kernel is locked down\n");
+		return -EPERM;
+	}
+
 #if DEBUGGING
 	net_debug = debug;
 #else
diff --git a/drivers/net/ethernet/dec/tulip/de4x5.c b/drivers/net/ethernet/dec/tulip/de4x5.c
index 6620fc861c47..64c312c81fe4 100644
--- a/drivers/net/ethernet/dec/tulip/de4x5.c
+++ b/drivers/net/ethernet/dec/tulip/de4x5.c
@@ -5554,6 +5554,11 @@ static int __init de4x5_module_init (void)
 {
 	int err = 0;
 
+	if (io && kernel_is_locked_down()) {
+		pr_err("Kernel is locked down\n");
+		return -EPERM;
+	}
+
 #ifdef CONFIG_PCI
 	err = pci_register_driver(&de4x5_pci_driver);
 #endif
diff --git a/drivers/net/ethernet/hp/hp100.c b/drivers/net/ethernet/hp/hp100.c
index 631dbc7b4dbb..c420e8e077d9 100644
--- a/drivers/net/ethernet/hp/hp100.c
+++ b/drivers/net/ethernet/hp/hp100.c
@@ -2967,8 +2967,9 @@ MODULE_DESCRIPTION("HP CASCADE Architecture Driver for 100VG-AnyLan Network Adap
 #if defined(MODULE) && defined(CONFIG_ISA)
 #define HP100_DEVICES 5
 /* Parameters set by insmod */
+static int hp100_nr_ports;
 static int hp100_port[HP100_DEVICES] = { 0, [1 ... (HP100_DEVICES-1)] = -1 };
-module_param_array(hp100_port, int, NULL, 0);
+module_param_array(hp100_port, int, &hp100_nr_ports, 0);
 
 /* List of devices */
 static struct net_device *hp100_devlist[HP100_DEVICES];
@@ -2978,6 +2979,11 @@ static int __init hp100_isa_init(void)
 	struct net_device *dev;
 	int i, err, cards = 0;
 
+	if (hp100_nr_ports > 0 && kernel_is_locked_down()) {
+		pr_err("Kernel is locked down\n");
+		return -EPERM;
+	}
+	
 	/* Don't autoprobe ISA bus */
 	if (hp100_port[0] == 0)
 		return -ENODEV;
diff --git a/drivers/net/ethernet/realtek/atp.c b/drivers/net/ethernet/realtek/atp.c
index 5cb96785fb63..8296397d5697 100644
--- a/drivers/net/ethernet/realtek/atp.c
+++ b/drivers/net/ethernet/realtek/atp.c
@@ -45,6 +45,7 @@ static int max_interrupt_work = 15;
 
 #define NUM_UNITS 2
 /* The standard set of ISA module parameters. */
+static unsigned int nr_io, nr_irq;
 static int io[NUM_UNITS];
 static int irq[NUM_UNITS];
 static int xcvr[NUM_UNITS]; 			/* The data transfer mode. */
@@ -151,8 +152,8 @@ MODULE_LICENSE("GPL");
 
 module_param(max_interrupt_work, int, 0);
 module_param(debug, int, 0);
-module_param_array(io, int, NULL, 0);
-module_param_array(irq, int, NULL, 0);
+module_param_array(io, int, &nr_io, 0);
+module_param_array(irq, int, &nr_irq, 0);
 module_param_array(xcvr, int, NULL, 0);
 MODULE_PARM_DESC(max_interrupt_work, "ATP maximum events handled per interrupt");
 MODULE_PARM_DESC(debug, "ATP debug level (0-7)");
@@ -860,7 +861,13 @@ static void set_rx_mode(struct net_device *dev)
 	write_reg_high(ioaddr, CMR2, lp->addr_mode);
 }
 
-static int __init atp_init_module(void) {
+static int __init atp_init_module(void)
+{
+	if ((nr_io > 0 || nr_irq > 0) && kernel_is_locked_down()) {
+		pr_err("Kernel is locked down\n");
+		return -EPERM;
+	}
+
 	if (debug)					/* Emit version even if no cards detected. */
 		printk(KERN_INFO "%s", version);
 	return atp_init();
diff --git a/drivers/net/ethernet/smsc/smc9194.c b/drivers/net/ethernet/smsc/smc9194.c
index d496888b85d3..1de9203dc29e 100644
--- a/drivers/net/ethernet/smsc/smc9194.c
+++ b/drivers/net/ethernet/smsc/smc9194.c
@@ -1511,6 +1511,11 @@ MODULE_PARM_DESC(ifport, "SMC 99194 interface port (0-default, 1-TP, 2-AUI)");
 
 int __init init_module(void)
 {
+	if ((io || irq) && kernel_is_locked_down()) {
+		pr_err("Kernel is locked down\n");
+		return -EPERM;
+	}
+
 	if (io == 0)
 		printk(KERN_WARNING
 		CARDNAME": You shouldn't use auto-probing with insmod!\n" );
diff --git a/drivers/net/hamradio/baycom_epp.c b/drivers/net/hamradio/baycom_epp.c
index 78dbc44540f6..4b60b617fdf4 100644
--- a/drivers/net/hamradio/baycom_epp.c
+++ b/drivers/net/hamradio/baycom_epp.c
@@ -1167,12 +1167,13 @@ static void baycom_probe(struct net_device *dev)
 /*
  * command line settable parameters
  */
+static unsigned int nr_iobase;
 static char *mode[NR_PORTS] = { "", };
 static int iobase[NR_PORTS] = { 0x378, };
 
 module_param_array(mode, charp, NULL, 0);
 MODULE_PARM_DESC(mode, "baycom operating mode");
-module_param_array(iobase, int, NULL, 0);
+module_param_array(iobase, int, &nr_iobase, 0);
 MODULE_PARM_DESC(iobase, "baycom io base address");
 
 MODULE_AUTHOR("Thomas M. Sailer, sailer@ife.ee.ethz.ch, hb9jnx@hb9w.che.eu");
@@ -1203,6 +1204,11 @@ static int __init init_baycomepp(void)
 	int i, found = 0;
 	char set_hw = 1;
 
+	if (nr_iobase > 0 && kernel_is_locked_down()) {
+		pr_err("Kernel is locked down\n");
+		return -EPERM;
+	}
+	
 	printk(bc_drvinfo);
 	/*
 	 * register net devices
diff --git a/drivers/net/hamradio/baycom_par.c b/drivers/net/hamradio/baycom_par.c
index 072cddce9264..c696d32a848a 100644
--- a/drivers/net/hamradio/baycom_par.c
+++ b/drivers/net/hamradio/baycom_par.c
@@ -476,12 +476,13 @@ static int baycom_ioctl(struct net_device *dev, struct ifreq *ifr,
 /*
  * command line settable parameters
  */
+static unsigned int nr_iobase;
 static char *mode[NR_PORTS] = { "picpar", };
 static int iobase[NR_PORTS] = { 0x378, };
 
 module_param_array(mode, charp, NULL, 0);
 MODULE_PARM_DESC(mode, "baycom operating mode; eg. par96 or picpar");
-module_param_array(iobase, int, NULL, 0);
+module_param_array(iobase, int, &nr_iobase, 0);
 MODULE_PARM_DESC(iobase, "baycom io base address");
 
 MODULE_AUTHOR("Thomas M. Sailer, sailer@ife.ee.ethz.ch, hb9jnx@hb9w.che.eu");
@@ -495,6 +496,11 @@ static int __init init_baycompar(void)
 	int i, found = 0;
 	char set_hw = 1;
 
+	if (nr_iobase > 0 && kernel_is_locked_down()) {
+		pr_err("Kernel is locked down\n");
+		return -EPERM;
+	}
+
 	printk(bc_drvinfo);
 	/*
 	 * register net devices
diff --git a/drivers/net/hamradio/baycom_ser_fdx.c b/drivers/net/hamradio/baycom_ser_fdx.c
index 7b916d5b14b9..4712fb402cef 100644
--- a/drivers/net/hamradio/baycom_ser_fdx.c
+++ b/drivers/net/hamradio/baycom_ser_fdx.c
@@ -607,6 +607,7 @@ static int baycom_ioctl(struct net_device *dev, struct ifreq *ifr,
 /*
  * command line settable parameters
  */
+static unsigned int nr_iobase, nr_irq;
 static char *mode[NR_PORTS] = { "ser12*", };
 static int iobase[NR_PORTS] = { 0x3f8, };
 static int irq[NR_PORTS] = { 4, };
@@ -614,9 +615,9 @@ static int baud[NR_PORTS] = { [0 ... NR_PORTS-1] = 1200 };
 
 module_param_array(mode, charp, NULL, 0);
 MODULE_PARM_DESC(mode, "baycom operating mode; * for software DCD");
-module_param_array(iobase, int, NULL, 0);
+module_param_array(iobase, int, &nr_iobase, 0);
 MODULE_PARM_DESC(iobase, "baycom io base address");
-module_param_array(irq, int, NULL, 0);
+module_param_array(irq, int, &nr_irq, 0);
 MODULE_PARM_DESC(irq, "baycom irq number");
 module_param_array(baud, int, NULL, 0);
 MODULE_PARM_DESC(baud, "baycom baud rate (300 to 4800)");
@@ -632,6 +633,11 @@ static int __init init_baycomserfdx(void)
 	int i, found = 0;
 	char set_hw = 1;
 
+	if ((nr_iobase > 0 || nr_irq > 0) && kernel_is_locked_down()) {
+		pr_err("Kernel is locked down\n");
+		return -EPERM;
+	}
+
 	printk(bc_drvinfo);
 	/*
 	 * register net devices
diff --git a/drivers/net/hamradio/baycom_ser_hdx.c b/drivers/net/hamradio/baycom_ser_hdx.c
index f9a8976195ba..354fdf24cd06 100644
--- a/drivers/net/hamradio/baycom_ser_hdx.c
+++ b/drivers/net/hamradio/baycom_ser_hdx.c
@@ -636,15 +636,16 @@ static int baycom_ioctl(struct net_device *dev, struct ifreq *ifr,
 /*
  * command line settable parameters
  */
+static unsigned int nr_iobase, nr_irq;
 static char *mode[NR_PORTS] = { "ser12*", };
 static int iobase[NR_PORTS] = { 0x3f8, };
 static int irq[NR_PORTS] = { 4, };
 
 module_param_array(mode, charp, NULL, 0);
 MODULE_PARM_DESC(mode, "baycom operating mode; * for software DCD");
-module_param_array(iobase, int, NULL, 0);
+module_param_array(iobase, int, &nr_iobase, 0);
 MODULE_PARM_DESC(iobase, "baycom io base address");
-module_param_array(irq, int, NULL, 0);
+module_param_array(irq, int, &nr_irq, 0);
 MODULE_PARM_DESC(irq, "baycom irq number");
 
 MODULE_AUTHOR("Thomas M. Sailer, sailer@ife.ee.ethz.ch, hb9jnx@hb9w.che.eu");
@@ -658,6 +659,11 @@ static int __init init_baycomserhdx(void)
 	int i, found = 0;
 	char set_hw = 1;
 
+	if ((nr_iobase > 0 || nr_irq > 0) && kernel_is_locked_down()) {
+		pr_err("Kernel is locked down\n");
+		return -EPERM;
+	}
+
 	printk(bc_drvinfo);
 	/*
 	 * register net devices
diff --git a/drivers/net/hamradio/dmascc.c b/drivers/net/hamradio/dmascc.c
index e4137c1b3df9..39071fe8dd0a 100644
--- a/drivers/net/hamradio/dmascc.c
+++ b/drivers/net/hamradio/dmascc.c
@@ -259,7 +259,7 @@ static void tm_isr(struct scc_priv *priv);
 
 
 /* Initialization variables */
-
+static unsigned int nr_io;
 static int io[MAX_NUM_DEVS] __initdata = { 0, };
 
 /* Beware! hw[] is also used in dmascc_exit(). */
@@ -274,7 +274,7 @@ static unsigned long rand;
 
 MODULE_AUTHOR("Klaus Kudielka");
 MODULE_DESCRIPTION("Driver for high-speed SCC boards");
-module_param_array(io, int, NULL, 0);
+module_param_array(io, int, &nr_io, 0);
 MODULE_LICENSE("GPL");
 
 static void __exit dmascc_exit(void)
@@ -314,6 +314,11 @@ static int __init dmascc_init(void)
 	unsigned long time, start[MAX_NUM_DEVS], delay[MAX_NUM_DEVS],
 	    counting[MAX_NUM_DEVS];
 
+	if (nr_io > 0 && kernel_is_locked_down()) {
+		pr_err("Kernel is locked down\n");
+		return -EPERM;
+	}
+
 	/* Initialize random number generator */
 	rand = jiffies;
 	/* Cards found = 0 */
diff --git a/drivers/net/irda/ali-ircc.c b/drivers/net/irda/ali-ircc.c
index c285eafd3f1c..bcd0f6298c78 100644
--- a/drivers/net/irda/ali-ircc.c
+++ b/drivers/net/irda/ali-ircc.c
@@ -68,6 +68,7 @@ static struct platform_driver ali_ircc_driver = {
 static int qos_mtt_bits = 0x07;  /* 1 ms or more */
 
 /* Use BIOS settions by default, but user may supply module parameters */
+static unsigned int nr_io, nr_irq, nr_dma;
 static unsigned int io[]  = { ~0, ~0, ~0, ~0 };
 static unsigned int irq[] = { 0, 0, 0, 0 };
 static unsigned int dma[] = { 0, 0, 0, 0 };
@@ -152,6 +153,12 @@ static int __init ali_ircc_init(void)
 	int cfg, cfg_base;
 	int reg, revision;
 	int i = 0;
+
+	if ((nr_io > 0 || nr_irq > 0 || nr_dma > 0) &&
+	    kernel_is_locked_down()) {
+		pr_err("Kernel is locked down\n");
+		return -EPERM;
+	}
 	
 	ret = platform_driver_register(&ali_ircc_driver);
         if (ret) {
@@ -2207,11 +2214,11 @@ MODULE_LICENSE("GPL");
 MODULE_ALIAS("platform:" ALI_IRCC_DRIVER_NAME);
 
 
-module_param_array(io, int, NULL, 0);
+module_param_array(io, int, &nr_io, 0);
 MODULE_PARM_DESC(io, "Base I/O addresses");
-module_param_array(irq, int, NULL, 0);
+module_param_array(irq, int, &nr_irq, 0);
 MODULE_PARM_DESC(irq, "IRQ lines");
-module_param_array(dma, int, NULL, 0);
+module_param_array(dma, int, &nr_dma, 0);
 MODULE_PARM_DESC(dma, "DMA channels");
 
 module_init(ali_ircc_init);
diff --git a/drivers/net/irda/nsc-ircc.c b/drivers/net/irda/nsc-ircc.c
index aaecc3baaf30..9a076437fc2c 100644
--- a/drivers/net/irda/nsc-ircc.c
+++ b/drivers/net/irda/nsc-ircc.c
@@ -91,6 +91,7 @@ static int qos_mtt_bits = 0x07;  /* 1 ms or more */
 static int dongle_id;
 
 /* Use BIOS settions by default, but user may supply module parameters */
+static unsigned int nr_io, nr_irq, nr_dma;
 static unsigned int io[]  = { ~0, ~0, ~0, ~0, ~0 };
 static unsigned int irq[] = {  0,  0,  0,  0,  0 };
 static unsigned int dma[] = {  0,  0,  0,  0,  0 };
@@ -209,6 +210,12 @@ static int __init nsc_ircc_init(void)
 	int reg;
 	int i = 0;
 
+	if ((nr_io > 0 || nr_irq > 0 || nr_dma > 0) &&
+	    kernel_is_locked_down()) {
+		pr_err("Kernel is locked down\n");
+		return -EPERM;
+	}
+
 	ret = platform_driver_register(&nsc_ircc_driver);
         if (ret) {
 		net_err_ratelimited("%s, Can't register driver!\n",
@@ -2396,11 +2403,11 @@ MODULE_LICENSE("GPL");
 
 module_param(qos_mtt_bits, int, 0);
 MODULE_PARM_DESC(qos_mtt_bits, "Minimum Turn Time");
-module_param_array(io, int, NULL, 0);
+module_param_array(io, int, &nr_io, 0);
 MODULE_PARM_DESC(io, "Base I/O addresses");
-module_param_array(irq, int, NULL, 0);
+module_param_array(irq, int, &nr_irq, 0);
 MODULE_PARM_DESC(irq, "IRQ lines");
-module_param_array(dma, int, NULL, 0);
+module_param_array(dma, int, &nr_dma, 0);
 MODULE_PARM_DESC(dma, "DMA channels");
 module_param(dongle_id, int, 0);
 MODULE_PARM_DESC(dongle_id, "Type-id of used dongle");
diff --git a/drivers/net/irda/smsc-ircc2.c b/drivers/net/irda/smsc-ircc2.c
index dcf92ba80872..2cbeb63000de 100644
--- a/drivers/net/irda/smsc-ircc2.c
+++ b/drivers/net/irda/smsc-ircc2.c
@@ -463,6 +463,13 @@ static int __init smsc_ircc_init(void)
 
 	pr_debug("%s\n", __func__);
 
+	if ((ircc_fir || ircc_sir || ircc_cfg ||
+	     ircc_dma != DMA_INVAL || ircc_irq != IRQ_INVAL) &&
+	    kernel_is_locked_down()) {
+		pr_err("Kernel is locked down\n");
+		return -EPERM;
+	}
+
 	ret = platform_driver_register(&smsc_ircc_driver);
 	if (ret) {
 		net_err_ratelimited("%s, Can't register driver!\n",
diff --git a/drivers/net/irda/w83977af_ir.c b/drivers/net/irda/w83977af_ir.c
index 4e3d2e7c697c..78786bd6ed12 100644
--- a/drivers/net/irda/w83977af_ir.c
+++ b/drivers/net/irda/w83977af_ir.c
@@ -70,6 +70,7 @@ static int  qos_mtt_bits = 0x07;   /* 1 ms or more */
 
 #define CHIP_IO_EXTENT 8
 
+static unsigned int nr_io, nr_irq;
 static unsigned int io[] = { 0x180, ~0, ~0, ~0 };
 #ifdef CONFIG_ARCH_NETWINDER             /* Adjust to NetWinder differences */
 static unsigned int irq[] = { 6, 0, 0, 0 };
@@ -110,6 +111,12 @@ static int __init w83977af_init(void)
 {
         int i;
 
+	if ((nr_io > 0 || nr_irq > 0) &&
+	    kernel_is_locked_down()) {
+		pr_err("Kernel is locked down\n");
+		return -EPERM;
+	}
+
 	for (i=0; i < ARRAY_SIZE(dev_self) && io[i] < 2000; i++) {
 		if (w83977af_open(i, io[i], irq[i], dma[i]) == 0)
 			return 0;
@@ -1264,9 +1271,9 @@ MODULE_LICENSE("GPL");
 
 module_param(qos_mtt_bits, int, 0);
 MODULE_PARM_DESC(qos_mtt_bits, "Mimimum Turn Time");
-module_param_array(io, int, NULL, 0);
+module_param_array(io, int, &nr_io, 0);
 MODULE_PARM_DESC(io, "Base I/O addresses");
-module_param_array(irq, int, NULL, 0);
+module_param_array(irq, int, &nr_irq, 0);
 MODULE_PARM_DESC(irq, "IRQ lines");
 
 /*
diff --git a/drivers/net/wan/cosa.c b/drivers/net/wan/cosa.c
index b87fe0a01c69..fe835b110371 100644
--- a/drivers/net/wan/cosa.c
+++ b/drivers/net/wan/cosa.c
@@ -232,11 +232,12 @@ static int irq[MAX_CARDS+1] = { -1, -1, -1, -1, -1, -1, 0, };
 static struct class *cosa_class;
 
 #ifdef MODULE
-module_param_array(io, int, NULL, 0);
+static unsigned int nr_io, nr_dma, nr_irq;
+module_param_array(io, int, &nr_io, 0);
 MODULE_PARM_DESC(io, "The I/O bases of the COSA or SRP cards");
-module_param_array(irq, int, NULL, 0);
+module_param_array(irq, int, &nr_irq, 0);
 MODULE_PARM_DESC(irq, "The IRQ lines of the COSA or SRP cards");
-module_param_array(dma, int, NULL, 0);
+module_param_array(dma, int, &nr_dma, 0);
 MODULE_PARM_DESC(dma, "The DMA channels of the COSA or SRP cards");
 
 MODULE_AUTHOR("Jan \"Yenya\" Kasprzak, <kas@fi.muni.cz>");
@@ -361,6 +362,12 @@ static int __init cosa_init(void)
 {
 	int i, err = 0;
 
+	if ((nr_io > 0 || nr_irq > 0 || nr_dma > 0) &&
+	    kernel_is_locked_down()) {
+		pr_err("Kernel is locked down\n");
+		return -EPERM;
+	}
+
 	if (cosa_major > 0) {
 		if (register_chrdev(cosa_major, "cosa", &cosa_fops)) {
 			pr_warn("unable to get major %d\n", cosa_major);
diff --git a/drivers/net/wan/hostess_sv11.c b/drivers/net/wan/hostess_sv11.c
index 3d741663fd67..286b4a75e038 100644
--- a/drivers/net/wan/hostess_sv11.c
+++ b/drivers/net/wan/hostess_sv11.c
@@ -340,6 +340,12 @@ static struct z8530_dev *sv11_unit;
 
 int init_module(void)
 {
+	if ((io || irq || dma) &&
+	    kernel_is_locked_down()) {
+		pr_err("Kernel is locked down\n");
+		return -EPERM;
+	}
+
 	if ((sv11_unit = sv11_init(io, irq)) == NULL)
 		return -ENODEV;
 	return 0;
diff --git a/drivers/net/wan/sbni.c b/drivers/net/wan/sbni.c
index 3a421ca8a4d0..ad75e698a68c 100644
--- a/drivers/net/wan/sbni.c
+++ b/drivers/net/wan/sbni.c
@@ -1464,8 +1464,9 @@ set_multicast_list( struct net_device  *dev )
 
 
 #ifdef MODULE
-module_param_array(io, int, NULL, 0);
-module_param_array(irq, int, NULL, 0);
+unsigned int nr_io, nr_irq;
+module_param_array(io, int, &nr_io, 0);
+module_param_array(irq, int, &nr_irq, 0);
 module_param_array(baud, int, NULL, 0);
 module_param_array(rxl, int, NULL, 0);
 module_param_array(mac, int, NULL, 0);
@@ -1479,6 +1480,12 @@ int __init init_module( void )
 	struct net_device  *dev;
 	int err;
 
+	if ((nr_io > 0 || nr_irq > 0) &&
+	    kernel_is_locked_down()) {
+		pr_err("Kernel is locked down\n");
+		return -EPERM;
+	}
+
 	while( num < SBNI_MAX_NUM_CARDS ) {
 		dev = alloc_netdev(sizeof(struct net_local), "sbni%d",
 				   NET_NAME_UNKNOWN, sbni_devsetup);
diff --git a/drivers/net/wan/sealevel.c b/drivers/net/wan/sealevel.c
index 27860b4f5908..678027db1fe6 100644
--- a/drivers/net/wan/sealevel.c
+++ b/drivers/net/wan/sealevel.c
@@ -383,6 +383,12 @@ static struct slvl_board *slvl_unit;
 
 static int __init slvl_init_module(void)
 {
+	if ((io != 0x238 || irq != 5 || tx_dma != 1 || rx_dma != 3) &&
+	    kernel_is_locked_down()) {
+		pr_err("Kernel is locked down\n");
+		return -EPERM;
+	}
+
 	slvl_unit = slvl_init(io, irq, txdma, rxdma, slow);
 
 	return slvl_unit ? 0 : -ENODEV;
diff --git a/drivers/net/wireless/cisco/airo.c b/drivers/net/wireless/cisco/airo.c
index 69b826d229c5..d5212e6def04 100644
--- a/drivers/net/wireless/cisco/airo.c
+++ b/drivers/net/wireless/cisco/airo.c
@@ -246,8 +246,9 @@ MODULE_DESCRIPTION("Support for Cisco/Aironet 802.11 wireless ethernet cards.  "
 		   "Direct support for ISA/PCI/MPI cards and support for PCMCIA when used with airo_cs.");
 MODULE_LICENSE("Dual BSD/GPL");
 MODULE_SUPPORTED_DEVICE("Aironet 4500, 4800 and Cisco 340/350");
-module_param_array(io, int, NULL, 0);
-module_param_array(irq, int, NULL, 0);
+static unsigned int nr_io, nr_irq;
+module_param_array(io, int, &nr_io, 0);
+module_param_array(irq, int, &nr_irq, 0);
 module_param_array(rates, int, NULL, 0);
 module_param_array(ssids, charp, NULL, 0);
 module_param(auto_wep, int, 0);
@@ -5649,6 +5650,12 @@ static int __init airo_init_module( void )
 {
 	int i;
 
+	if ((nr_io > 0 || nr_irq > 0) &&
+	    kernel_is_locked_down()) {
+		pr_err("Kernel is locked down\n");
+		return -EPERM;
+	}
+
 	proc_kuid = make_kuid(&init_user_ns, proc_uid);
 	proc_kgid = make_kgid(&init_user_ns, proc_gid);
 	if (!uid_valid(proc_kuid) || !gid_valid(proc_kgid))
diff --git a/drivers/parport/parport_pc.c b/drivers/parport/parport_pc.c
index 78530d1714dc..5501656fedfa 100644
--- a/drivers/parport/parport_pc.c
+++ b/drivers/parport/parport_pc.c
@@ -3149,14 +3149,15 @@ static int __init parport_init_mode_setup(char *str)
 static char *irq[PARPORT_PC_MAX_PORTS];
 static char *dma[PARPORT_PC_MAX_PORTS];
 
+static unsigned int nr_io, nr_io_hi, nr_irq, nr_dma;
 MODULE_PARM_DESC(io, "Base I/O address (SPP regs)");
-module_param_array(io, int, NULL, 0);
+module_param_array(io, int, &nr_io, 0);
 MODULE_PARM_DESC(io_hi, "Base I/O address (ECR)");
-module_param_array(io_hi, int, NULL, 0);
+module_param_array(io_hi, int, &nr_io_hi, 0);
 MODULE_PARM_DESC(irq, "IRQ line");
-module_param_array(irq, charp, NULL, 0);
+module_param_array(irq, charp, &nr_irq, 0);
 MODULE_PARM_DESC(dma, "DMA channel");
-module_param_array(dma, charp, NULL, 0);
+module_param_array(dma, charp, &nr_dma, 0);
 #if defined(CONFIG_PARPORT_PC_SUPERIO) || \
        (defined(CONFIG_PARPORT_1284) && defined(CONFIG_PARPORT_PC_FIFO))
 MODULE_PARM_DESC(verbose_probing, "Log chit-chat during initialisation");
@@ -3174,6 +3175,12 @@ static int __init parse_parport_params(void)
 	unsigned int i;
 	int val;
 
+	if ((nr_io > 0 || nr_io_hi > 0 || nr_irq > 0 || nr_dma > 0) &&
+	    kernel_is_locked_down()) {
+		pr_err("Kernel is locked down\n");
+		return -EPERM;
+	}
+
 #ifdef CONFIG_PCI
 	if (init_mode)
 		parport_init_mode_setup(init_mode);
diff --git a/drivers/pci/hotplug/cpcihp_generic.c b/drivers/pci/hotplug/cpcihp_generic.c
index 88a44a707b96..f21fbde49ffa 100644
--- a/drivers/pci/hotplug/cpcihp_generic.c
+++ b/drivers/pci/hotplug/cpcihp_generic.c
@@ -145,6 +145,11 @@ static int __init cpcihp_generic_init(void)
 	struct resource *r;
 	struct pci_dev *dev;
 
+	if ((port || irq_mask != 0xffff) && kernel_is_locked_down()) {
+		pr_err("Kernel is locked down\n");
+		return -EPERM;
+	}
+
 	info(DRIVER_DESC " version: " DRIVER_VERSION);
 	status = validate_parameters();
 	if (status)
diff --git a/drivers/pcmcia/i82365.c b/drivers/pcmcia/i82365.c
index eb0d80a429e4..5229734e60e9 100644
--- a/drivers/pcmcia/i82365.c
+++ b/drivers/pcmcia/i82365.c
@@ -757,7 +757,15 @@ static void __init isa_probe(void)
 #ifdef CONFIG_PNP
     struct isapnp_device_id *devid;
     struct pnp_dev *dev;
+#endif
+
+    if ((i365_base != 0x3e0 || irq_list_count > 0) &&
+	kernel_is_locked_down()) {
+		pr_err("Kernel is locked down\n");
+		return -EPERM;
+	}
 
+#ifdef CONFIG_PNP
     for (devid = id_table; devid->vendor; devid++) {
 	if ((dev = pnp_find_dev(NULL, devid->vendor, devid->function, NULL))) {
 	
diff --git a/drivers/pcmcia/tcic.c b/drivers/pcmcia/tcic.c
index 1ee63e5f0550..f412fb4e4e1f 100644
--- a/drivers/pcmcia/tcic.c
+++ b/drivers/pcmcia/tcic.c
@@ -782,6 +782,12 @@ static int tcic_init(struct pcmcia_socket *s)
 	pccard_io_map io = { 0, 0, 0, 0, 1 };
 	pccard_mem_map mem = { .res = &res, };
 
+	if ((tcic_base != TCIC_BASE || irq_mask != 0xffff || irq_list_count > 0) &&
+	    kernel_is_locked_down()) {
+		pr_err("Kernel is locked down\n");
+		return -EPERM;
+	}
+
 	for (i = 0; i < 2; i++) {
 		io.map = i;
 		tcic_set_io_map(s, &io);
diff --git a/drivers/scsi/aha152x.c b/drivers/scsi/aha152x.c
index f44d0487236e..d56d1d478d55 100644
--- a/drivers/scsi/aha152x.c
+++ b/drivers/scsi/aha152x.c
@@ -330,10 +330,12 @@ MODULE_LICENSE("GPL");
 
 #if !defined(PCMCIA)
 #if defined(MODULE)
+static unsigned int nr_io;
 static int io[] = {0, 0};
 module_param_array(io, int, NULL, 0);
 MODULE_PARM_DESC(io,"base io address of controller");
 
+static unsigned int nr_irq;
 static int irq[] = {0, 0};
 module_param_array(irq, int, NULL, 0);
 MODULE_PARM_DESC(irq,"interrupt for controller");
@@ -3083,6 +3085,11 @@ static int __init aha152x_init(void)
 	struct pnp_dev *dev=NULL, *pnpdev[2] = {NULL, NULL};
 #endif
 
+	if ((nr_io > 0 || nr_irq > 0) && kernel_is_locked_down()) {
+		pr_err("Kernel is locked down\n");
+		return -EPERM;
+	}
+
 	if ( setup_count ) {
 		printk(KERN_INFO "aha152x: processing commandline: ");
 
diff --git a/drivers/scsi/aha1542.c b/drivers/scsi/aha1542.c
index 7db448ec8beb..ff3ccedd5208 100644
--- a/drivers/scsi/aha1542.c
+++ b/drivers/scsi/aha1542.c
@@ -30,8 +30,9 @@ static bool isapnp = 1;
 module_param(isapnp, bool, 0);
 MODULE_PARM_DESC(isapnp, "enable PnP support (default=1)");
 
+static unsigned int nr_io;
 static int io[MAXBOARDS] = { 0x330, 0x334, 0, 0 };
-module_param_array(io, int, NULL, 0);
+module_param_array(io, int, &nr_io, 0);
 MODULE_PARM_DESC(io, "base IO address of controller (0x130,0x134,0x230,0x234,0x330,0x334, default=0x330,0x334)");
 
 /* time AHA spends on the AT-bus during data transfer */
@@ -1039,6 +1040,11 @@ static int __init aha1542_init(void)
 {
 	int ret = 0;
 
+	if (nr_io > 0 && kernel_is_locked_down()) {
+		pr_err("Kernel is locked down\n");
+		return -EPERM;
+	}
+
 #ifdef CONFIG_PNP
 	if (isapnp) {
 		ret = pnp_register_driver(&aha1542_pnp_driver);
diff --git a/drivers/scsi/eata.c b/drivers/scsi/eata.c
index 227dd2c2ec2f..0f289ec14a8c 100644
--- a/drivers/scsi/eata.c
+++ b/drivers/scsi/eata.c
@@ -1552,8 +1552,13 @@ static int eata2x_detect(struct scsi_host_template *tpnt)
 
 	tpnt->proc_name = "eata2x";
 
-	if (strlen(boot_options))
+	if (strlen(boot_options)) {
+		if (kernel_is_locked_down()) {
+			pr_err("Kernel is locked down\n");
+			return -EPERM;
+		}
 		option_setup(boot_options);
+	}
 
 #if defined(MODULE)
 	/* io_port could have been modified when loading as a module */
diff --git a/drivers/scsi/g_NCR5380.c b/drivers/scsi/g_NCR5380.c
index cbf010324c18..971dc37d0b59 100644
--- a/drivers/scsi/g_NCR5380.c
+++ b/drivers/scsi/g_NCR5380.c
@@ -52,12 +52,14 @@ module_param(ncr_53c400a, int, 0);
 module_param(dtc_3181e, int, 0);
 module_param(hp_c2502, int, 0);
 
+unsigned int nr_irq;
 static int irq[] = { 0, 0, 0, 0, 0, 0, 0, 0 };
-module_param_array(irq, int, NULL, 0);
+module_param_array(irq, int, &nr_irq, 0);
 MODULE_PARM_DESC(irq, "IRQ number(s)");
 
+unsigned int nr_base;
 static int base[] = { 0, 0, 0, 0, 0, 0, 0, 0 };
-module_param_array(base, int, NULL, 0);
+module_param_array(base, int, &nr_base, 0);
 MODULE_PARM_DESC(base, "base address(es)");
 
 static int card[] = { -1, -1, -1, -1, -1, -1, -1, -1 };
@@ -608,6 +610,12 @@ static int __init generic_NCR5380_init(void)
 {
 	int ret = 0;
 
+	if ((nr_base > 0 || nr_irq > 0 || ncr_addr || ncr_irq) &&
+	    kernel_is_locked_down()) {
+		pr_err("Kernel is locked down\n");
+		return -EPERM;
+	}
+
 	/* compatibility with old-style parameters */
 	if (irq[0] == 0 && base[0] == 0 && card[0] == -1) {
 		irq[0] = ncr_irq;
diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index 0a767740bf02..6a3b0d756591 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -325,6 +325,7 @@ static u8 gdth_direction_tab[0x100] = {
 
 /* LILO and modprobe/insmod parameters */
 /* IRQ list for GDT3000/3020 EISA controllers */
+static unsigned int nr_irq;
 static int irq[MAXHA] __initdata = 
 {0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,
  0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff};
@@ -353,7 +354,7 @@ static int probe_eisa_isa = 0;
 static int force_dma32 = 0;
 
 /* parameters for modprobe/insmod */
-module_param_array(irq, int, NULL, 0);
+module_param_array(irq, int, &irq, 0);
 module_param(disable, int, 0);
 module_param(reserve_mode, int, 0);
 module_param_array(reserve_list, int, NULL, 0);
@@ -5153,6 +5154,11 @@ static struct notifier_block gdth_notifier = {
 
 static int __init gdth_init(void)
 {
+	if (nr_irq > 0 && kernel_is_locked_down()) {
+		pr_err("Kernel is locked down\n");
+		return -EPERM;
+	}
+
 	if (disable) {
 		printk("GDT-HA: Controller driver disabled from"
                        " command line !\n");
diff --git a/drivers/scsi/qlogicfas.c b/drivers/scsi/qlogicfas.c
index 61cac87fb86f..d64a38627a73 100644
--- a/drivers/scsi/qlogicfas.c
+++ b/drivers/scsi/qlogicfas.c
@@ -135,10 +135,11 @@ static struct Scsi_Host *__qlogicfas_detect(struct scsi_host_template *host,
 
 #define MAX_QLOGICFAS	8
 static struct qlogicfas408_priv *cards;
+static unsigned int nr_iobase, nr_irq;
 static int iobase[MAX_QLOGICFAS];
 static int irq[MAX_QLOGICFAS] = { [0 ... MAX_QLOGICFAS-1] = -1 };
-module_param_array(iobase, int, NULL, 0);
-module_param_array(irq, int, NULL, 0);
+module_param_array(iobase, int, &nr_iobase, 0);
+module_param_array(irq, int, &nr_irq, 0);
 MODULE_PARM_DESC(iobase, "I/O address");
 MODULE_PARM_DESC(irq, "IRQ");
 
@@ -198,6 +199,11 @@ static struct scsi_host_template qlogicfas_driver_template = {
 
 static __init int qlogicfas_init(void)
 {
+	if ((nr_iobase > 0 || nr_irq > 0) && kernel_is_locked_down()) {
+		pr_err("Kernel is locked down\n");
+		return -EPERM;
+	}
+
 	if (!qlogicfas_detect(&qlogicfas_driver_template)) {
 		/* no cards found */
 		printk(KERN_INFO "%s: no cards were found, please specify "
diff --git a/drivers/staging/i4l/act2000/module.c b/drivers/staging/i4l/act2000/module.c
index 99c9c0a1c63e..70558e9e3319 100644
--- a/drivers/staging/i4l/act2000/module.c
+++ b/drivers/staging/i4l/act2000/module.c
@@ -795,6 +795,13 @@ static void __exit act2000_exit(void)
 {
 	act2000_card *card = cards;
 	act2000_card *last;
+
+	if ((act_bus || act_port != -1 || act_irq != -1) &&
+	    kernel_is_locked_down()) {
+		pr_err("Kernel is locked down\n");
+		return -EPERM;
+	}
+
 	while (card) {
 		unregister_card(card);
 		del_timer_sync(&card->ptimer);
diff --git a/drivers/staging/i4l/icn/icn.c b/drivers/staging/i4l/icn/icn.c
index 514bfc2c5b53..f124288ceaf4 100644
--- a/drivers/staging/i4l/icn/icn.c
+++ b/drivers/staging/i4l/icn/icn.c
@@ -1659,6 +1659,12 @@ static void __exit icn_exit(void)
 	int i;
 	unsigned long flags;
 
+	if ((portbase != ICN_BASEADDR || membase != ICN_MEMADDR) &&
+	    kernel_is_locked_down()) {
+		pr_err("Kernel is locked down\n");
+		return -EPERM;
+	}
+
 	icn_stopallcards();
 	while (card) {
 		cmd.command = ISDN_STAT_UNLOAD;
diff --git a/drivers/staging/i4l/pcbit/module.c b/drivers/staging/i4l/pcbit/module.c
index 0a59bd0b8210..dfce874c03b5 100644
--- a/drivers/staging/i4l/pcbit/module.c
+++ b/drivers/staging/i4l/pcbit/module.c
@@ -22,11 +22,12 @@ MODULE_DESCRIPTION("ISDN4Linux: Driver for PCBIT-T card");
 MODULE_AUTHOR("Pedro Roque Marques");
 MODULE_LICENSE("GPL");
 
+static unsigned int nr_mem, nr_irq;
 static int mem[MAX_PCBIT_CARDS];
 static int irq[MAX_PCBIT_CARDS];
 
-module_param_array(mem, int, NULL, 0);
-module_param_array(irq, int, NULL, 0);
+module_param_array(mem, int, &nr_mem, 0);
+module_param_array(irq, int, &nr_irq, 0);
 
 static int num_boards;
 struct pcbit_dev *dev_pcbit[MAX_PCBIT_CARDS];
@@ -35,6 +36,11 @@ static int __init pcbit_init(void)
 {
 	int board;
 
+	if ((nr_mem > 0 || nr_irq > 0) && kernel_is_locked_down()) {
+		pr_err("Kernel is locked down\n");
+		return -EPERM;
+	}
+
 	num_boards = 0;
 
 	printk(KERN_NOTICE
diff --git a/drivers/staging/media/lirc/lirc_parallel.c b/drivers/staging/media/lirc/lirc_parallel.c
index bfb76a45bfbf..4c2f27e78f01 100644
--- a/drivers/staging/media/lirc/lirc_parallel.c
+++ b/drivers/staging/media/lirc/lirc_parallel.c
@@ -630,6 +630,11 @@ static int __init lirc_parallel_init(void)
 {
 	int result;
 
+	if ((io || irq) && kernel_is_locked_down()) {
+		pr_err("Kernel is locked down\n");
+		return -EPERM;
+	}
+
 	result = platform_driver_register(&lirc_parallel_driver);
 	if (result) {
 		pr_notice("platform_driver_register returned %d\n", result);
diff --git a/drivers/staging/media/lirc/lirc_serial.c b/drivers/staging/media/lirc/lirc_serial.c
index b798b311d32c..38c3e80524a7 100644
--- a/drivers/staging/media/lirc/lirc_serial.c
+++ b/drivers/staging/media/lirc/lirc_serial.c
@@ -1030,6 +1030,11 @@ static int __init lirc_serial_init_module(void)
 {
 	int result;
 
+	if ((io || irq || ioshift || iommap) && kernel_is_locked_down()) {
+		pr_err("Kernel is locked down\n");
+		return -EPERM;
+	}
+
 	switch (type) {
 	case LIRC_HOMEBREW:
 	case LIRC_IRDEO:
diff --git a/drivers/staging/media/lirc/lirc_sir.c b/drivers/staging/media/lirc/lirc_sir.c
index 4f326e97ad75..e10d50c2f829 100644
--- a/drivers/staging/media/lirc/lirc_sir.c
+++ b/drivers/staging/media/lirc/lirc_sir.c
@@ -917,6 +917,11 @@ static int __init lirc_sir_init(void)
 {
 	int retval;
 
+	if ((io || irq) && kernel_is_locked_down()) {
+		pr_err("Kernel is locked down\n");
+		return -EPERM;
+	}
+
 	retval = platform_driver_register(&lirc_sir_driver);
 	if (retval) {
 		pr_err("Platform driver register failed!\n");
diff --git a/drivers/staging/speakup/speakup_acntpc.c b/drivers/staging/speakup/speakup_acntpc.c
index efb791bb642b..6d1d4d8f10c5 100644
--- a/drivers/staging/speakup/speakup_acntpc.c
+++ b/drivers/staging/speakup/speakup_acntpc.c
@@ -313,6 +313,8 @@ module_param_named(start, synth_acntpc.startup, short, S_IRUGO);
 MODULE_PARM_DESC(port, "Set the port for the synthesizer (override probing).");
 MODULE_PARM_DESC(start, "Start the synthesizer once it is loaded.");
 
+#undef define module_lockdown_check
+#define module_lockdown_check() (port_forced)
 module_spk_synth(synth_acntpc);
 
 MODULE_AUTHOR("Kirk Reiser <kirk@braille.uwo.ca>");
diff --git a/drivers/staging/speakup/speakup_dtlk.c b/drivers/staging/speakup/speakup_dtlk.c
index 38aa4013bf62..dfdc54434b28 100644
--- a/drivers/staging/speakup/speakup_dtlk.c
+++ b/drivers/staging/speakup/speakup_dtlk.c
@@ -384,6 +384,8 @@ module_param_named(start, synth_dtlk.startup, short, S_IRUGO);
 MODULE_PARM_DESC(port, "Set the port for the synthesizer (override probing).");
 MODULE_PARM_DESC(start, "Start the synthesizer once it is loaded.");
 
+#undef define module_lockdown_check
+#define module_lockdown_check() (port_forced)
 module_spk_synth(synth_dtlk);
 
 MODULE_AUTHOR("Kirk Reiser <kirk@braille.uwo.ca>");
diff --git a/drivers/staging/speakup/speakup_keypc.c b/drivers/staging/speakup/speakup_keypc.c
index 5e2170bf4a8b..156922c3d0cd 100644
--- a/drivers/staging/speakup/speakup_keypc.c
+++ b/drivers/staging/speakup/speakup_keypc.c
@@ -315,6 +315,8 @@ module_param_named(start, synth_keypc.startup, short, S_IRUGO);
 MODULE_PARM_DESC(port, "Set the port for the synthesizer (override probing).");
 MODULE_PARM_DESC(start, "Start the synthesizer once it is loaded.");
 
+#undef define module_lockdown_check
+#define module_lockdown_check() (port_forced)
 module_spk_synth(synth_keypc);
 
 MODULE_AUTHOR("David Borowski");
diff --git a/drivers/staging/vme/devices/vme_pio2_core.c b/drivers/staging/vme/devices/vme_pio2_core.c
index 8e66a520266c..36e33e8783f3 100644
--- a/drivers/staging/vme/devices/vme_pio2_core.c
+++ b/drivers/staging/vme/devices/vme_pio2_core.c
@@ -158,6 +158,12 @@ static struct vme_driver pio2_driver = {
 
 static int __init pio2_init(void)
 {
+	if ((bus_num > 0 || base_num > 0 || vector_num > 0 || level_num > 0) &&
+	    kernel_is_locked_down()) {
+		pr_err("Kernel is locked down\n");
+		return -EPERM;
+	}
+
 	if (bus_num == 0) {
 		pr_err("No cards, skipping registration\n");
 		return -ENODEV;
diff --git a/drivers/tty/cyclades.c b/drivers/tty/cyclades.c
index 5e4fa9206861..fffae49cc489 100644
--- a/drivers/tty/cyclades.c
+++ b/drivers/tty/cyclades.c
@@ -153,11 +153,12 @@ static unsigned int cy_isa_addresses[] = {
 
 #define NR_ISA_ADDRS ARRAY_SIZE(cy_isa_addresses)
 
+static unsigned int nr_maddr, nr_irq;
 static long maddr[NR_CARDS];
 static int irq[NR_CARDS];
 
-module_param_array(maddr, long, NULL, 0);
-module_param_array(irq, int, NULL, 0);
+module_param_array(maddr, long, &nr_maddr, 0);
+module_param_array(irq, int, &nr_irq, 0);
 
 #endif				/* CONFIG_ISA */
 
@@ -4038,6 +4039,13 @@ static int __init cy_init(void)
 	unsigned int nboards;
 	int retval = -ENOMEM;
 
+#ifdef CONFIG_ISA
+	if ((nr_maddr > 0 || nr_irq > 0) && kernel_is_locked_down()) {
+		pr_err("Kernel is locked down\n");
+		return -EPERM;
+	}
+#endif
+
 	cy_serial_driver = alloc_tty_driver(NR_PORTS);
 	if (!cy_serial_driver)
 		goto err;
diff --git a/drivers/tty/moxa.c b/drivers/tty/moxa.c
index 60d37b225589..9630fbe62403 100644
--- a/drivers/tty/moxa.c
+++ b/drivers/tty/moxa.c
@@ -165,6 +165,7 @@ static unsigned int moxaLowWaterChk;
 static DEFINE_MUTEX(moxa_openlock);
 static DEFINE_SPINLOCK(moxa_lock);
 
+unsigned int nr_baseaddr, nr_numports;
 static unsigned long baseaddr[MAX_BOARDS];
 static unsigned int type[MAX_BOARDS];
 static unsigned int numports[MAX_BOARDS];
@@ -179,9 +180,9 @@ MODULE_FIRMWARE("c320tunx.cod");
 
 module_param_array(type, uint, NULL, 0);
 MODULE_PARM_DESC(type, "card type: C218=2, C320=4");
-module_param_array(baseaddr, ulong, NULL, 0);
+module_param_array(baseaddr, ulong, &nr_baseaddr, 0);
 MODULE_PARM_DESC(baseaddr, "base address");
-module_param_array(numports, uint, NULL, 0);
+module_param_array(numports, uint, &nr_numports, 0);
 MODULE_PARM_DESC(numports, "numports (ignored for C218)");
 
 module_param(ttymajor, int, 0);
@@ -1039,6 +1040,11 @@ static int __init moxa_init(void)
 	struct moxa_board_conf *brd = moxa_boards;
 	unsigned int i;
 
+	if ((nr_baseaddr > 0 || nr_numports > 0) && kernel_is_locked_down()) {
+		pr_err("Kernel is locked down\n");
+		return -EPERM;
+	}
+
 	printk(KERN_INFO "MOXA Intellio family driver version %s\n",
 			MOXA_VERSION);
 
diff --git a/drivers/tty/mxser.c b/drivers/tty/mxser.c
index 69294ae154be..1493bc7efda8 100644
--- a/drivers/tty/mxser.c
+++ b/drivers/tty/mxser.c
@@ -176,6 +176,7 @@ static struct pci_device_id mxser_pcibrds[] = {
 };
 MODULE_DEVICE_TABLE(pci, mxser_pcibrds);
 
+static unsigned int nr_ioaddr;
 static unsigned long ioaddr[MXSER_BOARDS];
 static int ttymajor = MXSERMAJOR;
 
@@ -183,7 +184,7 @@ static int ttymajor = MXSERMAJOR;
 
 MODULE_AUTHOR("Casper Yang");
 MODULE_DESCRIPTION("MOXA Smartio/Industio Family Multiport Board Device Driver");
-module_param_array(ioaddr, ulong, NULL, 0);
+module_param_array(ioaddr, ulong, &nr_ioaddr, 0);
 MODULE_PARM_DESC(ioaddr, "ISA io addresses to look for a moxa board");
 module_param(ttymajor, int, 0);
 MODULE_LICENSE("GPL");
@@ -2699,6 +2700,11 @@ static int __init mxser_module_init(void)
 	unsigned int b, i, m;
 	int retval;
 
+	if (nr_ioaddr > 0 && kernel_is_locked_down()) {
+		pr_err("Kernel is locked down\n");
+		return -EPERM;
+	}
+
 	mxvar_sdriver = alloc_tty_driver(MXSER_PORTS + 1);
 	if (!mxvar_sdriver)
 		return -ENOMEM;
diff --git a/drivers/tty/rocket.c b/drivers/tty/rocket.c
index b0cc47c77b40..2656407a2a6e 100644
--- a/drivers/tty/rocket.c
+++ b/drivers/tty/rocket.c
@@ -2363,6 +2363,12 @@ static int __init rp_init(void)
 {
 	int ret = -ENOMEM, pci_boards_found, isa_boards_found, i;
 
+	if ((board1 || board2 || board3 || board4 || conroller) &&
+	    kernel_is_locked_down()) {
+		pr_err("Kernel is locked down\n");
+		return -EPERM;
+	}
+
 	printk(KERN_INFO "RocketPort device driver module, version %s, %s\n",
 	       ROCKET_VERSION, ROCKET_DATE);
 
diff --git a/drivers/tty/serial/8250/8250_core.c b/drivers/tty/serial/8250/8250_core.c
index 240a361b674f..f6f828f81e5e 100644
--- a/drivers/tty/serial/8250/8250_core.c
+++ b/drivers/tty/serial/8250/8250_core.c
@@ -645,6 +645,11 @@ static int univ8250_console_match(struct console *co, char *name, int idx,
 	if (strncmp(name, match, 4) != 0)
 		return -ENODEV;
 
+	if (kernel_is_locked_down()) {
+		pr_err("Kernel is locked down\n");
+		return -EPERM;
+	}
+
 	if (uart_parse_earlycon(options, &iotype, &addr, &options))
 		return -ENODEV;
 
diff --git a/drivers/tty/synclink.c b/drivers/tty/synclink.c
index c13e27ecb0b7..8a3ad24f3a0a 100644
--- a/drivers/tty/synclink.c
+++ b/drivers/tty/synclink.c
@@ -859,6 +859,7 @@ static int ttymajor;
 /*
  * Array of user specified options for ISA adapters.
  */
+static unsigned int nr_io, nr_irq, nr_dma;
 static int io[MAX_ISA_DEVICES];
 static int irq[MAX_ISA_DEVICES];
 static int dma[MAX_ISA_DEVICES];
@@ -869,9 +870,9 @@ static int txholdbufs[MAX_TOTAL_DEVICES];
 	
 module_param(break_on_load, bool, 0);
 module_param(ttymajor, int, 0);
-module_param_array(io, int, NULL, 0);
-module_param_array(irq, int, NULL, 0);
-module_param_array(dma, int, NULL, 0);
+module_param_array(io, int, &nr_io, 0);
+module_param_array(irq, int, &nr_irq, 0);
+module_param_array(dma, int, &nr_dma, 0);
 module_param(debug_level, int, 0);
 module_param_array(maxframe, int, NULL, 0);
 module_param_array(txdmabufs, int, NULL, 0);
@@ -4417,6 +4418,11 @@ static int __init synclink_init(void)
   		BREAKPOINT();
 	}
 
+	if ((nr_io > 0 || nr_irq > 0 || nr_dma > 0) && kernel_is_locked_down()) {
+		pr_err("Kernel is locked down\n");
+		return -EPERM;
+	}
+
  	printk("%s %s\n", driver_name, driver_version);
 
 	mgsl_enum_isa_devices();
diff --git a/drivers/video/fbdev/arcfb.c b/drivers/video/fbdev/arcfb.c
index 1928cb2b5386..4e4e029e9b15 100644
--- a/drivers/video/fbdev/arcfb.c
+++ b/drivers/video/fbdev/arcfb.c
@@ -611,6 +611,12 @@ static int __init arcfb_init(void)
 {
 	int ret;
 
+	if ((dio_addr || cio_addr || c2io_addr || irq) &&
+	    kernel_is_locked_down()) {
+		pr_err("Kernel is locked down\n");
+		return -EPERM;
+	}
+
 	if (!arcfb_enable)
 		return -ENXIO;
 
diff --git a/drivers/video/fbdev/n411.c b/drivers/video/fbdev/n411.c
index 053deacad7cc..29375b7cd916 100644
--- a/drivers/video/fbdev/n411.c
+++ b/drivers/video/fbdev/n411.c
@@ -153,6 +153,12 @@ static struct platform_device *n411_device;
 static int __init n411_init(void)
 {
 	int ret;
+
+	if ((dio_addr || cio_addr || c2io_addr) &&  kernel_is_locked_down()) {
+		pr_err("Kernel is locked down\n");
+		return -EPERM;
+	}
+
 	if (!dio_addr || !cio_addr || !c2io_addr) {
 		printk(KERN_WARNING "no IO addresses supplied\n");
 		return -EINVAL;
diff --git a/drivers/watchdog/cpu5wdt.c b/drivers/watchdog/cpu5wdt.c
index 6d03e8e30f8b..ac23f37445f8 100644
--- a/drivers/watchdog/cpu5wdt.c
+++ b/drivers/watchdog/cpu5wdt.c
@@ -257,6 +257,10 @@ static int cpu5wdt_init(void)
 
 static int cpu5wdt_init_module(void)
 {
+	if (port != 0x91 && kernel_is_locked_down()) {
+		pr_err("Kernel is locked down\n");
+		return -EPERM;
+	}
 	return cpu5wdt_init();
 }
 
diff --git a/drivers/watchdog/eurotechwdt.c b/drivers/watchdog/eurotechwdt.c
index 23ee53240c4c..c214cb5893c7 100644
--- a/drivers/watchdog/eurotechwdt.c
+++ b/drivers/watchdog/eurotechwdt.c
@@ -427,6 +427,11 @@ static int __init eurwdt_init(void)
 {
 	int ret;
 
+	if ((io != 0x3f0 || irq != 10) && kernel_is_locked_down()) {
+		pr_err("Kernel is locked down\n");
+		return -EPERM;
+	}
+
 	ret = request_irq(irq, eurwdt_interrupt, 0, "eurwdt", NULL);
 	if (ret) {
 		pr_err("IRQ %d is not free\n", irq);
diff --git a/drivers/watchdog/pc87413_wdt.c b/drivers/watchdog/pc87413_wdt.c
index 9f15dd9435d1..af00cc846eee 100644
--- a/drivers/watchdog/pc87413_wdt.c
+++ b/drivers/watchdog/pc87413_wdt.c
@@ -505,6 +505,11 @@ static int __init pc87413_init(void)
 {
 	int ret;
 
+	if (io != IO_DEFAULT && kernel_is_locked_down()) {
+		pr_err("Kernel is locked down\n");
+		return -EPERM;
+	}
+
 	pr_info("Version " VERSION " at io 0x%X\n",
 							WDT_INDEX_IO_PORT);
 
diff --git a/drivers/watchdog/sc1200wdt.c b/drivers/watchdog/sc1200wdt.c
index 131193a7acdf..91e68dd63238 100644
--- a/drivers/watchdog/sc1200wdt.c
+++ b/drivers/watchdog/sc1200wdt.c
@@ -390,6 +390,11 @@ static int __init sc1200wdt_init(void)
 {
 	int ret;
 
+	if (io != -1 && kernel_is_locked_down()) {
+		pr_err("Kernel is locked down\n");
+		return -EPERM;
+	}
+
 	pr_info("%s\n", SC1200_MODULE_VER);
 
 #if defined CONFIG_PNP
diff --git a/drivers/watchdog/wdt.c b/drivers/watchdog/wdt.c
index e0206b5b7d89..fa99480a1e8b 100644
--- a/drivers/watchdog/wdt.c
+++ b/drivers/watchdog/wdt.c
@@ -592,6 +592,11 @@ static int __init wdt_init(void)
 {
 	int ret;
 
+	if ((io != 0x240 || irq != 11) && kernel_is_locked_down()) {
+		pr_err("Kernel is locked down\n");
+		return -EPERM;
+	}
+
 	if (type != 500 && type != 501) {
 		pr_err("unknown card type '%d'\n", type);
 		return -ENODEV;
diff --git a/fs/pstore/ram.c b/fs/pstore/ram.c
index 6ad831b9d1b8..00a76f5cccb6 100644
--- a/fs/pstore/ram.c
+++ b/fs/pstore/ram.c
@@ -757,6 +757,11 @@ static void ramoops_register_dummy(void)
 
 static int __init ramoops_init(void)
 {
+	if ((mem_address || mem_size) && kernel_is_locked_down()) {
+		pr_err("Kernel is locked down\n");
+		return -EPERM;
+	}
+
 	ramoops_register_dummy();
 	return platform_driver_register(&ramoops_driver);
 }
diff --git a/include/linux/device.h b/include/linux/device.h
index bc41e87a969b..4fb2a9c3deb0 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -1332,6 +1332,14 @@ extern long sysfs_deprecated;
 #endif
 
 /**
+ * module_lockdown_check() - Called to check module params for lockdown mode
+ *
+ * This should return true if the module mustn't be allowed to load in lockdown
+ * mode and false otherwise.
+ */
+#define module_lockdown_check() (false)
+
+/**
  * module_driver() - Helper macro for drivers that don't do anything
  * special in module init/exit. This eliminates a lot of boilerplate.
  * Each module may only use this macro once, and calling it replaces
@@ -1348,6 +1356,10 @@ extern long sysfs_deprecated;
 #define module_driver(__driver, __register, __unregister, ...) \
 static int __init __driver##_init(void) \
 { \
+	if (module_lockdown_check() && kernel_is_locked_down()) {	\
+		pr_err("Kernel is locked down\n");			\
+		return -EPERM;						\
+	}								\
 	return __register(&(__driver) , ##__VA_ARGS__); \
 } \
 module_init(__driver##_init); \
diff --git a/include/linux/isa.h b/include/linux/isa.h
index f2d0258414cf..88700e1ef765 100644
--- a/include/linux/isa.h
+++ b/include/linux/isa.h
@@ -41,14 +41,17 @@ static inline void isa_unregister_driver(struct isa_driver *d)
  * module_isa_driver() - Helper macro for registering a ISA driver
  * @__isa_driver: isa_driver struct
  * @__num_isa_dev: number of devices to register
+ * @__lockdown: return -EPERM if this is true and lockdown is in effect
  *
  * Helper macro for ISA drivers which do not do anything special in module
  * init/exit. This eliminates a lot of boilerplate code. Each module may only
  * use this macro once, and calling it replaces module_init and module_exit.
  */
-#define module_isa_driver(__isa_driver, __num_isa_dev) \
+#define module_isa_driver(__isa_driver, __num_isa_dev, __lockdown) \
 static int __init __isa_driver##_init(void) \
 { \
+	if ((__lockdown) && kernel_is_locked_down())		    \
+		return -EPERM;					    \
 	return isa_register_driver(&(__isa_driver), __num_isa_dev); \
 } \
 module_init(__isa_driver##_init); \
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index bc6ed52a39b9..8ab309d3fb11 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -268,6 +268,15 @@ extern int oops_may_print(void);
 void do_exit(long error_code) __noreturn;
 void complete_and_exit(struct completion *, long) __noreturn;
 
+#ifdef CONFIG_LOCK_DOWN_KERNEL
+extern bool kernel_is_locked_down(void);
+#else
+static inline bool kernel_is_locked_down(void)
+{
+	return false;
+}
+#endif
+
 /* Internal, do not use. */
 int __must_check _kstrtoul(const char *s, unsigned int base, unsigned long *res);
 int __must_check _kstrtol(const char *s, unsigned int base, long *res);
diff --git a/include/linux/security.h b/include/linux/security.h
index 785868b44364..41a732598f24 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -1687,7 +1687,6 @@ static inline void free_secdata(void *secdata)
 
 #ifdef CONFIG_LOCK_DOWN_KERNEL
 extern void lock_kernel_down(void);
-extern bool kernel_is_locked_down(void);
 #ifdef CONFIG_ALLOW_LOCKDOWN_LIFT
 extern void lift_kernel_lockdown(void);
 #endif
@@ -1695,10 +1694,6 @@ extern void lift_kernel_lockdown(void);
 static inline void lock_kernel_down(void)
 {
 }
-static inline bool kernel_is_locked_down(void)
-{
-	return false;
-}
 #endif
 
 #endif /* ! __LINUX_SECURITY_H */
diff --git a/sound/drivers/mpu401/mpu401.c b/sound/drivers/mpu401/mpu401.c
index fed7e7e2177b..5b959ae50c0e 100644
--- a/sound/drivers/mpu401/mpu401.c
+++ b/sound/drivers/mpu401/mpu401.c
@@ -39,6 +39,7 @@ static bool enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE;	/* Enable this card */
 #ifdef CONFIG_PNP
 static bool pnp[SNDRV_CARDS] = {[0 ... (SNDRV_CARDS - 1)] = 1};
 #endif
+static unsigned int nr_port, nr_irq;
 static long port[SNDRV_CARDS] = SNDRV_DEFAULT_PORT;	/* MPU-401 port number */
 static int irq[SNDRV_CARDS] = SNDRV_DEFAULT_IRQ;	/* MPU-401 IRQ */
 static bool uart_enter[SNDRV_CARDS] = {[0 ... (SNDRV_CARDS - 1)] = 1};
@@ -53,9 +54,9 @@ MODULE_PARM_DESC(enable, "Enable MPU-401 device.");
 module_param_array(pnp, bool, NULL, 0444);
 MODULE_PARM_DESC(pnp, "PnP detection for MPU-401 device.");
 #endif
-module_param_array(port, long, NULL, 0444);
+module_param_array(port, long, &nr_port, 0444);
 MODULE_PARM_DESC(port, "Port # for MPU-401 device.");
-module_param_array(irq, int, NULL, 0444);
+module_param_array(irq, int, &nr_irq, 0444);
 MODULE_PARM_DESC(irq, "IRQ # for MPU-401 device.");
 module_param_array(uart_enter, bool, NULL, 0444);
 MODULE_PARM_DESC(uart_enter, "Issue UART_ENTER command at open.");
@@ -242,6 +243,11 @@ static int __init alsa_card_mpu401_init(void)
 {
 	int i, err;
 
+	if ((nr_port > 0 || nr_irq > 0) && kernel_is_locked_down()) {
+		pr_err("Kernel is locked down\n");
+		return -EPERM;
+	}
+
 	if ((err = platform_driver_register(&snd_mpu401_driver)) < 0)
 		return err;
 
diff --git a/sound/drivers/mtpav.c b/sound/drivers/mtpav.c
index 30e8a1d5bc87..ead24e3d01a3 100644
--- a/sound/drivers/mtpav.c
+++ b/sound/drivers/mtpav.c
@@ -762,6 +762,13 @@ static int __init alsa_card_mtpav_init(void)
 {
 	int err;
 
+	if ((port != MTPAV_IOBASE || irq != MTPAV_IRQ ||
+	     hwports != MTPAV_MAX_PORTS) &&
+	    kernel_is_locked_down()) {
+		pr_err("Kernel is locked down\n");
+		return -EPERM;
+	}
+
 	if ((err = platform_driver_register(&snd_mtpav_driver)) < 0)
 		return err;
 
diff --git a/sound/drivers/serial-u16550.c b/sound/drivers/serial-u16550.c
index 1927b89e1d1f..ac6a47663899 100644
--- a/sound/drivers/serial-u16550.c
+++ b/sound/drivers/serial-u16550.c
@@ -69,6 +69,7 @@ static char *adaptor_names[] = {
 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;	/* Index 0-MAX */
 static char *id[SNDRV_CARDS] = SNDRV_DEFAULT_STR;	/* ID for this card */
 static bool enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE; /* Enable this card */
+static unsigned int nr_port, nr_irq;
 static long port[SNDRV_CARDS] = SNDRV_DEFAULT_PORT; /* 0x3f8,0x2f8,0x3e8,0x2e8 */
 static int irq[SNDRV_CARDS] = SNDRV_DEFAULT_IRQ; 	/* 3,4,5,7,9,10,11,14,15 */
 static int speed[SNDRV_CARDS] = {[0 ... (SNDRV_CARDS - 1)] = 38400}; /* 9600,19200,38400,57600,115200 */
@@ -84,9 +85,9 @@ module_param_array(id, charp, NULL, 0444);
 MODULE_PARM_DESC(id, "ID string for Serial MIDI.");
 module_param_array(enable, bool, NULL, 0444);
 MODULE_PARM_DESC(enable, "Enable UART16550A chip.");
-module_param_array(port, long, NULL, 0444);
+module_param_array(port, long, &nr_port, 0444);
 MODULE_PARM_DESC(port, "Port # for UART16550A chip.");
-module_param_array(irq, int, NULL, 0444);
+module_param_array(irq, int, &nr_irq, 0444);
 MODULE_PARM_DESC(irq, "IRQ # for UART16550A chip.");
 module_param_array(speed, int, NULL, 0444);
 MODULE_PARM_DESC(speed, "Speed in bauds.");
@@ -1007,6 +1008,11 @@ static int __init alsa_card_serial_init(void)
 {
 	int i, cards, err;
 
+	if ((nr_port > 0 || nr_irq > 0) && kernel_is_locked_down()) {
+		pr_err("Kernel is locked down\n");
+		return -EPERM;
+	}
+
 	if ((err = platform_driver_register(&snd_serial_driver)) < 0)
 		return err;
 
diff --git a/sound/isa/ad1848/ad1848.c b/sound/isa/ad1848/ad1848.c
index a302d1f8d14f..4f2b277f36c9 100644
--- a/sound/isa/ad1848/ad1848.c
+++ b/sound/isa/ad1848/ad1848.c
@@ -44,6 +44,7 @@ MODULE_SUPPORTED_DEVICE("{{Analog Devices,AD1848},"
 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;	/* Index 0-MAX */
 static char *id[SNDRV_CARDS] = SNDRV_DEFAULT_STR;	/* ID for this card */
 static bool enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE;	/* Enable this card */
+static unsigned int nr_port, nr_irq, nr_dma1;
 static long port[SNDRV_CARDS] = SNDRV_DEFAULT_PORT;	/* PnP setup */
 static int irq[SNDRV_CARDS] = SNDRV_DEFAULT_IRQ;	/* 5,7,9,11,12,15 */
 static int dma1[SNDRV_CARDS] = SNDRV_DEFAULT_DMA;	/* 0,1,3,5,6,7 */
@@ -55,11 +56,11 @@ module_param_array(id, charp, NULL, 0444);
 MODULE_PARM_DESC(id, "ID string for " CRD_NAME " soundcard.");
 module_param_array(enable, bool, NULL, 0444);
 MODULE_PARM_DESC(enable, "Enable " CRD_NAME " soundcard.");
-module_param_array(port, long, NULL, 0444);
+module_param_array(port, long, &nr_port, 0444);
 MODULE_PARM_DESC(port, "Port # for " CRD_NAME " driver.");
-module_param_array(irq, int, NULL, 0444);
+module_param_array(irq, int, &nr_irq, 0444);
 MODULE_PARM_DESC(irq, "IRQ # for " CRD_NAME " driver.");
-module_param_array(dma1, int, NULL, 0444);
+module_param_array(dma1, int, &nr_dma1, 0444);
 MODULE_PARM_DESC(dma1, "DMA1 # for " CRD_NAME " driver.");
 module_param_array(thinkpad, bool, NULL, 0444);
 MODULE_PARM_DESC(thinkpad, "Enable only for the onboard CS4248 of IBM Thinkpad 360/750/755 series.");
@@ -170,4 +171,5 @@ static struct isa_driver snd_ad1848_driver = {
 	}
 };
 
-module_isa_driver(snd_ad1848_driver, SNDRV_CARDS);
+module_isa_driver(snd_ad1848_driver, SNDRV_CARDS,
+		  nr_port > 0 || nr_irq > 0 || nr_dma1 > 0);
diff --git a/sound/isa/adlib.c b/sound/isa/adlib.c
index 8d3060fd7ad7..b5f12f4ea6c0 100644
--- a/sound/isa/adlib.c
+++ b/sound/isa/adlib.c
@@ -16,6 +16,7 @@ MODULE_DESCRIPTION(CRD_NAME);
 MODULE_AUTHOR("Rene Herman");
 MODULE_LICENSE("GPL");
 
+static unsigned int nr_port;
 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;
 static char *id[SNDRV_CARDS] = SNDRV_DEFAULT_STR;
 static bool enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE;
@@ -27,7 +28,7 @@ module_param_array(id, charp, NULL, 0444);
 MODULE_PARM_DESC(id, "ID string for " CRD_NAME " soundcard.");
 module_param_array(enable, bool, NULL, 0444);
 MODULE_PARM_DESC(enable, "Enable " CRD_NAME " soundcard.");
-module_param_array(port, long, NULL, 0444);
+module_param_array(port, long, &nr_port, 0444);
 MODULE_PARM_DESC(port, "Port # for " CRD_NAME " driver.");
 
 static int snd_adlib_match(struct device *dev, unsigned int n)
@@ -112,4 +113,4 @@ static struct isa_driver snd_adlib_driver = {
 	}
 };
 
-module_isa_driver(snd_adlib_driver, SNDRV_CARDS);
+module_isa_driver(snd_adlib_driver, SNDRV_CARDS, nr_port > 0);
diff --git a/sound/isa/cmi8328.c b/sound/isa/cmi8328.c
index 787475084f46..6f4d546b7c48 100644
--- a/sound/isa/cmi8328.c
+++ b/sound/isa/cmi8328.c
@@ -34,6 +34,7 @@ MODULE_LICENSE("GPL");
 static int cmi8328_ports[] = { 0x530, 0xe80, 0xf40, 0x604 };
 #define CMI8328_MAX	ARRAY_SIZE(cmi8328_ports)
 
+static unsigned int nr_port, nr_irq, nr_dma1, nr_dma2, nr_mpuport, nr_mpuirq;
 static int index[CMI8328_MAX] =     {[0 ... (CMI8328_MAX-1)] = -1};
 static char *id[CMI8328_MAX] =      {[0 ... (CMI8328_MAX-1)] = NULL};
 static long port[CMI8328_MAX] =     {[0 ... (CMI8328_MAX-1)] = SNDRV_AUTO_PORT};
@@ -51,18 +52,18 @@ MODULE_PARM_DESC(index, "Index value for CMI8328 soundcard.");
 module_param_array(id, charp, NULL, 0444);
 MODULE_PARM_DESC(id, "ID string for CMI8328 soundcard.");
 
-module_param_array(port, long, NULL, 0444);
+module_param_array(port, long, &nr_port, 0444);
 MODULE_PARM_DESC(port, "Port # for CMI8328 driver.");
-module_param_array(irq, int, NULL, 0444);
+module_param_array(irq, int, &nr_irq, 0444);
 MODULE_PARM_DESC(irq, "IRQ # for CMI8328 driver.");
-module_param_array(dma1, int, NULL, 0444);
+module_param_array(dma1, int, &nr_dma1, 0444);
 MODULE_PARM_DESC(dma1, "DMA1 for CMI8328 driver.");
-module_param_array(dma2, int, NULL, 0444);
+module_param_array(dma2, int, &nr_dma2, 0444);
 MODULE_PARM_DESC(dma2, "DMA2 for CMI8328 driver.");
 
-module_param_array(mpuport, long, NULL, 0444);
+module_param_array(mpuport, long, &nr_mpuport, 0444);
 MODULE_PARM_DESC(mpuport, "MPU-401 port # for CMI8328 driver.");
-module_param_array(mpuirq, int, NULL, 0444);
+module_param_array(mpuirq, int, &nr_mpuirq, 0444);
 MODULE_PARM_DESC(mpuirq, "IRQ # for CMI8328 MPU-401 port.");
 #ifdef SUPPORT_JOYSTICK
 module_param_array(gameport, bool, NULL, 0444);
@@ -469,4 +470,6 @@ static struct isa_driver snd_cmi8328_driver = {
 	},
 };
 
-module_isa_driver(snd_cmi8328_driver, CMI8328_MAX);
+module_isa_driver(snd_cmi8328_driver, CMI8328_MAX,
+		  nr_port > 0 || nr_irq > 0 || nr_dma1 > 0 || nr_dma2 > 0 ||
+		  nr_mpuport > 0 || nr_mpuirq > 0);
diff --git a/sound/isa/cmi8330.c b/sound/isa/cmi8330.c
index dfedfd85f205..461263872c07 100644
--- a/sound/isa/cmi8330.c
+++ b/sound/isa/cmi8330.c
@@ -67,6 +67,9 @@ MODULE_DESCRIPTION("C-Media CMI8330/CMI8329");
 MODULE_LICENSE("GPL");
 MODULE_SUPPORTED_DEVICE("{{C-Media,CMI8330,isapnp:{CMI0001,@@@0001,@X@0001}}}");
 
+static unsigned int nr_sbport, nr_sbirq, nr_sbdma8, nr_sbdma16;
+static unsigned int nr_wssport, nr_wssirq, nr_wssdma;
+static unsigned int nr_fmport, nr_mpuport, nr_mpuirq;
 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;
 static char *id[SNDRV_CARDS] = SNDRV_DEFAULT_STR;
 static bool enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_ISAPNP;
@@ -95,27 +98,27 @@ module_param_array(isapnp, bool, NULL, 0444);
 MODULE_PARM_DESC(isapnp, "PnP detection for specified soundcard.");
 #endif
 
-module_param_array(sbport, long, NULL, 0444);
+module_param_array(sbport, long, &nr_sbport, 0444);
 MODULE_PARM_DESC(sbport, "Port # for CMI8330/CMI8329 SB driver.");
-module_param_array(sbirq, int, NULL, 0444);
+module_param_array(sbirq, int, &nr_sbirq, 0444);
 MODULE_PARM_DESC(sbirq, "IRQ # for CMI8330/CMI8329 SB driver.");
-module_param_array(sbdma8, int, NULL, 0444);
+module_param_array(sbdma8, int, &nr_sbdma8, 0444);
 MODULE_PARM_DESC(sbdma8, "DMA8 for CMI8330/CMI8329 SB driver.");
-module_param_array(sbdma16, int, NULL, 0444);
+module_param_array(sbdma16, int, &nr_sbdma16, 0444);
 MODULE_PARM_DESC(sbdma16, "DMA16 for CMI8330/CMI8329 SB driver.");
 
-module_param_array(wssport, long, NULL, 0444);
+module_param_array(wssport, long, &nr_wssport, 0444);
 MODULE_PARM_DESC(wssport, "Port # for CMI8330/CMI8329 WSS driver.");
-module_param_array(wssirq, int, NULL, 0444);
+module_param_array(wssirq, int, &nr_wssirq, 0444);
 MODULE_PARM_DESC(wssirq, "IRQ # for CMI8330/CMI8329 WSS driver.");
-module_param_array(wssdma, int, NULL, 0444);
+module_param_array(wssdma, int, &nr_wssdma, 0444);
 MODULE_PARM_DESC(wssdma, "DMA for CMI8330/CMI8329 WSS driver.");
 
-module_param_array(fmport, long, NULL, 0444);
+module_param_array(fmport, long, &nr_fmport, 0444);
 MODULE_PARM_DESC(fmport, "FM port # for CMI8330/CMI8329 driver.");
-module_param_array(mpuport, long, NULL, 0444);
+module_param_array(mpuport, long, &nr_mpuport, 0444);
 MODULE_PARM_DESC(mpuport, "MPU-401 port # for CMI8330/CMI8329 driver.");
-module_param_array(mpuirq, int, NULL, 0444);
+module_param_array(mpuirq, int, &nr_mpuirq, 0444);
 MODULE_PARM_DESC(mpuirq, "IRQ # for CMI8330/CMI8329 MPU-401 port.");
 #ifdef CONFIG_PNP
 static int isa_registered;
@@ -750,6 +753,14 @@ static int __init alsa_card_cmi8330_init(void)
 {
 	int err;
 
+	if ((nr_sbport > 0 || nr_sbirq > 0 || nr_sbdma8 > 0 || nr_sbdma16 > 0 ||
+	     nr_wssport > 0 || nr_wssirq > 0 || nr_wssdma > 0 ||
+	     nr_fmport > 0 || nr_mpuport > 0 || nr_mpuirq > 0) &&
+	    kernel_is_locked_down()) {
+		pr_err("Kernel is locked down\n");
+		return -EPERM;
+	}
+
 	err = isa_register_driver(&snd_cmi8330_driver, SNDRV_CARDS);
 #ifdef CONFIG_PNP
 	if (!err)
diff --git a/sound/isa/cs423x/cs4231.c b/sound/isa/cs423x/cs4231.c
index ef7448e9f813..647fc086034c 100644
--- a/sound/isa/cs423x/cs4231.c
+++ b/sound/isa/cs423x/cs4231.c
@@ -39,6 +39,8 @@ MODULE_AUTHOR("Jaroslav Kysela <perex@perex.cz>");
 MODULE_LICENSE("GPL");
 MODULE_SUPPORTED_DEVICE("{{Crystal Semiconductors,CS4231}}");
 
+static unsigned int nr_port, nr_irq, nr_dma1, nr_dma2;
+static unsigned int nr_mpuport, nr_mpuirq;
 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;	/* Index 0-MAX */
 static char *id[SNDRV_CARDS] = SNDRV_DEFAULT_STR;	/* ID for this card */
 static bool enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE;	/* Enable this card */
@@ -55,17 +57,17 @@ module_param_array(id, charp, NULL, 0444);
 MODULE_PARM_DESC(id, "ID string for " CRD_NAME " soundcard.");
 module_param_array(enable, bool, NULL, 0444);
 MODULE_PARM_DESC(enable, "Enable " CRD_NAME " soundcard.");
-module_param_array(port, long, NULL, 0444);
+module_param_array(port, long, &nr_port, 0444);
 MODULE_PARM_DESC(port, "Port # for " CRD_NAME " driver.");
-module_param_array(mpu_port, long, NULL, 0444);
+module_param_array(mpu_port, long, &nr_mpuport, 0444);
 MODULE_PARM_DESC(mpu_port, "MPU-401 port # for " CRD_NAME " driver.");
-module_param_array(irq, int, NULL, 0444);
+module_param_array(irq, int, &nr_irq, 0444);
 MODULE_PARM_DESC(irq, "IRQ # for " CRD_NAME " driver.");
-module_param_array(mpu_irq, int, NULL, 0444);
+module_param_array(mpu_irq, int, &nr_mpuirq, 0444);
 MODULE_PARM_DESC(mpu_irq, "MPU-401 IRQ # for " CRD_NAME " driver.");
-module_param_array(dma1, int, NULL, 0444);
+module_param_array(dma1, int, &nr_dma1, 0444);
 MODULE_PARM_DESC(dma1, "DMA1 # for " CRD_NAME " driver.");
-module_param_array(dma2, int, NULL, 0444);
+module_param_array(dma2, int, &nr_dma2, 0444);
 MODULE_PARM_DESC(dma2, "DMA2 # for " CRD_NAME " driver.");
 
 static int snd_cs4231_match(struct device *dev, unsigned int n)
@@ -186,4 +188,6 @@ static struct isa_driver snd_cs4231_driver = {
 	}
 };
 
-module_isa_driver(snd_cs4231_driver, SNDRV_CARDS);
+module_isa_driver(snd_cs4231_driver, SNDRV_CARDS,
+		  nr_port > 0 || nr_irq > 0 || nr_dma1 > 0 || nr_dma2 > 0 ||
+		  nr_mpuport > 0 || nr_mpuirq > 0);
diff --git a/sound/isa/cs423x/cs4236.c b/sound/isa/cs423x/cs4236.c
index 9d7582c90a95..1527bd7364b2 100644
--- a/sound/isa/cs423x/cs4236.c
+++ b/sound/isa/cs423x/cs4236.c
@@ -72,6 +72,8 @@ MODULE_ALIAS("snd_cs4232");
 #define IDENT "CS4232+"
 #define DEV_NAME "cs4232+"
 
+static unsigned int nr_port, nr_cport, nr_irq, nr_fm_port, nr_sb_port;
+static unsigned int nr_mpuport, nr_mpuirq, nr_dma1, nr_dma2;
 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;	/* Index 0-MAX */
 static char *id[SNDRV_CARDS] = SNDRV_DEFAULT_STR;	/* ID for this card */
 static bool enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_ISAPNP; /* Enable this card */
@@ -98,23 +100,23 @@ MODULE_PARM_DESC(enable, "Enable " IDENT " soundcard.");
 module_param_array(isapnp, bool, NULL, 0444);
 MODULE_PARM_DESC(isapnp, "ISA PnP detection for specified soundcard.");
 #endif
-module_param_array(port, long, NULL, 0444);
+module_param_array(port, long, &nr_port, 0444);
 MODULE_PARM_DESC(port, "Port # for " IDENT " driver.");
-module_param_array(cport, long, NULL, 0444);
+module_param_array(cport, long, &nr_cport, 0444);
 MODULE_PARM_DESC(cport, "Control port # for " IDENT " driver.");
-module_param_array(mpu_port, long, NULL, 0444);
+module_param_array(mpu_port, long, &nr_mpuport, 0444);
 MODULE_PARM_DESC(mpu_port, "MPU-401 port # for " IDENT " driver.");
-module_param_array(fm_port, long, NULL, 0444);
+module_param_array(fm_port, long, &nr_fm_port, 0444);
 MODULE_PARM_DESC(fm_port, "FM port # for " IDENT " driver.");
-module_param_array(sb_port, long, NULL, 0444);
+module_param_array(sb_port, long, &nr_sb_port, 0444);
 MODULE_PARM_DESC(sb_port, "SB port # for " IDENT " driver (optional).");
-module_param_array(irq, int, NULL, 0444);
+module_param_array(irq, int, &nr_irq, 0444);
 MODULE_PARM_DESC(irq, "IRQ # for " IDENT " driver.");
-module_param_array(mpu_irq, int, NULL, 0444);
+module_param_array(mpu_irq, int, &nr_mpu_irq, 0444);
 MODULE_PARM_DESC(mpu_irq, "MPU-401 IRQ # for " IDENT " driver.");
-module_param_array(dma1, int, NULL, 0444);
+module_param_array(dma1, int, &nr_dma1, 0444);
 MODULE_PARM_DESC(dma1, "DMA1 # for " IDENT " driver.");
-module_param_array(dma2, int, NULL, 0444);
+module_param_array(dma2, int, &nr_dma2, 0444);
 MODULE_PARM_DESC(dma2, "DMA2 # for " IDENT " driver.");
 
 #ifdef CONFIG_PNP
@@ -689,6 +691,15 @@ static int __init alsa_card_cs423x_init(void)
 {
 	int err;
 
+	if ((nr_port > 0 || nr_cport > 0 || nr_irq > 0 ||
+	     nr_fm_port > 0 || nr_sb_port > 0 ||
+	     nr_dma1 > 0 || nr_dma2 > 0 ||
+	     nr_mpuport > 0 || nr_mpuirq > 0) &&
+	    kernel_is_locked_down()) {
+		pr_err("Kernel is locked down\n");
+		return -EPERM;
+	}
+
 	err = isa_register_driver(&cs423x_isa_driver, SNDRV_CARDS);
 #ifdef CONFIG_PNP
 	if (!err)
diff --git a/sound/isa/es1688/es1688.c b/sound/isa/es1688/es1688.c
index 1901c2bb6c3b..cdfc023538d4 100644
--- a/sound/isa/es1688/es1688.c
+++ b/sound/isa/es1688/es1688.c
@@ -48,6 +48,8 @@ MODULE_SUPPORTED_DEVICE("{{ESS,ES688 PnP AudioDrive,pnp:ESS0100},"
 
 MODULE_ALIAS("snd_es968");
 
+static unsigned int nr_port, nr_irq, nr_fm_port;
+static unsigned int nr_mpu_port, nr_mpu_irq, nr_dma8;
 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;	/* Index 0-MAX */
 static char *id[SNDRV_CARDS] = SNDRV_DEFAULT_STR;	/* ID for this card */
 #ifdef CONFIG_PNP
@@ -71,17 +73,17 @@ module_param_array(isapnp, bool, NULL, 0444);
 MODULE_PARM_DESC(isapnp, "PnP detection for specified soundcard.");
 #endif
 MODULE_PARM_DESC(enable, "Enable " CRD_NAME " soundcard.");
-module_param_array(port, long, NULL, 0444);
+module_param_array(port, long, &nr_port, 0444);
 MODULE_PARM_DESC(port, "Port # for " CRD_NAME " driver.");
-module_param_array(mpu_port, long, NULL, 0444);
+module_param_array(mpu_port, long, &nr_mpu_port, 0444);
 MODULE_PARM_DESC(mpu_port, "MPU-401 port # for " CRD_NAME " driver.");
-module_param_array(irq, int, NULL, 0444);
-module_param_array(fm_port, long, NULL, 0444);
+module_param_array(irq, int, &nr_irq, 0444);
+module_param_array(fm_port, long, &nr_fm_port, 0444);
 MODULE_PARM_DESC(fm_port, "FM port # for ES1688 driver.");
 MODULE_PARM_DESC(irq, "IRQ # for " CRD_NAME " driver.");
-module_param_array(mpu_irq, int, NULL, 0444);
+module_param_array(mpu_irq, int, &nr_mpu_irq, 0444);
 MODULE_PARM_DESC(mpu_irq, "MPU-401 IRQ # for " CRD_NAME " driver.");
-module_param_array(dma8, int, NULL, 0444);
+module_param_array(dma8, int, &nr_dma8, 0444);
 MODULE_PARM_DESC(dma8, "8-bit DMA # for " CRD_NAME " driver.");
 
 #ifdef CONFIG_PNP
@@ -344,6 +346,14 @@ static struct pnp_card_driver es968_pnpc_driver = {
 
 static int __init alsa_card_es1688_init(void)
 {
+	if ((nr_port > 0 || nr_irq > 0 ||
+	     nr_fm_port > 0 || nr_dma8 > 0 ||
+	     nr_mpuport > 0 || nr_mpuirq > 0) &&
+	    kernel_is_locked_down()) {
+		pr_err("Kernel is locked down\n");
+		return -EPERM;
+	}
+
 #ifdef CONFIG_PNP
 	pnp_register_card_driver(&es968_pnpc_driver);
 	if (snd_es968_pnp_is_probed)
diff --git a/sound/isa/es18xx.c b/sound/isa/es18xx.c
index 5094b62d8f77..0e44d26d2eca 100644
--- a/sound/isa/es18xx.c
+++ b/sound/isa/es18xx.c
@@ -1972,6 +1972,8 @@ MODULE_SUPPORTED_DEVICE("{{ESS,ES1868 PnP AudioDrive},"
 		"{ESS,ES1887 AudioDrive},"
 		"{ESS,ES1888 AudioDrive}}");
 
+static unsigned int nr_port, nr_irq, nr_fm_port;
+static unsigned int nr_mpu_port, nr_dma1, nr_dma2;
 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;	/* Index 0-MAX */
 static char *id[SNDRV_CARDS] = SNDRV_DEFAULT_STR;	/* ID for this card */
 static bool enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_ISAPNP; /* Enable this card */
@@ -1999,17 +2001,17 @@ MODULE_PARM_DESC(enable, "Enable ES18xx soundcard.");
 module_param_array(isapnp, bool, NULL, 0444);
 MODULE_PARM_DESC(isapnp, "PnP detection for specified soundcard.");
 #endif
-module_param_array(port, long, NULL, 0444);
+module_param_array(port, long, &nr_port, 0444);
 MODULE_PARM_DESC(port, "Port # for ES18xx driver.");
-module_param_array(mpu_port, long, NULL, 0444);
+module_param_array(mpu_port, long, &nr_mpu_port, 0444);
 MODULE_PARM_DESC(mpu_port, "MPU-401 port # for ES18xx driver.");
-module_param_array(fm_port, long, NULL, 0444);
+module_param_array(fm_port, long, &nr_fm_port, 0444);
 MODULE_PARM_DESC(fm_port, "FM port # for ES18xx driver.");
-module_param_array(irq, int, NULL, 0444);
+module_param_array(irq, int, &nr_irq, 0444);
 MODULE_PARM_DESC(irq, "IRQ # for ES18xx driver.");
-module_param_array(dma1, int, NULL, 0444);
+module_param_array(dma1, int, &nr_dma1, 0444);
 MODULE_PARM_DESC(dma1, "DMA 1 # for ES18xx driver.");
-module_param_array(dma2, int, NULL, 0444);
+module_param_array(dma2, int, &nr_dma2, 0444);
 MODULE_PARM_DESC(dma2, "DMA 2 # for ES18xx driver.");
 
 #ifdef CONFIG_PNP
@@ -2405,6 +2407,14 @@ static int __init alsa_card_es18xx_init(void)
 {
 	int err;
 
+	if ((nr_port > 0 || nr_irq > 0 ||
+	     nr_dma1 > 0 || nr_dma2 > 0 ||
+	     nr_fm_port > 0 || nr_mpuport > 0) &&
+	    kernel_is_locked_down()) {
+		pr_err("Kernel is locked down\n");
+		return -EPERM;
+	}
+
 	err = isa_register_driver(&snd_es18xx_isa_driver, SNDRV_CARDS);
 #ifdef CONFIG_PNP
 	if (!err)
diff --git a/sound/isa/galaxy/galaxy.c b/sound/isa/galaxy/galaxy.c
index 379abe2cbeb2..8c8299abbb69 100644
--- a/sound/isa/galaxy/galaxy.c
+++ b/sound/isa/galaxy/galaxy.c
@@ -44,6 +44,8 @@ MODULE_PARM_DESC(id, "ID string for " CRD_NAME " soundcard.");
 module_param_array(enable, bool, NULL, 0444);
 MODULE_PARM_DESC(enable, "Enable " CRD_NAME " soundcard.");
 
+static unsigned int nr_port, nr_wss_port, nr_mpu_port, nr_fm_port;
+static unsigned int nr_irq, nr_mpu_irq, nr_dma1, nr_dma2;
 static long port[SNDRV_CARDS] = SNDRV_DEFAULT_PORT;
 static long wss_port[SNDRV_CARDS] = SNDRV_DEFAULT_PORT;
 static long mpu_port[SNDRV_CARDS] = SNDRV_DEFAULT_PORT;
@@ -53,21 +55,21 @@ static int mpu_irq[SNDRV_CARDS] = SNDRV_DEFAULT_IRQ;
 static int dma1[SNDRV_CARDS] = SNDRV_DEFAULT_DMA;
 static int dma2[SNDRV_CARDS] = SNDRV_DEFAULT_DMA;
 
-module_param_array(port, long, NULL, 0444);
+module_param_array(port, long, &nr_port, 0444);
 MODULE_PARM_DESC(port, "Port # for " CRD_NAME " driver.");
-module_param_array(wss_port, long, NULL, 0444);
+module_param_array(wss_port, long, &nr_wss_port, 0444);
 MODULE_PARM_DESC(wss_port, "WSS port # for " CRD_NAME " driver.");
-module_param_array(mpu_port, long, NULL, 0444);
+module_param_array(mpu_port, long, &nr_mpu_port, 0444);
 MODULE_PARM_DESC(mpu_port, "MPU-401 port # for " CRD_NAME " driver.");
-module_param_array(fm_port, long, NULL, 0444);
+module_param_array(fm_port, long, &nr_fm_port, 0444);
 MODULE_PARM_DESC(fm_port, "FM port # for " CRD_NAME " driver.");
-module_param_array(irq, int, NULL, 0444);
+module_param_array(irq, int, &nr_irq, 0444);
 MODULE_PARM_DESC(irq, "IRQ # for " CRD_NAME " driver.");
-module_param_array(mpu_irq, int, NULL, 0444);
+module_param_array(mpu_irq, int, &nr_mpu_irq, 0444);
 MODULE_PARM_DESC(mpu_irq, "MPU-401 IRQ # for " CRD_NAME " driver.");
-module_param_array(dma1, int, NULL, 0444);
+module_param_array(dma1, int, &nr_dma1, 0444);
 MODULE_PARM_DESC(dma1, "Playback DMA # for " CRD_NAME " driver.");
-module_param_array(dma2, int, NULL, 0444);
+module_param_array(dma2, int, &nr_dma2, 0444);
 MODULE_PARM_DESC(dma2, "Capture DMA # for " CRD_NAME " driver.");
 
 /*
@@ -634,4 +636,7 @@ static struct isa_driver snd_galaxy_driver = {
 	}
 };
 
-module_isa_driver(snd_galaxy_driver, SNDRV_CARDS);
+module_isa_driver(snd_galaxy_driver, SNDRV_CARDS,
+		  nr_port > 0 || nr_wss_port > 0 || nr_mpuport > 0 ||
+		  nr_fm_port > 0 || nr_irq > 0 || nr_mpuirq > 0 ||
+		  nr_dma1 > 0 || nr_dma2 > 0);
diff --git a/sound/isa/gus/gusclassic.c b/sound/isa/gus/gusclassic.c
index c169be49ed71..c2815f6adf7a 100644
--- a/sound/isa/gus/gusclassic.c
+++ b/sound/isa/gus/gusclassic.c
@@ -40,6 +40,7 @@ MODULE_AUTHOR("Jaroslav Kysela <perex@perex.cz>");
 MODULE_LICENSE("GPL");
 MODULE_SUPPORTED_DEVICE("{{Gravis,UltraSound Classic}}");
 
+static unsigned int nr_port, nr_irq, nr_dma1, nr_dma2;
 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;	/* Index 0-MAX */
 static char *id[SNDRV_CARDS] = SNDRV_DEFAULT_STR;	/* ID for this card */
 static bool enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE;	/* Enable this card */
@@ -58,13 +59,13 @@ module_param_array(id, charp, NULL, 0444);
 MODULE_PARM_DESC(id, "ID string for " CRD_NAME " soundcard.");
 module_param_array(enable, bool, NULL, 0444);
 MODULE_PARM_DESC(enable, "Enable " CRD_NAME " soundcard.");
-module_param_array(port, long, NULL, 0444);
+module_param_array(port, long, &nr_port, 0444);
 MODULE_PARM_DESC(port, "Port # for " CRD_NAME " driver.");
-module_param_array(irq, int, NULL, 0444);
+module_param_array(irq, int, &nr_irq, 0444);
 MODULE_PARM_DESC(irq, "IRQ # for " CRD_NAME " driver.");
-module_param_array(dma1, int, NULL, 0444);
+module_param_array(dma1, int, &nr_dma1, 0444);
 MODULE_PARM_DESC(dma1, "DMA1 # for " CRD_NAME " driver.");
-module_param_array(dma2, int, NULL, 0444);
+module_param_array(dma2, int, &nr_dma2, 0444);
 MODULE_PARM_DESC(dma2, "DMA2 # for " CRD_NAME " driver.");
 module_param_array(joystick_dac, int, NULL, 0444);
 MODULE_PARM_DESC(joystick_dac, "Joystick DAC level 0.59V-4.52V or 0.389V-2.98V for " CRD_NAME " driver.");
@@ -229,4 +230,5 @@ static struct isa_driver snd_gusclassic_driver = {
 	}
 };
 
-module_isa_driver(snd_gusclassic_driver, SNDRV_CARDS);
+module_isa_driver(snd_gusclassic_driver, SNDRV_CARDS,
+		  nr_port > 0 || nr_irq > 0 || nr_dma1 > 0 || nr_dma2 > 0);
diff --git a/sound/isa/gus/gusextreme.c b/sound/isa/gus/gusextreme.c
index 77ac2fd723b4..7b8b5bf51e00 100644
--- a/sound/isa/gus/gusextreme.c
+++ b/sound/isa/gus/gusextreme.c
@@ -44,6 +44,8 @@ MODULE_AUTHOR("Jaroslav Kysela <perex@perex.cz>");
 MODULE_LICENSE("GPL");
 MODULE_SUPPORTED_DEVICE("{{Gravis,UltraSound Extreme}}");
 
+static unsigned int nr_port, nr_gf1_port, nr_mpu_port;
+static unsigned int nr_irq, nr_mpu_irq, nr_gf1_irq, nr_dma8, nr_dma1;
 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;	/* Index 0-MAX */
 static char *id[SNDRV_CARDS] = SNDRV_DEFAULT_STR;	/* ID for this card */
 static bool enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE;	/* Enable this card */
@@ -66,21 +68,21 @@ module_param_array(id, charp, NULL, 0444);
 MODULE_PARM_DESC(id, "ID string for " CRD_NAME " soundcard.");
 module_param_array(enable, bool, NULL, 0444);
 MODULE_PARM_DESC(enable, "Enable " CRD_NAME " soundcard.");
-module_param_array(port, long, NULL, 0444);
+module_param_array(port, long, &nr_port, 0444);
 MODULE_PARM_DESC(port, "Port # for " CRD_NAME " driver.");
-module_param_array(gf1_port, long, NULL, 0444);
+module_param_array(gf1_port, long, &nr_gf1_port, 0444);
 MODULE_PARM_DESC(gf1_port, "GF1 port # for " CRD_NAME " driver (optional).");
-module_param_array(mpu_port, long, NULL, 0444);
+module_param_array(mpu_port, long, &nr_mpu_port, 0444);
 MODULE_PARM_DESC(mpu_port, "MPU-401 port # for " CRD_NAME " driver.");
-module_param_array(irq, int, NULL, 0444);
+module_param_array(irq, int, &nr_irq, 0444);
 MODULE_PARM_DESC(irq, "IRQ # for " CRD_NAME " driver.");
-module_param_array(mpu_irq, int, NULL, 0444);
+module_param_array(mpu_irq, int, &nr_mpu_irq, 0444);
 MODULE_PARM_DESC(mpu_irq, "MPU-401 IRQ # for " CRD_NAME " driver.");
-module_param_array(gf1_irq, int, NULL, 0444);
+module_param_array(gf1_irq, int, &nr_gf1_irq, 0444);
 MODULE_PARM_DESC(gf1_irq, "GF1 IRQ # for " CRD_NAME " driver.");
-module_param_array(dma8, int, NULL, 0444);
+module_param_array(dma8, int, &nr_dma8, 0444);
 MODULE_PARM_DESC(dma8, "8-bit DMA # for " CRD_NAME " driver.");
-module_param_array(dma1, int, NULL, 0444);
+module_param_array(dma1, int, &nr_dma1, 0444);
 MODULE_PARM_DESC(dma1, "GF1 DMA # for " CRD_NAME " driver.");
 module_param_array(joystick_dac, int, NULL, 0444);
 MODULE_PARM_DESC(joystick_dac, "Joystick DAC level 0.59V-4.52V or 0.389V-2.98V for " CRD_NAME " driver.");
@@ -358,4 +360,7 @@ static struct isa_driver snd_gusextreme_driver = {
 	}
 };
 
-module_isa_driver(snd_gusextreme_driver, SNDRV_CARDS);
+module_isa_driver(snd_gusextreme_driver, SNDRV_CARDS,
+		  nr_port > 0 || nr_gf1_port > 0 || nr_mpu_irq > 0 ||
+		  nr_irq > 0 || nr_mpu_irq > 0 || nr_gf1_irq > 0 ||
+		  nr_dma8 > 0 || nr_dma1 > 0);
diff --git a/sound/isa/gus/gusmax.c b/sound/isa/gus/gusmax.c
index dd88c9d33492..32914b7854f4 100644
--- a/sound/isa/gus/gusmax.c
+++ b/sound/isa/gus/gusmax.c
@@ -50,19 +50,20 @@ static int joystick_dac[SNDRV_CARDS] = {[0 ... (SNDRV_CARDS - 1)] = 29};
 static int channels[SNDRV_CARDS] = {[0 ... (SNDRV_CARDS - 1)] = 24};
 static int pcm_channels[SNDRV_CARDS] = {[0 ... (SNDRV_CARDS - 1)] = 2};
 
+static unsigned int nr_port, nr_irq, nr_dma1, nr_dma2;
 module_param_array(index, int, NULL, 0444);
 MODULE_PARM_DESC(index, "Index value for GUS MAX soundcard.");
 module_param_array(id, charp, NULL, 0444);
 MODULE_PARM_DESC(id, "ID string for GUS MAX soundcard.");
 module_param_array(enable, bool, NULL, 0444);
 MODULE_PARM_DESC(enable, "Enable GUS MAX soundcard.");
-module_param_array(port, long, NULL, 0444);
+module_param_array(port, long, &nr_port, 0444);
 MODULE_PARM_DESC(port, "Port # for GUS MAX driver.");
-module_param_array(irq, int, NULL, 0444);
+module_param_array(irq, int, &nr_irq, 0444);
 MODULE_PARM_DESC(irq, "IRQ # for GUS MAX driver.");
-module_param_array(dma1, int, NULL, 0444);
+module_param_array(dma1, int, &nr_dma1, 0444);
 MODULE_PARM_DESC(dma1, "DMA1 # for GUS MAX driver.");
-module_param_array(dma2, int, NULL, 0444);
+module_param_array(dma2, int, &nr_dma2, 0444);
 MODULE_PARM_DESC(dma2, "DMA2 # for GUS MAX driver.");
 module_param_array(joystick_dac, int, NULL, 0444);
 MODULE_PARM_DESC(joystick_dac, "Joystick DAC level 0.59V-4.52V or 0.389V-2.98V for GUS MAX driver.");
@@ -370,4 +371,5 @@ static struct isa_driver snd_gusmax_driver = {
 	},
 };
 
-module_isa_driver(snd_gusmax_driver, SNDRV_CARDS);
+module_isa_driver(snd_gusmax_driver, SNDRV_CARDS,
+		  nr_port > 0 || nr_irq > 0 || nr_dma1 > 0 || nr_dma2 > 0);
diff --git a/sound/isa/gus/interwave.c b/sound/isa/gus/interwave.c
index 70d0040484c8..8ab68e0ca6de 100644
--- a/sound/isa/gus/interwave.c
+++ b/sound/isa/gus/interwave.c
@@ -53,6 +53,7 @@ MODULE_DESCRIPTION("AMD InterWave STB with TEA6330T");
 MODULE_SUPPORTED_DEVICE("{{AMD,InterWave STB with TEA6330T}}");
 #endif
 
+static unsigned int nr_port, nr_irq, nr_dma1, nr_dma2;
 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;	/* Index 0-MAX */
 static char *id[SNDRV_CARDS] = SNDRV_DEFAULT_STR;	/* ID for this card */
 static bool enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_ISAPNP; /* Enable this card */
@@ -61,6 +62,7 @@ static bool isapnp[SNDRV_CARDS] = {[0 ... (SNDRV_CARDS - 1)] = 1};
 #endif
 static long port[SNDRV_CARDS] = SNDRV_DEFAULT_PORT;	/* 0x210,0x220,0x230,0x240,0x250,0x260 */
 #ifdef SNDRV_STB
+static unsigned int nr_port_tc;
 static long port_tc[SNDRV_CARDS] = SNDRV_DEFAULT_PORT;	/* 0x350,0x360,0x370,0x380 */
 #endif
 static int irq[SNDRV_CARDS] = SNDRV_DEFAULT_IRQ;	/* 2,3,5,9,11,12,15 */
@@ -92,17 +94,17 @@ MODULE_PARM_DESC(enable, "Enable InterWave soundcard.");
 module_param_array(isapnp, bool, NULL, 0444);
 MODULE_PARM_DESC(isapnp, "ISA PnP detection for specified soundcard.");
 #endif
-module_param_array(port, long, NULL, 0444);
+module_param_array(port, long, &nr_port, 0444);
 MODULE_PARM_DESC(port, "Port # for InterWave driver.");
 #ifdef SNDRV_STB
-module_param_array(port_tc, long, NULL, 0444);
+module_param_array(port_tc, long, &nr_port_tc, 0444);
 MODULE_PARM_DESC(port_tc, "Tone control (TEA6330T - i2c bus) port # for InterWave driver.");
 #endif
-module_param_array(irq, int, NULL, 0444);
+module_param_array(irq, int, &nr_port_irq, 0444);
 MODULE_PARM_DESC(irq, "IRQ # for InterWave driver.");
-module_param_array(dma1, int, NULL, 0444);
+module_param_array(dma1, int, &nr_port_dma1, 0444);
 MODULE_PARM_DESC(dma1, "DMA1 # for InterWave driver.");
-module_param_array(dma2, int, NULL, 0444);
+module_param_array(dma2, int, &nr_port_dma2, 0444);
 MODULE_PARM_DESC(dma2, "DMA2 # for InterWave driver.");
 module_param_array(joystick_dac, int, NULL, 0444);
 MODULE_PARM_DESC(joystick_dac, "Joystick DAC level 0.59V-4.52V or 0.389V-2.98V for InterWave driver.");
@@ -908,6 +910,15 @@ static int __init alsa_card_interwave_init(void)
 {
 	int err;
 
+	if ((nr_port > 0 || nr_irq > 0 || nr_dma1 > 0 || nr_dma2 > 0
+#ifdef SNDRV_STB
+	     || nr_port_tc > 0
+#endif
+	     ) && kernel_is_locked_down()) {
+		pr_err("Kernel is locked down\n");
+		return -EPERM;
+	}
+
 	err = isa_register_driver(&snd_interwave_driver, SNDRV_CARDS);
 #ifdef CONFIG_PNP
 	if (!err)
diff --git a/sound/isa/msnd/msnd_pinnacle.c b/sound/isa/msnd/msnd_pinnacle.c
index 4c072666115d..fa389122bc0b 100644
--- a/sound/isa/msnd/msnd_pinnacle.c
+++ b/sound/isa/msnd/msnd_pinnacle.c
@@ -800,22 +800,25 @@ MODULE_LICENSE("GPL");
 MODULE_FIRMWARE(INITCODEFILE);
 MODULE_FIRMWARE(PERMCODEFILE);
 
-module_param_array(io, long, NULL, S_IRUGO);
+static unsigned int nr_io, nr_irq, nr_mem;
+static unsigned int nr_mpu_io, nr_mpu_irq;
+static unsigned int nr_ide_io0, nr_ide_io1, nr_ide_irq, nr_joystick_io;
+module_param_array(io, long, &nr_io, S_IRUGO);
 MODULE_PARM_DESC(io, "IO port #");
-module_param_array(irq, int, NULL, S_IRUGO);
-module_param_array(mem, long, NULL, S_IRUGO);
+module_param_array(irq, int, &nr_irq, S_IRUGO);
+module_param_array(mem, long, &nr_mem, S_IRUGO);
 module_param_array(write_ndelay, int, NULL, S_IRUGO);
 module_param(calibrate_signal, int, S_IRUGO);
 #ifndef MSND_CLASSIC
 module_param_array(digital, int, NULL, S_IRUGO);
 module_param_array(cfg, long, NULL, S_IRUGO);
 module_param_array(reset, int, 0, S_IRUGO);
-module_param_array(mpu_io, long, NULL, S_IRUGO);
-module_param_array(mpu_irq, int, NULL, S_IRUGO);
-module_param_array(ide_io0, long, NULL, S_IRUGO);
-module_param_array(ide_io1, long, NULL, S_IRUGO);
-module_param_array(ide_irq, int, NULL, S_IRUGO);
-module_param_array(joystick_io, long, NULL, S_IRUGO);
+module_param_array(mpu_io, long, &nr_mpu_io, S_IRUGO);
+module_param_array(mpu_irq, int, &nr_mpu_irq, S_IRUGO);
+module_param_array(ide_io0, long, &nr_ide_io0, S_IRUGO);
+module_param_array(ide_io1, long, &nr_ide_io1, S_IRUGO);
+module_param_array(ide_irq, int, &nr_ide_irq, S_IRUGO);
+module_param_array(joystick_io, long, &nr_joystick_io, S_IRUGO);
 #endif
 
 
@@ -1212,6 +1215,17 @@ static int __init snd_msnd_init(void)
 {
 	int err;
 
+	if ((nr_io > 0 || nr_irq > 0 || nr_mem > 0
+#ifndef MSND_CLASSIC
+	     || nr_mpu_io > 0 || nr_mpu_irq > 0 ||
+	     nr_ide_io0 > 0 || nr_ide_io1 > 0 || nr_ide_irq > 0 ||
+	     nr_joystick_io > 0
+#endif
+	     ) && kernel_is_locked_down()) {
+		pr_err("Kernel is locked down\n");
+		return -EPERM;
+	}
+
 	err = isa_register_driver(&snd_msnd_driver, SNDRV_CARDS);
 #ifdef CONFIG_PNP
 	if (!err)
diff --git a/sound/isa/opl3sa2.c b/sound/isa/opl3sa2.c
index ae133633a420..7ad1c357cbb8 100644
--- a/sound/isa/opl3sa2.c
+++ b/sound/isa/opl3sa2.c
@@ -43,6 +43,8 @@ MODULE_SUPPORTED_DEVICE("{{Yamaha,YMF719E-S},"
 		"{Intel,AL440LX sound},"
 	        "{NeoMagic,MagicWave 3DX}}");
 
+static unsigned int nr_port, nr_sb_port, nr_wss_port, nr_fm_port, nr_midi_port;
+static unsigned int nr_irq, nr_dma1, nr_dma2;
 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;	/* Index 0-MAX */
 static char *id[SNDRV_CARDS] = SNDRV_DEFAULT_STR;	/* ID for this card */
 static bool enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_ISAPNP; /* Enable this card */
@@ -69,21 +71,21 @@ MODULE_PARM_DESC(enable, "Enable OPL3-SA soundcard.");
 module_param_array(isapnp, bool, NULL, 0444);
 MODULE_PARM_DESC(isapnp, "PnP detection for specified soundcard.");
 #endif
-module_param_array(port, long, NULL, 0444);
+module_param_array(port, long, &nr_port, 0444);
 MODULE_PARM_DESC(port, "Port # for OPL3-SA driver.");
-module_param_array(sb_port, long, NULL, 0444);
+module_param_array(sb_port, long, &nr_sb_port, 0444);
 MODULE_PARM_DESC(sb_port, "SB port # for OPL3-SA driver.");
-module_param_array(wss_port, long, NULL, 0444);
+module_param_array(wss_port, long, &nr_wss_port, 0444);
 MODULE_PARM_DESC(wss_port, "WSS port # for OPL3-SA driver.");
-module_param_array(fm_port, long, NULL, 0444);
+module_param_array(fm_port, long, &nr_fm_port, 0444);
 MODULE_PARM_DESC(fm_port, "FM port # for OPL3-SA driver.");
-module_param_array(midi_port, long, NULL, 0444);
+module_param_array(midi_port, long, &nr_midi_port, 0444);
 MODULE_PARM_DESC(midi_port, "MIDI port # for OPL3-SA driver.");
-module_param_array(irq, int, NULL, 0444);
+module_param_array(irq, int, &nr_irq, 0444);
 MODULE_PARM_DESC(irq, "IRQ # for OPL3-SA driver.");
-module_param_array(dma1, int, NULL, 0444);
+module_param_array(dma1, int, &nr_dma1, 0444);
 MODULE_PARM_DESC(dma1, "DMA1 # for OPL3-SA driver.");
-module_param_array(dma2, int, NULL, 0444);
+module_param_array(dma2, int, &nr_dma2, 0444);
 MODULE_PARM_DESC(dma2, "DMA2 # for OPL3-SA driver.");
 module_param_array(opl3sa3_ymode, int, NULL, 0444);
 MODULE_PARM_DESC(opl3sa3_ymode, "Speaker size selection for 3D Enhancement mode: Desktop/Large Notebook/Small Notebook/HiFi.");
@@ -931,6 +933,14 @@ static int __init alsa_card_opl3sa2_init(void)
 {
 	int err;
 
+	if ((nr_port > 0 || nr_sb_port > 0 || nr_wss_port > 0 ||
+	     nr_fm_port > 0 || nr_midi_port > 0 ||
+	     nr_irq > 0 || nr_dma1 > 0 || nr_dma2) &&
+	    kernel_is_locked_down()) {
+		pr_err("Kernel is locked down\n");
+		return -EPERM;
+	}
+
 	err = isa_register_driver(&snd_opl3sa2_isa_driver, SNDRV_CARDS);
 #ifdef CONFIG_PNP
 	if (!err)
diff --git a/sound/isa/opti9xx/miro.c b/sound/isa/opti9xx/miro.c
index 3a9067db1a84..c88a34d62705 100644
--- a/sound/isa/opti9xx/miro.c
+++ b/sound/isa/opti9xx/miro.c
@@ -1636,6 +1636,18 @@ static struct pnp_card_driver miro_pnpc_driver = {
 
 static int __init alsa_card_miro_init(void)
 {
+	if ((port != SNDRV_DEFAULT_PORT1 ||
+	     mpu_port != SNDRV_DEFAULT_PORT1 ||
+	     fm_port != SNDRV_DEFAULT_PORT1 ||
+	     irq != SNDRV_DEFAULT_IRQ1 ||
+	     mpu_irq != SNDRV_DEFAULT_IRQ1 ||
+	     dma1 != SNDRV_DEFAULT_DMA1 ||
+	     dma2 != SNDRV_DEFAULT_DMA1) &&
+	    kernel_is_locked_down()) {
+		pr_err("Kernel is locked down\n");
+		return -EPERM;
+	}
+
 #ifdef CONFIG_PNP
 	pnp_register_card_driver(&miro_pnpc_driver);
 	if (snd_miro_pnp_is_probed)
diff --git a/sound/isa/opti9xx/opti92x-ad1848.c b/sound/isa/opti9xx/opti92x-ad1848.c
index 0a5266003786..8408a381c8b9 100644
--- a/sound/isa/opti9xx/opti92x-ad1848.c
+++ b/sound/isa/opti9xx/opti92x-ad1848.c
@@ -1177,6 +1177,21 @@ static struct pnp_card_driver opti9xx_pnpc_driver = {
 
 static int __init alsa_card_opti9xx_init(void)
 {
+	if ((port != SNDRV_DEFAULT_PORT1 ||
+	     mpu_port != SNDRV_DEFAULT_PORT1 ||
+	     fm_port != SNDRV_DEFAULT_PORT1 ||
+	     irq != SNDRV_DEFAULT_IRQ1 ||
+	     mpu_irq != SNDRV_DEFAULT_IRQ1 ||
+	     dma1 != SNDRV_DEFAULT_DMA1
+#if defined(CS4231) || defined(OPTi93X)
+	     || dma2 != SNDRV_DEFAULT_DMA1
+#endif
+	     ) &&
+	    kernel_is_locked_down()) {
+		pr_err("Kernel is locked down\n");
+		return -EPERM;
+	}
+
 #ifdef CONFIG_PNP
 	pnp_register_card_driver(&opti9xx_pnpc_driver);
 	if (snd_opti9xx_pnp_is_probed)
diff --git a/sound/isa/sb/jazz16.c b/sound/isa/sb/jazz16.c
index 4d909971eedb..80d2db12a355 100644
--- a/sound/isa/sb/jazz16.c
+++ b/sound/isa/sb/jazz16.c
@@ -34,6 +34,7 @@ MODULE_SUPPORTED_DEVICE("{{Media Vision ??? },"
 MODULE_AUTHOR("Krzysztof Helt <krzysztof.h1@wp.pl>");
 MODULE_LICENSE("GPL");
 
+static unsigned int nr_port, nr_mpu_port, nr_irq, nr_mpu_irq, nr_dma8, nr_dma16;
 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;	/* Index 0-MAX */
 static char *id[SNDRV_CARDS] = SNDRV_DEFAULT_STR;	/* ID for this card */
 static bool enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE;	/* Enable this card */
@@ -50,17 +51,17 @@ module_param_array(id, charp, NULL, 0444);
 MODULE_PARM_DESC(id, "ID string for Media Vision Jazz16 based soundcard.");
 module_param_array(enable, bool, NULL, 0444);
 MODULE_PARM_DESC(enable, "Enable Media Vision Jazz16 based soundcard.");
-module_param_array(port, long, NULL, 0444);
+module_param_array(port, long, &nr_port, 0444);
 MODULE_PARM_DESC(port, "Port # for jazz16 driver.");
-module_param_array(mpu_port, long, NULL, 0444);
+module_param_array(mpu_port, long, &nr_mpu_port, 0444);
 MODULE_PARM_DESC(mpu_port, "MPU-401 port # for jazz16 driver.");
-module_param_array(irq, int, NULL, 0444);
+module_param_array(irq, int, &nr_irq, 0444);
 MODULE_PARM_DESC(irq, "IRQ # for jazz16 driver.");
-module_param_array(mpu_irq, int, NULL, 0444);
+module_param_array(mpu_irq, int, &nr_mpu_irq, 0444);
 MODULE_PARM_DESC(mpu_irq, "MPU-401 IRQ # for jazz16 driver.");
-module_param_array(dma8, int, NULL, 0444);
+module_param_array(dma8, int, &nr_dma8, 0444);
 MODULE_PARM_DESC(dma8, "DMA8 # for jazz16 driver.");
-module_param_array(dma16, int, NULL, 0444);
+module_param_array(dma16, int, &nr_dma16, 0444);
 MODULE_PARM_DESC(dma16, "DMA16 # for jazz16 driver.");
 
 #define SB_JAZZ16_WAKEUP	0xaf
@@ -387,4 +388,6 @@ static struct isa_driver snd_jazz16_driver = {
 	},
 };
 
-module_isa_driver(snd_jazz16_driver, SNDRV_CARDS);
+module_isa_driver(snd_jazz16_driver, SNDRV_CARDS,
+		  nr_port > 0 || nr_mpu_port > 0 ||
+		  nr_irq > 0 || nr_mpu_irq > 0 || nr_dma8 > 0 || nr_dma16);
diff --git a/sound/isa/sb/sb16.c b/sound/isa/sb/sb16.c
index 4a7d7c89808f..55f0f2bafefc 100644
--- a/sound/isa/sb/sb16.c
+++ b/sound/isa/sb/sb16.c
@@ -66,6 +66,11 @@ MODULE_SUPPORTED_DEVICE("{{Creative Labs,SB AWE 32},"
 #define SNDRV_SBAWE_EMU8000
 #endif
 
+static unsigned int nr_port, nr_mpu_port, nr_fm_port;
+#ifdef SNDRV_SBAWE_EMU8000
+static unsigned int nr_awe_port;
+#endif
+static unsigned int nr_irq, nr_mpu_irq, nr_dma8, nr_dma16;
 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;	/* Index 0-MAX */
 static char *id[SNDRV_CARDS] = SNDRV_DEFAULT_STR;	/* ID for this card */
 static bool enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_ISAPNP; /* Enable this card */
@@ -99,21 +104,21 @@ MODULE_PARM_DESC(enable, "Enable SoundBlaster 16 soundcard.");
 module_param_array(isapnp, bool, NULL, 0444);
 MODULE_PARM_DESC(isapnp, "PnP detection for specified soundcard.");
 #endif
-module_param_array(port, long, NULL, 0444);
+module_param_array(port, long, &nr_port, 0444);
 MODULE_PARM_DESC(port, "Port # for SB16 driver.");
-module_param_array(mpu_port, long, NULL, 0444);
+module_param_array(mpu_port, long, &nr_mpu_port, 0444);
 MODULE_PARM_DESC(mpu_port, "MPU-401 port # for SB16 driver.");
-module_param_array(fm_port, long, NULL, 0444);
+module_param_array(fm_port, long, &nr_fm_port, 0444);
 MODULE_PARM_DESC(fm_port, "FM port # for SB16 PnP driver.");
 #ifdef SNDRV_SBAWE_EMU8000
-module_param_array(awe_port, long, NULL, 0444);
+module_param_array(awe_port, long, &nr_awe_port, 0444);
 MODULE_PARM_DESC(awe_port, "AWE port # for SB16 PnP driver.");
 #endif
-module_param_array(irq, int, NULL, 0444);
+module_param_array(irq, int, &nr_irq, 0444);
 MODULE_PARM_DESC(irq, "IRQ # for SB16 driver.");
-module_param_array(dma8, int, NULL, 0444);
+module_param_array(dma8, int, &nr_dma8, 0444);
 MODULE_PARM_DESC(dma8, "8-bit DMA # for SB16 driver.");
-module_param_array(dma16, int, NULL, 0444);
+module_param_array(dma16, int, &nr_dma16, 0444);
 MODULE_PARM_DESC(dma16, "16-bit DMA # for SB16 driver.");
 module_param_array(mic_agc, int, NULL, 0444);
 MODULE_PARM_DESC(mic_agc, "Mic Auto-Gain-Control switch.");
@@ -668,6 +673,16 @@ static int __init alsa_card_sb16_init(void)
 {
 	int err;
 
+	if ((nr_port > 0 || nr_mpu_port > 0 || nr_fm_port > 0 ||
+	     nr_irq > 0 || nr_mpu_irq > 0 || nr_dma8 > 0 || nr_dma16 > 0
+#ifdef SNDRV_SBAWE_EMU8000
+	     || nr_awe_port > 0
+#endif
+	     ) && kernel_is_locked_down()) {
+		pr_err("Kernel is locked down\n");
+		return -EPERM;
+	}
+
 	err = isa_register_driver(&snd_sb16_isa_driver, SNDRV_CARDS);
 #ifdef CONFIG_PNP
 	if (!err)
diff --git a/sound/isa/sb/sb8.c b/sound/isa/sb/sb8.c
index ad42d2364199..38988a2ae59c 100644
--- a/sound/isa/sb/sb8.c
+++ b/sound/isa/sb/sb8.c
@@ -34,6 +34,7 @@ MODULE_DESCRIPTION("Sound Blaster 1.0/2.0/Pro");
 MODULE_LICENSE("GPL");
 MODULE_SUPPORTED_DEVICE("{{Creative Labs,SB 1.0/SB 2.0/SB Pro}}");
 
+static unsigned int nr_port, nr_irq, nr_dma8;
 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;	/* Index 0-MAX */
 static char *id[SNDRV_CARDS] = SNDRV_DEFAULT_STR;	/* ID for this card */
 static bool enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE;	/* Enable this card */
@@ -47,11 +48,11 @@ module_param_array(id, charp, NULL, 0444);
 MODULE_PARM_DESC(id, "ID string for Sound Blaster soundcard.");
 module_param_array(enable, bool, NULL, 0444);
 MODULE_PARM_DESC(enable, "Enable Sound Blaster soundcard.");
-module_param_array(port, long, NULL, 0444);
+module_param_array(port, long, &nr_port, 0444);
 MODULE_PARM_DESC(port, "Port # for SB8 driver.");
-module_param_array(irq, int, NULL, 0444);
+module_param_array(irq, int, &nr_irq, 0444);
 MODULE_PARM_DESC(irq, "IRQ # for SB8 driver.");
-module_param_array(dma8, int, NULL, 0444);
+module_param_array(dma8, int, &nr_dma8, 0444);
 MODULE_PARM_DESC(dma8, "8-bit DMA # for SB8 driver.");
 
 struct snd_sb8 {
@@ -251,4 +252,5 @@ static struct isa_driver snd_sb8_driver = {
 	},
 };
 
-module_isa_driver(snd_sb8_driver, SNDRV_CARDS);
+module_isa_driver(snd_sb8_driver, SNDRV_CARDS,
+		  nr_port > 0 || nr_irq > 0 || nr_dma8 > 0);
diff --git a/sound/isa/sc6000.c b/sound/isa/sc6000.c
index b61a6633d8f2..b5ac04f34497 100644
--- a/sound/isa/sc6000.c
+++ b/sound/isa/sc6000.c
@@ -46,6 +46,8 @@ MODULE_SUPPORTED_DEVICE("{{Gallant, SC-6000},"
 			"{AudioExcel, Audio Excel DSP 16},"
 			"{Zoltrix, AV302}}");
 
+static unsigned int nr_port, nr_irq, nr_mss_port;
+static unsigned int nr_mpu_port, nr_mpu_irq, nr_dma;
 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;	/* Index 0-MAX */
 static char *id[SNDRV_CARDS] = SNDRV_DEFAULT_STR;	/* ID for this card */
 static bool enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE;	/* Enable this card */
@@ -64,17 +66,17 @@ module_param_array(id, charp, NULL, 0444);
 MODULE_PARM_DESC(id, "ID string for sc-6000 based soundcard.");
 module_param_array(enable, bool, NULL, 0444);
 MODULE_PARM_DESC(enable, "Enable sc-6000 based soundcard.");
-module_param_array(port, long, NULL, 0444);
+module_param_array(port, long, &nr_port, 0444);
 MODULE_PARM_DESC(port, "Port # for sc-6000 driver.");
-module_param_array(mss_port, long, NULL, 0444);
+module_param_array(mss_port, long, &nr_mss_port, 0444);
 MODULE_PARM_DESC(mss_port, "MSS Port # for sc-6000 driver.");
-module_param_array(mpu_port, long, NULL, 0444);
+module_param_array(mpu_port, long, &nr_mpu_port, 0444);
 MODULE_PARM_DESC(mpu_port, "MPU-401 port # for sc-6000 driver.");
-module_param_array(irq, int, NULL, 0444);
+module_param_array(irq, int, &nr_irq, 0444);
 MODULE_PARM_DESC(irq, "IRQ # for sc-6000 driver.");
-module_param_array(mpu_irq, int, NULL, 0444);
+module_param_array(mpu_irq, int, &nr_mpu_irq, 0444);
 MODULE_PARM_DESC(mpu_irq, "MPU-401 IRQ # for sc-6000 driver.");
-module_param_array(dma, int, NULL, 0444);
+module_param_array(dma, int, &nr_dma, 0444);
 MODULE_PARM_DESC(dma, "DMA # for sc-6000 driver.");
 module_param_array(joystick, bool, NULL, 0444);
 MODULE_PARM_DESC(joystick, "Enable gameport.");
@@ -711,4 +713,7 @@ static struct isa_driver snd_sc6000_driver = {
 };
 
 
-module_isa_driver(snd_sc6000_driver, SNDRV_CARDS);
+module_isa_driver(snd_sc6000_driver, SNDRV_CARDS,
+		  nr_port > 0 || nr_irq > 0 || nr_mss_port > 0 ||
+		  nr_mpu_port > 0 || nr_mpu_irq > 0 || nr_dma > 0);
+
diff --git a/sound/isa/sscape.c b/sound/isa/sscape.c
index fdcfa29e2205..2dce17ff0b5b 100644
--- a/sound/isa/sscape.c
+++ b/sound/isa/sscape.c
@@ -47,6 +47,7 @@ MODULE_FIRMWARE("sndscape.co3");
 MODULE_FIRMWARE("sndscape.co4");
 MODULE_FIRMWARE("scope.cod");
 
+static unsigned int nr_port, nr_wss_port, nr_irq, nr_mpu_irq, nr_dma, nr_dma2;
 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;
 static char* id[SNDRV_CARDS] = SNDRV_DEFAULT_STR;
 static long port[SNDRV_CARDS] = SNDRV_DEFAULT_PORT;
@@ -63,22 +64,22 @@ MODULE_PARM_DESC(index, "Index number for SoundScape soundcard");
 module_param_array(id, charp, NULL, 0444);
 MODULE_PARM_DESC(id, "Description for SoundScape card");
 
-module_param_array(port, long, NULL, 0444);
+module_param_array(port, long, &nr_port, 0444);
 MODULE_PARM_DESC(port, "Port # for SoundScape driver.");
 
-module_param_array(wss_port, long, NULL, 0444);
+module_param_array(wss_port, &nr_wss_port, NULL, 0444);
 MODULE_PARM_DESC(wss_port, "WSS Port # for SoundScape driver.");
 
-module_param_array(irq, int, NULL, 0444);
+module_param_array(irq, int, &nr_irq, 0444);
 MODULE_PARM_DESC(irq, "IRQ # for SoundScape driver.");
 
-module_param_array(mpu_irq, int, NULL, 0444);
+module_param_array(mpu_irq, int, &nr_mpu_irq, 0444);
 MODULE_PARM_DESC(mpu_irq, "MPU401 IRQ # for SoundScape driver.");
 
-module_param_array(dma, int, NULL, 0444);
+module_param_array(dma, int, &nr_dma, 0444);
 MODULE_PARM_DESC(dma, "DMA # for SoundScape driver.");
 
-module_param_array(dma2, int, NULL, 0444);
+module_param_array(dma2, int, &nr_dma2, 0444);
 MODULE_PARM_DESC(dma2, "DMA2 # for SoundScape driver.");
 
 module_param_array(joystick, bool, NULL, 0444);
@@ -1328,6 +1329,12 @@ static int __init sscape_init(void)
 {
 	int err;
 
+	if ((nr_port > 0 || nr_wss_port > 0 || nr_irq > 0 || nr_mpu_irq > 0 ||
+	     nr_dma > 0 || nr_dma2 > 0) && kernel_is_locked_down()) {
+		pr_err("Kernel is locked down\n");
+		return -EPERM;
+	}
+	
 	err = isa_register_driver(&snd_sscape_driver, SNDRV_CARDS);
 #ifdef CONFIG_PNP
 	if (!err)
diff --git a/sound/isa/wavefront/wavefront.c b/sound/isa/wavefront/wavefront.c
index a0987a57c8a9..8300528ea918 100644
--- a/sound/isa/wavefront/wavefront.c
+++ b/sound/isa/wavefront/wavefront.c
@@ -36,6 +36,10 @@ MODULE_DESCRIPTION("Turtle Beach Wavefront");
 MODULE_LICENSE("GPL");
 MODULE_SUPPORTED_DEVICE("{{Turtle Beach,Maui/Tropez/Tropez+}}");
 
+static unsigned int nr_cs4232_pcm_port, nr_cs4232_pcm_irq;
+static unsigned int nr_cs4232_mpu_port, nr_cs4232_mpu_irq;
+static unsigned int nr_ics2115_port, nr_ics2115_irq;
+static unsigned int nr_fm_port, nr_dma1, nr_dma2;
 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;	    /* Index 0-MAX */
 static char *id[SNDRV_CARDS] = SNDRV_DEFAULT_STR;	    /* ID for this card */
 static bool enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE;	    /* Enable this card */
@@ -63,23 +67,23 @@ MODULE_PARM_DESC(enable, "Enable WaveFront soundcard.");
 module_param_array(isapnp, bool, NULL, 0444);
 MODULE_PARM_DESC(isapnp, "ISA PnP detection for WaveFront soundcards.");
 #endif
-module_param_array(cs4232_pcm_port, long, NULL, 0444);
+module_param_array(cs4232_pcm_port, long, &nr_cs4232_pcm_port, 0444);
 MODULE_PARM_DESC(cs4232_pcm_port, "Port # for CS4232 PCM interface.");
-module_param_array(cs4232_pcm_irq, int, NULL, 0444);
+module_param_array(cs4232_pcm_irq, int, &nr_cs4232_pcm_irq, 0444);
 MODULE_PARM_DESC(cs4232_pcm_irq, "IRQ # for CS4232 PCM interface.");
-module_param_array(dma1, int, NULL, 0444);
+module_param_array(dma1, int, &nr_dma1, 0444);
 MODULE_PARM_DESC(dma1, "DMA1 # for CS4232 PCM interface.");
-module_param_array(dma2, int, NULL, 0444);
+module_param_array(dma2, int, &nr_dma2, 0444);
 MODULE_PARM_DESC(dma2, "DMA2 # for CS4232 PCM interface.");
-module_param_array(cs4232_mpu_port, long, NULL, 0444);
+module_param_array(cs4232_mpu_port, long, &nr_cs4232_mpu_port, 0444);
 MODULE_PARM_DESC(cs4232_mpu_port, "port # for CS4232 MPU-401 interface.");
-module_param_array(cs4232_mpu_irq, int, NULL, 0444);
+module_param_array(cs4232_mpu_irq, int, &nr_cs4232_mpu_irq, 0444);
 MODULE_PARM_DESC(cs4232_mpu_irq, "IRQ # for CS4232 MPU-401 interface.");
-module_param_array(ics2115_irq, int, NULL, 0444);
+module_param_array(ics2115_irq, int, &nr_ics2115_irq, 0444);
 MODULE_PARM_DESC(ics2115_irq, "IRQ # for ICS2115.");
-module_param_array(ics2115_port, long, NULL, 0444);
+module_param_array(ics2115_port, long, &nr_ics2115_port, 0444);
 MODULE_PARM_DESC(ics2115_port, "Port # for ICS2115.");
-module_param_array(fm_port, long, NULL, 0444);
+module_param_array(fm_port, long, &nr_fm_port, 0444);
 MODULE_PARM_DESC(fm_port, "FM port #.");
 module_param_array(use_cs4232_midi, bool, NULL, 0444);
 MODULE_PARM_DESC(use_cs4232_midi, "Use CS4232 MPU-401 interface (inaccessibly located inside your computer)");
@@ -653,6 +657,15 @@ static int __init alsa_card_wavefront_init(void)
 {
 	int err;
 
+	if ((nr_cs4232_pcm_port > 0 || nr_cs4232_pcm_irq > 0 ||
+	     nr_cs4232_mpu_port > 0 || nr_cs4232_mpu_irq > 0 ||
+	     nr_ics2115_port > 0 || nr_ics2115_irq > 0 ||
+	     nr_fm_port > 0 || nr_dma1 > 0 || nr_dma2 > 0) &&
+	    kernel_is_locked_down()) {
+		pr_err("Kernel is locked down\n");
+		return -EPERM;
+	}
+
 	err = isa_register_driver(&snd_wavefront_driver, SNDRV_CARDS);
 #ifdef CONFIG_PNP
 	if (!err)
diff --git a/sound/oss/ad1848.c b/sound/oss/ad1848.c
index 6368e5c7d0ba..a10371be4343 100644
--- a/sound/oss/ad1848.c
+++ b/sound/oss/ad1848.c
@@ -2983,6 +2983,12 @@ static int __init ad1848_isapnp_probe(struct address_info *hw_config)
 
 static int __init init_ad1848(void)
 {
+	if ((io != -1 || irq != -1 || dma != -1 || dma2 != -1) &&
+	    kernel_is_locked_down()) {
+		pr_err("Kernel is locked down\n");
+		return -EPERM;
+	}
+
 	printk(KERN_INFO "ad1848/cs4248 codec driver Copyright (C) by Hannu Savolainen 1993-1996\n");
 
 #ifdef CONFIG_PNP
diff --git a/sound/oss/aedsp16.c b/sound/oss/aedsp16.c
index bb477d5c8528..527d4bf4af49 100644
--- a/sound/oss/aedsp16.c
+++ b/sound/oss/aedsp16.c
@@ -1319,7 +1319,13 @@ MODULE_AUTHOR("Riccardo Facchetti <fizban@tin.it>");
 MODULE_DESCRIPTION("Audio Excel DSP 16 Driver Version " VERSION);
 MODULE_LICENSE("GPL");
 
-static int __init do_init_aedsp16(void) {
+static int __init do_init_aedsp16(void)
+{
+	if (kernel_is_locked_down()) {
+		pr_err("Kernel is locked down\n");
+		return -EPERM;
+	}
+
 	printk("Audio Excel DSP 16 init driver Copyright (C) Riccardo Facchetti 1995-98\n");
 	if (io == -1 || dma == -1 || irq == -1) {
 		printk(KERN_INFO "aedsp16: I/O, IRQ and DMA are mandatory\n");
diff --git a/sound/oss/mpu401.c b/sound/oss/mpu401.c
index 862735005b43..e13299f1ac8e 100644
--- a/sound/oss/mpu401.c
+++ b/sound/oss/mpu401.c
@@ -1758,6 +1758,12 @@ static int __init init_mpu401(void)
 	   to others */
 	if (io != -1 && irq != -1) {
 		struct resource *ports;
+
+		if (kernel_is_locked_down()) {
+			pr_err("Kernel is locked down\n");
+			return -EPERM;
+		}
+
 	        cfg.irq = irq;
 		cfg.io_base = io;
 		ports = request_region(io, 2, "mpu401");
diff --git a/sound/oss/msnd_pinnacle.c b/sound/oss/msnd_pinnacle.c
index a8bb4a06ba6f..3a78506ee7b9 100644
--- a/sound/oss/msnd_pinnacle.c
+++ b/sound/oss/msnd_pinnacle.c
@@ -1750,6 +1750,29 @@ static int __init msnd_init(void)
 	static msnd_pinnacle_cfg_t pinnacle_devs;
 #endif /* MSND_CLASSIC */
 
+	if ((
+#ifdef MSND_CLASSIC
+		    io != CONFIG_MSNDCLAS_IO ||
+		    irq != CONFIG_MSNDCLAS_IRQ ||
+		    mem != CONFIG_MSNDCLAS_MEM
+#else
+		    io != CONFIG_MSNDPIN_IO ||
+		    irq != CONFIG_MSNDPIN_IRQ ||
+		    mem != CONFIG_MSNDPIN_MEM ||
+		    cfg != CONFIG_MSNDPIN_CFG ||
+		    mpu_io != CONFIG_MSNDPIN_MPU_IO ||
+		    mpu_irq != CONFIG_MSNDPIN_MPU_IRQ ||
+		    ide_io0 != CONFIG_MSNDPIN_IDE_IO0 ||
+		    ide_io1 != CONFIG_MSNDPIN_IDE_IO1 ||
+		    ide_irq != CONFIG_MSNDPIN_IDE_IRQ ||
+		    joystick_io != CONFIG_MSNDPIN_JOYSTICK_IO
+#endif
+	     ) && kernel_is_locked_down()) {
+		pr_err("Kernel is locked down\n");
+		return -EPERM;
+	}
+
+	
 	printk(KERN_INFO LOGNAME ": Turtle Beach " LONGNAME " Linux Driver Version "
 	       VERSION ", Copyright (C) 1998 Andrew Veliath\n");
 
diff --git a/sound/oss/opl3.c b/sound/oss/opl3.c
index b6d19adf8f41..3e017dd58746 100644
--- a/sound/oss/opl3.c
+++ b/sound/oss/opl3.c
@@ -1208,6 +1208,11 @@ static int __init init_opl3 (void)
 
 	if (io != -1)	/* User loading pure OPL3 module */
 	{
+		if (kernel_is_locked_down()) {
+			pr_err("Kernel is locked down\n");
+			return -EPERM;
+		}
+
 		if (!opl3_detect(io))
 		{
 			return -ENODEV;
diff --git a/sound/oss/pas2_card.c b/sound/oss/pas2_card.c
index b07954a79536..16c1a4c731ca 100644
--- a/sound/oss/pas2_card.c
+++ b/sound/oss/pas2_card.c
@@ -401,6 +401,11 @@ MODULE_LICENSE("GPL");
 
 static int __init init_pas2(void)
 {
+	if (kernel_is_locked_down()) {
+		pr_err("Kernel is locked down\n");
+		return -EPERM;
+	}
+
 	printk(KERN_INFO "Pro Audio Spectrum driver Copyright (C) by Hannu Savolainen 1993-1996\n");
 
 	cfg.io_base = io;
diff --git a/sound/oss/pss.c b/sound/oss/pss.c
index 81314f9e2ccb..aee8bba44191 100644
--- a/sound/oss/pss.c
+++ b/sound/oss/pss.c
@@ -1177,6 +1177,10 @@ static int pssmpu = 0, pssmss = 0;
 
 static int __init init_pss(void)
 {
+	if (kernel_is_locked_down()) {
+		pr_err("Kernel is locked down\n");
+		return -EPERM;
+	}
 
 	if(pss_no_sound)		/* If configuring only nonsound components */
 	{
diff --git a/sound/oss/sb_card.c b/sound/oss/sb_card.c
index fb5d7250de38..dd65111c77f8 100644
--- a/sound/oss/sb_card.c
+++ b/sound/oss/sb_card.c
@@ -304,6 +304,13 @@ static int __init sb_init(void)
 	int lres = 0;
 	int pres = 0;
 
+	if ((mpu_io != 0 || io != -1 || irq != -1 ||
+	     dma != -1 || dma16	!= -1) &&
+	    kernel_is_locked_down()) {
+		pr_err("Kernel is locked down\n");
+		return -EPERM;
+	}
+
 	printk(KERN_INFO "sb: Init: Starting Probe...\n");
 
 	if(io != -1 && irq != -1 && dma != -1) {
diff --git a/sound/oss/trix.c b/sound/oss/trix.c
index 3c494dc93b93..32a094d501bd 100644
--- a/sound/oss/trix.c
+++ b/sound/oss/trix.c
@@ -426,6 +426,11 @@ module_param(joystick, bool, 0);
 
 static int __init init_trix(void)
 {
+	if (kernel_is_locked_down()) {
+		pr_err("Kernel is locked down\n");
+		return -EPERM;
+	}
+
 	printk(KERN_INFO "MediaTrix audio driver Copyright (C) by Hannu Savolainen 1993-1996\n");
 
 	cfg.io_base = io;
diff --git a/sound/oss/uart401.c b/sound/oss/uart401.c
index dae4d4344407..0709caa63163 100644
--- a/sound/oss/uart401.c
+++ b/sound/oss/uart401.c
@@ -441,6 +441,11 @@ static int __init init_uart401(void)
 	/* Can be loaded either for module use or to provide functions
 	   to others */
 	if (cfg_mpu.io_base != -1 && cfg_mpu.irq != -1) {
+		if (kernel_is_locked_down()) {
+			pr_err("Kernel is locked down\n");
+			return -EPERM;
+		}
+
 		printk(KERN_INFO "MPU-401 UART driver Copyright (C) Hannu Savolainen 1993-1997");
 		if (!probe_uart401(&cfg_mpu, THIS_MODULE))
 			return -ENODEV;
diff --git a/sound/oss/uart6850.c b/sound/oss/uart6850.c
index 1079133dd6ab..7e59460890c0 100644
--- a/sound/oss/uart6850.c
+++ b/sound/oss/uart6850.c
@@ -320,6 +320,11 @@ module_param(irq, int, 0);
 
 static int __init init_uart6850(void)
 {
+	if (kernel_is_locked_down()) {
+		pr_err("Kernel is locked down\n");
+		return -EPERM;
+	}
+
 	cfg_mpu.io_base = io;
 	cfg_mpu.irq = irq;
 
diff --git a/sound/oss/waveartist.c b/sound/oss/waveartist.c
index 0b8d0de87273..912ba3d3094d 100644
--- a/sound/oss/waveartist.c
+++ b/sound/oss/waveartist.c
@@ -1986,6 +1986,9 @@ static int __init init_waveartist(void)
 		irq  = 12;
 		dma  = 3;
 		dma2 = 7;
+	} else if (kernel_is_locked_down()) {
+		pr_err("Kernel is locked down\n");
+		return -EPERM;
 	}
 
 	mix = &waveartist_mixer;
diff --git a/sound/pci/als4000.c b/sound/pci/als4000.c
index edabe1371660..cca148be0c84 100644
--- a/sound/pci/als4000.c
+++ b/sound/pci/als4000.c
@@ -88,6 +88,7 @@ MODULE_SUPPORTED_DEVICE("{{Avance Logic,ALS4000}}");
 #define SUPPORT_JOYSTICK 1
 #endif
 
+static unsigned int nr_joystick_port;
 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;	/* Index 0-MAX */
 static char *id[SNDRV_CARDS] = SNDRV_DEFAULT_STR;	/* ID for this card */
 static bool enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_PNP;	/* Enable this card */
@@ -102,7 +103,7 @@ MODULE_PARM_DESC(id, "ID string for ALS4000 soundcard.");
 module_param_array(enable, bool, NULL, 0444);
 MODULE_PARM_DESC(enable, "Enable ALS4000 soundcard.");
 #ifdef SUPPORT_JOYSTICK
-module_param_array(joystick_port, int, NULL, 0444);
+module_param_array(joystick_port, int, &nr_joystick_port, 0444);
 MODULE_PARM_DESC(joystick_port, "Joystick port address for ALS4000 soundcard. (0 = disabled)");
 #endif
 
@@ -1034,4 +1035,6 @@ static struct pci_driver als4000_driver = {
 	},
 };
 
+#undef module_lockdown_check
+#define module_lockdown_check() (nr_joystick_port > 0)
 module_pci_driver(als4000_driver);
diff --git a/sound/pci/cmipci.c b/sound/pci/cmipci.c
index 73f593526b2d..2a7105abef23 100644
--- a/sound/pci/cmipci.c
+++ b/sound/pci/cmipci.c
@@ -52,6 +52,7 @@ MODULE_SUPPORTED_DEVICE("{{C-Media,CMI8738},"
 #define SUPPORT_JOYSTICK 1
 #endif
 
+static unsigned int nr_mpu_port, nr_fm_port, nr_joystick_port;
 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;	/* Index 0-MAX */
 static char *id[SNDRV_CARDS] = SNDRV_DEFAULT_STR;	/* ID for this card */
 static bool enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_PNP;	/* Enable switches */
@@ -68,9 +69,9 @@ module_param_array(id, charp, NULL, 0444);
 MODULE_PARM_DESC(id, "ID string for C-Media PCI soundcard.");
 module_param_array(enable, bool, NULL, 0444);
 MODULE_PARM_DESC(enable, "Enable C-Media PCI soundcard.");
-module_param_array(mpu_port, long, NULL, 0444);
+module_param_array(mpu_port, long, &nr_mpu_port, 0444);
 MODULE_PARM_DESC(mpu_port, "MPU-401 port.");
-module_param_array(fm_port, long, NULL, 0444);
+module_param_array(fm_port, long, &nr_fm_port, 0444);
 MODULE_PARM_DESC(fm_port, "FM port.");
 module_param_array(soft_ac3, bool, NULL, 0444);
 MODULE_PARM_DESC(soft_ac3, "Software-conversion of raw SPDIF packets (model 033 only).");
@@ -3401,4 +3402,6 @@ static struct pci_driver cmipci_driver = {
 	},
 };
 	
+#undef module_lockdown_check
+#define module_lockdown_check() (nr_mpu_port > 0 || nr_fm_port > 0 || nr_joystick_port > 0)
 module_pci_driver(cmipci_driver);
diff --git a/sound/pci/ens1370.c b/sound/pci/ens1370.c
index 7e760fed0728..72fd3f2319c0 100644
--- a/sound/pci/ens1370.c
+++ b/sound/pci/ens1370.c
@@ -83,6 +83,7 @@ MODULE_SUPPORTED_DEVICE("{{Ensoniq,AudioPCI ES1371/73},"
 #define SUPPORT_JOYSTICK
 #endif
 
+static unsigned int nr_joystick_port;
 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;	/* Index 0-MAX */
 static char *id[SNDRV_CARDS] = SNDRV_DEFAULT_STR;	/* ID for this card */
 static bool enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_PNP;	/* Enable switches */
@@ -106,7 +107,7 @@ module_param_array(enable, bool, NULL, 0444);
 MODULE_PARM_DESC(enable, "Enable Ensoniq AudioPCI soundcard.");
 #ifdef SUPPORT_JOYSTICK
 #ifdef CHIP1371
-module_param_array(joystick_port, int, NULL, 0444);
+module_param_array(joystick_port, int, &nr_joystick_port, 0444);
 MODULE_PARM_DESC(joystick_port, "Joystick port address.");
 #else
 module_param_array(joystick, bool, NULL, 0444);
@@ -2475,4 +2476,6 @@ static struct pci_driver ens137x_driver = {
 	},
 };
 	
+#undef module_lockdown_check
+#define module_lockdown_check() (nr_joystick_port > 0)
 module_pci_driver(ens137x_driver);
diff --git a/sound/pci/riptide/riptide.c b/sound/pci/riptide/riptide.c
index ada5f01d479c..4c41a6f6a9d7 100644
--- a/sound/pci/riptide/riptide.c
+++ b/sound/pci/riptide/riptide.c
@@ -124,9 +124,11 @@ static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;
 static char *id[SNDRV_CARDS] = SNDRV_DEFAULT_STR;
 static bool enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE;
 
+static unsigned int nr_joystick_port;
 #ifdef SUPPORT_JOYSTICK
 static int joystick_port[SNDRV_CARDS] = { [0 ... (SNDRV_CARDS - 1)] = 0x200 };
 #endif
+static unsigned int nr_mpu_port, nr_opl3_port;
 static int mpu_port[SNDRV_CARDS] = { [0 ... (SNDRV_CARDS - 1)] = 0x330 };
 static int opl3_port[SNDRV_CARDS] = { [0 ... (SNDRV_CARDS - 1)] = 0x388 };
 
@@ -137,12 +139,12 @@ MODULE_PARM_DESC(id, "ID string for Riptide soundcard.");
 module_param_array(enable, bool, NULL, 0444);
 MODULE_PARM_DESC(enable, "Enable Riptide soundcard.");
 #ifdef SUPPORT_JOYSTICK
-module_param_array(joystick_port, int, NULL, 0444);
+module_param_array(joystick_port, int, &nr_joystick_port, 0444);
 MODULE_PARM_DESC(joystick_port, "Joystick port # for Riptide soundcard.");
 #endif
-module_param_array(mpu_port, int, NULL, 0444);
+module_param_array(mpu_port, int, &nr_mpu_port, 0444);
 MODULE_PARM_DESC(mpu_port, "MPU401 port # for Riptide driver.");
-module_param_array(opl3_port, int, NULL, 0444);
+module_param_array(opl3_port, int, &nr_opl3_port, 0444);
 MODULE_PARM_DESC(opl3_port, "OPL3 port # for Riptide driver.");
 
 /*
@@ -2193,6 +2195,17 @@ static struct pci_driver joystick_driver = {
 static int __init alsa_card_riptide_init(void)
 {
 	int err;
+
+	if ((
+#ifdef SUPPORT_JOYSTICK
+		    nr_joystick_port > 0 ||
+#endif
+		    nr_mpu_port > 0 || nr_opl3_port > 0)) &&
+		kernel_is_locked_down()) {
+		pr_err("Kernel is locked down\n");
+		return -EPERM;
+	}
+
 	err = pci_register_driver(&driver);
 	if (err < 0)
 		return err;
diff --git a/sound/pci/sonicvibes.c b/sound/pci/sonicvibes.c
index e1a13870bb80..d7b248aab5a3 100644
--- a/sound/pci/sonicvibes.c
+++ b/sound/pci/sonicvibes.c
@@ -1539,4 +1539,6 @@ static struct pci_driver sonicvibes_driver = {
 	.remove = snd_sonic_remove,
 };
 
+#undef module_lockdown_check
+#define module_lockdown_check() (dmaio != 0x7a00)
 module_pci_driver(sonicvibes_driver);
diff --git a/sound/pci/via82xx.c b/sound/pci/via82xx.c
index 38a17b4342a6..e9dc57571155 100644
--- a/sound/pci/via82xx.c
+++ b/sound/pci/via82xx.c
@@ -2645,4 +2645,6 @@ static struct pci_driver via82xx_driver = {
 	},
 };
 
+#undef module_lockdown_check
+#define module_lockdown_check() (mpu_port)
 module_pci_driver(via82xx_driver);
diff --git a/sound/pci/ymfpci/ymfpci.c b/sound/pci/ymfpci/ymfpci.c
index 812e27a1bcbc..f3e646b1df64 100644
--- a/sound/pci/ymfpci/ymfpci.c
+++ b/sound/pci/ymfpci/ymfpci.c
@@ -39,12 +39,14 @@ MODULE_SUPPORTED_DEVICE("{{Yamaha,YMF724},"
 		"{Yamaha,YMF744},"
 		"{Yamaha,YMF754}}");
 
+static unsigned int nr_fm_port, nr_mpu_port;
 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;	/* Index 0-MAX */
 static char *id[SNDRV_CARDS] = SNDRV_DEFAULT_STR;	/* ID for this card */
 static bool enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_PNP;	/* Enable this card */
 static long fm_port[SNDRV_CARDS];
 static long mpu_port[SNDRV_CARDS];
 #ifdef SUPPORT_JOYSTICK
+static unsigned int nr_joystick_port;
 static long joystick_port[SNDRV_CARDS];
 #endif
 static bool rear_switch[SNDRV_CARDS];
@@ -55,12 +57,12 @@ module_param_array(id, charp, NULL, 0444);
 MODULE_PARM_DESC(id, "ID string for the Yamaha DS-1 PCI soundcard.");
 module_param_array(enable, bool, NULL, 0444);
 MODULE_PARM_DESC(enable, "Enable Yamaha DS-1 soundcard.");
-module_param_array(mpu_port, long, NULL, 0444);
+module_param_array(mpu_port, long, &nr_mpu_port, 0444);
 MODULE_PARM_DESC(mpu_port, "MPU-401 Port.");
-module_param_array(fm_port, long, NULL, 0444);
+module_param_array(fm_port, long, &nr_fm_port, 0444);
 MODULE_PARM_DESC(fm_port, "FM OPL-3 Port.");
 #ifdef SUPPORT_JOYSTICK
-module_param_array(joystick_port, long, NULL, 0444);
+module_param_array(joystick_port, long, &nr_joystick_port, 0444);
 MODULE_PARM_DESC(joystick_port, "Joystick port address");
 #endif
 module_param_array(rear_switch, bool, NULL, 0444);
@@ -370,4 +372,10 @@ static struct pci_driver ymfpci_driver = {
 #endif
 };
 
+#undef module_lockdown_check
+#ifdef SUPPORT_JOYSTICK
+#define module_lockdown_check() (nr_mpu_port > 0 || nr_fm_port > 0 || nr_joystick_port > 0)
+#else
+#define module_lockdown_check() (nr_mpu_port > 0 || nr_fm_port > 0)
+#endif
 module_pci_driver(ymfpci_driver);
