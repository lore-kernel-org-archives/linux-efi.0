From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: [PATCH 1/5] efi: Don't issue error message when booted under xen
Date: Fri, 26 May 2017 12:36:47 +0100
Message-ID: <20170526113652.21339-2-matt@codeblueprint.co.uk>
References: <20170526113652.21339-1-matt@codeblueprint.co.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170526113652.21339-1-matt@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>
Cc: Juergen Gross <jgross@suse.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Matt Fleming <matt@codeblueprint.co.uk>, stable@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

From: Juergen Gross <jgross@suse.com>

When booted as Xen dom0 there won't be an EFI memmap allocated. Avoid
issuing an error message in this case:

[    0.144079] efi: Failed to allocate new EFI memmap

Signed-off-by: Juergen Gross <jgross@suse.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: <stable@vger.kernel.org> # v4.9+
Signed-off-by: Matt Fleming <matt@codeblueprint.co.uk>
---
 arch/x86/platform/efi/quirks.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
index 26615991d69c..e0cf95a83f3f 100644
--- a/arch/x86/platform/efi/quirks.c
+++ b/arch/x86/platform/efi/quirks.c
@@ -360,6 +360,9 @@ void __init efi_free_boot_services(void)
 		free_bootmem_late(start, size);
 	}
 
+	if (!num_entries)
+		return;
+
 	new_size = efi.memmap.desc_size * num_entries;
 	new_phys = efi_memmap_alloc(num_entries);
 	if (!new_phys) {
-- 
2.12.2
