From: Kosuke Tatsukawa <tatsu@ab.jp.nec.com>
Subject: [PATCH 1/2] x86: Fix kernel panic when booting with XD disabled in
 uEFI firmware
Date: Thu, 3 Dec 2015 23:58:33 +0000
Message-ID: <17EC94B0A072C34B8DCF0D30AD16044A0288E2D7@BPXM09GP.gisp.nec.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: ja-JP
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>
Cc: Matt Fleming <matt.fleming@intel.com>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

The kernel panics early in boot on a x86_64 server if the eXecute
Disable (XD) bit is set to disabled in the uEFI firmware.  The message
in the kernel log buffer looks like below.
------------------------------------------------------------------------
[    0.000000] CPU: 0 PID: 0 Comm: swapper Not tainted 4.4.0-rc3 #1
[    0.000000]  0000000000000000 261c6fa13723be1b ffffffff819b7e40 ffffffff8131f320
[    0.000000]  ffffffffffffffff ffffffff819b7f30 ffffffff81b261b0 000000000000001c
[    0.000000]  ffffffff81d77a1c 0000000000000010 00000000be35a000 ffffffffff200000
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff8131f320>] dump_stack+0x44/0x64
[    0.000000]  [<ffffffff81b261b0>] early_idt_handler_common+0x90/0xd0
[    0.000000]  [<ffffffff81b2f1c5>] ? setup_arch+0x1f1/0xce0
[    0.000000]  [<ffffffff81b2f1c5>] ? setup_arch+0x1f1/0xce0
[    0.000000]  [<ffffffff81b26120>] ? early_idt_handler_array+0x120/0x120
[    0.000000]  [<ffffffff81b26d81>] start_kernel+0xe6/0x4f0
[    0.000000]  [<ffffffff81b26120>] ? early_idt_handler_array+0x120/0x120
[    0.000000]  [<ffffffff81b26120>] ? early_idt_handler_array+0x120/0x120
[    0.000000]  [<ffffffff81b265ee>] x86_64_start_reservations+0x2a/0x2c
[    0.000000]  [<ffffffff81b2673c>] x86_64_start_kernel+0x14c/0x16f
[    0.000000] RIP 0x80000000be359163
------------------------------------------------------------------------

The panic occurs because __early_set_fixmap() called from
parse_setup_data() unconditionally sets the PTE with FIXMAP_PAGE_NORMAL,
which contains _PAGE_NX and causes an exception.

This patch modifies __early_set_fixmap() to set _PAGE_NX only when the
hardware supports it.  It also moves the call to x86_configure_nx()
earlier in setup_arch() before __early_set_fixmap() is first called.

The above problem occurs after __early_set_fixmap() is called from
parse_setup_data().  However, since setup_olpc_ofw_pgd() can also call
__early_set_fixmap(), the patch moves the call to x86_configure_nx()
before that.

Signed-off-by: Kosuke Tatsukawa <tatsu@ab.jp.nec.com>
---
 arch/x86/kernel/setup.c |   18 +++++++++---------
 arch/x86/mm/ioremap.c   |    3 +++
 2 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 29db25f..c8b2cdb 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -894,6 +894,15 @@ void __init setup_arch(char **cmdline_p)
 	early_cpu_init();
 	early_ioremap_init();
 
+	/*
+	 * x86_configure_nx() is called to detect whether hardware doesn't
+	 * support NX.  It has to be called before __early_set_fixmap() is
+	 * called from setup_olpc_ofw_pgd and parse_setup_data.  It may
+	 * then be called again from within noexec_setup() during parsing
+	 * early parameters to honor the respective command line option.
+	 */
+	x86_configure_nx();
+
 	setup_olpc_ofw_pgd();
 
 	ROOT_DEV = old_decode_dev(boot_params.hdr.root_dev);
@@ -971,15 +980,6 @@ void __init setup_arch(char **cmdline_p)
 	strlcpy(command_line, boot_command_line, COMMAND_LINE_SIZE);
 	*cmdline_p = command_line;
 
-	/*
-	 * x86_configure_nx() is called before parse_early_param() to detect
-	 * whether hardware doesn't support NX (so that the early EHCI debug
-	 * console setup can safely call set_fixmap()). It may then be called
-	 * again from within noexec_setup() during parsing early parameters
-	 * to honor the respective command line option.
-	 */
-	x86_configure_nx();
-
 	parse_early_param();
 
 	x86_report_nx();
diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index b9c78f3..9036c8e 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -493,6 +493,9 @@ void __init __early_set_fixmap(enum fixed_addresses idx,
 	}
 	pte = early_ioremap_pte(addr);
 
+	if (!(__supported_pte_mask & _PAGE_NX))
+		pgprot_val(flags) &= ~_PAGE_NX;
+
 	if (pgprot_val(flags))
 		set_pte(pte, pfn_pte(phys >> PAGE_SHIFT, flags));
 	else
