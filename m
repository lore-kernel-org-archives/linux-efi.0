From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: Object debugging warning from efivar
Date: Sat, 10 Nov 2018 12:48:13 +0100
Message-ID: <CAKv+Gu8RKJUnsEqSPDnvUSckUootTp8Tq=AhUA9iEVb3zMqdCA@mail.gmail.com>
References: <AAACED12-1AAD-4C03-97EF-EF87F05A7056@gmx.us>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <AAACED12-1AAD-4C03-97EF-EF87F05A7056@gmx.us>
Sender: linux-kernel-owner@vger.kernel.org
To: Qian Cai <cai@gmx.us>
Cc: open list <linux-kernel@vger.kernel.org>, linux-efi <linux-efi@vger.kernel.org>, Matthew Garrett <matthew.garrett@nebula.com>, Jeremy Kerr <jk@ozlabs.org>
List-Id: linux-efi@vger.kernel.org

On 9 November 2018 at 23:19, Qian Cai <cai@gmx.us> wrote:
> Booting this aarch64 server with the latest mainline (3541833fd1f2) get this warning
> using object debugging. Any idea?
>

Thanks Qian

Fix is here
https://lore.kernel.org/lkml/1540304307-2806-1-git-send-email-longman@redhat.com/

and is queued in efi/urgent


> [   34.716558] ODEBUG: object (____ptrval____) is NOT on stack (____ptrval____), but annotated.
> [   34.725266] WARNING: CPU: 0 PID: 1 at lib/debugobjects.c:369 __debug_object_init+0x910/0x918
> [   34.733806] Modules linked in:
> [   34.736903] CPU: 0 PID: 1 Comm: swapper/0 Tainted: G        W         4.20.0-rc1+ #1
> [   34.744740] Hardware name: Huawei TaiShan 2280 /BC11SPCD, BIOS 1.50 06/01/2018
> [   34.752051] pstate: 20000085 (nzCv daIf -PAN -UAO)
> [   34.756902] pc : __debug_object_init+0x910/0x918
> [   34.761576] lr : __debug_object_init+0x594/0x918
> [   34.766249] sp : ffff8096c1a0f420
> [   34.769603] x29: ffff8096c1a0f420 x28: 1ffff012d8341ec6
> [   34.774984] x27: ffff20000bc21000 x26: ffff20000bc34e40
> [   34.780364] x25: ffff8096c411e8c8 x24: ffff8096c411e8d0
> [   34.785743] x23: ffff20000c5654d0 x22: ffff20000bc21c40
> [   34.791123] x21: ffff801ec1a00060 x20: ffff801ec1a00040
> [   34.796502] x19: ffff801ec1a00040 x18: 000000000000003f
> [   34.801881] x17: 0000000000000000 x16: 0000000000000000
> [   34.807260] x15: 0000000000007fff x14: 6e6120747562202c
> [   34.812640] x13: 295f5f5f5f6c6176 x12: ffff1012d8341ceb
> [   34.818019] x11: 00000000f2f2f2f2 x10: dfff200000000000
> [   34.823399] x9 : ffff20000a0e9848 x8 : ffff801ec1a00b70
> [   34.828778] x7 : 00000000f2f2f204 x6 : 00000000f2f2f204
> [   34.834157] x5 : 0000000041b58ab3 x4 : dfff200000000000
> [   34.839537] x3 : dfff200000000000 x2 : 2b6ba53cf7873600
> [   34.844916] x1 : 0000000000000000 x0 : 0000000000000050
> [   34.850295] Call trace:
> [   34.852772]  __debug_object_init+0x910/0x918
> [   34.857095]  debug_object_init_on_stack+0x20/0x28
> [   34.861859]  __init_work+0x34/0x50
> [   34.865304]  virt_efi_get_next_variable+0xbc/0x190
> [   34.870153]  efivar_init+0x144/0x4b0
> [   34.873773]  efisubsys_init+0x1a8/0x428
> [   34.877656]  do_one_initcall+0x160/0x6bc
> [   34.881628]  kernel_init_freeable+0x74c/0x814
> [   34.886040]  kernel_init+0x18/0x11c
> [   34.889572]  ret_from_fork+0x10/0x1c
> [   34.893189] irq event stamp: 882290
> [   34.896723] hardirqs last  enabled at (882289): [<ffff200008fab538>] _raw_spin_unlock_irqrestore+0x80/0x88
> [   34.906496] hardirqs last disabled at (882290): [<ffff200008fab264>] _raw_spin_lock_irqsave+0x34/0x98
> [   34.915829] softirqs last  enabled at (881706): [<ffff200008082210>] __do_softirq+0x7c8/0x9c8
> [   34.924460] softirqs last disabled at (881697): [<ffff20000812dbe4>] irq_exit+0x25c/0x2f0
> [   34.932736] ---[ end trace f86eaf2ac70822cc ]---
