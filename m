From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: sysfs: cannot create duplicate filename
Date: Fri, 08 Mar 2013 15:11:19 +0000
Message-ID: <1362755479.15011.238.camel@mfleming-mobl1.ger.corp.intel.com>
References: <CAHsu+b-cG+ED6TX5evRTBjR-LwHugW+8-9hnHXAz5DnAioJnUQ@mail.gmail.com>
	 <5135BD66.1030005@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5135BD66.1030005-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lingzhu Xiang <lxiang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Andre Heider <a.heider-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Tue, 2013-03-05 at 17:39 +0800, Lingzhu Xiang wrote:
> On 03/03/2013 02:03 AM, Andre Heider wrote:
> > After a BIOS update I get this in dmesg:
> > 
> > [    0.581554] EFI Variables Facility v0.08 2004-May-17
> > [    0.584914] ------------[ cut here ]------------
> > [    0.585639] WARNING: at /home/andre/linux/fs/sysfs/dir.c:536 sysfs_add_one+0x
> > d4/0x100()
> > [    0.586381] Hardware name: To be filled by O.E.M.
> > [    0.587123] sysfs: cannot create duplicate filename '/firmware/efi/vars/SbAsl
> > BufferPtrVar-01f33c25-764d-43ea-aeea-6b5a41f3f3e8'
> > (snip)
> > 
> > Sounds like yet another BIOS issue, and I guess the answer is
> > "complain to the manufacturer"... But we know how well that works, so
> > can this be a warning instead of a scary backtrace? :)
> > 
> > (this is: Gigabyte Technology Co., Ltd. To be filled by
> > O.E.M./Z77X-UD3H, BIOS F19e 11/21/2012)"
> 
> Just saw https://bugzilla.kernel.org/show_bug.cgi?id=47631
> 
> I think this problem is getting more and more common.
> 
> I had an IBM System x3100 M4 and x3850 X5 on which kernel would get stuck
> in infinite loop creating duplicate sysfs files because, for some reason,
> there are several duplicate boot entries in nvram getting GetNextVariableName
> into a circle of iteration (with period > 2).
> 
> Granted, it's not kernel's fault for duplicate variables, but it'd be much
> harder for users to fix their broken firmware than kernel dealing with it
> by not dying on the never-ending GetNextVariableName.

Guys, could you test the following patch?

---

>From bb94d021f900a990def5891a7cb480cc6d3e5247 Mon Sep 17 00:00:00 2001
From: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Date: Thu, 7 Mar 2013 11:59:14 +0000
Subject: [PATCH] efivars: Handle duplicate names from get_next_variable()

Some firmware exhibits a bug where the same VariableName and
VendorGuid values are returned on consecutive invocations of
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

Reported-by: Andre Heider <a.heider-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Reported-by: Lingzhu Xiang <lxiang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Signed-off-by: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/firmware/efivars.c | 29 ++++++++++++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index bea32d1..ea415df 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -1962,8 +1962,9 @@ int register_efivars(struct efivars *efivars,
 		     struct kobject *parent_kobj)
 {
 	efi_status_t status = EFI_NOT_FOUND;
-	efi_guid_t vendor_guid;
+	efi_guid_t vendor_guid, prev_guid;
 	efi_char16_t *variable_name;
+	efi_char16_t *prev_name = NULL;
 	unsigned long variable_name_size = 1024;
 	int error = 0;
 
@@ -1973,6 +1974,13 @@ int register_efivars(struct efivars *efivars,
 		return -ENOMEM;
 	}
 
+	prev_name = kzalloc(variable_name_size, GFP_KERNEL);
+	if (!prev_name) {
+		printk(KERN_ERR "efivars: Memory allocation failed.\n");
+		error = -ENOMEM;
+		goto out;
+	}
+
 	spin_lock_init(&efivars->lock);
 	INIT_LIST_HEAD(&efivars->list);
 	efivars->ops = ops;
@@ -2005,6 +2013,21 @@ int register_efivars(struct efivars *efivars,
 						&vendor_guid);
 		switch (status) {
 		case EFI_SUCCESS:
+			/*
+			 * Some firmware implementations return the
+			 * same variable name on consecutive calls to
+			 * get_next_variable(). Terminate the loop
+			 * immediately as there is no guarantee that
+			 * we'll ever see a different variable name,
+			 * and may end up looping here forever.
+			 */
+			if (!efi_guidcmp(prev_guid, vendor_guid) &&
+			     !memcmp(prev_name, variable_name, variable_name_size)) {
+				printk(KERN_WARNING "efivars: duplicate variable name.\n");
+				status = EFI_NOT_FOUND;
+				break;
+			}
+
 			efivar_create_sysfs_entry(efivars,
 						  variable_name_size,
 						  variable_name,
@@ -2018,6 +2041,9 @@ int register_efivars(struct efivars *efivars,
 			status = EFI_NOT_FOUND;
 			break;
 		}
+
+		memcpy(prev_name, variable_name, variable_name_size);
+		memcpy(&prev_guid, &vendor_guid, sizeof(efi_guid_t));
 	} while (status != EFI_NOT_FOUND);
 
 	error = create_efivars_bin_attributes(efivars);
@@ -2037,6 +2063,7 @@ int register_efivars(struct efivars *efivars,
 	register_filesystem(&efivarfs_type);
 
 out:
+	kfree(prev_name);
 	kfree(variable_name);
 
 	return error;
-- 
1.7.11.7
