From: Daniel Kiper <daniel.kiper-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v3 2/5] efi: Export arch_tables variable
Date: Tue, 25 Mar 2014 21:57:53 +0100
Message-ID: <1395781076-12000-3-git-send-email-daniel.kiper@oracle.com>
References: <1395781076-12000-1-git-send-email-daniel.kiper@oracle.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1395781076-12000-1-git-send-email-daniel.kiper-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ia64-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, xen-devel-GuqFBffKawtpuQazS67q72D2FQJk+8+b@public.gmane.org
Cc: boris.ostrovsky-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, david.vrabel-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, eshelton-e+AXbWqSrlAAvxtiuMwx3w@public.gmane.org, fenghua.yu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, ian.campbell-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, jbeulich-IBi9RG/b67k@public.gmane.org, jeremy-TSDbQ3PG+2Y@public.gmane.org, konrad.wilk-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, stefano.stabellini-mvvWK6WmYclDPfheJLI6IQ@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Daniel Kiper <daniel.kiper-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Export arch_tables variable. Xen init function calls efi_config_init()
which takes it as an argument.

Additionally, put __initdata in place suggested by include/linux/init.h.

Signed-off-by: Daniel Kiper <daniel.kiper-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 arch/x86/platform/efi/efi.c |    2 +-
 include/linux/efi.h         |    2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index e4af217..26651c6 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -70,7 +70,7 @@ static efi_system_table_t efi_systab __initdata;
 
 unsigned long x86_efi_facility;
 
-static __initdata efi_config_table_type_t arch_tables[] = {
+efi_config_table_type_t arch_tables[] __initdata = {
 #ifdef CONFIG_X86_UV
 	{UV_SYSTEM_TABLE_GUID, "UVsystab", &efi.uv_systab},
 #endif
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 67ba1a0..f00ef14 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -583,6 +583,8 @@ extern struct efi {
 	struct efi_memory_map *memmap;
 } efi;
 
+extern efi_config_table_type_t arch_tables[] __initdata;
+
 static inline int
 efi_guidcmp (efi_guid_t left, efi_guid_t right)
 {
-- 
1.7.10.4
