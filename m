From: Anton Vorontsov <anton.vorontsov-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: EFI pstore: BUG: scheduling while atomic, and possible circular
 locking dependency
Date: Wed, 21 Nov 2012 20:12:40 -0800
Message-ID: <20121122041239.GA24623@lizard.sbx14280.paloaca.wayport.net>
References: <50AD94A4.4030100@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <50AD94A4.4030100-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lingzhu Xiang <lxiang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, Nov 22, 2012 at 10:57:40AM +0800, Lingzhu Xiang wrote:
[..]
> Kernel version ranges from 3.2 to 3.7-rc.
[...]
> [   83.505022]  [<ffffffff810d59a0>] ? print_irqtrace_events+0xd0/0xe0
> [   83.505022]  [<ffffffff810a401d>] __might_sleep+0x18d/0x250
> [   83.505022]  [<ffffffff811b9dc7>] __kmalloc+0x67/0x2d0
> [   83.505022]  [<ffffffff8156375b>] ? efivar_create_sysfs_entry+0x3b/0x1b0
> [   83.505022]  [<ffffffff8156375b>] efivar_create_sysfs_entry+0x3b/0x1b0

efi_pstore_write calls create_sysfs_entry, which is obviosly unsafe from
the dumper code, we're in the atomic context.

> [   83.505022]  [<ffffffff81563c03>] efi_pstore_write+0x333/0x3a0
> [   83.505022]  [<ffffffff8106a3fe>] ? kmsg_dump_get_buffer+0x24e/0x2b0
> [   83.505022]  [<ffffffff812ca4c5>] ? pstore_dump+0x195/0x210
> [   83.505022]  [<ffffffff812ca45f>] pstore_dump+0x12f/0x210
> [   83.505022]  [<ffffffff8106c459>] kmsg_dump+0xf9/0x240
[...]
> After reboot, mount pstore
> ==========================
> 
> [root@localhost ~]# mount -t pstore -o kmsg_bytes=8000 - /dev/pstore
> [   36.502832] BUG: sleeping function called from invalid context at mm/slub.c:928
> [   36.504379] in_atomic(): 1, irqs_disabled(): 0, pid: 851, name: mount
> [   36.505652] 3 locks held by mount/851:
> [   36.506355]  #0:  (&type->s_umount_key#38/1){+.+.+.}, at: [<ffffffff811d5aed>] sget+0x37d/0x640
> [   36.508899]  #1:  (&psinfo->read_mutex){+.+.+.}, at: [<ffffffff812ca59b>] pstore_get_records+0x3b/0x130
> [   36.510688]  #2:  (&(&efivars->lock)->rlock){+.+.+.}, at: [<ffffffff8156273d>] efi_pstore_open+0x1d/0x40
> [   36.512468] Pid: 851, comm: mount Tainted: G        W    3.7.0-0.rc5.git2.1.fc19.x86_64 #1
> [   36.514001] Call Trace:
> [   36.514440]  [<ffffffff810a401d>] __might_sleep+0x18d/0x250
> [   36.515634]  [<ffffffff811b9dc7>] __kmalloc+0x67/0x2d0
> [   36.516509]  [<ffffffff81562103>] ? efi_pstore_read+0x1c3/0x220
> [   36.517525]  [<ffffffff81562103>] efi_pstore_read+0x1c3/0x220
> [   36.518507]  [<ffffffff812ca5f1>] pstore_get_records+0x91/0x130

get_records() calls pinfo->open, which is efi_pstore_open, which grabs a
spin_lock. Then efi_pstore_read tries to kmalloc things with GFP_KERNEL,
which clearly a bug, since we're holding the spinlock.

The second issue is easy to fix, but the fix is not pretty: we must
allocate buf with GFP_ATOMIC (the lock is required during ->read(), it
protects efivars->list, so we can't simply drop it).

The first issue requires us to not create the sysfs entry (since it must
be done in a non-atomic context). This makes pstore efi vars invisible via
/sys/firmware/efi. :( If anyone wants to fix it, he'd have to "sync"
efivars with sysfs thru a workqueue.

[...]
> After reboot, rm a pstore entry
> ===============================
> 
> [root@localhost ~]# rm -f /dev/pstore/dmesg-efi-9
> [   55.572466] 
> [   55.572767] ======================================================
> [   55.573015] [ INFO: possible circular locking dependency detected ]
> [   55.573015] 3.7.0-0.rc5.git2.1.fc19.x86_64 #1 Tainted: G        W

I don't see an obvious problem, but let's solve the first two, and see if
this will help, since the kernel was tainted already.

Please see if the patch down below helps to solve the first two issues...

--

diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index 6e51c1e..773c5bb 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -701,7 +701,7 @@ static ssize_t efi_pstore_read(u64 *id, enum pstore_type_id *type,
 
 			get_var_data_locked(efivars, &efivars->walk_entry->var);
 			size = efivars->walk_entry->var.DataSize;
-			*buf = kmalloc(size, GFP_KERNEL);
+			*buf = kmalloc(size, GFP_ATOMIC);
 			if (*buf == NULL)
 				return -ENOMEM;
 			memcpy(*buf, efivars->walk_entry->var.Data,
@@ -758,12 +758,13 @@ static int efi_pstore_write(enum pstore_type_id type,
 
 	spin_unlock(&efivars->lock);
 
+#if 0 /* FIXME: We are in the atomic context! */
 	if (size)
 		ret = efivar_create_sysfs_entry(efivars,
 					  utf16_strsize(efi_name,
 							DUMP_NAME_LEN * 2),
 					  efi_name, &vendor);
-
+#endif
 	*id = part;
 	return ret;
 };
