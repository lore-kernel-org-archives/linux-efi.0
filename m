From: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
Subject: [PATCH V4 3/3] x86/efi: Introduce EFI_PAGE_FAULT_HANDLER
Date: Thu,  6 Sep 2018 16:27:48 -0700
Message-ID: <1536276468-28499-4-git-send-email-sai.praneeth.prakhya@intel.com>
References: <1536276468-28499-1-git-send-email-sai.praneeth.prakhya@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1536276468-28499-1-git-send-email-sai.praneeth.prakhya@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
Cc: ricardo.neri@intel.com, matt@codeblueprint.co.uk, Sai Praneeth <sai.praneeth.prakhya@intel.com>, Al Stone <astone@redhat.com>, Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, Bhupesh Sharma <bhsharma@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Peter Zijlstra <peterz@infradead.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: linux-efi@vger.kernel.org

From: Sai Praneeth <sai.praneeth.prakhya@intel.com>

There may exist some buggy UEFI firmware implementations that might
access efi regions other than EFI_RUNTIME_SERVICES_<CODE/DATA> even
after the kernel has assumed control of the platform. This violates UEFI
specification.

If selected, this debug option will print a warning message if the UEFI
firmware tries to access any memory region which it shouldn't. Along
with the warning, the efi page fault handler will also try to recover
from the page fault triggered by the firmware so that the machine
doesn't hang.

Suggested-by: Matt Fleming <matt@codeblueprint.co.uk>
Based-on-code-from: Ricardo Neri <ricardo.neri@intel.com>
Signed-off-by: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
Cc: Al Stone <astone@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Bhupesh Sharma <bhsharma@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/x86/Kconfig | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index f1dbb4ee19d7..cc840710ae3e 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1957,6 +1957,24 @@ config EFI_MIXED
 
 	   If unsure, say N.
 
+config EFI_PAGE_FAULT_HANDLER
+	bool "EFI page fault handler support" if EXPERT
+	depends on EFI
+	help
+	  Enable this debug feature so that the kernel can recover from page
+	  faults caused by buggy firmware. Also,
+	  1. If the page fault is caused by efi_reset_system(), then the
+	     platform is rebooted through BIOS.
+	  2. If the page fault is caused by any other efi runtime service,
+	     then the kernel freezes efi_rts_wq (work queue that runs efi
+	     runtime services) and schedules a new process. Also, it disables
+	     EFI Runtime Services, so that it will never again call buggy
+	     firmware.
+	  Please see the UEFI specification for details on the expectations
+	  of memory usage.
+
+	  If unsure, say N.
+
 config SECCOMP
 	def_bool y
 	prompt "Enable seccomp to safely compute untrusted bytecode"
-- 
2.7.4
