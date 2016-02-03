From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH 2/5] efi: use ucs2_as_utf8 in efivarfs instead of open
 coding a bad version
Date: Wed, 3 Feb 2016 16:42:45 +0000
Message-ID: <20160203164245.GA15385@codeblueprint.co.uk>
References: <1454504567-2826-1-git-send-email-pjones@redhat.com>
 <1454504567-2826-2-git-send-email-pjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1454504567-2826-2-git-send-email-pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Wed, 03 Feb, at 08:02:44AM, Peter Jones wrote:
> Translate EFI's UCS-2 variable names to UTF-8 instead of just assuming
> all variable names fit in ASCII.
> 
> Signed-off-by: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/firmware/efi/efivars.c | 13 ++++---------
>  fs/efivarfs/super.c            |  7 +++----
>  2 files changed, 7 insertions(+), 13 deletions(-)

This patch causes the following Oops on my test grid,

[    1.331926] EFI Variables Facility v0.08 2004-May-17
[    1.341570] hidraw: raw HID events driver (C) Jiri Kosina
[    1.343291] general protection fault: 0000 [#1] SMP 
[    1.343400] Modules linked in:
[    1.343550] CPU: 1 PID: 181 Comm: kworker/u4:4 Not tainted 4.4.0-rc2+ #1
[    1.343726] Workqueue: events_unbound call_usermodehelper_exec_work
[    1.343821] task: ffff88003f84d080 ti: ffff88003df48000 task.ti: ffff88003df48000
[    1.343915] RIP: 0010:[<ffffffff8116399c>]  [<ffffffff8116399c>] __kmalloc_track_caller+0x8c/0x170
[    1.344039] RSP: 0018:ffff88003df4bbc8  EFLAGS: 00000286
[    1.344039] RAX: 0000000000000000 RBX: 0000000000000018 RCX: 0000000000000d46
[    1.344039] RDX: 0000000000000d45 RSI: 0000000000000000 RDI: 0000000000000002
[    1.344039] RBP: ffff88003df4bbf8 R08: 00000000000182e0 R09: 000000003fb0f401
[    1.344039] R10: 0000000000000003 R11: ffff88003df99480 R12: 00000000024000c0
[    1.344039] R13: 0000000000000018 R14: 3061612d32643131 R15: ffff88003dc01c00
[    1.344039] FS:  0000000000000000(0000) GS:ffff88003e100000(0000) knlGS:0000000000000000
[    1.344039] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    1.344039] CR2: 0000000000000000 CR3: 0000000001e0b000 CR4: 00000000000006e0
[    1.344039] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    1.344039] DR3: 0000000000000000 DR6: 0000000000000000 DR7: 0000000000000000
[    1.344039] Stack:
[    1.344039]  ffffffff812adda6 0000000000000018 ffff88003df8b480 ffff88003dee0780
[    1.344039]  ffff88003fb0f480 ffffffff81065ed0 ffff88003df4bc18 ffffffff811304fb
[    1.344039]  ffff88003fb0f480 00000000024000c0 ffff88003df4bc30 ffffffff812adda6
[    1.344039] Call Trace:
[    1.344039]  [<ffffffff812adda6>] ? selinux_cred_prepare+0x16/0x30
[    1.344039]  [<ffffffff81065ed0>] ? call_usermodehelper_exec_work+0xb0/0xb0
[    1.344039]  [<ffffffff811304fb>] kmemdup+0x1b/0x40
[    1.344039]  [<ffffffff812adda6>] selinux_cred_prepare+0x16/0x30
[    1.344039]  [<ffffffff812a9c9e>] security_prepare_creds+0x3e/0x60
[    1.344039]  [<ffffffff8107077d>] prepare_creds+0xdd/0x180
[    1.344039]  [<ffffffff81070cc2>] copy_creds+0x22/0x110
[    1.344039]  [<ffffffff81051771>] copy_process+0x311/0x1dc0
[    1.344039]  [<ffffffff81035c22>] ? native_smp_send_reschedule+0x42/0x60
[    1.344039]  [<ffffffff8107722a>] ? resched_curr+0x8a/0xb0
[    1.344039]  [<ffffffff8105338d>] _do_fork+0x7d/0x2d0
[    1.344039]  [<ffffffff8108525e>] ? pick_next_task_fair+0x3fe/0x460
[    1.344039]  [<ffffffff81053604>] kernel_thread+0x24/0x30
[    1.344039]  [<ffffffff81065e46>] call_usermodehelper_exec_work+0x26/0xb0
[    1.344039]  [<ffffffff8186def3>] ? __schedule+0x313/0x870
[    1.344039]  [<ffffffff8106996e>] process_one_work+0x13e/0x3c0
[    1.344039]  [<ffffffff81069d05>] worker_thread+0x115/0x450
[    1.344039]  [<ffffffff8186def3>] ? __schedule+0x313/0x870
[    1.344039]  [<ffffffff81069bf0>] ? process_one_work+0x3c0/0x3c0
[    1.344039]  [<ffffffff8106ed64>] kthread+0xc4/0xe0
[    1.344039]  [<ffffffff8106eca0>] ? kthread_park+0x50/0x50
[    1.344039]  [<ffffffff81871adf>] ret_from_fork+0x3f/0x70
[    1.344039]  [<ffffffff8106eca0>] ? kthread_park+0x50/0x50
[    1.344039] Code: 4c 03 05 a0 67 ea 7e 4d 8b 30 49 8b 40 10 4d 85 f6 0f 84 8e 00 00 00 48 85 c0 0f 84 85 00 00 00 49 63 47 20 48 8d 4a 01 4d 8b 07 <49> 8b 1c 06 4c 89 f0 65 49 0f c7 08 0f 94 c0 84 c0 74 b9 49 63 
[    1.344039] RIP  [<ffffffff8116399c>] __kmalloc_track_caller+0x8c/0x170
[    1.344039]  RSP <ffff88003df4bbc8>
[    1.348190] ---[ end trace ed036c029f24ae69 ]---

I suspect the length calculations we're doing are now wrong and we're
overwriting kmalloc metadata, probably in the efivars code.
