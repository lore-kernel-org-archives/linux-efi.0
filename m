From: Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 09/10] arm64/efi: ignore unusable regions instead of
 reserving them
Date: Tue, 11 Nov 2014 12:12:09 -0500
Message-ID: <1415725929.32311.130.camel@deneb.redhat.com>
References: <1415283206-14713-1-git-send-email-ard.biesheuvel@linaro.org>
	 <1415283206-14713-10-git-send-email-ard.biesheuvel@linaro.org>
	 <1415592695.32311.91.camel@deneb.redhat.com>
	 <CAKv+Gu8ZpDpfJSvDksUfW0L4k9uU0-j9mConGwcdcsmh1XM_2w@mail.gmail.com>
	 <1415720536.32311.113.camel@deneb.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1415720536.32311.113.camel-PDpCo7skNiwAicBL8TP8PQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Grant Likely <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, 2014-11-11 at 10:42 -0500, Mark Salter wrote:
> On Mon, 2014-11-10 at 08:31 +0100, Ard Biesheuvel wrote:
> > On 10 November 2014 05:11, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> > > On Thu, 2014-11-06 at 15:13 +0100, Ard Biesheuvel wrote:
> > >> This changes the way memblocks are installed based on the contents
> > of
> > >> the UEFI memory map. Formerly, all regions would be
> > memblock_add()'ed,
> > >> after which unusable regions would be memblock_reserve()'d as well.
> > >> To simplify things, but also to allow access to the unusable
> > regions
> > >> through mmap(/dev/mem), even with CONFIG_STRICT_DEVMEM set, change
> > >> this so that only usable regions are memblock_add()'ed in the first
> > >> place.
> > >
> > > This patch is crashing 64K pagesize kernels during boot. I'm not
> > exactly
> > > sure why, though. Here is what I get on an APM Mustang box:
> > >
> > 
> > Ah, yes, I meant to mention this patch
> > 
> > https://git.kernel.org/cgit/linux/kernel/git/glikely/linux.git/commit/?id=8cccffc52694938fc88f3d90bc7fed8460e27191
> > 
> > in the cover letter, which addresses this issue at least for the DT
> > case.
> > 
> 
> That isn't the problem. In general, with 64K kernel pages, you can't be
> sure if you leave something you need out of the kernel linear mapping.
> If you have Loader Code/Data regions begin and/or end at something other
> than a 64K boundary and that region is adjacent to a region not being
> added, then you end up leaving out the unaligned bits from the linear
> mapping. This could be bits of the initramfs or devicetree.
> 
> What I don't get with this failure is that it is an alignment fault
> which should be masked at EL1 for the kernel. The same unaligned
> access happens without this patch and it doesn't generate a fault.
> 

Ah, but unaligned accesses are not ignored for device memory.
I have this in include/acpi/acpi_io.h:

static inline void __iomem *acpi_os_ioremap(acpi_physical_address phys,
					    acpi_size size)
{
#ifdef CONFIG_ARM64
	if (!page_is_ram(phys >> PAGE_SHIFT))
		return ioremap(phys, size);
#endif

       return ioremap_cache(phys, size);
}

Because the table isn't in the linear mapping, it fails the
page_is_ram() test and it gits mapped with ioremap() leading to
the alignment fault.

If I take out the code inside the #ifdef, I get a different
fault:

[    0.350057] Unhandled fault: synchronous external abort (0x96000010) at 0xfffffe0000fae6f4
[    0.358704] pgd = fffffe0001160000
[    0.362276] [fffffe0000fae6f4] *pgd=0000004001370003, *pud=0000004001370003, *pmd=0000004001370003, *pte=02c00040011a0713
[    0.373746] Internal error: : 96000010 [#1] SMP
[    0.378484] Modules linked in:
[    0.381601] CPU: 1 PID: 1 Comm: swapper/0 Not tainted 3.18.0-rc4+ #15
[    0.388248] Hardware name: APM X-Gene Mustang board (DT)
[    0.393738] task: fffffe03dbe10000 ti: fffffe03dbf00000 task.ti: fffffe03dbf00000
[    0.401503] PC is at acpi_ex_system_memory_space_handler+0x238/0x2e0
[    0.408160] LR is at acpi_ex_system_memory_space_handler+0x130/0x2e0

That happens because AML is trying to access a hardware register
which has been mapped as normal memory.

So, we need a way to tell a table in ram from an io address in AML.
And page_is_ram() no longer cuts it if the tables are not in the
linear mapping.
