From: Sai Praneeth Prakhya <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] x86/efi: Fix kexec kernel panic when efi=old_map is
 enabled
Date: Fri, 12 May 2017 10:51:10 -0700
Message-ID: <1494611470.8845.26.camel@intel.com>
References: <1494271523-17331-1-git-send-email-sai.praneeth.prakhya@intel.com>
         <20170512095603.GB14028@linux-l9pv.suse>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170512095603.GB14028-g7OFGfmEpDh8S/rGE13EwQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: joeyli <jlee-IBi9RG/b67k@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Ricardo Neri <ricardo.neri-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Ravi Shankar <ravi.v.shankar-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, 2017-05-12 at 17:56 +0800, joeyli wrote:
> On Mon, May 08, 2017 at 12:25:23PM -0700, Sai Praneeth Prakhya wrote:
> > From: Sai Praneeth <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > 
> > Booting kexec kernel with "efi=old_map" in kernel command line hits
> > kernel panic as shown below.
> > 
> > [    0.001000] BUG: unable to handle kernel paging request at ffff88007fe78070
> > [    0.001000] IP: virt_efi_set_variable.part.7+0x63/0x1b0
> > [    0.001000] PGD 7ea28067
> > [    0.001000] PUD 7ea2b067
> > [    0.001000] PMD 7ea2d067
> > [    0.001000] PTE 0
> > [    0.001000]
> > [    0.001000] Oops: 0000 [#1] SMP
> > [    0.001000] Modules linked in:
> > [    0.001000] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 4.11.0-rc2-yocto-standard+ #229
> > [    0.001000] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 0.0.0 02/06/2015
> > [    0.001000] task: ffffffff82022500 task.stack: ffffffff82000000
> > [    0.001000] RIP: 0010:virt_efi_set_variable.part.7+0x63/0x1b0
> > [    0.001000] RSP: 0000:ffffffff82003dc0 EFLAGS: 00010246
> > [    0.001000] RAX: ffff88007fe78018 RBX: ffffffff82050300 RCX: 0000000000000007
> > [    0.001000] RDX: ffffffff82003e50 RSI: ffffffff82050300 RDI: ffffffff82050300
> > [    0.001000] RBP: ffffffff82003e08 R08: 0000000000000000 R09: 0000000000000000
> > [    0.001000] R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff82003e50
> > [    0.001000] R13: 0000000000000007 R14: 0000000000000246 R15: 0000000000000000
> > [    0.001000] FS:  0000000000000000(0000) GS:ffff88007fa00000(0000) knlGS:0000000000000000
> > [    0.001000] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [    0.001000] CR2: ffff88007fe78070 CR3: 000000007da1d000 CR4: 00000000000006b0
> > [    0.001000] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > [    0.001000] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > [    0.001000] Call Trace:
> > [    0.001000]  virt_efi_set_variable+0x5d/0x70
> > [    0.001000]  efi_delete_dummy_variable+0x7a/0x80
> > [    0.001000]  efi_enter_virtual_mode+0x3f6/0x4a7
> > [    0.001000]  start_kernel+0x375/0x400
> > [    0.001000]  x86_64_start_reservations+0x2a/0x2c
> > [    0.001000]  x86_64_start_kernel+0x168/0x176
> > [    0.001000]  start_cpu+0x14/0x14
> > [    0.001000] Code: 04 b0 84 ff 80 3d c5 56 b3 00 00 4c 8b 44 24 08 75
> > 6b 9c 41 5e 48 8b 05 9c 78 99 00 4d 89 c1 48 89 de 4d 89 f8 44 89 e9 4c
> > 89 e2 <48> 8b 40 58 48 8b 78 58 e8 b0 2d 88 ff 48 c7 c6 b6 1d f4 81 4c
> > [    0.001000] RIP: virt_efi_set_variable.part.7+0x63/0x1b0 RSP: ffffffff82003dc0
> > [    0.001000] CR2: ffff88007fe78070
> > [    0.001000] ---[ end trace 0000000000000000 ]---
> > [    0.001000] Kernel panic - not syncing: Attempted to kill the idle task!
> > [    0.001000] ---[ end Kernel panic - not syncing: Attempted to kill the idle task!
> > 
> > This happens because efi=old_map doesn't use efi_pgd but rather it uses
> > kernel's pgd. We don't hit the same panic in a regular kernel because
> > it uses old_map_region() and not __map_region().
> >
> 
> This issue can be reproduced on OVMF. This patch works to fix
> problem.
> 
> Tested-by: Lee, Chun-Yi <jlee-IBi9RG/b67k@public.gmane.org>
> 

Thanks a lot! Joey, for testing the patch.

Regards,
Sai
