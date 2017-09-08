From: Bhupesh Sharma <bhsharma-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V2 0/3] Use mm_struct and switch_mm() instead of manually
Date: Fri, 8 Sep 2017 17:25:35 +0530
Message-ID: <CACi5LpPTD3xXy0hxQHNJVdh4km0Vu5rg4BhNW78G=EEu0SjSyg@mail.gmail.com>
References: <1503963432-32055-1-git-send-email-sai.praneeth.prakhya@intel.com>
 <CACi5LpMAKotBYeHpFHZKFCbZ5UST3pqFef6ALwH46JJhdhkkQw@mail.gmail.com>
 <CACi5LpOTjBbT7ngiQykTbhUbVoODvxQRj5Ub-fm7yMP8VySkpA@mail.gmail.com>
 <FFF73D592F13FD46B8700F0A279B802F1859E218@ORSMSX114.amr.corp.intel.com>
 <CACi5LpOMD=xAJz+WkHGi7D-d4xjc20Xx6E-YU1MC0UvHpEx1NA@mail.gmail.com>
 <1504664466.4482.25.camel@intel.com> <1504665789.4482.31.camel@intel.com> <FFF73D592F13FD46B8700F0A279B802F185ACB0E@ORSMSX114.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <FFF73D592F13FD46B8700F0A279B802F185ACB0E-8oqHQFITsIE64kNsxIetb7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Prakhya, Sai Praneeth" <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "jlee-IBi9RG/b67k@public.gmane.org" <jlee-IBi9RG/b67k@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, "Luck, Tony" <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Neri, Ricardo" <ricardo.neri-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Shankar, Ravi V" <ravi.v.shankar-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Hi Sai,

There were several combinations suggested in your threads, so it took
me some time to try them out and document the different behaviours.
Please see them inline:

