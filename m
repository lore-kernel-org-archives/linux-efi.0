From: Dennis Chen <dennis.chen-5wv7dgnIgG8@public.gmane.org>
Subject: [PATCH v5 3/3] arm64:acpi Fix the acpi alignment exeception when 'mem=' specified
Date: Wed, 29 Jun 2016 08:57:35 +0800
Message-ID: <1467161855-10010-3-git-send-email-dennis.chen@arm.com>
References: <1467161855-10010-1-git-send-email-dennis.chen@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1467161855-10010-1-git-send-email-dennis.chen-5wv7dgnIgG8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
Cc: nd-5wv7dgnIgG8@public.gmane.org, Dennis Chen <dennis.chen-5wv7dgnIgG8@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Steve Capper <steve.capper-5wv7dgnIgG8@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, "Rafael J . Wysocki" <rafael.j.wysocki-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

When booting an ACPI enabled kernel with 'mem=x', probably the ACPI data
regions loaded by firmware will beyond the limit of the memory, in this
case we need to keep those NOMAP regions above the limit while not removing
them from memblock, because once a region removed from memblock, the ACPI
will think that region is not normal memory and map it as device type
memory accordingly. Since the ACPI core will produce non-alignment access
when paring AML data stream, hence result in alignment fault upon the IO
mapped memory space.

For example, below is an alignment exception observed on ARM platform when
booting the kernel with 'acpi=on mem=8G':

...
[    0.542475] Unable to handle kernel paging request at virtual address ffff0000080521e7
[    0.550457] pgd = ffff000008aa0000
[    0.553880] [ffff0000080521e7] *pgd=000000801fffe003, *pud=000000801fffd003, *pmd=000000801fffc003, *pte=00e80083ff1c1707
[    0.564939] Internal error: Oops: 96000021 [#1] PREEMPT SMP
[    0.570553] Modules linked in:
[    0.573626] CPU: 1 PID: 1 Comm: swapper/0 Not tainted 4.7.0-rc3-next-20160616+ #172
[    0.581344] Hardware name: AMD Overdrive/Supercharger/Default string, BIOS ROD1001A 02/09/2016
[    0.590025] task: ffff800001ef0000 ti: ffff800001ef8000 task.ti: ffff800001ef8000
[    0.597571] PC is at acpi_ns_lookup+0x520/0x734
[    0.602134] LR is at acpi_ns_lookup+0x4a4/0x734
[    0.606693] pc : [<ffff0000083b8b10>] lr : [<ffff0000083b8a94>] pstate: 60000045
[    0.614145] sp : ffff800001efb8b0
[    0.617478] x29: ffff800001efb8c0 x28: 000000000000001b
[    0.622829] x27: 0000000000000001 x26: 0000000000000000
[    0.628181] x25: ffff800001efb9e8 x24: ffff000008a10000
[    0.633531] x23: 0000000000000001 x22: 0000000000000001
[    0.638881] x21: ffff000008724000 x20: 000000000000001b
[    0.644230] x19: ffff0000080521e7 x18: 000000000000000d
[    0.649580] x17: 00000000000038ff x16: 0000000000000002
[    0.654929] x15: 0000000000000007 x14: 0000000000007fff
[    0.660278] x13: ffffff0000000000 x12: 0000000000000018
[    0.665627] x11: 000000001fffd200 x10: 00000000ffffff76
[    0.670978] x9 : 000000000000005f x8 : ffff000008725fa8
[    0.676328] x7 : ffff000008a8df70 x6 : ffff000008a8df70
[    0.681679] x5 : ffff000008a8d000 x4 : 0000000000000010
[    0.687027] x3 : 0000000000000010 x2 : 000000000000000c
[    0.692378] x1 : 0000000000000006 x0 : 0000000000000000
...
[    1.262235] [<ffff0000083b8b10>] acpi_ns_lookup+0x520/0x734
[    1.267845] [<ffff0000083a7160>] acpi_ds_load1_begin_op+0x174/0x4fc
[    1.274156] [<ffff0000083c1f4c>] acpi_ps_build_named_op+0xf8/0x220
[    1.280380] [<ffff0000083c227c>] acpi_ps_create_op+0x208/0x33c
[    1.286254] [<ffff0000083c1820>] acpi_ps_parse_loop+0x204/0x838
[    1.292215] [<ffff0000083c2fd4>] acpi_ps_parse_aml+0x1bc/0x42c
[    1.298090] [<ffff0000083bc6e8>] acpi_ns_one_complete_parse+0x1e8/0x22c
[    1.304753] [<ffff0000083bc7b8>] acpi_ns_parse_table+0x8c/0x128
[    1.310716] [<ffff0000083bb8fc>] acpi_ns_load_table+0xc0/0x1e8
[    1.316591] [<ffff0000083c9068>] acpi_tb_load_namespace+0xf8/0x2e8
[    1.322818] [<ffff000008984128>] acpi_load_tables+0x7c/0x110
[    1.328516] [<ffff000008982ea4>] acpi_init+0x90/0x2c0
[    1.333603] [<ffff0000080819fc>] do_one_initcall+0x38/0x12c
[    1.339215] [<ffff000008960cd4>] kernel_init_freeable+0x148/0x1ec
[    1.345353] [<ffff0000086b7d30>] kernel_init+0x10/0xec
[    1.350529] [<ffff000008084e10>] ret_from_fork+0x10/0x40
[    1.355878] Code: b9009fbc 2a00037b 36380057 3219037b (b9400260)
[    1.362035] ---[ end trace 03381e5eb0a24de4 ]---
[    1.366691] Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b

With 'efi=debug', we can see those ACPI regions loaded by firmware on
that board as:
[    0.000000] efi:   0x0083ff185000-0x0083ff1b4fff [Reserved           |   |  |  |  |  |  |  |   |WB|WT|WC|UC]*
[    0.000000] efi:   0x0083ff1b5000-0x0083ff1c2fff [ACPI Reclaim Memory|   |  |  |  |  |  |  |   |WB|WT|WC|UC]*
[    0.000000] efi:   0x0083ff223000-0x0083ff224fff [ACPI Memory NVS    |   |  |  |  |  |  |  |   |WB|WT|WC|UC]*

This patch is trying to address the above issue by only keep those
NOMAP regions instead of removing all above limit from memory memblock.

Signed-off-by: Dennis Chen <dennis.chen-5wv7dgnIgG8@public.gmane.org>
Cc: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
Cc: Steve Capper <steve.capper-5wv7dgnIgG8@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
Cc: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Cc: Rafael J. Wysocki <rafael.j.wysocki-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
 arch/arm64/mm/init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/mm/init.c b/arch/arm64/mm/init.c
index 7d25b4d..9482b45 100644
--- a/arch/arm64/mm/init.c
+++ b/arch/arm64/mm/init.c
@@ -226,7 +226,7 @@ void __init arm64_memblock_init(void)
 	 * via the linear mapping.
 	 */
 	if (memory_limit != (phys_addr_t)ULLONG_MAX) {
-		memblock_enforce_memory_limit(memory_limit);
+		memblock_mem_limit_remove_map(memory_limit);
 		memblock_add(__pa(_text), (u64)(_end - _text));
 	}
 
-- 
2.7.4
