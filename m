From: Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>
Subject: [PATCH v5 31/32] x86: Add sysfs support for Secure Memory Encryption
Date: Tue, 18 Apr 2017 16:22:12 -0500
Message-ID: <20170418212212.10190.73484.stgit@tlendack-t1.amdoffice.net>
References: <20170418211612.10190.82788.stgit@tlendack-t1.amdoffice.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <20170418211612.10190.82788.stgit-qCXWGYdRb2BnqfbPTmsdiZQ+2ll4COg0XqFh9Ls21Oc@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kasan-dev-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Brijesh Singh <brijesh.singh-5C7GfCeVMHo@public.gmane.org>, Toshimitsu Kani <toshi.kani-ZPxbGqLxI0U@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Radim =?utf-8?b?S3LEjW3DocWZ?= <rkrcmar-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrey Ryabinin <aryabinin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "H. Peter
	Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alexander Potapenko <glider-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Larry Woodman <lwoodman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Add sysfs support for SME so that user-space utilities (kdump, etc.) can
determine if SME is active.

A new directory will be created:
  /sys/kernel/mm/sme/

And two entries within the new directory:
  /sys/kernel/mm/sme/active
  /sys/kernel/mm/sme/encryption_mask

Signed-off-by: Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>
---
 arch/x86/mm/mem_encrypt.c |   49 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 49 insertions(+)

diff --git a/arch/x86/mm/mem_encrypt.c b/arch/x86/mm/mem_encrypt.c
index 0ff41a4..7dc4e98 100644
--- a/arch/x86/mm/mem_encrypt.c
+++ b/arch/x86/mm/mem_encrypt.c
@@ -18,6 +18,8 @@
 #include <linux/mm.h>
 #include <linux/dma-mapping.h>
 #include <linux/swiotlb.h>
+#include <linux/kobject.h>
+#include <linux/sysfs.h>
 
 #include <asm/tlbflush.h>
 #include <asm/fixmap.h>
@@ -25,6 +27,7 @@
 #include <asm/bootparam.h>
 #include <asm/cacheflush.h>
 #include <asm/sections.h>
+#include <asm/mem_encrypt.h>
 
 /*
  * Since SME related variables are set early in the boot process they must
@@ -38,6 +41,52 @@
 static char sme_early_buffer[PAGE_SIZE] __aligned(PAGE_SIZE);
 
 /*
+ * Sysfs support for SME.
+ *   Create an sme directory under /sys/kernel/mm
+ *   Create two sme entries under /sys/kernel/mm/sme:
+ *     active - returns 0 if not active, 1 if active
+ *     encryption_mask - returns the encryption mask in use
+ */
+static ssize_t active_show(struct kobject *kobj, struct kobj_attribute *attr,
+			   char *buf)
+{
+	return sprintf(buf, "%u\n", sme_active());
+}
+static struct kobj_attribute active_attr = __ATTR_RO(active);
+
+static ssize_t encryption_mask_show(struct kobject *kobj,
+				    struct kobj_attribute *attr, char *buf)
+{
+	return sprintf(buf, "0x%016lx\n", sme_me_mask);
+}
+static struct kobj_attribute encryption_mask_attr = __ATTR_RO(encryption_mask);
+
+static struct attribute *sme_attrs[] = {
+	&active_attr.attr,
+	&encryption_mask_attr.attr,
+	NULL
+};
+
+static struct attribute_group sme_attr_group = {
+	.attrs = sme_attrs,
+	.name = "sme",
+};
+
+static int __init sme_sysfs_init(void)
+{
+	int ret;
+
+	ret = sysfs_create_group(mm_kobj, &sme_attr_group);
+	if (ret) {
+		pr_err("SME sysfs initialization failed\n");
+		return ret;
+	}
+
+	return 0;
+}
+subsys_initcall(sme_sysfs_init);
+
+/*
  * This routine does not change the underlying encryption setting of the
  * page(s) that map this memory. It assumes that eventually the memory is
  * meant to be accessed as either encrypted or decrypted but the contents
