From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 1/1] efi/arm64: add a terminator for ptdump marker
Date: Sat,  2 Feb 2019 10:50:17 +0100
Message-ID: <20190202095017.13799-2-ard.biesheuvel@linaro.org>
References: <20190202095017.13799-1-ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190202095017.13799-1-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, Qian Cai <cai@lca.pw>
List-Id: linux-efi@vger.kernel.org

From: Qian Cai <cai@lca.pw>

Reading efi_page_tables debugfs triggers an out-of-bounds access here,

  arch/arm64/mm/dump.c: 282
  if (addr >= st->marker[1].start_address) {

called from,

  arch/arm64/mm/dump.c: 331
  note_page(st, addr, 2, pud_val(pud));

because st->marker++ is is called after "UEFI runtime end" which is the
last element in addr_marker[]. Therefore, add a terminator like the one
for kernel_page_tables, so it can be skipped to print out non-existent
markers.

  # cat /sys/kernel/debug/efi_page_tables
  ---[ UEFI runtime start ]---
  0x0000000020000000-0x0000000020010000          64K PTE       RW NX SHD AF ...
  0x0000000020200000-0x0000000021340000       17664K PTE       RW NX SHD AF ...
  ...
  0x0000000021920000-0x0000000021950000         192K PTE       RW x  SHD AF ...
  0x0000000021950000-0x00000000219a0000         320K PTE       RW NX SHD AF ...
  ---[ UEFI runtime end ]---
  ---[ (null) ]---
  ---[ (null) ]---

  [12126.163970] BUG: KASAN: global-out-of-bounds in note_page+0x1f0/0xac0
  [12126.170404] Read of size 8 at addr ffff2000123f2ac0 by task read_all/42464
  [12126.199520] Call trace:
  [12126.201972]  dump_backtrace+0x0/0x298
  [12126.205627]  show_stack+0x24/0x30
  [12126.208944]  dump_stack+0xb0/0xdc
  [12126.212258]  print_address_description+0x64/0x2b0
  [12126.216954]  kasan_report+0x150/0x1a4
  [12126.220610]  __asan_report_load8_noabort+0x30/0x3c
  [12126.225392]  note_page+0x1f0/0xac0
  [12126.228786]  walk_pgd+0xb4/0x244
  [12126.232005]  ptdump_walk_pgd+0xec/0x140
  [12126.235833]  ptdump_show+0x40/0x50
  [12126.239237]  seq_read+0x3f8/0xad0
  [12126.242548]  full_proxy_read+0x9c/0xc0
  [12126.246290]  __vfs_read+0xfc/0x4c8
  [12126.249684]  vfs_read+0xec/0x208
  [12126.252904]  ksys_read+0xd0/0x15c
  [12126.256210]  __arm64_sys_read+0x84/0x94
  [12126.260048]  el0_svc_handler+0x258/0x304
  [12126.263963]  el0_svc+0x8/0xc
  [12126.266834]
  [12126.268317] The buggy address belongs to the variable:
  [12126.273458]  __compound_literal.0+0x20/0x800
  [12126.277718]
  [12126.279201] Memory state around the buggy address:
  [12126.283987]  ffff2000123f2980: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  [12126.291200]  ffff2000123f2a00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 fa
  [12126.298412] >ffff2000123f2a80: fa fa fa fa 00 00 00 00 fa fa fa fa 00 00 00 00
  [12126.305624]                                            ^
  [12126.310927]  ffff2000123f2b00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  [12126.318140]  ffff2000123f2b80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0

Fixes: 9d80448ac92b ("efi/arm64: Add debugfs node to dump UEFI runtime page tables")
Signed-off-by: Qian Cai <cai@lca.pw>
[ardb: fix up whitespace]
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/firmware/efi/arm-runtime.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/efi/arm-runtime.c b/drivers/firmware/efi/arm-runtime.c
index 23ea1ed409d1..352bd2473162 100644
--- a/drivers/firmware/efi/arm-runtime.c
+++ b/drivers/firmware/efi/arm-runtime.c
@@ -37,8 +37,9 @@ extern u64 efi_system_table;
 static struct ptdump_info efi_ptdump_info = {
 	.mm		= &efi_mm,
 	.markers	= (struct addr_marker[]){
-		{ 0,		"UEFI runtime start" },
-		{ DEFAULT_MAP_WINDOW_64, "UEFI runtime end" }
+		{ 0,				"UEFI runtime start" },
+		{ DEFAULT_MAP_WINDOW_64,	"UEFI runtime end" },
+		{ -1,				NULL }
 	},
 	.base_addr	= 0,
 };
-- 
2.17.1
