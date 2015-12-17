From: =?UTF-8?Q?M=c3=b4she_van_der_Sterre?= <me-A/3C56C7qwM@public.gmane.org>
Subject: BGRT doesn't work for me on efi-next
Date: Thu, 17 Dec 2015 17:30:45 +0100
Message-ID: <5672E335.8000004@moshe.nl>
References: <5665E8E0.4050203@moshe.nl> <20151207204451.GC16222@cloud>
 <56660979.5080204@moshe.nl> <20151207235520.GA17617@cloud>
 <566623B3.8010104@moshe.nl> <20151208023443.GA10087@x>
 <56664F79.6060100@moshe.nl> <20151208140529.GH2518@codeblueprint.co.uk>
 <5667E7B5.3080705@moshe.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5667E7B5.3080705-A/3C56C7qwM@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sai Praneeth <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Hello Sai and others,

The change to use early_mem*() instead of early_io*() in 50a0cb56 does=20
not work on my machine. Last week I discussed some BGRT changes and I=20
created a patch for that, but can't test it on efi-next because of this=
=2E

I get this (when booting 50a0cb56, without any of my changes):
[    0.026936] ------------[ cut here ]------------
[    0.026941] WARNING: CPU: 0 PID: 0 at mm/early_ioremap.c:137=20
__early_ioremap+0x102/0x1bb()
[    0.026941] Modules linked in:
[    0.026944] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 4.4.0-rc1 #2
[    0.026945] Hardware name: Dell Inc. XPS 13 9343/09K8G1, BIOS A05=20
07/14/2015
[    0.026946]  0000000000000000 900f03d5a116524d ffffffff81c03e60=20
ffffffff813a3fff
[    0.026948]  0000000000000000 ffffffff81c03e98 ffffffff810a0852=20
00000000d7b76000
[    0.026949]  0000000000000000 0000000000000001 0000000000000001=20
000000000000017c
[    0.026951] Call Trace:
[    0.026955]  [<ffffffff813a3fff>] dump_stack+0x44/0x55
[    0.026958]  [<ffffffff810a0852>] warn_slowpath_common+0x82/0xc0
[    0.026959]  [<ffffffff810a099a>] warn_slowpath_null+0x1a/0x20
[    0.026961]  [<ffffffff81d8c395>] __early_ioremap+0x102/0x1bb
[    0.026962]  [<ffffffff81d8c602>] early_memremap+0x13/0x15
[    0.026964]  [<ffffffff81d78361>] efi_bgrt_init+0x162/0x1ad
[    0.026966]  [<ffffffff81d778ec>] efi_late_init+0x9/0xb
[    0.026968]  [<ffffffff81d58ff5>] start_kernel+0x46f/0x49f
[    0.026970]  [<ffffffff81d58120>] ? early_idt_handler_array+0x120/0x=
120
[    0.026972]  [<ffffffff81d58339>] x86_64_start_reservations+0x2a/0x2=
c
[    0.026974]  [<ffffffff81d58485>] x86_64_start_kernel+0x14a/0x16d
[    0.026977] ---[ end trace f9b3812eb8e24c58 ]---
[    0.026978] efi_bgrt: Ignoring BGRT: failed to map image memory

This is the second early_memremap call in efi_bgrt_init triggering=20
WARN_ON(nrpages > NR_FIX_BTMAPS). Can you comment on this?

Greetings,
M=F4she van der Sterre
