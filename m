From: dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Subject: [patch 4/7 v2] export more efi table variable to sysfs
Date: Tue, 05 Nov 2013 16:20:11 +0800
Message-ID: <20131105082717.561020034@dhcp-16-126.nay.redhat.com>
References: <20131105082007.872550445@dhcp-16-126.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kexec-bounces+glkk-kexec=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Content-Disposition: inline; filename=04-export-more-efi-sysfs-vars.patch
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
Cc: mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, horms-/R6kz+dDXgpPR4JQBCEnsQ@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Export fw_vendor, runtime and config tables physical
addresses to /sys/firmware/efi/systab becaue kexec
kernel will need them.

>From EFI spec these 3 variables will be updated to
virtual address after entering virtual mode. But
kernel startup code will need the physical address.

Signed-off-by: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 arch/x86/platform/efi/efi.c |    4 ++++
 drivers/firmware/efi/efi.c  |    9 +++++++++
 include/linux/efi.h         |    3 +++
 3 files changed, 16 insertions(+)

--- linux-2.6.orig/drivers/firmware/efi/efi.c
+++ linux-2.6/drivers/firmware/efi/efi.c
@@ -32,6 +32,9 @@ struct efi __read_mostly efi = {
 	.hcdp       = EFI_INVALID_TABLE_ADDR,
 	.uga        = EFI_INVALID_TABLE_ADDR,
 	.uv_systab  = EFI_INVALID_TABLE_ADDR,
+	.fw_vendor  = EFI_INVALID_TABLE_ADDR,
+	.runtime    = EFI_INVALID_TABLE_ADDR,
+	.config_tables  = EFI_INVALID_TABLE_ADDR,
 };
 EXPORT_SYMBOL(efi);
 
@@ -64,6 +67,12 @@ static ssize_t systab_show(struct kobjec
 		str += sprintf(str, "BOOTINFO=0x%lx\n", efi.boot_info);
 	if (efi.uga != EFI_INVALID_TABLE_ADDR)
 		str += sprintf(str, "UGA=0x%lx\n", efi.uga);
+	if (efi.fw_vendor != EFI_INVALID_TABLE_ADDR)
+		str += sprintf(str, "fw_vendor=0x%lx\n", efi.fw_vendor);
+	if (efi.runtime != EFI_INVALID_TABLE_ADDR)
+		str += sprintf(str, "runtime=0x%lx\n", efi.runtime);
+	if (efi.config_tables != EFI_INVALID_TABLE_ADDR)
+		str += sprintf(str, "config_tables=0x%lx\n", efi.config_tables);
 
 	return str - buf;
 }
--- linux-2.6.orig/include/linux/efi.h
+++ linux-2.6/include/linux/efi.h
@@ -556,6 +556,9 @@ extern struct efi {
 	unsigned long hcdp;		/* HCDP table */
 	unsigned long uga;		/* UGA table */
 	unsigned long uv_systab;	/* UV system table */
+	unsigned long fw_vendor;
+	unsigned long runtime;
+	unsigned long config_tables;
 	efi_get_time_t *get_time;
 	efi_set_time_t *set_time;
 	efi_get_wakeup_time_t *get_wakeup_time;
--- linux-2.6.orig/arch/x86/platform/efi/efi.c
+++ linux-2.6/arch/x86/platform/efi/efi.c
@@ -653,6 +653,10 @@ void __init efi_init(void)
 
 	set_bit(EFI_SYSTEM_TABLES, &x86_efi_facility);
 
+	efi.fw_vendor = (unsigned long)efi.systab->fw_vendor;
+	efi.runtime = (unsigned long)efi.systab->runtime;
+	efi.config_tables = (unsigned long)efi.systab->tables;
+
 	/*
 	 * Show what we know for posterity
 	 */
