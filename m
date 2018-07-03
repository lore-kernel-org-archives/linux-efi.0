From: Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH] x86/efi: Access EFI MMIO data as unencrypted when SEV is active
Date: Tue,  3 Jul 2018 08:32:00 -0500
Message-ID: <1530624720-32004-1-git-send-email-brijesh.singh@amd.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: x86@kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Brijesh Singh <brijesh.singh@amd.com>, Tom Lendacky <thomas.lendacky@amd.com>, Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@suse.de>, kvm@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Matt Fleming <matt@codeblueprint.co.uk>, Andy Lutomirski <luto@kernel.org>, "# 4 . 15 . x" <stable@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

SEV guest fails to update the UEFI runtime variables stored in the
flash. commit 1379edd59673 ("x86/efi: Access EFI data as encrypted
when SEV is active") unconditionally maps all the UEFI runtime data
as 'encrypted' (C=1). When SEV is active the UEFI runtime data marked
as EFI_MEMORY_MAPPED_IO should be mapped as 'unencrypted' so that both
guest and hypervisor can access the data.

Fixes: 1379edd59673 (x86/efi: Access EFI data as encrypted ...)
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Borislav Petkov <bp@suse.de>
Cc: linux-efi@vger.kernel.org
Cc: kvm@vger.kernel.org
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: <stable@vger.kernel.org> # 4.15.x
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/platform/efi/efi_64.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
index 77873ce..5f2eb32 100644
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
2.7.4
