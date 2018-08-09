From: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
Subject: [PATCH V1 6/6] x86/efi: Introduce EFI_WARN_ON_ILLEGAL_ACCESSES
Date: Wed,  8 Aug 2018 21:31:17 -0700
Message-ID: <1533789077-16156-7-git-send-email-sai.praneeth.prakhya@intel.com>
References: <1533789077-16156-1-git-send-email-sai.praneeth.prakhya@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1533789077-16156-1-git-send-email-sai.praneeth.prakhya@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: ricardo.ner@intel.com, matt@codeblueprint.co.uk, Sai Praneeth <sai.praneeth.prakhya@intel.com>, Lee Chun-Yi <jlee@suse.com>, Al Stone <astone@redhat.com>, Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, Bhupesh Sharma <bhsharma@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: linux-efi@vger.kernel.org

From: Sai Praneeth <sai.praneeth.prakhya@intel.com>

There may exist some buggy UEFI firmware implementations that might
access efi regions other than EFI_RUNTIME_SERVICES_<CODE/DATA> even
after the kernel has assumed control of the platform. This violates UEFI
specification.

If selected, this debug option will print a warning message if the UEFI
firmware tries to access any memory region which it shouldn't. Along
with the warning, the efi page fault handler will also try to
fixup/recover from the page fault triggered by the firmware so that the
machine doesn't hang.

To support this feature, two changes should be made to the existing efi
subsystem
1. Map EFI_BOOT_SERVICES_<CODE/DATA> regions only when
   EFI_WARN_ON_ILLEGAL_ACCESSES is disabled
    Presently, the kernel maps EFI_BOOT_SERVICES_<CODE/DATA> regions as
    a workaround for buggy firmware that accesses them even when they
    shouldn't. With EFI_WARN_ON_ILLEGAL_ACCESSES enabled (and hence efi
    page fault handler) kernel can now detect and handle such accesses
    dynamically. Hence, rather than safely mapping
    EFI_BOOT_SERVICES_<CODE/DATA> regions *all* the time, map them on
    demand.

2. If EFI_WARN_ON_ILLEGAL_ACCESSES is enabled don't call
   efi_free_boot_services()
    Presently, during early boot phase EFI_BOOT_SERVICES_<CODE/DATA>
    regions are marked as reserved by kernel
    (see efi_reserve_boot_services()) and are freed before entering
    runtime (see efi_free_boot_services()). But, while dynamically
    fixing page faults caused by the firmware, efi page fault handler
    assumes that EFI_BOOT_SERVICES_<CODE/DATA> regions are still intact.
    Hence, to make this assumption true, don't call
    efi_free_boot_services() if EFI_WARN_ON_ILLEGAL_ACCESSES is enabled.

Suggested-by: Matt Fleming <matt@codeblueprint.co.uk>
Based-on-code-from: Ricardo Neri <ricardo.neri@intel.com>
Signed-off-by: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
Cc: Lee Chun-Yi <jlee@suse.com>
Cc: Al Stone <astone@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Bhupesh Sharma <bhsharma@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/x86/Kconfig            | 21 +++++++++++++++++++++
 arch/x86/platform/efi/efi.c |  4 ++++
 init/main.c                 |  3 ++-
 3 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index f1dbb4ee19d7..278e5820e8dd 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1957,6 +1957,27 @@ config EFI_MIXED
 
 	   If unsure, say N.
 
+config EFI_WARN_ON_ILLEGAL_ACCESSES
+	bool "Warn about illegal memory accesses by firmware"
+	depends on EFI
+	help
+	  Enable this debug feature so that the kernel can detect illegal
+	  memory accesses by firmware and issue a warning. Also,
+	  1. If the illegally accessed region is EFI_BOOT_SERVICES_<CODE/DATA>,
+	     the kernel fixes it up by mapping the requested region.
+	  2. If the illegally accessed region is any other region (Eg:
+	     EFI_CONVENTIONAL_MEMORY or EFI_LOADER_<CODE/DATA>), then the
+	     kernel freezes efi_rts_wq and schedules a new process. Also, it
+	     disables EFI Runtime Services, so that it will never again call
+	     buggy firmware.
+	  3. If the access is to any other efi region like above but if the
+	     buggy efi runtime service is efi_reset_system(), then the
+	     platform is rebooted through BIOS.
+	  Please see the UEFI specification for details on the expectations
+	  of memory usage.
+
+	  If unsure, say N.
+
 config SECCOMP
 	def_bool y
 	prompt "Enable seccomp to safely compute untrusted bytecode"
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 7d18b7ed5d41..0ddb22a03d88 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -768,9 +768,13 @@ static bool should_map_region(efi_memory_desc_t *md)
 	/*
 	 * Map boot services regions as a workaround for buggy
 	 * firmware that accesses them even when they shouldn't.
+	 * (only if CONFIG_EFI_WARN_ON_ILLEGAL_ACCESSES is disabled)
 	 *
 	 * See efi_{reserve,free}_boot_services().
 	 */
+	if (IS_ENABLED(CONFIG_EFI_WARN_ON_ILLEGAL_ACCESSES))
+		return false;
+
 	if (md->type == EFI_BOOT_SERVICES_CODE ||
 	    md->type == EFI_BOOT_SERVICES_DATA)
 		return true;
diff --git a/init/main.c b/init/main.c
index 3b4ada11ed52..dce0520861a1 100644
--- a/init/main.c
+++ b/init/main.c
@@ -730,7 +730,8 @@ asmlinkage __visible void __init start_kernel(void)
 	arch_post_acpi_subsys_init();
 	sfi_init_late();
 
-	if (efi_enabled(EFI_RUNTIME_SERVICES)) {
+	if (efi_enabled(EFI_RUNTIME_SERVICES) &&
+	    !IS_ENABLED(CONFIG_EFI_WARN_ON_ILLEGAL_ACCESSES)) {
 		efi_free_boot_services();
 	}
 
-- 
2.7.4
