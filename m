From: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v4 6/8] arm64/efi: move SetVirtualAddressMap() to UEFI
 stub
Date: Tue, 6 Jan 2015 17:13:59 +0000
Message-ID: <20150106171359.GE3827@bivouac.eciton.net>
References: <1419245944-2424-1-git-send-email-ard.biesheuvel@linaro.org>
 <1419245944-2424-7-git-send-email-ard.biesheuvel@linaro.org>
 <20150105162016.GD26699@leverpostej>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150105162016.GD26699@leverpostej>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Catalin Marinas <Catalin.Marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <Will.Deacon-5wv7dgnIgG8@public.gmane.org>, "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org" <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, "dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "geoff.levand-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <geoff.levand-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, Jan 05, 2015 at 04:20:16PM +0000, Mark Rutland wrote:
> Hi Ard,
> 
> I have a few (minor) comments below.
> 
> On Mon, Dec 22, 2014 at 10:59:02AM +0000, Ard Biesheuvel wrote:
> > In order to support kexec, the kernel needs to be able to deal with the
> > state of the UEFI firmware after SetVirtualAddressMap() has been called.
> > To avoid having separate code paths for non-kexec and kexec, let's move
> > the call to SetVirtualAddressMap() to the stub: this will guarantee us
> > that it will only be called once (since the stub is not executed during
> > kexec), and ensures that the UEFI state is identical between kexec and
> > normal boot.
> > 
> > This implies that the layout of the virtual mapping needs to be created
> > by the stub as well. All regions are rounded up to a naturally aligned
> > multiple of 64 KB (for compatibility with 64k pages kernels) and recorded
> > in the UEFI memory map. The kernel proper reads those values and installs
> > the mappings in a dedicated set of page tables that are swapped in during
> > UEFI Runtime Services calls.
> > 
> > Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> > ---
> >  arch/arm64/include/asm/efi.h       |  20 +++-
> >  arch/arm64/kernel/efi.c            | 223 ++++++++++++++++++++-----------------
> >  arch/arm64/kernel/setup.c          |   1 +
> >  drivers/firmware/efi/libstub/fdt.c | 137 ++++++++++++++++++++++-
> >  4 files changed, 270 insertions(+), 111 deletions(-)
> 
> [...]
> 
> > +static void efi_set_pgd(struct mm_struct *mm)
> > +{
> > +       cpu_switch_mm(mm->pgd, mm);
> > +       flush_tlb_all();
> > +       if (icache_is_aivivt())
> > +               __flush_icache_all();
> > +}
> 
> Do we have any idea how often we call runtime services?

Very rarely.
 
> I assume not all that often (read the RTC at boot, set/get variables).

And in future possibly:
- adding capsules
- getwakeuptime/setwakeuptime
- saving time to RTC on shutdown
- reboot

All of which are uid0-invoked manual operations.

The only exception I can think of is if we're using the efivarfs
backend for pstore.

> If we're nuking the TLBs and I-cache a lot we'll probably need to
> reserve an asid for the EFI virtmap.

> > @@ -248,12 +337,52 @@ efi_status_t allocate_new_fdt_and_exit_boot(efi_system_table_t *sys_table,
> >                 }
> >         }
> > 
> > +       /*
> > +        * Update the memory map with virtual addresses. The function will also
> > +        * populate the spare second half of the memory_map allocation with
> > +        * copies of just the EFI_MEMORY_RUNTIME entries so that we can pass it
> > +        * straight into SetVirtualAddressMap()
> > +        */
> > +       update_memory_map(memory_map, map_size, desc_size,
> > +                         &runtime_entry_count);
> > +
> > +       pr_efi(sys_table,
> > +              "Exiting boot services and installing virtual address map...\n");
> 
> I believe that the memory map is allowed to change as a result of this
> call, so I think this needs to be moved before update_memory_map.

You are absolutely correct - but update_memory_map() only modifies the
copy of the memory map. The message needs to move all the way to
before the calll to get_memory_map(), and for practical reasons
perhaps before the while(1) loop.

/
    Leif
