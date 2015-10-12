From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH v2] x86/mm: warn on W+x mappings
Date: Mon, 12 Oct 2015 13:41:13 +0100
Message-ID: <20151012124113.GD2579@codeblueprint.co.uk>
References: <1443814185-21552-1-git-send-email-sds@tycho.nsa.gov>
 <20151003112701.GA4531@gmail.com>
 <5612CBE8.2010504@tycho.nsa.gov>
 <20151006073205.GA11115@gmail.com>
 <5613EAD5.2070405@tycho.nsa.gov>
 <20151012113605.GB7384@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151012113605.GB7384-fF5Pk5pvG8Y@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: Stephen Smalley <sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Denys Vlasenko <dvlasenk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Brian Gerst <brgerst-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, 12 Oct, at 01:36:05PM, Borislav Petkov wrote:
> On Tue, Oct 06, 2015 at 11:37:57AM -0400, Stephen Smalley wrote:
> > > What does this range correspond to on your kernel?
> 
> Got a W+X splat here too, on the UEFI box with rc5+tip/master:
> 
> [    6.792949] rtc_cmos 00:02: setting system clock to 2015-10-12 11:17:03 UTC (1444648623)
> [    6.807863] Freeing unused kernel memory: 1312K (ffffffff81f5f000 - ffffffff820a7000)
> [    6.815831] usb 3-1: new high-speed USB device number 2 using ehci-pci
> [    6.823261] Write protecting the kernel read-only data: 14336k
> [    6.832196] Freeing unused kernel memory: 1796K (ffff88000383f000 - ffff880003a00000)
> [    6.842210] Freeing unused kernel memory: 284K (ffff880003db9000 - ffff880003e00000)
> [    6.850524] ------------[ cut here ]------------
> [    6.855682] WARNING: CPU: 5 PID: 1 at arch/x86/mm/dump_pagetables.c:225 note_page+0x61e/0x7e0()
> [    6.864944] x86/mm: Found insecure W+X mapping at address ffff88000005e000/0xffff88000005e000
> [    6.874022] Modules linked in:
> [    6.877643] CPU: 5 PID: 1 Comm: swapper/0 Not tainted 4.3.0-rc5+ #1
> [    6.884462] Hardware name: Dell Inc. Precision T3600/0PTTT9, BIOS A13 05/11/2014
> [    6.892416]  ffffffff81caf1f7 ffff88043bdffd60 ffffffff813aab2c ffff88043bdffda8
> [    6.900460]  ffff88043bdffd98 ffffffff81066776 ffff880004e55308 0000000000000004
> [    6.907816] usb 4-1: new high-speed USB device number 2 using ehci-pci
> [    6.915499]  8000000000000163 ffff88043bdffe98 0000000000000000 ffff88043bdffdf8
> [    6.923520] Call Trace:
> [    6.926512]  [<ffffffff813aab2c>] dump_stack+0x4e/0x82
> [    6.931551] usb 3-1: New USB device found, idVendor=8087, idProduct=0024
> [    6.931552] usb 3-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
> [    6.933120] hub 3-1:1.0: USB hub found
> [    6.933369] hub 3-1:1.0: 6 ports detected
> [    6.955784]  [<ffffffff81066776>] warn_slowpath_common+0x86/0xc0
> [    6.962341]  [<ffffffff810667fc>] warn_slowpath_fmt+0x4c/0x50
> [    6.968631]  [<ffffffff8105bb7e>] note_page+0x61e/0x7e0
> [    6.974404]  [<ffffffff8105c09f>] ptdump_walk_pgd_level_core+0x35f/0x3f0
> [    6.981651]  [<ffffffff8105c1d7>] ptdump_walk_pgd_level_checkwx+0x17/0x20
> [    6.988996]  [<ffffffff81051b0e>] mark_rodata_ro+0xee/0x100
> [    6.995124]  [<ffffffff81828610>] ? rest_init+0x140/0x140
> [    7.001064]  [<ffffffff8182862d>] kernel_init+0x1d/0xe0
> [    7.006841]  [<ffffffff81836f6f>] ret_from_fork+0x3f/0x70
> [    7.012774]  [<ffffffff81828610>] ? rest_init+0x140/0x140
> [    7.018706] ---[ end trace 920055014e07ef1e ]---
> [    7.024302] x86/mm: Checked W+X mappings: FAILED, 69568 W+X pages found.
> 
> And yes, there are a bunch of those mappings here too:
> 
> $ grep -c 'RW.*x' /sys/kernel/debug/kernel_page_tables
> 75
> 
> Some of them are the UEFI runtime regions. I guess we can try to map
> them as RO maybe, they need to be X. Matt, any reasons against that?

I'm glad you asked (but you won't be)!

Basically, it's guaranteed that there exist some machines that contain
data in EfiRuntimeCode regions (and so require write permission) and
code in EfiRuntimeData regions (and therefore require eXecute),
because the whole point of the new EFI_PROPERTIES_TABLE feature in
UEFI v2.5 was to make it explicit when the firmware does not include
such regions.

I do have patches sitting in a git branch that begin to implement
support for mapping EFI runtime data regions as NX, and code regions
as RO when EFI_PROPERTIES_TABLE is enabled,

  https://git.kernel.org/cgit/linux/kernel/git/mfleming/efi.git/log/?h=memmap

Things got stalled when we realised that Linux didn't even boot with
the feature enabled, see commit a5caa209ba9c ("x86/efi: Fix boot crash
by mapping EFI memmap entries bottom-up at runtime, instead of
top-down").

For more information on what the current limitations are for mapping
EFI regions, check out this whitepaper,

  https://firmware.intel.com/sites/default/files/resources/A_Tour_Beyond_BIOS_Memory_Practices_with_UEFI.pdf

-- 
Matt Fleming, Intel Open Source Technology Center
