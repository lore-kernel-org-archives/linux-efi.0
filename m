From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: sysfs: cannot create duplicate filename
Date: Mon, 18 Mar 2013 14:51:01 +0000
Message-ID: <1363618261.14988.4.camel@mfleming-mobl1.ger.corp.intel.com>
References: <CAHsu+b-cG+ED6TX5evRTBjR-LwHugW+8-9hnHXAz5DnAioJnUQ@mail.gmail.com>
	 <5135BD66.1030005@redhat.com>
	 <1362755479.15011.238.camel@mfleming-mobl1.ger.corp.intel.com>
	 <513A2B29.8090705@redhat.com>
	 <1363082900.15011.257.camel@mfleming-mobl1.ger.corp.intel.com>
	 <513F0734.80600@redhat.com>
	 <1363106125.15011.263.camel@mfleming-mobl1.ger.corp.intel.com>
	 <51405943.2000601@redhat.com>
	 <1363278817.15011.316.camel@mfleming-mobl1.ger.corp.intel.com>
	 <A5ED84D3BB3A384992CBB9C77DEDA4D41AF68807@USINDEM103.corp.hds.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <A5ED84D3BB3A384992CBB9C77DEDA4D41AF68807-ohthHghroY0jroPwUH3sq+6wyyQG6/Uh@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Seiji Aguchi <seiji.aguchi-7rDLJAbr9SE@public.gmane.org>
Cc: Lingzhu Xiang <lxiang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andre Heider <a.heider-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, 2013-03-14 at 19:31 +0000, Seiji Aguchi wrote:
> To fix the broken firmware, users need to erase the duplicated variable.
> Is it correct?

I'm unsure whether that will fix the problem for all platforms. Lingzhu,
do you have any idea?

> If yes, how about printing the duplicated variable name as follows?
> Or add printk() persuade to upgrading/downgrading firmware?
> 
> + printk(KERN_WARNING "efivars: duplicate variable name. %s\n", variable_name);

Yes, I think there's merit to printing that. Unfortunately, it's a utf16
string, and printk() doesn't know how to print it.

> As for update_sysfs_entries() , a candidate fix is introducing a
> global variable like is_firmware_broken.
> And if the variable is set, update_sysfs_entries() returns without
> calling GetNextVariableName().
> As I mentioned above, there is no way to make efivars, including
> efi_pstore, work reliably on the broken firmware..
> 
> I admit that introducing a global variable is messy. But I can't find
> any other way to fix..

Right, looks like this is the only way to go.

How does everyone feel about this version? Lingzhu, if I could get a
Tested-by for this version that would be great. This, plus some other
patches, are sitting on the 'urgent' branch.

---

>From 544a6c06479e4ea4e7acc7eea589a82f0ff9aa6d Mon Sep 17 00:00:00 2001
From: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Date: Thu, 7 Mar 2013 11:59:14 +0000
Subject: [PATCH] efivars: Handle duplicate names from get_next_variable()

Some firmware exhibits a bug where the same VariableName and
VendorGuid values are returned on multiple invocations of
GetNextVariableName(). See,

    https://bugzilla.kernel.org/show_bug.cgi?id=47631

As a consequence of such a bug, Andre reports hitting the following
WARN_ON() in the sysfs code after updating the BIOS on his, "Gigabyte
Technology Co., Ltd. To be filled by O.E.M./Z77X-UD3H, BIOS F19e
11/21/2012)" machine,

[    0.581554] EFI Variables Facility v0.08 2004-May-17
[    0.584914] ------------[ cut here ]------------
[    0.585639] WARNING: at /home/andre/linux/fs/sysfs/dir.c:536 sysfs_add_one+0xd4/0x100()
[    0.586381] Hardware name: To be filled by O.E.M.
[    0.587123] sysfs: cannot create duplicate filename '/firmware/efi/vars/SbAslBufferPtrVar-01f33c25-764d-43ea-aeea-6b5a41f3f3e8'
[    0.588694] Modules linked in:
[    0.589484] Pid: 1, comm: swapper/0 Not tainted 3.8.0+ #7
[    0.590280] Call Trace:
[    0.591066]  [<ffffffff81208954>] ? sysfs_add_one+0xd4/0x100
[    0.591861]  [<ffffffff810587bf>] warn_slowpath_common+0x7f/0xc0
[    0.592650]  [<ffffffff810588bc>] warn_slowpath_fmt+0x4c/0x50
[    0.593429]  [<ffffffff8134dd85>] ? strlcat+0x65/0x80
[    0.594203]  [<ffffffff81208954>] sysfs_add_one+0xd4/0x100
[    0.594979]  [<ffffffff81208b78>] create_dir+0x78/0xd0
[    0.595753]  [<ffffffff81208ec6>] sysfs_create_dir+0x86/0xe0
[    0.596532]  [<ffffffff81347e4c>] kobject_add_internal+0x9c/0x220
[    0.597310]  [<ffffffff81348307>] kobject_init_and_add+0x67/0x90
[    0.598083]  [<ffffffff81584a71>] ? efivar_create_sysfs_entry+0x61/0x1c0
[    0.598859]  [<ffffffff81584b2b>] efivar_create_sysfs_entry+0x11b/0x1c0
[    0.599631]  [<ffffffff8158517e>] register_efivars+0xde/0x420
[    0.600395]  [<ffffffff81d430a7>] ? edd_init+0x2f5/0x2f5
[    0.601150]  [<ffffffff81d4315f>] efivars_init+0xb8/0x104
[    0.601903]  [<ffffffff8100215a>] do_one_initcall+0x12a/0x180
[    0.602659]  [<ffffffff81d05d80>] kernel_init_freeable+0x13e/0x1c6
[    0.603418]  [<ffffffff81d05586>] ? loglevel+0x31/0x31
[    0.604183]  [<ffffffff816a6530>] ? rest_init+0x80/0x80
[    0.604936]  [<ffffffff816a653e>] kernel_init+0xe/0xf0
[    0.605681]  [<ffffffff816ce7ec>] ret_from_fork+0x7c/0xb0
[    0.606414]  [<ffffffff816a6530>] ? rest_init+0x80/0x80
[    0.607143] ---[ end trace 1609741ab737eb29 ]---

