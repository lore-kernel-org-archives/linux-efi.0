From: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v5 10/14] efi: only print saved efi runtime maps instead of
 all memmap ranges for kexec
Date: Mon,  9 Dec 2013 17:42:23 +0800
Message-ID: <1386582147-9802-11-git-send-email-dyoung@redhat.com>
References: <1386582147-9802-1-git-send-email-dyoung@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kexec-bounces+glkk-kexec=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
In-Reply-To: <1386582147-9802-1-git-send-email-dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
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

changelog:
Matt: use efi_setup instead of esdata
      share function print_efi_memmap for both normal and kexec boot.

Signed-off-by: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 arch/x86/platform/efi/efi.c | 24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 69a6ec2..94a1cbc 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -423,19 +423,16 @@ int __init efi_memblock_x86_reserve_range(void)
 	return 0;
 }
 
-static void __init print_efi_memmap(void)
+static void __init print_efi_memmap(void *map, int nr_map, int md_size)
 {
 #ifdef EFI_DEBUG
 	efi_memory_desc_t *md;
 	void *p;
 	int i;
 
-	for (p = memmap.map, i = 0;
-	     p < memmap.map_end;
-	     p += memmap.desc_size, i++) {
+	for (p = map, i = 0; i < nr_map; p += md_size, i++) {
 		md = p;
-		pr_info("mem%02u: type=%u, attr=0x%llx, "
-			"range=[0x%016llx-0x%016llx) (%lluMB)\n",
+		pr_info("mem%02u: type=%u, attr=0x%llx, range=[0x%016llx-0x%016llx) (%lluMB)\n",
 			i, md->type, md->attribute, md->phys_addr,
 			md->phys_addr + (md->num_pages << EFI_PAGE_SHIFT),
 			(md->num_pages >> (20 - EFI_PAGE_SHIFT)));
@@ -797,7 +794,20 @@ void __init efi_init(void)
 		x86_platform.set_wallclock = efi_set_rtc_mmss;
 	}
 #endif
-	print_efi_memmap();
+	if (efi_setup) {
+		int s;
+		struct efi_setup_data *data;
+
+		s = sizeof(*data) + nr_efi_runtime_map * sizeof(data->map[0]);
+		data = early_memremap(efi_setup, s);
+		if (!data)
+			return;
+		print_efi_memmap(data->map, nr_efi_runtime_map,
+				 sizeof(data->map[0]));
+		early_memunmap(data, s);
+	} else {
+		print_efi_memmap(memmap.map, memmap.nr_map, memmap.desc_size);
+	}
 }
 
 void __init efi_late_init(void)
-- 
1.8.3.1
