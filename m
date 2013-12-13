From: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v5 08/14] efi: export efi runtime memory mapping to sysfs
Date: Fri, 13 Dec 2013 15:26:00 +0800
Message-ID: <20131213072600.GB11164@dhcp-16-126.nay.redhat.com>
References: <1386582147-9802-1-git-send-email-dyoung@redhat.com>
 <1386582147-9802-9-git-send-email-dyoung@redhat.com>
 <20131211185520.GG23793@pd.tnic>
 <20131212023617.GF3751@dhcp-16-126.nay.redhat.com>
 <20131212205346.GA30162@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kexec-bounces+glkk-kexec=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20131212205346.GA30162-fF5Pk5pvG8Y@public.gmane.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/kexec>,
 <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/kexec/>
List-Post: <mailto:kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Help: <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/kexec>,
 <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=subscribe>
Sender: "kexec" <kexec-bounces-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Errors-To: kexec-bounces+glkk-kexec=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
To: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, toshi.kani-VXdhtT5mjnY@public.gmane.org, matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org, greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, horms-/R6kz+dDXgpPR4JQBCEnsQ@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 12/12/13 at 09:53pm, Borislav Petkov wrote:
> On Thu, Dec 12, 2013 at 10:36:17AM +0800, Dave Young wrote:
> > Sorry that I forgot to explain this in changelog, should ask you before.
> > 
> > I did try moving it to efisubsys_init but it need add extern declaration
> 
> So what? Add it.
> 
> > for efi_runtime_map_init. Since link order will ensure it being called after
> > efisubsys_init I think it's fine with this static function.
> 
> This is actually exactly the reason why it shouldn't be another
> subsys_initcall() if it can be helped. People would need to go have a
> look at drivers/firmware/efi/Makefile to realize that the link order is
> ok.
> 
> And, this is prone to future breakage if people go and move code around
> and thereby change the link order.
> 
> Please call efi_runtime_map_init from efisubsys_init.

After moving to efisubsys_init, the code will looks like below, because
the funtion only is used in drivers/firmware/efi/efi.c thus I can not
add a blank function in #else section in the efi.h header file. Creating
another header file for this one function looks bad to me.

Is below changes fine to you? I can add it to next version if you like it.

diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index 9fbaeb2..2db7ea5 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -133,6 +133,10 @@ extern void efi_sync_low_kernel_mappings(void);
 extern void efi_setup_page_tables(void);
 extern void __init old_map_region(efi_memory_desc_t *md);
 
+#ifdef CONFIG_EFI_RUNTIME_MAP
+extern int __init efi_runtime_map_init(void);
+#endif
+
 #ifdef CONFIG_EFI
 
 static inline bool efi_is_native(void)
diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index afd0b49..85fd904 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -168,6 +168,12 @@ static int __init efisubsys_init(void)
 		goto err_unregister;
 	}
 
+#ifdef CONFIG_EFI_RUNTIME_MAP
+	error = efi_runtime_map_init();
+	if (error)
+		goto err_remove_group;
+#endif
+
 	/* and the standard mountpoint for efivarfs */
 	efivars_kobj = kobject_create_and_add("efivars", efi_kobj);
 	if (!efivars_kobj) {
diff --git a/drivers/firmware/efi/runtime-map.c b/drivers/firmware/efi/runtime-map.c
index e5e9984..5af06ad 100644
--- a/drivers/firmware/efi/runtime-map.c
+++ b/drivers/firmware/efi/runtime-map.c
@@ -135,7 +135,7 @@ static struct efi_runtime_map_entry *add_sysfs_runtime_map_entry(int nr)
 	return entry;
 }
 
-static int __init efi_runtime_map_init(void)
+int __init efi_runtime_map_init(void)
 {
 	int i, j, ret = 0;
 	struct efi_runtime_map_entry *entry;
@@ -172,5 +172,3 @@ out_add_entry:
 out:
 	return ret;
 }
-
-subsys_initcall(efi_runtime_map_init);

--
Thanks
Dave