There's not much we can do to work around and keep traversing the
variable list once we hit this firmware bug. Our only solution is to
terminate the loop because, as Lingzhu reports, some machines get
stuck when they encounter duplicate names,

  > I had an IBM System x3100 M4 and x3850 X5 on which kernel would
  > get stuck in infinite loop creating duplicate sysfs files because,
  > for some reason, there are several duplicate boot entries in nvram
  > getting GetNextVariableName into a circle of iteration (with
  > period > 2).

Also disable the workqueue, as efivar_update_sysfs_entries() uses
GetNextVariableName() to figure out which variables have been created
since the last iteration. That algorithm isn't going to work if
GetNextVariableName() returns duplicates. Note that we don't disable
EFI variable creation completely on the affected machines, it's just
that any pstore dump-* files won't appear in sysfs until the next
boot.

Reported-by: Andre Heider <a.heider-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Reported-by: Lingzhu Xiang <lxiang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Seiji Aguchi <seiji.aguchi-7rDLJAbr9SE@public.gmane.org>
Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Signed-off-by: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/firmware/efivars.c | 48 +++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 47 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index ae26d5e..a1a3d01 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -170,6 +170,7 @@ efivar_create_sysfs_entry(struct efivars *efivars,
 
 static void efivar_update_sysfs_entries(struct work_struct *);
 static DECLARE_WORK(efivar_work, efivar_update_sysfs_entries);
+static bool efivar_wq_enabled = true;
 
 /* Return the number of unicode characters in data */
 static unsigned long
@@ -1443,7 +1444,7 @@ static int efi_pstore_write(enum pstore_type_id type,
 
 	spin_unlock_irqrestore(&efivars->lock, flags);
 
-	if (reason == KMSG_DUMP_OOPS)
+	if (reason == KMSG_DUMP_OOPS && efivar_wq_enabled)
 		schedule_work(&efivar_work);
 
 	*id = part;
@@ -1974,6 +1975,35 @@ void unregister_efivars(struct efivars *efivars)
 }
 EXPORT_SYMBOL_GPL(unregister_efivars);
 
+/*
+ * Print a warning when duplicate EFI variables are encountered and
+ * disable the sysfs workqueue since the firmware is buggy.
+ */
+static void dup_variable_bug(efi_char16_t *s16, efi_guid_t *vendor_guid,
+			     unsigned long len16)
+{
+	size_t i, len8 = len16 / sizeof(efi_char16_t);
+	char *s8;
+
+	/*
+	 * Disable the workqueue since the algorithm it uses for
+	 * detecting new variables won't work with this buggy
+	 * implementation of GetNextVariableName().
+	 */
+	efivar_wq_enabled = false;
+
+	s8 = kzalloc(len8, GFP_KERNEL);
+	if (!s8)
+		return;
+
+	for (i = 0; i < len8; i++)
+		s8[i] = s16[i];
+
+	printk(KERN_WARNING "efivars: duplicate variable: %s-%pUl\n",
+	       s8, vendor_guid);
+	kfree(s8);
+}
+
 int register_efivars(struct efivars *efivars,
 		     const struct efivar_operations *ops,
 		     struct kobject *parent_kobj)
@@ -2024,6 +2054,22 @@ int register_efivars(struct efivars *efivars,
 		case EFI_SUCCESS:
 			variable_name_size = var_name_strnsize(variable_name,
 							       variable_name_size);
+
+			/*
+			 * Some firmware implementations return the
+			 * same variable name on multiple calls to
+			 * get_next_variable(). Terminate the loop
+			 * immediately as there is no guarantee that
+			 * we'll ever see a different variable name,
+			 * and may end up looping here forever.
+			 */
+			if (variable_is_present(variable_name, &vendor_guid)) {
+				dup_variable_bug(variable_name, &vendor_guid,
+						 variable_name_size);
+				status = EFI_NOT_FOUND;
+				break;
+			}
+
 			efivar_create_sysfs_entry(efivars,
 						  variable_name_size,
 						  variable_name,
-- 
1.7.11.7



-- 
Matt Fleming, Intel Open Source Technology Center
