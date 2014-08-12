From: Dave Young <dyoung@redhat.com>
Subject: [PATCH 4/5] efi x86: clear EFI_RUNTIME_SERVICES bit in case failures
 other than SetVirtualAddressMap
Date: Tue, 12 Aug 2014 14:10:21 +0800
Message-ID: <1407823822-23829-4-git-send-email-dyoung@redhat.com>
References: <1407823822-23829-1-git-send-email-dyoung@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1407823822-23829-1-git-send-email-dyoung@redhat.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Matt Fleming <matt.fleming@intel.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>, Randy Dunlap <rdunlap@infradead.org>, rtc-linux@googlegroups.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-efi@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, Mark Salter <msalter@redhat.com>, Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org, Leif Lindholm <leif.lindholm@linaro.org>, Ingo Molnar <mingo@redhat.com>, hpa@zytor.com, Thomas Gleixner <tglx@linutronix.de>, linux-arm-kernel@lists.infradead.org
List-Id: linux-efi@vger.kernel.org

If enter virtual mode failed due to some reason other than the efi call
the EFI_RUNTIME_SERVICES bit in efi.flags should be cleared thus users
of efi runtime services can check the bit and handle the case instead of
assume efi runtime is ok.

Per Matt, if efi call SetVirtualAddressMap fails we will be not sure it's safe
to make any assumptions about the state of the system. so kernel panics instead
of clears EFI_RUNTIME_SERVICES bit.

Signed-off-by: Dave Young <dyoung@redhat.com>
---
 arch/x86/platform/efi/efi.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index eae91be..c42f49b 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -724,6 +724,7 @@ static void __init kexec_enter_virtual_mode(void)
 	 */
 	if (!efi_is_native()) {
 		efi_unmap_memmap();
+		clear_bit(EFI_RUNTIME_SERVICES, &efi.flags);
 		return;
 	}
 
@@ -797,6 +798,7 @@ static void __init __efi_enter_virtual_mode(void)
 	new_memmap = efi_map_regions(&count, &pg_shift);
 	if (!new_memmap) {
 		pr_err("Error reallocating memory, EFI runtime non-functional!\n");
+		clear_bit(EFI_RUNTIME_SERVICES, &efi.flags);
 		return;
 	}
 
@@ -804,8 +806,10 @@ static void __init __efi_enter_virtual_mode(void)
 
 	BUG_ON(!efi.systab);
 
-	if (efi_setup_page_tables(__pa(new_memmap), 1 << pg_shift))
+	if (efi_setup_page_tables(__pa(new_memmap), 1 << pg_shift)) {
+		clear_bit(EFI_RUNTIME_SERVICES, &efi.flags);
 		return;
+	}
 
 	efi_sync_low_kernel_mappings();
 	efi_dump_pagetable();
@@ -882,8 +886,10 @@ static void __init __efi_enter_virtual_mode(void)
 
 void __init efi_enter_virtual_mode(void)
 {
-	if (efi_enabled(EFI_PARAVIRT))
+	if (efi_enabled(EFI_PARAVIRT)) {
+		clear_bit(EFI_RUNTIME_SERVICES, &efi.flags);
 		return;
+	}
 
 	if (efi_setup)
 		kexec_enter_virtual_mode();
-- 
1.8.3.1
