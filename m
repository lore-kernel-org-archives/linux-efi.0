From: Bhupesh Sharma <bhsharma-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V2 0/3] Use mm_struct and switch_mm() instead of manually
Date: Sat, 2 Sep 2017 19:38:15 +0530
Message-ID: <CACi5LpMAKotBYeHpFHZKFCbZ5UST3pqFef6ALwH46JJhdhkkQw@mail.gmail.com>
References: <1503963432-32055-1-git-send-email-sai.praneeth.prakhya@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1503963432-32055-1-git-send-email-sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sai Praneeth Prakhya <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, jlee-IBi9RG/b67k@public.gmane.org, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ricardo.neri-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, ravi.v.shankar-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Hi Sai,

On Tue, Aug 29, 2017 at 5:07 AM, Sai Praneeth Prakhya
<sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> From: Sai Praneeth <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>
> Presently, in x86, to invoke any efi function like
> efi_set_virtual_address_map() or any efi_runtime_service() the code path
> typically involves read_cr3() (save previous pgd), write_cr3()
> (write efi_pgd) and calling efi function. Likewise after returning from
> efi function the code path typically involves read_cr3() (save efi_pgd),
> write_cr3() (write previous pgd). We do this couple of times in efi
> subsystem of Linux kernel, instead we can use helper function
> efi_switch_mm() to do this. This improves readability and maintainability.
> Also, instead of maintaining a separate struct "efi_scratch" to store/restore
> efi_pgd, we can use mm_struct to do this.
>
> I have tested this patch set against LUV (Linux UEFI Validation), so I
> think I didn't break any existing configurations. I have tested this
> patch set for
> 1. x86_64,
> 2. x86_32,
> 3. Mixed mode
> with efi=old_map and for kexec kernel. Please let me know if I have
> missed any other configurations.
>
> Changes in V2:
> 1. Resolve mm_dropping() issue by not mm_dropping()/mm_grabbing() any mm,
> as we are not losing/creating any references.
>
> Sai Praneeth (3):
>   efi: Use efi_mm in x86 as well as ARM
>   x86/efi: Replace efi_pgd with efi_mm.pgd
>   x86/efi: Use efi_switch_mm() rather than manually twiddling with %cr3
>
>  arch/x86/include/asm/efi.h           | 29 ++++++++++----------
>  arch/x86/platform/efi/efi_64.c       | 52 ++++++++++++++++++++----------------
>  arch/x86/platform/efi/efi_thunk_64.S |  2 +-
>  drivers/firmware/efi/arm-runtime.c   |  9 -------
>  drivers/firmware/efi/efi.c           |  9 +++++++
>  include/linux/efi.h                  |  2 ++
>  6 files changed, 55 insertions(+), 48 deletions(-)
>
> --
> 2.1.4
>

Thanks for this v2.
Introducing the 'efi_switch_mm() ' helper instead of manually
twiddling with %cr3 seems more cleaner.

I have tested this patchset on a x86_64 machine with the following
configurations:

1. Primary kernel boot with efi=old_map
2. Primary kernel boot with new efi map

While it seems that efi=old_map passes, the new efi map boot fails for
me on both the two x86 machine (Dell 3050MT and a SGI - UV300 machine.

It seems we are hitting a NULL pointer deference in
'efi_call_phys_prolog' while accessing '&efi_mm'.

Please see the log below for details:

[    0.020006] BUG: unable to handle kernel NULL pointer dereference
at           (null)
[    0.021000] IP: switch_mm_irqs_off+0x44/0x270
[    0.021000] PGD 0
[    0.021000] P4D 0
[    0.021000]
[    0.021000] Oops: 0002 [#1] SMP
[    0.021000] Modules linked in:
[    0.021000] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 4.12.0-rc7+ #8
[    0.021000] Hardware name: SGI UV300/UV300, BIOS SGI UV 300 series
BIOS 05/25/2016
[    0.021000] task: ffffffffb0e104c0 task.stack: ffffffffb0e00000
[    0.021000] RIP: 0010:switch_mm_irqs_off+0x44/0x270
[    0.021000] RSP: 0000:ffffffffb0e035d0 EFLAGS: 00010083
[    0.021000] RAX: 0000000000000000 RBX: ffffffffb0fbe620 RCX: ffffffffb0e61348
[    0.021000] RDX: ffffffffb0e104c0 RSI: ffffffffb0fbe620 RDI: ffffffffb0f14660
[    0.021000] RBP: ffffffffb0e035f0 R08: 65202c3120676f6c R09: 0000000000000189
[    0.021000] R10: 30313d6d6d5f6966 R11: 3432303331363936 R12: ffffffffb0f14660
[    0.021000] R13: 0000000000000000 R14: 0000000000000bb0 R15: 0000000000000450
[    0.021000] FS:  0000000000000000(0000) GS:ffff8bf2c3600000(0000)
knlGS:0000000000000000
[    0.021000] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    0.021000] CR2: 0000000000000000 CR3: 0000005b43e09000 CR4: 00000000000406b0
[    0.021000] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    0.021000] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[    0.021000] Call Trace:
[    0.021000]  switch_mm+0x20/0x30
[    0.021000]  efi_switch_mm+0x49/0x60
[    0.021000]  efi_call_phys_prolog+0x56/0x1b3
[    0.021000]  efi_enter_virtual_mode+0x3a9/0x520
[    0.021000]  start_kernel+0x424/0x4c8
[    0.021000]  ? set_init_arg+0x5a/0x5a
[    0.021000]  ? early_idt_handler_array+0x120/0x120
[    0.021000]  x86_64_start_reservations+0x29/0x2b
[    0.021000]  x86_64_start_kernel+0x151/0x174
[    0.021000]  secondary_startup_64+0x9f/0x9f
[    0.021000] Code: 2d 82 51 d9 4f 65 c7 05 0f 65 da 4f 01 00 00 00
48 39 f7 0f 84 14 01 00 00 65 48 89 35 f6 64 da 4f 48 8b 86 e8 02 00
00 45 89 ed <f0> 4c 0f ab 28 bf 00 00 00 80 48 03 7e 50 48 8b 05 27 b0
b9 00
[    0.021000] RIP: switch_mm_irqs_off+0x44/0x270 RSP: ffffffffb0e035d0
[    0.021000] CR2: 0000000000000000
[    0.021000] ---[ end trace fb94349305e1cb8b ]---
[    0.021000] Kernel panic - not syncing: Fatal exception
[    0.021000] ---[ end Kernel panic - not syncing: Fatal exception


Regards,
Bhupesh
