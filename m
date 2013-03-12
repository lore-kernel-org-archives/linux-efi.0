From: Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: Re: [PATCH] efivars: Allow disabling use as a pstore backend
Date: Tue, 12 Mar 2013 16:14:17 -0500
Message-ID: <20130312211417.GC16558@thinkpad-t410>
References: <1362678017-2862-1-git-send-email-seth.forshee@canonical.com>
 <5138FAD9.7050504@zytor.com>
 <20130307205915.GF24233@thinkpad-t410>
 <1362694529.15011.211.camel@mfleming-mobl1.ger.corp.intel.com>
 <513911F9.8050308@zytor.com>
 <20130311211750.GB8440@thinkpad-t410>
 <1363118073.15011.275.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1363118073.15011.275.camel-ZqTwcBeJ+wsBof6jY8KHXm7IUlhRatedral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Tue, Mar 12, 2013 at 07:54:33PM +0000, Matt Fleming wrote:
> On Mon, 2013-03-11 at 16:17 -0500, Seth Forshee wrote:
> > Here's a patch that does the command line option. I'm happy with either
> > one.
> 
> I like the idea, but isn't the logic backwards? I would have expected
> s/EFI_VARS_PSTORE_DEFAULT_DISABLE/EFI_VARS_PSTORE/g and then 'default y'
> in the Kconfig file to maintain backward compatibility?
> 
> Is there a reason that wouldn't work?

It should work, just a change of perspective I guess. When the feature
is enabled by default a foo_disable parameter feels more natural to me
than foo_enable, but it's just semantics. I've switched it to your
suggestion in the patch below. I must admit that the name of the config
option is much better this way.

> I know that Linus has previously denounced setting new Kconfig symbols
> to 'y' by default, but I think there's a case here for doing exactly
> that since the previous behaviour was always enabled. The networking
> folks did something similar recently, where they introduced new Kconfig
> symbols for existing functionality that was previously on by default.
> 
> [...]
> 
> > +#ifdef CONFIG_EFI_VARS_PSTORE_DEFAULT_DISABLE
> > +static bool efivars_pstore_disable = true;
> > +#else
> > +static bool efivars_pstore_disable = false;
> > +#endif
> > +module_param_named(pstore_disable, efivars_pstore_disable, bool, 0644);
> > +
> 
> static bool efivars_pstore_enable = IS_ENABLED(CONFIG_EFI_VARS_PSTORE) ?

Yes, that's much nicer.


>From 91df4dd0d1e20f44ea16b3653cffecd507fdb500 Mon Sep 17 00:00:00 2001
From: Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Date: Wed, 6 Mar 2013 14:25:36 -0600
Subject: [PATCH] efivars: Add module parameter to allow disabling use as a
 pstore backend

We know that with some firmware implementations writing too much data to
UEFI variables can lead to bricking machines. Recent changes attempt to
address this issue, but for some it may still be prudent to avoid
writing large amounts of data until the solution has been proven on a
wide variety of hardware.

Crash dumps or other data from pstore can potentially be a large data
source. Add a pstore_enable parameter to efivars to allow disabling its
use as a backend for pstore. Also add a config option,
CONFIG_EFI_VARS_PSTORE, which will specify the default value for this
parameter. Default this option to Y to maintain the existing behavior.

Signed-off-by: Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
---
 drivers/firmware/Kconfig   |    9 ++++++
 drivers/firmware/efivars.c |   66 +++++++++++++++-----------------------------
 2 files changed, 32 insertions(+), 43 deletions(-)

diff --git a/drivers/firmware/Kconfig b/drivers/firmware/Kconfig
index 9b00072..35f7d16 100644
--- a/drivers/firmware/Kconfig
+++ b/drivers/firmware/Kconfig
@@ -53,6 +53,15 @@ config EFI_VARS
 	  Subsequent efibootmgr releases may be found at:
 	  <http://linux.dell.com/efibootmgr>
 
