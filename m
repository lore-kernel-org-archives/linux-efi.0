From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH 15/15] kexec: Support kexec/kdump on EFI systems
Date: Tue, 1 Jul 2014 13:14:19 -0700
Message-ID: <20140701131419.454a3fc32fcc84a43b668c50@linux-foundation.org>
References: <1403814824-7587-1-git-send-email-vgoyal@redhat.com>
	<1403814824-7587-16-git-send-email-vgoyal@redhat.com>
	<20140701194605.GJ7539@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140701194605.GJ7539-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org, greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, chaowang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Tue, 1 Jul 2014 20:46:05 +0100 Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org> wrote:

> > +int get_efi_runtime_map_size(void)
> > +{
> > +	return nr_efi_runtime_map * efi_memdesc_size;
> > +}
> > +
> > +int get_efi_runtime_map_desc_size(void)
> > +{
> > +	return efi_memdesc_size;
> > +}
> > +
> > +int efi_runtime_map_copy(void *buf, size_t bufsz)
> > +{
> > +	size_t sz = get_efi_runtime_map_size();
> > +
> > +	if (sz > bufsz)
> > +		sz = bufsz;
> > +
> > +	memcpy(buf, efi_runtime_map, sz);
> > +	return 0;
> > +}
> 
> Could we prefix these with efi_, e.g. efi_get_runtime_map_size() ?

This?

From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: kexec-support-kexec-kdump-on-efi-systems-fix

s/get_efi/efi_get/g, per Matt

Cc: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Signed-off-by: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
---

 arch/x86/kernel/kexec-bzimage64.c  |    4 ++--
 drivers/firmware/efi/runtime-map.c |    6 +++---
 include/linux/efi.h                |    8 ++++----
 3 files changed, 9 insertions(+), 9 deletions(-)

diff -puN arch/x86/kernel/kexec-bzimage64.c~kexec-support-kexec-kdump-on-efi-systems-fix arch/x86/kernel/kexec-bzimage64.c
--- a/arch/x86/kernel/kexec-bzimage64.c~kexec-support-kexec-kdump-on-efi-systems-fix
+++ a/arch/x86/kernel/kexec-bzimage64.c
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
diff -puN drivers/firmware/efi/runtime-map.c~kexec-support-kexec-kdump-on-efi-systems-fix drivers/firmware/efi/runtime-map.c
--- a/drivers/firmware/efi/runtime-map.c~kexec-support-kexec-kdump-on-efi-systems-fix
+++ a/drivers/firmware/efi/runtime-map.c
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
diff -puN include/linux/efi.h~kexec-support-kexec-kdump-on-efi-systems-fix include/linux/efi.h
--- a/include/linux/efi.h~kexec-support-kexec-kdump-on-efi-systems-fix
+++ a/include/linux/efi.h
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
@@ -1163,12 +1163,12 @@ static inline int efi_runtime_map_init(s
 static inline void
 efi_runtime_map_setup(void *map, int nr_entries, u32 desc_size) {}
 
-static inline int get_efi_runtime_map_size(void)
+static inline int efi_get_runtime_map_size(void)
 {
 	return 0;
 }
 
-static inline int get_efi_runtime_map_desc_size(void)
+static inline int efi_get_runtime_map_desc_size(void)
 {
 	return 0;
 }
_
