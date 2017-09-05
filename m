From: Bhupesh Sharma <bhsharma-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V2 0/3] Use mm_struct and switch_mm() instead of manually
Date: Tue, 5 Sep 2017 13:13:07 +0530
Message-ID: <CACi5LpOMD=xAJz+WkHGi7D-d4xjc20Xx6E-YU1MC0UvHpEx1NA@mail.gmail.com>
References: <1503963432-32055-1-git-send-email-sai.praneeth.prakhya@intel.com>
 <CACi5LpMAKotBYeHpFHZKFCbZ5UST3pqFef6ALwH46JJhdhkkQw@mail.gmail.com>
 <CACi5LpOTjBbT7ngiQykTbhUbVoODvxQRj5Ub-fm7yMP8VySkpA@mail.gmail.com> <FFF73D592F13FD46B8700F0A279B802F1859E218@ORSMSX114.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <FFF73D592F13FD46B8700F0A279B802F1859E218-8oqHQFITsIE64kNsxIetb7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Prakhya, Sai Praneeth" <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "jlee-IBi9RG/b67k@public.gmane.org" <jlee-IBi9RG/b67k@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, "Luck, Tony" <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Neri, Ricardo" <ricardo.neri-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Shankar, Ravi V" <ravi.v.shankar-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Hi Sai,

