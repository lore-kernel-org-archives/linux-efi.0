From: Juergen Gross <jgross-IBi9RG/b67k@public.gmane.org>
Subject: [PATCH] efi: don't issue error message when booted under xen
Date: Mon,  8 May 2017 14:56:33 +0200
Message-ID: <20170508125633.1762-1-jgross@suse.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, Juergen Gross <jgross-IBi9RG/b67k@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

When booted as Xen dom0 there won't be an EFI memmap allocated. Avoid
issuing an error message in this case:

[    0.144079] efi: Failed to allocate new EFI memmap

Signed-off-by: Juergen Gross <jgross-IBi9RG/b67k@public.gmane.org>
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
2.12.0
