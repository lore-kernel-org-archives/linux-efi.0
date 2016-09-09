From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: [PATCH 01/29] x86/efi: Test for EFI_MEMMAP functionality when iterating EFI memmap
Date: Fri,  9 Sep 2016 16:18:23 +0100
Message-ID: <20160909151851.27577-2-matt@codeblueprint.co.uk>
References: <20160909151851.27577-1-matt@codeblueprint.co.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160909151851.27577-1-matt@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>
Cc: Matt Fleming <matt@codeblueprint.co.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Dave Young <dyoung@redhat.com>, Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Taku Izumi <izumi.taku@jp.fujitsu.com>, Tony Luck <tony.luck@intel.com>, Xishi Qiu <qiuxishi@huawei.com>
List-Id: linux-efi@vger.kernel.org

Both efi_find_mirror() and efi_fake_memmap() really want to know
whether the EFI memory map is available, not just whether the machine
was booted using EFI. efi_fake_memmap() even has a check for
EFI_MEMMAP at the start of the function.

Since we've already got other code that has this dependency, merge
everything under one if() conditional, and remove the now superfluous
check from efi_fake_memmap().

Tested-by: Dave Young <dyoung@redhat.com> [kexec/kdump]
Tested-by: Ard Biesheuvel <ard.biesheuvel@linaro.org> [arm]
Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Taku Izumi <izumi.taku@jp.fujitsu.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Xishi Qiu <qiuxishi@huawei.com>
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Matt Fleming <matt@codeblueprint.co.uk>
---
 arch/x86/kernel/setup.c         | 17 ++++++++---------
 drivers/firmware/efi/fake_mem.c |  2 +-
 2 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 0fa60f5f5a16..4fd69e532c15 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -1096,19 +1096,18 @@ void __init setup_arch(char **cmdline_p)
 	memblock_set_current_limit(ISA_END_ADDRESS);
 	memblock_x86_fill();
 
-	if (efi_enabled(EFI_BOOT)) {
+	reserve_bios_regions();
+
+	if (efi_enabled(EFI_MEMMAP)) {
 		efi_fake_memmap();
 		efi_find_mirror();
-	}
-
-	reserve_bios_regions();
 
-	/*
-	 * The EFI specification says that boot service code won't be called
-	 * after ExitBootServices(). This is, in fact, a lie.
-	 */
-	if (efi_enabled(EFI_MEMMAP))
+		/*
+		 * The EFI specification says that boot service code won't be
+		 * called after ExitBootServices(). This is, in fact, a lie.
+		 */
 		efi_reserve_boot_services();
+	}
 
 	/* preallocate 4k for mptable mpc */
 	early_reserve_e820_mpc_new();
diff --git a/drivers/firmware/efi/fake_mem.c b/drivers/firmware/efi/fake_mem.c
index 48430aba13c1..c437388a7b85 100644
--- a/drivers/firmware/efi/fake_mem.c
+++ b/drivers/firmware/efi/fake_mem.c
@@ -64,7 +64,7 @@ void __init efi_fake_memmap(void)
 	void *old, *new;
 	int i;
 
-	if (!nr_fake_mem || !efi_enabled(EFI_MEMMAP))
+	if (!nr_fake_mem)
 		return;
 
 	/* count up the number of EFI memory descriptor */
-- 
2.9.3
