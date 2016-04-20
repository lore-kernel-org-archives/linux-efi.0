From: Jani Nikula <jani.nikula-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [Intel-gfx] [PATCH] lib: Always NUL terminate ucs2_as_utf8
Date: Wed, 20 Apr 2016 17:03:28 +0300
Message-ID: <871t60nzrj.fsf@intel.com>
References: <1461141427-16361-1-git-send-email-chris@chris-wilson.co.uk>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1461141427-16361-1-git-send-email-chris-Y6uKTt2uX1cEflXRtASbqLVCufUGDwFn@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chris Wilson <chris-Y6uKTt2uX1cEflXRtASbqLVCufUGDwFn@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jason Andryuk <jandryuk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, intel-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matthew Garrett <mjg59-JW9irJGTvgXQT0dZR+AlfA@public.gmane.org>, Laszlo Ersek <lersek-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, 20 Apr 2016, Chris Wilson <chris-Y6uKTt2uX1cEflXRtASbqLVCufUGDwFn@public.gmane.org> wrote:
> If the caller, in this case efivarfs_callback(), only provides sufficent
> room for the expanded utf8 and not enough to include the terminating NUL
> byte, that NUL byte is skipped. When the caller then interprets it as a
> string, it may then read from past its allocated memory:
>
> [  170.605647] WARNING: kmemcheck: Caught 8-bit read from uninitialized memory (ffff8804079ae786)
> [  170.605677] 436f6e4f757400004c44322d35363062663538612d316530642d346437652d39
> [  170.606037]  i i i i i i u u u u u u u u u u u u u u u u u u u u u u u u u u
> [  170.606236]              ^
> [  170.606243] RIP: 0010:[<ffffffff813a251f>]  [<ffffffff813a251f>] efivar_variable_is_removable+0xaf/0xf0
> [  170.606346] RSP: 0018:ffff880408e73c20  EFLAGS: 00010206
> [  170.606352] RAX: 0000000000000000 RBX: 0000000000000006 RCX: 0000000000000006
> [  170.606359] RDX: 0000000000000000 RSI: 0000000000000074 RDI: ffff880408e73c30
> [  170.606365] RBP: ffff880408e73c80 R08: 0000000000000006 R09: 000000000000008c
> [  170.606371] R10: 0000000000000006 R11: 0000000000000000 R12: ffffffff8166ed20
> [  170.606378] R13: 11d293ca8be4df61 R14: ffffffff81773834 R15: ffff8804079ae780
> [  170.606385] FS:  0000000000000000(0000) GS:ffff88041ca00000(0000) knlGS:0000000000000000
> [  170.606392] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  170.606399] CR2: ffff880409cbe4c0 CR3: 00000004085fd000 CR4: 00000000001406f0
> [  170.606405]  [<ffffffff811eb938>] efivarfs_callback+0xf8/0x275
> [  170.606418]  [<ffffffff813a3368>] efivar_init+0x248/0x2e0
> [  170.606440]  [<ffffffff811eb6b4>] efivarfs_fill_super+0xb4/0xf0
> [  170.606452]  [<ffffffff811333e7>] mount_single+0x87/0xb0
> [  170.606463]  [<ffffffff811eb5f3>] efivarfs_mount+0x13/0x20
> [  170.606475]  [<ffffffff81133480>] mount_fs+0x10/0x90
> [  170.606497]  [<ffffffff8114c732>] vfs_kern_mount+0x62/0x100
> [  170.606508]  [<ffffffff8114ecb0>] do_mount+0x1e0/0xcd0
> [  170.606519]  [<ffffffff8114fa9f>] SyS_mount+0x8f/0xd0
> [  170.606530]  [<ffffffff81451d1f>] entry_SYSCALL_64_fastpath+0x17/0x93
> [  170.606542]  [<ffffffffffffffff>] 0xffffffffffffffff

So I eyeballed the code a bit, and came across efivar_validate(), which
calls variable_matches(), which definitely can access off by one beyond
the passed in var_name on that call path.

However I can't match that up with your backtrace, so may be another
bug.


BR,
Jani.


-- 
Jani Nikula, Intel Open Source Technology Center
