From: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v4 08/12] efi: only print saved efi runtime maps instead of
 all memmap ranges for kexec
Date: Tue, 26 Nov 2013 13:57:53 +0800
Message-ID: <1385445477-9665-9-git-send-email-dyoung@redhat.com>
References: <1385445477-9665-1-git-send-email-dyoung@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kexec-bounces+glkk-kexec=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
In-Reply-To: <1385445477-9665-1-git-send-email-dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/kexec>,
 <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/kexec/>
List-Post: <mailto:kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Help: <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/kexec>,
 <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=subscribe>
Sender: "kexec" <kexec-bounces-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Errors-To: kexec-bounces+glkk-kexec=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, toshi.kani-VXdhtT5mjnY@public.gmane.org, matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org, greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, horms-/R6kz+dDXgpPR4JQBCEnsQ@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

For kexec/kdump kernel efi runtime mappings are saved, printing original whole
memmap ranges does not make sense anymore. So introduce a new function to only
print runtime maps in case kexec/kdump kernel is used.

Signed-off-by: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 arch/x86/platform/efi/efi.c | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index fafeb40..c65b0b8 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -430,6 +430,24 @@ int __init efi_memblock_x86_reserve_range(void)
 	return 0;
 }
 
+/* for kexec kernel runtime maps are passed in setup_data */
+static void __init print_saved_runtime_map(void)
+{
+#ifdef EFI_DEBUG
+	int i;
+	efi_memory_desc_t *md;
+
+	for (i = 0; i < nr_efi_runtime_map; i++) {
+		md = esdata->map + i;
+		pr_info("mem%02u: type=%u, attr=0x%llx, "
+			"range=[0x%016llx-0x%016llx) (%lluMB)\n",
+			i, md->type, md->attribute, md->phys_addr,
+			md->phys_addr + (md->num_pages << EFI_PAGE_SHIFT),
+			(md->num_pages >> (20 - EFI_PAGE_SHIFT)));
+	}
+#endif  /*  EFI_DEBUG  */
+}
+
 static void __init print_efi_memmap(void)
 {
 #ifdef EFI_DEBUG
@@ -782,7 +800,10 @@ void __init efi_init(void)
 		x86_platform.set_wallclock = efi_set_rtc_mmss;
 	}
 #endif
-	print_efi_memmap();
+	if (esdata)
+		print_saved_runtime_map();
+	else
+		print_efi_memmap();
 }
 
 void __init efi_late_init(void)
-- 
1.8.3.1
