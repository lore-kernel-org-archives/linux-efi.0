From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.17 17/31] x86/efi: Access EFI MMIO data as unencrypted when SEV is active
Date: Sat,  4 Aug 2018 11:00:52 +0200
Message-ID: <20180804082633.586381045@linuxfoundation.org>
References: <20180804082632.304529527@linuxfoundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180804082632.304529527@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, Brijesh Singh <brijesh.singh@amd.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Tom Lendacky <thomas.lendacky@amd.com>, Linus Torvalds <torvalds@linux-foundation.org>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>
List-Id: linux-efi@vger.kernel.org

4.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brijesh Singh <brijesh.singh@amd.com>

commit 9b788f32bee6b0b293a4bdfca4ad4bb0206407fb upstream.

SEV guest fails to update the UEFI runtime variables stored in the
flash.

The following commit:

  1379edd59673 ("x86/efi: Access EFI data as encrypted when SEV is active")

unconditionally maps all the UEFI runtime data as 'encrypted' (C=1).

When SEV is active the UEFI runtime data marked as EFI_MEMORY_MAPPED_IO
should be mapped as 'unencrypted' so that both guest and hypervisor can
access the data.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Cc: <stable@vger.kernel.org> # 4.15.x
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-efi@vger.kernel.org
Fixes: 1379edd59673 ("x86/efi: Access EFI data as encrypted ...")
Link: http://lkml.kernel.org/r/20180720012846.23560-2-ard.biesheuvel@linaro.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/platform/efi/efi_64.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -417,7 +417,7 @@ static void __init __map_region(efi_memo
 	if (!(md->attribute & EFI_MEMORY_WB))
 		flags |= _PAGE_PCD;
 
-	if (sev_active())
+	if (sev_active() && md->type != EFI_MEMORY_MAPPED_IO)
 		flags |= _PAGE_ENC;
 
 	pfn = md->phys_addr >> PAGE_SHIFT;