On Wed, Sep 6, 2017 at 2:30 PM, Prakhya, Sai Praneeth
<sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>
>
>> -----Original Message-----
>> From: Sai Praneeth Prakhya [mailto:sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org]
>> Sent: Tuesday, September 5, 2017 7:43 PM
>> To: Bhupesh Sharma <bhsharma-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Matt Fleming
>> <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>; Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>;
>> jlee-IBi9RG/b67k@public.gmane.org; Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>; Luck, Tony
>> <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>; luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org; mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org; Neri, Ricardo
>> <ricardo.neri-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>; Shankar, Ravi V <ravi.v.shankar-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>> Subject: Re: [PATCH V2 0/3] Use mm_struct and switch_mm() instead of
>> manually
>>
>> On Tue, 2017-09-05 at 19:21 -0700, Sai Praneeth Prakhya wrote:
>> > > I get a similar crash on Qemu with linus's master branch and the V2
>> > > applied on top of it. Here are the details of my test environment:
>> > >
>> > > 1. I use the OVMF (EDK2) EFI firmware to launch the kernel:
>> > > edk2.git/ovmf-x64
>> > >
>> > > 2. I used linus's master branch (HEAD - commit:
>> > > b1b6f83ac938d176742c85757960dec2cf10e468) and applied your v2 on top
>> > > of the same.
>> > >
>> > > 3. I use the following qemu command line to launch the test:
>> > >
>> > > # /usr/local/bin/qemu-system-x86_64 --version QEMU emulator version
>> > > 2.9.50 (v2.9.0-526-g76d20ea) Copyright (c) 2003-2017 Fabrice Bellard
>> > > and the QEMU Project developers
>> > >
>> > > # /usr/local/bin/qemu-system-x86_64 -enable-kvm  -net nic -net tap
>> > > -m $MEMSIZE -nographic -drive
>> > > file=$DISK_IMAGE,if=virtio,format=qcow2
>> > > -vga std -boot c -cpu host -kernel $KERNEL -append
>> > > "crashkernel=$CRASH_MEMSIZE console=ttyS0,115200n81"  -initrd
>> > > $INITRAMFS -bios $OVMF_FW_PATH
>> > >
>> > > And here is the crash log:
>> > >
>> > > [    0.006054] general protection fault: 0000 [#1] SMP
>> > > [    0.006459] Modules linked in:
>> > > [    0.006711] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 4.13.0+ #3
>> > > [    0.007000] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
>> > > BIOS 0.0.0 02/06/2015
>> > > [    0.007000] task: ffffffff81e0f480 task.stack: ffffffff81e00000
>> > > [    0.007000] RIP: 0010:switch_mm_irqs_off+0x1bc/0x440
>> > > [    0.007000] RSP: 0000:ffffffff81e03d80 EFLAGS: 00010086
>> > > [    0.007000] RAX: 800000007d084000 RBX: 0000000000000000 RCX:
>> 000077ff80000000
>> > > [    0.007000] RDX: 000000007d084000 RSI: 8000000000000000 RDI:
>> 0000000000019a00
>> > > [    0.007000] RBP: ffffffff81e03dc0 R08: 0000000000000000 R09:
>> ffff88007d085000
>> > > [    0.007000] R10: ffffffff81e03dd8 R11: 000000007d095063 R12:
>> ffffffff81e5c6a0
>> > > [    0.007000] R13: ffffffff81ed4f40 R14: 0000000000000030 R15:
>> 0000000000000001
>> > > [    0.007000] FS:  0000000000000000(0000) GS:ffff88007d400000(0000)
>> > > knlGS:0000000000000000
>> > > [    0.007000] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> > > [    0.007000] CR2: ffff88007d754000 CR3: 000000000220a000 CR4:
>> 00000000000406b0
>> > > [    0.007000] Call Trace:
>> > > [    0.007000]  switch_mm+0xd/0x20
>> > > [    0.007000]  ? switch_mm+0xd/0x20
>> > > [    0.007000]  efi_switch_mm+0x3e/0x4a
>> > > [    0.007000]  efi_call_phys_prolog+0x28/0x1ac
>> > > [    0.007000]  efi_enter_virtual_mode+0x35a/0x48f
>> > > [    0.007000]  start_kernel+0x332/0x3b8
>> > > [    0.007000]  x86_64_start_reservations+0x2a/0x2c
>> > > [    0.007000]  x86_64_start_kernel+0x178/0x18b
>> > > [    0.007000]  secondary_startup_64+0xa5/0xa5
>> > > [    0.007000]  ? secondary_startup_64+0xa5/0xa5
>> > > [    0.007000] Code: 00 00 00 80 49 03 55 50 0f 82 7f 02 00 00 48 b9
>> > > 00 00 00 80 ff 77 00 00 48 be 00 00 00 00 00 00 00 80 48 01 ca 48 09
>> > > f0 48 09 d0 <0f> 22 d8 0f 1f 44 00 00 e9 47 ff ff ff 65 8b 05 b8 87
>> > > fb 7e 89
>> > > [    0.007000] RIP: switch_mm_irqs_off+0x1bc/0x440 RSP: ffffffff81e03d80
>> > > [    0.007000] ---[ end trace bfa55bf4e4765255 ]---
>> > > [    0.007000] Kernel panic - not syncing: Attempted to kill the idle task!
>> > > [    0.007000] ---[ end Kernel panic - not syncing: Attempted to kill
>> > > the idle task!
>> > >
>> > > 4. Note though that if I use the EFI_MIXED mode (i.e. 32-bit ovmf
>> > > firmware and 64-bit x86 kernel) with your patches, the primary
>> > > kernel boots fine on Qemu:
>> > >
>> > > ovmf firmware used in this case - edk2.git/ovmf-ia32
>> > >
>> > > 5. Also, if I append 'efi=old_map' to the bootargs (for the failing
>> > > case in point 3 above), I see the primary kernel boots fine on Qemu
>> > > as well.
>> > >
>> > > Regards,
>> > > Bhupesh
>> >
>> > Hi Bhupesh,
>> >
>> > Thanks a lot for the detailed explanation. They are helpful to
>> > reproduce the issue quickly. From my initial debug, I think that AMD
>> > SME + efi_mm_struct patches + -cpu host (in qemu) are required to
>> > reproduce the issue on qemu.
>> >
>> > I have tried the following combinations (all tests are on qemu):
>> > On Linus's tree:
>> > 1. With  SME and  efi_mm and  -cpu host -> panics 2. With  SME and
>> > efi_mm and !-cpu host -> boots 3. With  SME and !efi_mm and  -cpu host
>> > -> boots 4. With  SME and !efi_mm and !-cpu host -> boots 5. With !SME
>> > and  efi_mm and  -cpu host -> boots 6. With !SME and  efi_mm and !-cpu
>> > host -> boots 7. With !SME and !efi_mm and  -cpu host -> boots 8. With
>> > !SME and !efi_mm and !-cpu host -> boots
>> >
>> > On Matt's tree (no SME):
>> > 1. With  efi_mm and  -cpu host -> boots 2. With  efi_mm and !-cpu host
>> > -> boots 3. With !efi_mm and  -cpu host -> boots 4. With !efi_mm and
>> > !-cpu host -> boots
>> >
>> > Summary:
>> > On Matt's tree (next branch), I am unable to reproduce the issue
>> > because they don't have SME patches.
>> >
>> > On Linus's tree, with SME patches
>> > (b1b6f83ac938d176742c85757960dec2cf10e468) and my patches and -cpu
>> > host switch enabled in qemu, I was able to reproduce the issue.
>> >
>> > Could you please confirm if you are seeing the same behavior?
>> > Specially on real machines (I think, this is equivalent to -cpu host
>> > on
>> > qemu) because in earlier mails you have mentioned that you were able
>> > to reproduce this on Matt's tree, but according to my theory it
>> > shouldn't be the case because Matt's three doesn't have SME patches.
>> > Did you back port (b1b6f83ac938d176742c85757960dec2cf10e468) this
>> > commit to Matt's tree and then applied my patches?

[snip..]

> Hi Bhupesh,
>
> Could you please append "nopcid" to kernel command line parameters and see if the issue goes away (on both qemu and real machines)?

(1) On Linus's tree, with SME + 5-level page table + PCID based tlb
flush patches (i.e. b1b6f83ac938d176742c85757960dec2cf10e468) and your
v2 patchset applied:

a) when 'nopcid' is specified in bootargs:

- qemu: primary kernel boots fine.
- Real efi test hardware (SGI UV 300 machine): primary boots _fails_

b) when 'nopcid' is _not_ specified in bootargs:

- qemu: primary kernel boot _fails_.
- Real efi test hardware (SGI UV 300 machine): primary boot _fails_.

(2) On Matt's tree, with c4d2793e5a07d5e63d91715a4393fe47c8345112 as
head and your v2 patchset applied:

a) when 'nopcid' is specified in bootargs:

- qemu: primary kernel boots fine.
- Real efi test hardware (SGI UV 300 machine): primary boot _fails_

b) when 'nopcid' is _not_ specified in bootargs:

- qemu: primary kernel boots fine.
- Real efi test hardware (SGI UV 300 machine): primary boot _fails_

So, in summary it seems that the primary kernel boot _fails_ with your
v2 patchset on the real hardware for me irrespective of whether I use
Matt's tree or Linus's tree:

a) I would suggest that you perform some more checks on real hardware
as qemu boot tests sometimes do not expose the problems we might see
when booting a kernel on efi capable hardware.

b) Also do note that both Matt's tree and Linus's tree work fine on
this hardware for me (with the 'nopcid' added to the bootargs)

Please let me know if I can help further in debugging the same.

Regards,
Bhupesh