On Sun, Sep 3, 2017 at 1:16 PM, Prakhya, Sai Praneeth
<sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>> >
>> > Thanks for this v2.
>> > Introducing the 'efi_switch_mm() ' helper instead of manually
>> > twiddling with %cr3 seems more cleaner.
>> >
>> > I have tested this patchset on a x86_64 machine with the following
>> > configurations:
>> >
>> > 1. Primary kernel boot with efi=old_map 2. Primary kernel boot with
>> > new efi map
>> >
>> > While it seems that efi=old_map passes, the new efi map boot fails for
>> > me on both the two x86 machine (Dell 3050MT and a SGI - UV300 machine.
>> >
>> > It seems we are hitting a NULL pointer deference in
>> > 'efi_call_phys_prolog' while accessing '&efi_mm'.
>> >
>> > Please see the log below for details:
>> >
>> > [    0.020006] BUG: unable to handle kernel NULL pointer dereference
>> > at           (null)
>> > [    0.021000] IP: switch_mm_irqs_off+0x44/0x270
>> > [    0.021000] Call Trace:
>> > [    0.021000]  switch_mm+0x20/0x30
>> > [    0.021000]  efi_switch_mm+0x49/0x60
>> > [    0.021000]  efi_call_phys_prolog+0x56/0x1b3
>> > [    0.021000]  efi_enter_virtual_mode+0x3a9/0x520
>> > [    0.021000]  start_kernel+0x424/0x4c8
>> > [    0.021000]  ? set_init_arg+0x5a/0x5a
>> > [    0.021000]  ? early_idt_handler_array+0x120/0x120
>> > [    0.021000]  x86_64_start_reservations+0x29/0x2b
>> > [    0.021000]  x86_64_start_kernel+0x151/0x174
>> > [    0.021000]  secondary_startup_64+0x9f/0x9f
>> > [    0.021000] Code: 2d 82 51 d9 4f 65 c7 05 0f 65 da 4f 01 00 00 00
>> > 48 39 f7 0f 84 14 01 00 00 65 48 89 35 f6 64 da 4f 48 8b 86 e8 02 00
>> > 00 45 89 ed <f0> 4c 0f ab 28 bf 00 00 00 80 48 03 7e 50 48 8b 05 27 b0
>> > b9 00
>> > [    0.021000] RIP: switch_mm_irqs_off+0x44/0x270 RSP: ffffffffb0e035d0
>> > [    0.021000] CR2: 0000000000000000
>> > [    0.021000] ---[ end trace fb94349305e1cb8b ]---
>> > [    0.021000] Kernel panic - not syncing: Fatal exception
>> > [    0.021000] ---[ end Kernel panic - not syncing: Fatal exception
>> >
>>
>> And I forgot to mention that I tried the patchset both with the efi/next and
>> linus's trees and saw the same result.
>>
>> I would be happy to help in case you need further details of the test environment
>> or need help in testing this crash further.
>>
>> Regards,
>> Bhupesh
>
> Hi Bhupesh,
>
> Thanks for trying the patches and raising the concern.
> Could you also please also give a try on qemu? (if reproducible, we will be having a common platform to start debugging)
> I have tested this patch set on qemu and real machines (different from one's you tried) in our lab and didn’t notice this issue.
>

I get a similar crash on Qemu with linus's master branch and the V2
applied on top of it. Here are the details of my test environment:

1. I use the OVMF (EDK2) EFI firmware to launch the kernel:
edk2.git/ovmf-x64

2. I used linus's master branch (HEAD - commit:
b1b6f83ac938d176742c85757960dec2cf10e468) and applied your v2 on top
of the same.

3. I use the following qemu command line to launch the test:

# /usr/local/bin/qemu-system-x86_64 --version
QEMU emulator version 2.9.50 (v2.9.0-526-g76d20ea)
Copyright (c) 2003-2017 Fabrice Bellard and the QEMU Project developers

# /usr/local/bin/qemu-system-x86_64 -enable-kvm  -net nic -net tap  -m
$MEMSIZE -nographic -drive file=$DISK_IMAGE,if=virtio,format=qcow2
-vga std -boot c -cpu host -kernel $KERNEL -append
"crashkernel=$CRASH_MEMSIZE console=ttyS0,115200n81"  -initrd
$INITRAMFS -bios $OVMF_FW_PATH

And here is the crash log:

[    0.006054] general protection fault: 0000 [#1] SMP
[    0.006459] Modules linked in:
[    0.006711] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 4.13.0+ #3
[    0.007000] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS 0.0.0 02/06/2015
[    0.007000] task: ffffffff81e0f480 task.stack: ffffffff81e00000
[    0.007000] RIP: 0010:switch_mm_irqs_off+0x1bc/0x440
[    0.007000] RSP: 0000:ffffffff81e03d80 EFLAGS: 00010086
[    0.007000] RAX: 800000007d084000 RBX: 0000000000000000 RCX: 000077ff80000000
[    0.007000] RDX: 000000007d084000 RSI: 8000000000000000 RDI: 0000000000019a00
[    0.007000] RBP: ffffffff81e03dc0 R08: 0000000000000000 R09: ffff88007d085000
[    0.007000] R10: ffffffff81e03dd8 R11: 000000007d095063 R12: ffffffff81e5c6a0
[    0.007000] R13: ffffffff81ed4f40 R14: 0000000000000030 R15: 0000000000000001
[    0.007000] FS:  0000000000000000(0000) GS:ffff88007d400000(0000)
knlGS:0000000000000000
[    0.007000] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    0.007000] CR2: ffff88007d754000 CR3: 000000000220a000 CR4: 00000000000406b0
[    0.007000] Call Trace:
[    0.007000]  switch_mm+0xd/0x20
[    0.007000]  ? switch_mm+0xd/0x20
[    0.007000]  efi_switch_mm+0x3e/0x4a
[    0.007000]  efi_call_phys_prolog+0x28/0x1ac
[    0.007000]  efi_enter_virtual_mode+0x35a/0x48f
[    0.007000]  start_kernel+0x332/0x3b8
[    0.007000]  x86_64_start_reservations+0x2a/0x2c
[    0.007000]  x86_64_start_kernel+0x178/0x18b
[    0.007000]  secondary_startup_64+0xa5/0xa5
[    0.007000]  ? secondary_startup_64+0xa5/0xa5
[    0.007000] Code: 00 00 00 80 49 03 55 50 0f 82 7f 02 00 00 48 b9
00 00 00 80 ff 77 00 00 48 be 00 00 00 00 00 00 00 80 48 01 ca 48 09
f0 48 09 d0 <0f> 22 d8 0f 1f 44 00 00 e9 47 ff ff ff 65 8b 05 b8 87 fb
7e 89
[    0.007000] RIP: switch_mm_irqs_off+0x1bc/0x440 RSP: ffffffff81e03d80
[    0.007000] ---[ end trace bfa55bf4e4765255 ]---
[    0.007000] Kernel panic - not syncing: Attempted to kill the idle task!
[    0.007000] ---[ end Kernel panic - not syncing: Attempted to kill
the idle task!

4. Note though that if I use the EFI_MIXED mode (i.e. 32-bit ovmf
firmware and 64-bit x86 kernel) with your patches, the primary kernel
boots fine on Qemu:

ovmf firmware used in this case - edk2.git/ovmf-ia32

5. Also, if I append 'efi=old_map' to the bootargs (for the failing
case in point 3 above), I see the primary kernel boots fine on Qemu as
well.

Regards,
Bhupesh
