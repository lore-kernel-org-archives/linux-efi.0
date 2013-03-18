From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Curious crash with secure variables
Date: Mon, 18 Mar 2013 08:01:24 +0000
Message-ID: <1363593684.2412.5.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

The crash is attached below.  The curiosity is that the failing
"virtual" address is actually a physical address inside the EFI runtime.
It looks like either SetVirtualAddressMap() failed to relocate
something, or there are caching effects on pre-relocated addresses.

The way to trigger this is to run tianocore in kvm and boot to an
initial ramdisk with the efi tools and a shell.  If I insert a PK in the
UEFI shell and then try to remove it in the initrd, the crash happens.
If, however, I try to insert and remove the PK in the initrd without
touching the secure variables in the UEFI shell, everything works

James

---

[    0.998342] BUG: unable to handle kernel paging request at 000000001e339788
[    1.000046] IP: [<ffff88001e3e4989>] 0xffff88001e3e4988
[    1.000046] PGD 18211067 PUD 181e8067 PMD 0 
[    1.000046] Oops: 0002 [#1] SMP 
[    1.000046] Modules linked in:
[    1.000046] CPU 0 
[    1.000046] Pid: 34, comm: efi-updatevar Not tainted 3.9.0-rc2+ #45  
[    1.000046] RIP: 0010:[<ffff88001e3e4989>]  [<ffff88001e3e4989>] 0xffff88001e3e4988
[    1.000046] RSP: 0018:ffff88001821b9f0  EFLAGS: 00010086
[    1.000046] RAX: 000000001e3396e0 RBX: ffffffff818537c0 RCX: 0000000000000000
[    1.000046] RDX: ffff88001e36eee0 RSI: ffff88001e36eee0 RDI: 000000001e3396e0
[    1.000046] RBP: ffff88001821ba30 R08: ffff88001f9dfd72 R09: 00000000000002cc
[    1.000046] R10: ffff8800181ff800 R11: ffffffff8152573a R12: ffff8800181ff800
[    1.000046] R13: ffff880018193000 R14: 0000000000000573 R15: ffff88001ed654c0
[    1.000046] FS:  00007f161a916700(0000) GS:ffff88001d200000(0000) knlGS:0000000000000000
[    1.000046] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    1.000046] CR2: 000000001e339788 CR3: 00000000181f4000 CR4: 00000000000006f0
[    1.000046] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    1.000046] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[    1.000046] Process efi-updatevar (pid: 34, threadinfo ffff88001821a000, task ffff880018203870)
[    1.000046] Stack:
[    1.000046]  0000000000000000 0000000000000018 ffff88001e36eee0 000000001e3396e0
[    1.000046]  0000000000000000 0000001800000000 ffff88001e40e670 ffff88001e36eee0
[    1.000046]  ffff88001821ba80 ffff88001e3ab99d 11d293ca8be4df61 ffff88001e4460a0
[    1.000046] Call Trace:
[    1.000046]  [<ffffffff8103a25b>] ? efi_call5+0x4b/0x80
[    1.000046]  [<ffffffff812aaa2e>] ? efivarfs_file_write+0x1f7/0x351
[    1.000046]  [<ffffffff8117999d>] ? security_file_permission+0x15/0x2b
[    1.000046]  [<ffffffff8110dfae>] ? vfs_write+0x96/0xf8
[    1.000046]  [<ffffffff8110e1d6>] ? sys_write+0x51/0x80
[    1.000046]  [<ffffffff813937ed>] ? system_call_fastpath+0x1a/0x1f
[    1.000046] Code: 8b 45 d8 48 89 c7 48 b8 8b 56 3a 1e 00 88 ff ff ff d0 eb 01 90 c9 c3 55 48 89 e5 48 83 ec 40 48 89 7d d8 48 89 75 d0 48 8b 45 d8 <c7> 80 a8 00 00 00 00 00 00 00 48 8b 45 d8 48 8b 48 28 48 8b 45 
[    1.000046] RIP  [<ffff88001e3e4989>] 0xffff88001e3e4988
[    1.000046]  RSP <ffff88001821b9f0>
[    1.000046] CR2: 000000001e339788
[    1.000046] ---[ end trace ee19301618adf435 ]---
