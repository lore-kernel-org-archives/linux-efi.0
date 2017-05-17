From: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] x86/efi: Disable runtime services on kexec kernel if
 booted with efi=old_map
Date: Wed, 17 May 2017 09:57:40 +0800
Message-ID: <20170517015740.GA9562@dhcp-128-65.nay.redhat.com>
References: <1494983663-29286-1-git-send-email-sai.praneeth.prakhya@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1494983663-29286-1-git-send-email-sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sai Praneeth Prakhya <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Ricardo Neri <ricardo.neri-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Ravi Shankar <ravi.v.shankar-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Lee Chun-Yi <jlee-IBi9RG/b67k@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Hi Sai,
On 05/16/17 at 06:14pm, Sai Praneeth Prakhya wrote:
> From: Sai Praneeth <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
> Booting kexec kernel with "efi=old_map" in kernel command line hits
> kernel panic as shown below.
> 
> [0.001000] BUG: unable to handle kernel paging request at ffff88007fe78070
> [0.001000] IP: virt_efi_set_variable.part.7+0x63/0x1b0
> [0.001000] PGD 7ea28067
> [0.001000] PUD 7ea2b067
> [0.001000] PMD 7ea2d067
> [0.001000] PTE 0
> [0.001000]
> [0.001000] Oops: 0000 [#1] SMP
> [0.001000] Modules linked in:
> [0.001000] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 4.11.0-rc2-yocto-standard+ #229
> [0.001000] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 0.0.0 02/06/2015
> [0.001000] task: ffffffff82022500 task.stack: ffffffff82000000
> [0.001000] RIP: 0010:virt_efi_set_variable.part.7+0x63/0x1b0
> [0.001000] RSP: 0000:ffffffff82003dc0 EFLAGS: 00010246
> [0.001000] RAX: ffff88007fe78018 RBX: ffffffff82050300 RCX: 0000000000000007
> [0.001000] RDX: ffffffff82003e50 RSI: ffffffff82050300 RDI: ffffffff82050300
> [0.001000] RBP: ffffffff82003e08 R08: 0000000000000000 R09: 0000000000000000
> [0.001000] R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff82003e50
> [0.001000] R13: 0000000000000007 R14: 0000000000000246 R15: 0000000000000000
> [0.001000] FS:  0000000000000000(0000) GS:ffff88007fa00000(0000) knlGS:0000000000000000
> [0.001000] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [0.001000] CR2: ffff88007fe78070 CR3: 000000007da1d000 CR4: 00000000000006b0
> [0.001000] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [0.001000] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [0.001000] Call Trace:
> [0.001000]  virt_efi_set_variable+0x5d/0x70
> [0.001000]  efi_delete_dummy_variable+0x7a/0x80
> [0.001000]  efi_enter_virtual_mode+0x3f6/0x4a7
> [0.001000]  start_kernel+0x375/0x400
> [0.001000]  x86_64_start_reservations+0x2a/0x2c
> [0.001000]  x86_64_start_kernel+0x168/0x176
> [0.001000]  start_cpu+0x14/0x14
> [0.001000] Code: 04 b0 84 ff 80 3d c5 56 b3 00 00 4c 8b 44 24 08 75
> 6b 9c 41 5e 48 8b 05 9c 78 99 00 4d 89 c1 48 89 de 4d 89 f8 44 89 e9 4c
> 89 e2 <48> 8b 40 58 48 8b 78 58 e8 b0 2d 88 ff 48 c7 c6 b6 1d f4 81 4c
> [0.001000] RIP: virt_efi_set_variable.part.7+0x63/0x1b0 RSP: ffffffff82003dc0
> [0.001000] CR2: ffff88007fe78070
> [0.001000] ---[ end trace 0000000000000000 ]---
> [0.001000] Kernel panic - not syncing: Attempted to kill the idle task!
> [0.001000] ---[ end Kernel panic - not syncing: Attempted to kill the idle task!
> 
> [efi=old_map was never intended to work with kexec. The problem with
> using efi=old_map is that the virtual addresses are assigned from the
> memory region used by other kernel mappings; vmalloc() space.
> Potentially there could be collisions when booting kexec if something
> else is mapped at the virtual address we allocated for runtime service
> regions in the initial boot] - Matt Fleming
> 
> Since kexec was never intended to work with efi=old_map, disable
> runtime services in kexec if booted with efi=old_map, so that we don't
> panic.
> 
> Signed-off-by: Sai Praneeth Prakhya <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Cc: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
> Cc: Ricardo Neri <ricardo.neri-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
> Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> Cc: Ravi Shankar <ravi.v.shankar-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Cc: Lee Chun-Yi <jlee-IBi9RG/b67k@public.gmane.org>
> Cc: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> 
> Changes since v1:
> Don't fix the panic, because this was never intended to work.
> ---
>  arch/x86/platform/efi/efi.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
> index 87835c97611f..627b7b86f369 100644
> --- a/arch/x86/platform/efi/efi.c
> +++ b/arch/x86/platform/efi/efi.c
> @@ -827,9 +827,11 @@ static void __init kexec_enter_virtual_mode(void)
>  
>  	/*
>  	 * We don't do virtual mode, since we don't do runtime services, on
> -	 * non-native EFI
> +	 * non-native EFI. With efi=old_map, we don't do runtime services in
> +	 * kexec kernel because in the initial boot something else might
> +	 * have been mapped at these virtual addresses.
>  	 */
> -	if (!efi_is_native()) {
> +	if (!efi_is_native() || efi_enabled(EFI_OLD_MEMMAP)) {
>  		efi_memmap_unmap();
>  		clear_bit(EFI_RUNTIME_SERVICES, &efi.flags);
>  		return;
> -- 
> 2.1.4
> 

Suppose it has passed the test on your hardware:
Acked-by: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Thanks
Dave
