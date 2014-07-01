From: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 17/15] kexec-bzimage: Change EFI helper function names
Date: Tue, 1 Jul 2014 16:09:47 -0400
Message-ID: <20140701200947.GA19352@redhat.com>
References: <1403814824-7587-1-git-send-email-vgoyal@redhat.com>
 <1403814824-7587-16-git-send-email-vgoyal@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1403814824-7587-16-git-send-email-vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
Cc: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org, greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, chaowang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Matt suggested to change helper function names newly introduced functions
and prefix these with efi_.

Signed-off-by: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
CC: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
CC: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
 arch/x86/kernel/kexec-bzimage64.c  |    4 ++--
 drivers/firmware/efi/runtime-map.c |    6 +++---
 include/linux/efi.h                |    4 ++--
 3 files changed, 7 insertions(+), 7 deletions(-)

Index: linux-2.6/include/linux/efi.h
===================================================================
--- linux-2.6.orig/include/linux/efi.h	2014-07-01 14:05:54.197071710 -0400
+++ linux-2.6/include/linux/efi.h	2014-07-01 15:54:21.019754754 -0400
@@ -1151,8 +1151,8 @@ int efivars_sysfs_init(void);
 #ifdef CONFIG_EFI_RUNTIME_MAP
 int efi_runtime_map_init(struct kobject *);
 void efi_runtime_map_setup(void *, int, u32);
-int get_efi_runtime_map_size(void);
-int get_efi_runtime_map_desc_size(void);
+int efi_get_runtime_map_size(void);
+int efi_get_runtime_map_desc_size(void);
 int efi_runtime_map_copy(void *buf, size_t bufsz);
 #else
 static inline int efi_runtime_map_init(struct kobject *kobj)
Index: linux-2.6/drivers/firmware/efi/runtime-map.c
===================================================================
--- linux-2.6.orig/drivers/firmware/efi/runtime-map.c	2014-07-01 14:05:54.196071711 -0400
+++ linux-2.6/drivers/firmware/efi/runtime-map.c	2014-07-01 15:55:47.990759859 -0400
@@ -138,19 +138,19 @@ add_sysfs_runtime_map_entry(struct kobje
 	return entry;
 }
 
-int get_efi_runtime_map_size(void)
+int efi_get_runtime_map_size(void)
 {
 	return nr_efi_runtime_map * efi_memdesc_size;
 }
 
-int get_efi_runtime_map_desc_size(void)
+int efi_get_runtime_map_desc_size(void)
 {
 	return efi_memdesc_size;
 }
 
 int efi_runtime_map_copy(void *buf, size_t bufsz)
 {
-	size_t sz = get_efi_runtime_map_size();
+	size_t sz = efi_get_runtime_map_size();
 
 	if (sz > bufsz)
 		sz = bufsz;
Index: linux-2.6/arch/x86/kernel/kexec-bzimage64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/kexec-bzimage64.c	2014-07-01 15:52:22.285747785 -0400
+++ linux-2.6/arch/x86/kernel/kexec-bzimage64.c	2014-07-01 15:56:31.071762387 -0400
@@ -181,7 +181,7 @@ setup_efi_state(struct boot_params *para
 	ei->efi_systab_hi = current_ei->efi_systab_hi;
 
 	ei->efi_memdesc_version = current_ei->efi_memdesc_version;
-	ei->efi_memdesc_size = get_efi_runtime_map_desc_size();
+	ei->efi_memdesc_size = efi_get_runtime_map_desc_size();
 
 	setup_efi_info_memmap(params, params_load_addr, efi_map_offset,
 			      efi_map_sz);
@@ -397,7 +397,7 @@ void *bzImage64_load(struct kimage *imag
 	 * have to create separate segment for each. Keeps things
 	 * little bit simple
 	 */
-	efi_map_sz = get_efi_runtime_map_size();
+	efi_map_sz = efi_get_runtime_map_size();
 	efi_map_sz = ALIGN(efi_map_sz, 16);
 	params_cmdline_sz = sizeof(struct boot_params) + cmdline_len +
 				MAX_ELFCOREHDR_STR_LEN;
