From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: [PATCH 1/2] x86/platform/uv: Skip UV runtime services mapping in the efi_runtime_disabled case
Date: Thu, 11 Aug 2016 11:41:59 +0100
Message-ID: <1470912120-22831-2-git-send-email-matt@codeblueprint.co.uk>
References: <1470912120-22831-1-git-send-email-matt@codeblueprint.co.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1470912120-22831-1-git-send-email-matt@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>
Cc: Alex Thorlton <athorlton@sgi.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Matt Fleming <matt@codeblueprint.co.uk>, Borislav Petkov <bp@suse.de>, Ingo Molnar <mingo@redhat.com>, Mike Travis <travis@sgi.com>, Russ Anderson <rja@sgi.com>, stable@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

From: Alex Thorlton <athorlton@sgi.com>

This problem has actually been in the UV code for a while, but we didn't
catch it until recently, because we had been relying on EFI_OLD_MEMMAP
to allow our systems to boot for a period of time.  We noticed the issue
when trying to kexec a recent community kernel, where we hit this NULL
pointer dereference in efi_sync_low_kernel_mappings:

[    0.337515] BUG: unable to handle kernel NULL pointer dereference at 0000000000000880
[    0.346276] IP: [<ffffffff8105df8d>] efi_sync_low_kernel_mappings+0x5d/0x1b0

The problem doesn't show up with EFI_OLD_MEMMAP because we skip the
chunk of setup_efi_state that sets the efi_loader_signature for the
kexec'd kernel.  When the kexec'd kernel boots, it won't set EFI_BOOT in
setup_arch, so we completely avoid the bug.

We always kexec with noefi on the command line, so this shouldn't be an
issue, but since we're not actually checking for efi_runtime_disabled in
uv_bios_init, we end up trying to do EFI runtime callbacks when we
shouldn't be. This patch just adds a check for efi_runtime_disabled in
uv_bios_init so that we don't map in uv_systab when runtime_disabled ==
true.

Signed-off-by: Alex Thorlton <athorlton@sgi.com>
Cc: Russ Anderson <rja@sgi.com>
Cc: Mike Travis <travis@sgi.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
Cc: <stable@vger.kernel.org> # v4.7
Signed-off-by: Matt Fleming <matt@codeblueprint.co.uk>
---
 arch/x86/platform/uv/bios_uv.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/platform/uv/bios_uv.c b/arch/x86/platform/uv/bios_uv.c
index 66b2166ea4a1..0df8a0370d32 100644
--- a/arch/x86/platform/uv/bios_uv.c
+++ b/arch/x86/platform/uv/bios_uv.c
@@ -187,7 +187,8 @@ EXPORT_SYMBOL_GPL(uv_bios_set_legacy_vga_target);
 void uv_bios_init(void)
 {
 	uv_systab = NULL;
-	if ((efi.uv_systab == EFI_INVALID_TABLE_ADDR) || !efi.uv_systab) {
+	if ((efi.uv_systab == EFI_INVALID_TABLE_ADDR) ||
+	    !efi.uv_systab || efi_runtime_disabled()) {
 		pr_crit("UV: UVsystab: missing\n");
 		return;
 	}
-- 
2.7.3
