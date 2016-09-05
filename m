From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.7 003/143] x86/platform/uv: Skip UV runtime services mapping in the efi_runtime_disabled case
Date: Mon,  5 Sep 2016 18:42:59 +0200
Message-ID: <20160905164430.753320812@linuxfoundation.org>
References: <20160905164430.593075551@linuxfoundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160905164430.593075551@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, Alex Thorlton <athorlton@sgi.com>, Matt Fleming <matt@codeblueprint.co.uk>, Andy Lutomirski <luto@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Borislav Petkov <bp@alien8.de>, Borislav Petkov <bp@suse.de>, Brian Gerst <brgerst@gmail.com>, Denys Vlasenko <dvlasenk@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Josh Poimboeuf <jpoimboe@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, Mike Travis <travis@sgi.com>, Peter Zijlstra <peterz@infradead.org>, Russ Anderson <rja@sgi.com>, Thomas Gleixner <tglx@linutronix.de>, linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>
List-Id: linux-efi@vger.kernel.org

4.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Thorlton <athorlton@sgi.com>

commit f72075c9eda8a43aeea2f9dbb8d187afd4a76f0b upstream.

This problem has actually been in the UV code for a while, but we didn't
catch it until recently, because we had been relying on EFI_OLD_MEMMAP
to allow our systems to boot for a period of time.  We noticed the issue
when trying to kexec a recent community kernel, where we hit this NULL
pointer dereference in efi_sync_low_kernel_mappings():

 [    0.337515] BUG: unable to handle kernel NULL pointer dereference at 0000000000000880
 [    0.346276] IP: [<ffffffff8105df8d>] efi_sync_low_kernel_mappings+0x5d/0x1b0

The problem doesn't show up with EFI_OLD_MEMMAP because we skip the
chunk of setup_efi_state() that sets the efi_loader_signature for the
kexec'd kernel.  When the kexec'd kernel boots, it won't set EFI_BOOT in
setup_arch, so we completely avoid the bug.

We always kexec with noefi on the command line, so this shouldn't be an
issue, but since we're not actually checking for efi_runtime_disabled in
uv_bios_init(), we end up trying to do EFI runtime callbacks when we
shouldn't be. This patch just adds a check for efi_runtime_disabled in
uv_bios_init() so that we don't map in uv_systab when runtime_disabled ==
true.

Signed-off-by: Alex Thorlton <athorlton@sgi.com>
Signed-off-by: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Borislav Petkov <bp@suse.de>
Cc: Brian Gerst <brgerst@gmail.com>
Cc: Denys Vlasenko <dvlasenk@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mike Travis <travis@sgi.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Russ Anderson <rja@sgi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-efi@vger.kernel.org
Link: http://lkml.kernel.org/r/1470912120-22831-2-git-send-email-matt@codeblueprint.co.uk
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/platform/uv/bios_uv.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/x86/platform/uv/bios_uv.c
+++ b/arch/x86/platform/uv/bios_uv.c
@@ -188,7 +188,8 @@ EXPORT_SYMBOL_GPL(uv_bios_set_legacy_vga
 void uv_bios_init(void)
 {
 	uv_systab = NULL;
-	if ((efi.uv_systab == EFI_INVALID_TABLE_ADDR) || !efi.uv_systab) {
+	if ((efi.uv_systab == EFI_INVALID_TABLE_ADDR) ||
+	    !efi.uv_systab || efi_runtime_disabled()) {
 		pr_crit("UV: UVsystab: missing\n");
 		return;
 	}
