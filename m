From: Sai Praneeth Prakhya <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH V2] x86/efi: Add missing 1:1 mappings to support buggy firmware
Date: Tue, 14 Feb 2017 20:03:41 -0800
Message-ID: <1487131421-23703-1-git-send-email-sai.praneeth.prakhya@intel.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Sai Praneeth <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Lee, Chun-Yi" <jlee-IBi9RG/b67k@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Ricardo Neri <ricardo.neri-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Ravi Shankar <ravi.v.shankar-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Fenghua Yu <fenghua.yu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Sai Praneeth <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

There are some machines with buggy firmware that access EFI regions in
1:1 mode (or physical mode) rather than virtual mode even after kernel
being booted. On these machines, if we invoke an EFI runtime service
(that does these buggy accesses) then it causes a page fault and hence
results in kernel hang. The page fault happens because the requested
region doesn't have appropriate page attributes set or the mapping for
the region might be missing. This issue was introduced by commit
67a9108ed431 ("x86/efi: Build our own page table structures"). Before
this commit, 1:1 mappings for EFI regions were in swapper_pgd and were
not needed to be synced, but this commit introduced efi_pgd which missed
these mappings.

Below is the edited version of the page fault output that I noticed:

BUG: unable to handle kernel paging request at 0000000018847980
IP: [<fffffffef6981ec3>] 0xfffffffef6981ec3
PGD 4324d3063 PUD 4324e4063 PMD 0
Oops: 0000 [#1] SMP
Modules linked in: efi_runtime(O) chipsec(O) igb e1000e [last unloaded:
efi_runtime]
CPU: 5 PID: 2308 Comm: fwts Tainted: G   W  O    4.7.0-yocto-standard #1
Hardware name: Gigabyte Technology Co., Ltd. Z87X-UD5H/Z87X-UD5H-CF,
BIOS F9 03/18/2014
task: ffff88041974d900 ti: ffff880418844000 task.ti: ffff880418844000
RIP: 0010:[<fffffffef6981ec3>]  [<fffffffef6981ec3>] 0xfffffffef6981ec3
RSP: 0018:ffff880418847868  EFLAGS: 00010297
RAX: 00000000000000e0 RBX: 0000000000000000 RCX: ffff880418847a50
RDX: 0000000018847980 RSI: ffff880418847a10 RDI: 0000000000000020
RBP: 0000000000000001 R08: ffff880418847a68 R09: 0000000000000000
R10: ffff880418847a70 R11: 0000000000000008 R12: ffff88042005c130
R13: 0000000000000010 R14: ffff880418847e30 R15: 0000000000000000
FS:  00007fb94251e700(0000) GS:ffff880432b40000(0000)
knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000018847980 CR3: 00000004324d1000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
[<ffffffff810abf01>] ? __lock_acquire+0x121/0x1480
[<ffffffff810ac57f>] ? __lock_acquire+0x79f/0x1480
[<ffffffff810599a8>] ? efi_call+0x58/0x90
[<ffffffff81748e4b>] ? virt_efi_set_variable+0x7b/0x190
[<ffffffffa0065e63>] ? efi_runtime_ioctl+0xe43/0x108c [efi_runtime]
[<ffffffff810893b4>] ? __might_sleep+0x44/0x80
[<ffffffff811e07de>] ? do_vfs_ioctl+0x8e/0x660
[<ffffffff8133dd4e>] ? security_file_ioctl+0x3e/0x60
[<ffffffff811e0e24>] ? SyS_ioctl+0x74/0x80
[<ffffffff81a20de5>] ? entry_SYSCALL_64_fastpath+0x18/0xa8

I have looked at EFI Memory map for the faulted address and found that
it belongs to memory region of type "Conventional Memory". So, this
firmware bug is not same as accessing EFI_BOOT_SERVICES_* regions after
boot, but firmware accessing *illegal regions* in *1:1 mode*.

Below shown are the efi_pgd dumps before and after the bad commit.
efi_dump_pagetable() is called before calling efi_merge_regions() in
__efi_enter_virtual_mode() and this kernel is booted on qemu to obtain
page table dumps.

EFI_PGT_DUMP before commit:
---------------------------
[0.007041] ---[ User Space ]---
[0.007427] 0x0000000000000000-0x0000000000200000 2M    RW     GLB NX pte
[0.008609] 0x0000000000200000-0x0000000000800000 6M    RW PSE GLB NX pmd
[0.010069] 0x0000000000800000-0x0000000000808000 32K                 pte
[0.011068] 0x0000000000808000-0x0000000000810000 32K   RW     GLB NX pte
[0.012325] 0x0000000000810000-0x0000000000900000 960K                pte
[0.013071] 0x0000000000900000-0x0000000000a00000 1M    RW     GLB NX pte
[0.014579] 0x0000000000a00000-0x000000007e800000 2014M RW PSE GLB NX pmd
[0.015593] 0x000000007e800000-0x000000007e9b6000 1752K RW     GLB NX pte
[0.016600] 0x000000007e9b6000-0x000000007e9fe000 288K                pte
[0.018003] 0x000000007e9fe000-0x000000007ea00000 8K    RW     GLB NX pte
[0.019165] 0x000000007ea00000-0x000000007ec00000 2M    RW PSE GLB NX pmd
[0.020331] 0x000000007ec00000-0x000000007eda9000 1700K RW     GLB NX pte
[0.021483] 0x000000007eda9000-0x000000007ee14000 428K                pte
[0.022500] 0x000000007ee14000-0x000000007f000000 1968K RW     GLB NX pte
[0.023596] 0x000000007f000000-0x000000007fe00000 14M   RW PSE GLB NX pmd
[0.025004] 0x000000007fe00000-0x000000007fe94000 592K  RW     GLB NX pte
[0.026220] 0x000000007fe94000-0x000000007fef8000 400K                pte
[0.027069] 0x000000007fef8000-0x000000007ffd0000 864K  RW     GLB NX pte
[0.028420] 0x000000007ffd0000-0x000000007fff0000 128K                pte
[0.029551] 0x000000007fff0000-0x0000000080000000 64K   RW     GLB NX pte
[0.030601] 0x0000000080000000-0x0000008000000000 510G                pud
[0.031499] 0x0000008000000000-0xffff800000000000 17179737600G        pgd
[0.032152] ---[ Kernel Space ]---

EFI_PGT_DUMP after commit:
--------------------------
[0.005620] ---[ User Space ]---
[0.005838] 0x0000000000000000-0xffff800000000000 16777088T           pgd
[0.005873] ---[ Kernel Space ]---

While not having these mappings isn't a bug but we need these mappings
to support machines with buggy firmware.

Signed-off-by: Sai Praneeth Prakhya <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Lee, Chun-Yi <jlee-IBi9RG/b67k@public.gmane.org>
Cc: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: Ricardo Neri <ricardo.neri-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Ravi Shankar <ravi.v.shankar-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Fenghua Yu <fenghua.yu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 arch/x86/platform/efi/efi_64.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
index de9652bd19d4..8d2fd6568b91 100644
--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -139,6 +139,7 @@ int __init efi_alloc_page_tables(void)
 	pgd_t *pgd;
 	pud_t *pud;
 	gfp_t gfp_mask;
+	unsigned num_pgds;
 
 	if (efi_enabled(EFI_OLD_MEMMAP))
 		return 0;
@@ -158,6 +159,13 @@ int __init efi_alloc_page_tables(void)
 
 	pgd_populate(NULL, pgd, pud);
 
+	/*
+	 * Sync 1:1 mappings to support buggy firmware which haven't updated
+	 * their addresses even after kernel has booted.
+	 */
+	num_pgds = pgd_index(VMALLOC_START) - pgd_index(PAGE_OFFSET);
+	memcpy(efi_pgd, pgd_offset_k(PAGE_OFFSET), sizeof(pgd_t) * num_pgds);
+
 	return 0;
 }
 
-- 
2.1.4
