From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: [PATCH 01/11] x86/efi: Test for EFI_MEMMAP functionality when iterating EFI memmap
Date: Thu, 23 Jun 2016 12:34:40 +0100
Message-ID: <1466681690-5850-2-git-send-email-matt@codeblueprint.co.uk>
References: <1466681690-5850-1-git-send-email-matt@codeblueprint.co.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1466681690-5850-1-git-send-email-matt@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>, Dave Young <dyoung@redhat.com>
Cc: Matt Fleming <matt@codeblueprint.co.uk>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Taku Izumi <izumi.taku@jp.fujitsu.com>, Tony Luck <tony.luck@intel.com>, Xishi Qiu <qiuxishi@huawei.com>, Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
List-Id: linux-efi@vger.kernel.org

Both efi_find_mirror() and efi_fake_memmap() really want to know
whether the EFI memory map is available, not just whether the machine
was booted using EFI. efi_fake_memmap() even has a check for
EFI_MEMMAP at the start of the function.

Since we've already got other code that has this dependency, merge
everything under one if() conditional, and remove the now superfluous
check from efi_fake_memmap().

Cc: Taku Izumi <izumi.taku@jp.fujitsu.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Xishi Qiu <qiuxishi@huawei.com>
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Matt Fleming <matt@codeblueprint.co.uk>
---
 arch/x86/kernel/setup.c         | 13 ++++++-------
 drivers/firmware/efi/fake_mem.c |  2 +-
 2 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index c4e7b3991b60..1867fa8ff75e 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -1096,17 +1096,16 @@ void __init setup_arch(char **cmdline_p)
 	memblock_set_current_limit(ISA_END_ADDRESS);
 	memblock_x86_fill();
 
-	if (efi_enabled(EFI_BOOT)) {
+	if (efi_enabled(EFI_MEMMAP)) {
 		efi_fake_memmap();
 		efi_find_mirror();
-	}
 
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
2.7.3
