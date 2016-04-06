From: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
Subject: Re: [PATCH] PCI: Add Broadcom 4331 reset quirk to prevent IRQ storm
Date: Wed, 6 Apr 2016 23:30:29 +0200
Message-ID: <20160406213029.GA12421@wunner.de>
References: <811539524df8b5ed7e2817c1c3e3e08560c97964.1459275517.git.lukas@wunner.de>
 <20160405194015.GC15353@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-wireless-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160405194015.GC15353@localhost>
Sender: linux-wireless-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bjorn Helgaas <helgaas-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-wireless-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, zajec5-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, b43-dev-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

[+cc Matt Fleming, linux-efi]

Hi Bjorn,

On Tue, Apr 05, 2016 at 02:40:15PM -0500, Bjorn Helgaas wrote:
> On Tue, Mar 29, 2016 at 08:20:30PM +0200, Lukas Wunner wrote:
> > Broadcom 4331 wireless cards built into Apple Macs unleash an IRQ storm
> > on boot until they are reset, causing spurious interrupts if the IRQ is
> > shared. Apparently the EFI bootloader enables the device and does not
> > disable it before passing control to the OS. The bootloader contains a
> > driver for the wireless card which allows it to phone home to Cupertino.
> > This is used for Internet Recovery (download and install OS X images)
> > and probably also for Back to My Mac (remote access, RFC 6281) and to
> > discover stolen hardware.
> > 
> > The issue is most pronounced on 2011 and 2012 MacBook Pros where the IRQ
> > is shared with 3 other devices (Light Ridge Thunderbolt controller, SDXC
> > reader, HDA card on discrete GPU). As soon as an interrupt handler is
> > installed for one of these devices, the ensuing storm of spurious IRQs
> > causes the kernel to disable the IRQ and switch to polling. This lasts
> > until the b43 driver loads and resets the device.
> > 
> > Loading the b43 driver first is not always an option, in particular with
> > the Light Ridge Thunderbolt controller: The PCI hotplug IRQ handler gets
> > installed early on because it is built in, unlike b43 which is usually
> > a module.
> > 
> > Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=79301
> > Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=895951
> > Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=1009819
> > Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=1149632
> > Tested-by: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org> [MacBookPro9,1]
> > Signed-off-by: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
> > ---
> >  drivers/bcma/bcma_private.h |  2 --
> >  drivers/pci/quirks.c        | 27 +++++++++++++++++++++++++++
> >  include/linux/bcma/bcma.h   |  1 +
> >  3 files changed, 28 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/bcma/bcma_private.h b/drivers/bcma/bcma_private.h
> > index eda0909..f642c42 100644
> > --- a/drivers/bcma/bcma_private.h
> > +++ b/drivers/bcma/bcma_private.h
> > @@ -8,8 +8,6 @@
> >  #include <linux/bcma/bcma.h>
> >  #include <linux/delay.h>
> >  
> > -#define BCMA_CORE_SIZE		0x1000
> > -
> >  #define bcma_err(bus, fmt, ...) \
> >  	pr_err("bus%d: " fmt, (bus)->num, ##__VA_ARGS__)
> >  #define bcma_warn(bus, fmt, ...) \
> > diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
> > index 8e67802..d4fb5ee 100644
> > --- a/drivers/pci/quirks.c
> > +++ b/drivers/pci/quirks.c
> > @@ -25,6 +25,8 @@
> >  #include <linux/sched.h>
> >  #include <linux/ktime.h>
> >  #include <linux/mm.h>
> > +#include <linux/bcma/bcma.h>
> > +#include <linux/bcma/bcma_regs.h>
> >  #include <asm/dma.h>	/* isa_dma_bridge_buggy */
> >  #include "pci.h"
> >  
> > @@ -3282,6 +3284,31 @@ DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_INTEL, 0x156d,
> >  			       quirk_apple_wait_for_thunderbolt);
> >  #endif
> >  
> > +/*
> > + * Broadcom 4331 wireless cards built into Apple Macs unleash an IRQ storm
> > + * on boot until they are reset, causing spurious interrupts if the IRQ is
> > + * shared. Apparently the EFI bootloader enables the device to phone home
> > + * to Cupertino and does not disable it before passing control to the OS.
> > + */
> > +static void quirk_apple_b43_reset(struct pci_dev *dev)
> > +{
> > +	void __iomem *mmio;
> > +
> > +	if (!dmi_match(DMI_BOARD_VENDOR, "Apple Inc.") || !dev->bus->self ||
> > +	    pci_pcie_type(dev->bus->self) != PCI_EXP_TYPE_ROOT_PORT)
> > +		return;
> > +
> > +	mmio = pci_iomap(dev, 0, 0);
> > +	if (!mmio) {
> > +		pr_err("b43 quirk: Cannot iomap device, IRQ storm ahead\n");
> > +		return;
> > +	}
> > +	iowrite32(BCMA_RESET_CTL_RESET,
> > +		  mmio + (1 * BCMA_CORE_SIZE) + BCMA_RESET_CTL);
> > +	pci_iounmap(dev, mmio);
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=111781 and
> https://mjg59.dreamwidth.org/11235.html describe a sort of similar
> issue, but with DMA.  An interrupt from the device is probably to
> signal a DMA completion, but these problem reports only mention the
> "IRQ nobody cared" issue; I don't see anything about memory
> corruption.
> 
> If this resets the device, I guess that should prevent future DMA as
> well as future interrupts.  Would pci_reset_function() do the same
> thing in a more generic way?

Matthew's grub patch puts the wireless card into D3hot, which does not
stop the interrupts. I have tested this. (It may stop the DMA, I cannot
verify that as it doesn't occur on my machine for lack of an access point.)

Calling pci_reset_function() does stop the interrupts. More specifically,
clearing the command register in pci_dev_save_and_disable() does. However
the b43/bcma driver subsequently locks up the machine on module load.
The closed source broadcom-sta driver loads fine. (I'm not even sure it's
worth fixing this anomalous use case in b43/bcma.)

It should be noted that clearing the command register merely cures the
symptom, but not the cause. The wireless core keeps generating interrupts
but they're not coming through because DisINTx is set. I think resetting
the wireless core, as I've done in the patch above, is preferable. Putting
on my tinfoil hat for a moment, this feels like EFI phoning home to Apple
and passing control to the OS with Cupertino still on the line. Seems like
a good idea to hang up that call firmly on boot.


> I'm a little bit hesitant to put a quirk like this in Linux because
> it's only a 90% solution.  If the only problem is the interrupts, it's
> probably OK since a few extra interrupts doesn't hurt anything.  But
> if there is also DMA that might corrupt something, a 90% solution just
> makes it harder to debug for the remaining 10%.

Matthew mentions in his blog post that the DMA occurs in an EFI boot
services data area. According to the spec the OS is free to use that
memory after ExitBootServices(), but a lot of EFI implementations do
not adhere to that rule. Apple is not alone there. That's why the kernel
delays making that memory available to the page allocator, but it doesn't
delay it long enough, i.e. not until PCI header fixups are run, which is
the earliest point where we could reset the wireless core from the PCI
subsystem. (I.e, immediately after BAR scanning.)

More specifically, arch/x86/platform/efi/quirks.c:efi_free_boot_services()
makes EFI boot services memory available to the page allocator and this
is called near the end of init/main.c:start_kernel(). *Afterwards*, the
initcalls are executed via rest_init() -> kernel_init() ->
kernel_init_freeable() -> do_basic_setup() -> do_initcalls(). In particular,
PCI header fixups are executed in the subsys_initcall acpi_init().

Some of the possible solutions are:

(1) Delay efi_free_boot_services() further, e.g. until late_initcall.

(2) Find out exactly which EFI boot services area is used for DMA and
    amend arch/x86/platform/efi/quirks.c:efi_apply_memmap_quirks() to
    assign that area a different type if dmi_match(DMI_SYS_VENDOR,
    "Apple Inc."). That way it's not freed by efi_free_boot_services().
    Add a late_initcall which calls free_bootmem() for that area.

(3) In lieu of a PCI quirk, add an EFI quirk which resets the wireless
    core using efi_pci_io_protocol.mem.write().

(4) It's conceivable that Apple has provided an EFI protocol for the
    wireless card. If it exists, it might allow us to reset it or
    disassociate from the access point, which should stop the DMA.

@Matt Fleming: Do you have a preference or recommendation for either of
these options?

I'm not sure how quickly I can come up with a patch for (3) or how long
it would take to reverse-engineer (4).

Thanks,

Lukas

> 
> > +}
> > +DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_BROADCOM, 0x4331, quirk_apple_b43_reset);
> > +
> >  static void pci_do_fixups(struct pci_dev *dev, struct pci_fixup *f,
> >  			  struct pci_fixup *end)
> >  {
> > diff --git a/include/linux/bcma/bcma.h b/include/linux/bcma/bcma.h
> > index 0367c63..5c37b58 100644
> > --- a/include/linux/bcma/bcma.h
> > +++ b/include/linux/bcma/bcma.h
> > @@ -158,6 +158,7 @@ struct bcma_host_ops {
> >  #define BCMA_CORE_DEFAULT		0xFFF
> >  
> >  #define BCMA_MAX_NR_CORES		16
> > +#define BCMA_CORE_SIZE			0x1000
> >  
> >  /* Chip IDs of PCIe devices */
> >  #define BCMA_CHIP_ID_BCM4313	0x4313
> > -- 
> > 2.8.0.rc3
--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
