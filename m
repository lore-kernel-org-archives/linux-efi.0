From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH 1/2] x86: Fix kernel panic when booting with XD disabled
 in uEFI firmware
Date: Fri, 4 Dec 2015 16:40:57 +0000
Message-ID: <20151204164057.GE2514@codeblueprint.co.uk>
References: <17EC94B0A072C34B8DCF0D30AD16044A0288E2D7@BPXM09GP.gisp.nec.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <17EC94B0A072C34B8DCF0D30AD16044A0288E2D7-9lrffkYxhwTt6d3pZDjeaEtBU8KWyXPq@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kosuke Tatsukawa <tatsu-zZGIbrA41Td8UrSeD/g0lQ@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, 03 Dec, at 11:58:33PM, Kosuke Tatsukawa wrote:
> The kernel panics early in boot on a x86_64 server if the eXecute
> Disable (XD) bit is set to disabled in the uEFI firmware.  The message
> in the kernel log buffer looks like below.
> ------------------------------------------------------------------------
> [    0.000000] CPU: 0 PID: 0 Comm: swapper Not tainted 4.4.0-rc3 #1
> [    0.000000]  0000000000000000 261c6fa13723be1b ffffffff819b7e40 ffffffff8131f320
> [    0.000000]  ffffffffffffffff ffffffff819b7f30 ffffffff81b261b0 000000000000001c
> [    0.000000]  ffffffff81d77a1c 0000000000000010 00000000be35a000 ffffffffff200000
> [    0.000000] Call Trace:
> [    0.000000]  [<ffffffff8131f320>] dump_stack+0x44/0x64
> [    0.000000]  [<ffffffff81b261b0>] early_idt_handler_common+0x90/0xd0
> [    0.000000]  [<ffffffff81b2f1c5>] ? setup_arch+0x1f1/0xce0
> [    0.000000]  [<ffffffff81b2f1c5>] ? setup_arch+0x1f1/0xce0
> [    0.000000]  [<ffffffff81b26120>] ? early_idt_handler_array+0x120/0x120
> [    0.000000]  [<ffffffff81b26d81>] start_kernel+0xe6/0x4f0
> [    0.000000]  [<ffffffff81b26120>] ? early_idt_handler_array+0x120/0x120
> [    0.000000]  [<ffffffff81b26120>] ? early_idt_handler_array+0x120/0x120
> [    0.000000]  [<ffffffff81b265ee>] x86_64_start_reservations+0x2a/0x2c
> [    0.000000]  [<ffffffff81b2673c>] x86_64_start_kernel+0x14c/0x16f
> [    0.000000] RIP 0x80000000be359163
> ------------------------------------------------------------------------
> 
> The panic occurs because __early_set_fixmap() called from
> parse_setup_data() unconditionally sets the PTE with FIXMAP_PAGE_NORMAL,
> which contains _PAGE_NX and causes an exception.
> 
> This patch modifies __early_set_fixmap() to set _PAGE_NX only when the
> hardware supports it.  It also moves the call to x86_configure_nx()
> earlier in setup_arch() before __early_set_fixmap() is first called.
> 
> The above problem occurs after __early_set_fixmap() is called from
> parse_setup_data().  However, since setup_olpc_ofw_pgd() can also call
> __early_set_fixmap(), the patch moves the call to x86_configure_nx()
> before that.
> 
> Signed-off-by: Kosuke Tatsukawa <tatsu-zZGIbrA41Td8UrSeD/g0lQ@public.gmane.org>
> ---
>  arch/x86/kernel/setup.c |   18 +++++++++---------
>  arch/x86/mm/ioremap.c   |    3 +++
>  2 files changed, 12 insertions(+), 9 deletions(-)

Could you try booting with the commit 04633df0c43d ("x86/cpu: Call
verify_cpu() after having entered long mode too") instead? It's part
of v4.4-rc1.

Allowing NX to be disabled should be avoided.
