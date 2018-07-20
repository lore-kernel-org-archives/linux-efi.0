From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 1/1] x86/efi: Access EFI MMIO data as unencrypted when SEV is active
Date: Fri, 20 Jul 2018 10:28:46 +0900
Message-ID: <20180720012846.23560-2-ard.biesheuvel@linaro.org>
References: <20180720012846.23560-1-ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180720012846.23560-1-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, Brijesh Singh <brijesh.singh@amd.com>, Tom Lendacky <thomas.lendacky@amd.com>
List-Id: linux-efi@vger.kernel.org

From: Brijesh Singh <brijesh.singh@amd.com>

SEV guest fails to update the UEFI runtime variables stored in the
flash. commit 1379edd59673 ("x86/efi: Access EFI data as encrypted
when SEV is active") unconditionally maps all the UEFI runtime data
as 'encrypted' (C=1). When SEV is active the UEFI runtime data marked
as EFI_MEMORY_MAPPED_IO should be mapped as 'unencrypted' so that both
guest and hypervisor can access the data.

Fixes: 1379edd59673 ("x86/efi: Access EFI data as encrypted ...")
Cc: <stable@vger.kernel.org> # 4.15.x
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/x86/platform/efi/efi_64.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
index 77873ce700ae..5f2eb3231607 100644
--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -417,7 +417,7 @@ static void __init __map_region(efi_memory_desc_t *md, u64 va)
 	if (!(md->attribute & EFI_MEMORY_WB))
 		flags |= _PAGE_PCD;
 
-	if (sev_active())
+	if (sev_active() && md->type != EFI_MEMORY_MAPPED_IO)
 		flags |= _PAGE_ENC;
 
 	pfn = md->phys_addr >> PAGE_SHIFT;
-- 
2.17.1