+config EFI_VARS_PSTORE
+	bool "Use efivars as a pstore backend"
+	depends on EFI_VARS
+	default y
+	help
+	  Say Y here to enable the use of efivars as a storage backend
+	  for pstore. This setting can be overridden using the
+	  efivars.pstore_enable parameter.
+
 config EFI_PCDP
 	bool "Console device selection via EFI PCDP or HCDP table"
 	depends on ACPI && EFI && IA64
diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index fe62aa3..1e5d326 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -103,6 +103,9 @@ MODULE_VERSION(EFIVARS_VERSION);
  */
 #define GUID_LEN 36
 
+static bool efivars_pstore_enable = IS_ENABLED(CONFIG_EFI_VARS_PSTORE);
+module_param_named(pstore_enable, efivars_pstore_enable, bool, 0644);
+
 /*
  * The maximum size of VariableName + Data = 1024
  * Therefore, it's reasonable to save that much
@@ -1309,8 +1312,6 @@ static const struct inode_operations efivarfs_dir_inode_operations = {
 	.create = efivarfs_create,
 };
 
-static struct pstore_info efi_pstore_info;
-
 #ifdef CONFIG_PSTORE
 
 static int efi_pstore_open(struct pstore_info *psi)
@@ -1514,38 +1515,6 @@ static int efi_pstore_erase(enum pstore_type_id type, u64 id, int count,
 
 	return 0;
 }
-#else
-static int efi_pstore_open(struct pstore_info *psi)
-{
-	return 0;
-}
-
-static int efi_pstore_close(struct pstore_info *psi)
-{
-	return 0;
-}
-
-static ssize_t efi_pstore_read(u64 *id, enum pstore_type_id *type, int *count,
-			       struct timespec *timespec,
-			       char **buf, struct pstore_info *psi)
-{
-	return -1;
-}
-
-static int efi_pstore_write(enum pstore_type_id type,
-		enum kmsg_dump_reason reason, u64 *id,
-		unsigned int part, int count, size_t size,
-		struct pstore_info *psi)
-{
-	return 0;
-}
-
-static int efi_pstore_erase(enum pstore_type_id type, u64 id, int count,
-			    struct timespec time, struct pstore_info *psi)
-{
-	return 0;
-}
-#endif
 
 static struct pstore_info efi_pstore_info = {
 	.owner		= THIS_MODULE,
@@ -1557,6 +1526,24 @@ static struct pstore_info efi_pstore_info = {
 	.erase		= efi_pstore_erase,
 };
 
+static void efivar_pstore_register(struct efivars *efivars)
+{
+	efivars->efi_pstore_info = efi_pstore_info;
+	efivars->efi_pstore_info.buf = kmalloc(4096, GFP_KERNEL);
+	if (efivars->efi_pstore_info.buf) {
+		efivars->efi_pstore_info.bufsize = 1024;
+		efivars->efi_pstore_info.data = efivars;
+		spin_lock_init(&efivars->efi_pstore_info.buf_lock);
+		pstore_register(&efivars->efi_pstore_info);
+	}
+}
+#else
+static void efivar_pstore_register(struct efivars *efivars)
+{
+	return;
+}
+#endif
+
 static ssize_t efivar_create(struct file *filp, struct kobject *kobj,
 			     struct bin_attribute *bin_attr,
 			     char *buf, loff_t pos, size_t count)
@@ -2025,15 +2012,8 @@ int register_efivars(struct efivars *efivars,
 	if (error)
 		unregister_efivars(efivars);
 
-	efivars->efi_pstore_info = efi_pstore_info;
-
-	efivars->efi_pstore_info.buf = kmalloc(4096, GFP_KERNEL);
-	if (efivars->efi_pstore_info.buf) {
-		efivars->efi_pstore_info.bufsize = 1024;
-		efivars->efi_pstore_info.data = efivars;
-		spin_lock_init(&efivars->efi_pstore_info.buf_lock);
-		pstore_register(&efivars->efi_pstore_info);
-	}
+	if (efivars_pstore_enable)
+		efivar_pstore_register(efivars);
 
 	register_filesystem(&efivarfs_type);
 
-- 
1.7.9.5
