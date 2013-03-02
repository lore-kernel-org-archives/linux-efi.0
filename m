From: Andre Heider <a.heider-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: sysfs: cannot create duplicate filename
Date: Sat, 2 Mar 2013 19:03:26 +0100
Message-ID: <CAHsu+b-cG+ED6TX5evRTBjR-LwHugW+8-9hnHXAz5DnAioJnUQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Hi,

After a BIOS update I get this in dmesg:

[    0.581554] EFI Variables Facility v0.08 2004-May-17
[    0.584914] ------------[ cut here ]------------
[    0.585639] WARNING: at /home/andre/linux/fs/sysfs/dir.c:536 sysfs_add_one+0x
d4/0x100()
[    0.586381] Hardware name: To be filled by O.E.M.
[    0.587123] sysfs: cannot create duplicate filename '/firmware/efi/vars/SbAsl
BufferPtrVar-01f33c25-764d-43ea-aeea-6b5a41f3f3e8'
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
[    0.607869] ------------[ cut here ]------------
[    0.608589] WARNING: at /home/andre/linux/lib/kobject.c:196
kobject_add_internal+0x204/0x220()
[    0.609342] Hardware name: To be filled by O.E.M.
[    0.610093] kobject_add_internal failed for
SbAslBufferPtrVar-01f33c25-764d-43ea-aeea-6b5a41f3f3e8 with -EEXIST,
don't try to register things with the same name in the same directory.
[    0.611703] Modules linked in:
[    0.612497] Pid: 1, comm: swapper/0 Tainted: G        W    3.8.0+ #7
[    0.613312] Call Trace:
[    0.614112]  [<ffffffff81347fb4>] ? kobject_add_internal+0x204/0x220
[    0.614931]  [<ffffffff810587bf>] warn_slowpath_common+0x7f/0xc0
[    0.615753]  [<ffffffff810588bc>] warn_slowpath_fmt+0x4c/0x50
[    0.616559]  [<ffffffff81347fb4>] kobject_add_internal+0x204/0x220
[    0.617362]  [<ffffffff81348307>] kobject_init_and_add+0x67/0x90
[    0.618152]  [<ffffffff81584a71>] ? efivar_create_sysfs_entry+0x61/0x1c0
[    0.618936]  [<ffffffff81584b2b>] efivar_create_sysfs_entry+0x11b/0x1c0
[    0.619732]  [<ffffffff8158517e>] register_efivars+0xde/0x420
[    0.620518]  [<ffffffff81d430a7>] ? edd_init+0x2f5/0x2f5
[    0.621297]  [<ffffffff81d4315f>] efivars_init+0xb8/0x104
[    0.622072]  [<ffffffff8100215a>] do_one_initcall+0x12a/0x180
[    0.622836]  [<ffffffff81d05d80>] kernel_init_freeable+0x13e/0x1c6
[    0.623590]  [<ffffffff81d05586>] ? loglevel+0x31/0x31
[    0.624314]  [<ffffffff816a6530>] ? rest_init+0x80/0x80
[    0.625010]  [<ffffffff816a653e>] kernel_init+0xe/0xf0
[    0.625703]  [<ffffffff816ce7ec>] ret_from_fork+0x7c/0xb0
[    0.626393]  [<ffffffff816a6530>] ? rest_init+0x80/0x80
[    0.627078] ---[ end trace 1609741ab737eb2a ]---

Sounds like yet another BIOS issue, and I guess the answer is
"complain to the manufacturer"... But we know how well that works, so
can this be a warning instead of a scary backtrace? :)

(this is: Gigabyte Technology Co., Ltd. To be filled by
O.E.M./Z77X-UD3H, BIOS F19e 11/21/2012)"

Thanks,
Andre
