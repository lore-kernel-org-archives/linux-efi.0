From: Alex Thorlton <athorlton-sJ/iWh9BUns@public.gmane.org>
Subject: [BUG] x86/efi: MMRs no longer properly mapped after switch to
 isolated page table
Date: Wed, 27 Apr 2016 10:41:32 -0500
Message-ID: <20160427154132.GB113599@stormcage.americas.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Russ Anderson <rja-sJ/iWh9BUns@public.gmane.org>, Dimitri Sivanich <sivanich-sJ/iWh9BUns@public.gmane.org>, mike travis <travis-sJ/iWh9BUns@public.gmane.org>, Alex Thorlton <athorlton-sJ/iWh9BUns@public.gmane.org>, Nathan Zimmer <nzimmer-sJ/iWh9BUns@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Hey guys,

We've hit an issue that we haven't seen before on recent community
kernels.  Hoping that you can provide some insight.

Late last week I hit this bad paging request in uv_system_init on one of
our small UV systems:

8<---
[    0.355998] UV: Found UV2000/3000 hub
[    0.360088] BUG: unable to handle kernel paging request at ffff8800fb600000
[    0.367882] IP: [<ffffffff81b6e906>] uv_system_init+0x1f8/0x1051
[    0.374604] PGD 1f83067 PUD 0 
[    0.378030] Oops: 0000 [#1] SMP 
[    0.381652] Modules linked in:
[    0.385069] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 4.6.0-rc3-community-4.6-rc2+ #454
[    0.394003] Hardware name: SGI UV3000/UV3000, BIOS SGI UV 3000 series BIOS 01/15/2015
[    0.402743] task: ffff88086ee18000 ti: ffff88086ee1c000 task.ti: ffff88086ee1c000
[    0.411097] RIP: 0010:[<ffffffff81b6e906>]  [<ffffffff81b6e906>] uv_system_init+0x1f8/0x1051
[    0.420530] RSP: 0000:ffff88086ee1fdb0  EFLAGS: 00010286
[    0.426458] RAX: ffff8800fb600000 RBX: 0000000000000000 RCX: 000000000000c780
[    0.434421] RDX: 00000000fa000000 RSI: 0000000000000246 RDI: 0000000000000246
[    0.442385] RBP: ffff88086ee1fe48 R08: 00000000fffffffe R09: 0000000000000000
[    0.450348] R10: 0000000000000005 R11: 0000000000000146 R12: 000000000000c780
[    0.458312] R13: 000000000000a0f0 R14: 0000000000000037 R15: 0000000000000038
[    0.466277] FS:  0000000000000000(0000) GS:ffff880870c00000(0000) knlGS:0000000000000000
[    0.475307] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    0.481718] CR2: ffff8800fb600000 CR3: 0000000001a06000 CR4: 00000000001406f0
[    0.489682] Stack:
[    0.491924]  0000000000000037 0000000000000038 ffff88086ee1fdd0 ffffffff810bef29
[    0.500219]  ffff88086ee1fe28 ffffffff8116426d ffff880800000010 ffff88086ee1fe38
[    0.508517]  ffff88086ee1fdf8 ffffffff8116426d 0000000000000002 0000000000000001
[    0.516810] Call Trace:
[    0.519542]  [<ffffffff810bef29>] ? vprintk_default+0x29/0x40
[    0.525957]  [<ffffffff8116426d>] ? printk+0x4d/0x4f
[    0.531497]  [<ffffffff8116426d>] ? printk+0x4d/0x4f
[    0.537041]  [<ffffffff81b6a2d2>] native_smp_prepare_cpus+0x299/0x2e4
[    0.544232]  [<ffffffff81b5b19b>] kernel_init_freeable+0xc3/0x220
[    0.551035]  [<ffffffff815b236e>] kernel_init+0xe/0x110
[    0.556869]  [<ffffffff815be102>] ret_from_fork+0x22/0x40
[    0.562893]  [<ffffffff815b2360>] ? rest_init+0x80/0x80
[    0.568723] Code: 65 48 03 05 1d b8 49 7e 80 78 14 02 ba 00 00 00 fa 76 0b 48 89 c8 65 48 03 05 07 b8 49 7e 48 b8 00 00 60 01 00 88 ff ff 48 09 d0 <48> 8b 00 88 c3 48 c1 e8 06 41 bd 01 00 00 00 88 c1 83 e3 3f 4c 
[    0.590530] RIP  [<ffffffff81b6e906>] uv_system_init+0x1f8/0x1051
[    0.597341]  RSP <ffff88086ee1fdb0>
[    0.601230] CR2: ffff8800fb600000
[    0.604933] ---[ end trace 06918ff61c5d4cab ]---
[    0.610091] Kernel panic - not syncing: Attempted to kill init! exitcode=0x00000009
--->8

A bit of digging will tell us that this is the failing line:

m_n_config.v = uv_read_local_mmr(UVH_RH_GAM_CONFIG_MMR );

A bisect (with a bit of extra digging into a merge commit) led me to
commit 67a9108ed4313 ("x86/efi: Build our own page table structures") as
being the first bad commit.

After a bit of poking around, I found that the part of this change that
is actually breaking things for us is the fact that the EFI memory
regions are no longer being mapped into the trampoline_pgd in
__map_region.

Just as a quick test, I made this small change and it got my UV to boot:

8<---
diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
index 49e4dd4..15bf5df 100644
--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -296,6 +296,7 @@ static void __init __map_region(efi_memory_desc_t *md, u64 va)
 {
        unsigned long flags = _PAGE_RW;
        unsigned long pfn;
+       pgd_t *tramp_pgd = (pgd_t *)__va(real_mode_header->trampoline_pgd);
        pgd_t *pgd = efi_pgd;

        if (!(md->attribute & EFI_MEMORY_WB))
@@ -305,6 +306,10 @@ static void __init __map_region(efi_memory_desc_t *md, u64 va)
        if (kernel_map_pages_in_pgd(pgd, pfn, va, md->num_pages, flags))
                pr_warn("Error mapping PA 0x%llx -> VA 0x%llx!\n",
                           md->phys_addr, va);
+
+       if (kernel_map_pages_in_pgd(tramp_pgd, pfn, va, md->num_pages, flags))
+               pr_warn("Error mapping in trampoline_pgd PA 0x%llx -> VA 0x%llx!\n",
+                          md->phys_addr, va);
 }

 void __init efi_map_region(efi_memory_desc_t *md)
--->8

>From what I know, this works because the first PGD entry (the one
containing the identity mappings) of the trampoline_pgd is shared with
the main kernel PGD (init_level4_pgt), so when __map_region maps this
stuff into the trampoline_pgd, we get it in the kernel PGD as well.

The way I understand it, the motivation behind this change is to isolate
the EFI runtime services code/data from the regular kernel page tables,
but it appears that we've isolated a bit more than that.  I do
understand that if we were doing an actual EFI callback, we'd switch
over to the efi_pgd, where we'd have this stuff mapped in, but, until
now, we've been able to read these MMRs using the regular kernel page
table without issues.

Please let me know what you guys think about this issue, and if you have
any suggestions for possible solutions.  Any input is greatly
appreciated!

- Alex
