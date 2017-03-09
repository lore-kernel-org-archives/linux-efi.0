From: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: kexec regression since 4.9 caused by efi
Date: Thu, 9 Mar 2017 14:38:06 +0800
Message-ID: <20170309063806.GB17257@dhcp-128-65.nay.redhat.com>
References: <20170308201616.GC8598@vader>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170308201616.GC8598@vader>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Omar Sandoval <osandov-nWWhXC5lh1RBDgjK7y7TUQ@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Add efi/kexec list.

On 03/08/17 at 12:16pm, Omar Sandoval wrote:
> Hi, everyone,
> 
> Since 4.9, kexec results in the following panic on some of our servers:
> 
> [    0.001000] general protection fault: 0000 [#1] SMP
> [    0.001000] Modules linked in:
> [    0.001000] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 4.11.0-rc1 #53
> [    0.001000] Hardware name: Wiwynn Leopard-Orv2/Leopard-DDR BW, BIOS LBM05   09/30/2016
> [    0.001000] task: ffffffff81e0e4c0 task.stack: ffffffff81e00000
> [    0.001000] RIP: 0010:virt_efi_set_variable+0x85/0x1a0
> [    0.001000] RSP: 0000:ffffffff81e03e18 EFLAGS: 00010202
> [    0.001000] RAX: afafafafafafafaf RBX: ffffffff81e3a4e0 RCX: 0000000000000007
> [    0.001000] RDX: ffffffff81e03e70 RSI: ffffffff81e3a4e0 RDI: ffff88407f8c2de0
> [    0.001000] RBP: ffffffff81e03e60 R08: 0000000000000000 R09: 0000000000000000
> [    0.001000] R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81e03e70
> [    0.001000] R13: 0000000000000007 R14: 0000000000000000 R15: 0000000000000000
> [    0.001000] FS:  0000000000000000(0000) GS:ffff881fff600000(0000) knlGS:0000000000000000
> [    0.001000] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [    0.001000] CR2: ffff88407f30f000 CR3: 0000001fff102000 CR4: 00000000000406b0
> [    0.001000] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [    0.001000] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [    0.001000] Call Trace:
> [    0.001000]  efi_delete_dummy_variable+0x7a/0x80
> [    0.001000]  efi_enter_virtual_mode+0x3e2/0x494
> [    0.001000]  start_kernel+0x392/0x418
> [    0.001000]  ? set_init_arg+0x55/0x55
> [    0.001000]  x86_64_start_reservations+0x2a/0x2c
> [    0.001000]  x86_64_start_kernel+0xea/0xed
> [    0.001000]  start_cpu+0x14/0x14
> [    0.001000] Code: 42 25 8d ff 80 3d 43 77 95 00 00 75 68 9c 8f 04 24 48 8b 05 3e 7d 7e 00 48 89 de 4d 89 f9 4d 89 f0 44 89 e9 4c 89 e2 48 8b 40 58 <48> 8b 78 58 31 c0 e8 90 e4 92 ff 48 8b 3c 24 48 c7 c6 2b 0a ca
> [    0.001000] RIP: virt_efi_set_variable+0x85/0x1a0 RSP: ffffffff81e03e18
> [    0.001000] ---[ end trace 0bd213e540e9b19f ]---
> [    0.001000] Kernel panic - not syncing: Fatal exception
> [    0.001000] ---[ end Kernel panic - not syncing: Fatal exception
> 
> Booting normally (i.e., not kexec) still works.
> 
> The decoded code is:
> 
> 
>    0:   42 25 8d ff 80 3d       rex.X and $0x3d80ff8d,%eax
>    6:   43 77 95                rex.XB ja 0xffffffffffffff9e
>    9:   00 00                   add    %al,(%rax)
>    b:   75 68                   jne    0x75
>    d:   9c                      pushfq
>    e:   8f 04 24                popq   (%rsp)
>   11:   48 8b 05 3e 7d 7e 00    mov    0x7e7d3e(%rip),%rax        # 0x7e7d56
>   18:   48 89 de                mov    %rbx,%rsi
>   1b:   4d 89 f9                mov    %r15,%r9
>   1e:   4d 89 f0                mov    %r14,%r8
>   21:   44 89 e9                mov    %r13d,%ecx
>   24:   4c 89 e2                mov    %r12,%rdx
>   27:   48 8b 40 58             mov    0x58(%rax),%rax
>   2b:*  48 8b 78 58             mov    0x58(%rax),%rdi          <-- trapping instruction
>   2f:   31 c0                   xor    %eax,%eax
>   31:   e8 90 e4 92 ff          callq  0xffffffffff92e4c6
>   36:   48 8b 3c 24             mov    (%rsp),%rdi
>   3a:   48                      rex.W
>   3b:   c7                      .byte 0xc7
>   3c:   c6                      (bad)
>   3d:   2b 0a                   sub    (%rdx),%ecx
>   3f:   ca                      .byte 0xca
> 
> If I'm reading this correctly, efi.systab->runtime == 0xafafafafafafafaf,

I have no more clue yet from your provided log, but the runtime value is
odd to me. It is set in below code:

arch/x86/platform/efi/efi.c: efi_systab_init()
	efi_systab.runtime = data ?
			     (void *)(unsigned long)data->runtime :
			     (void *)(unsigne long)systab64->runtime;

Here data is the setup_data passed by kexec-tools from normal kernel to
kexec kernel, efi_setup_data structure is like below: 
struct efi_setup_data {
        u64 fw_vendor;
        u64 runtime;
        u64 tables;
        u64 smbios;
        u64 reserved[8];
};

kexec-tools get the runtime address from /sys/firmware/efi/runtime

So can you do some debuggin on your side, eg. see the sysfs runtime
value is correct or not. And add some printk in efi init path etc.

> and we're crashing when we try to dereference that.
> 
> Here is the output of efi=debug from before the crash:
> 
> [    0.000000] Linux version 4.11.0-rc1 (osandov-LNiRsUx2DMbOmZU/NTPFeQ2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org) (gcc version 4.8.5 20150623 (Red Hat 4.8.5-11) (GCC) ) #53 SMP Wed Mar 8 12:07:16 PST 2017
> [    0.000000] Command line: BOOT_IMAGE=/vmlinuz-4.6.7-34_fbk7_2504_g8275185 ro root=LABEL=/ ipv6.autoconf=0 erst_disable biosdevname=0 net.ifnames=0 fsck.repair=yes pcie_pme=nomsi netconsole=+6666@2401:db00:0011:b03e:face:0000:0009:0000/eth0,1514@2401:db00:eef0:a59::/02:90:fb:5b:b7:1e crashkernel=128M console=tty0 co
> nsole=ttyS1,57600 efi=debug
> [    0.000000] x86/fpu: Supporting XSAVE feature 0x001: 'x87 floating point registers'
> [    0.000000] x86/fpu: Supporting XSAVE feature 0x002: 'SSE registers'
> [    0.000000] x86/fpu: Supporting XSAVE feature 0x004: 'AVX registers'
> [    0.000000] x86/fpu: xstate_offset[2]:  576, xstate_sizes[2]:  256
> [    0.000000] x86/fpu: Enabled xstate features 0x7, context size is 832 bytes, using 'standard' format.
> [    0.000000] e820: BIOS-provided physical RAM map:
> [    0.000000] BIOS-e820: [mem 0x0000000000000100-0x000000000009ffff] usable
> [    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000750bdfff] usable
> [    0.000000] BIOS-e820: [mem 0x00000000750be000-0x0000000075ddbfff] reserved
> [    0.000000] BIOS-e820: [mem 0x0000000075ddc000-0x0000000075e32fff] ACPI data
> [    0.000000] BIOS-e820: [mem 0x0000000075e33000-0x000000007642dfff] ACPI NVS
> [    0.000000] BIOS-e820: [mem 0x000000007642e000-0x000000007bcd9fff] reserved
> [    0.000000] BIOS-e820: [mem 0x000000007bcda000-0x000000007bcdafff] usable
> [    0.000000] BIOS-e820: [mem 0x000000007bcdb000-0x000000007bd60fff] reserved
> [    0.000000] BIOS-e820: [mem 0x000000007bd61000-0x000000007bffffff] usable
> [    0.000000] BIOS-e820: [mem 0x000000007c000000-0x000000008fffffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed44fff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] reserved
> [    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000407fffffff] usable
> [    0.000000] NX (Execute Disable) protection: active
> [    0.000000] extended physical RAM map:
> [    0.000000] reserve setup_data: [mem 0x0000000000000100-0x000000000009ffff] usable
> [    0.000000] reserve setup_data: [mem 0x0000000000100000-0x000000000010006f] usable
> [    0.000000] reserve setup_data: [mem 0x0000000000100070-0x00000000750bdfff] usable
> [    0.000000] reserve setup_data: [mem 0x00000000750be000-0x0000000075ddbfff] reserved
> [    0.000000] reserve setup_data: [mem 0x0000000075ddc000-0x0000000075e32fff] ACPI data
> [    0.000000] reserve setup_data: [mem 0x0000000075e33000-0x000000007642dfff] ACPI NVS
> [    0.000000] reserve setup_data: [mem 0x000000007642e000-0x000000007bcd9fff] reserved
> [    0.000000] reserve setup_data: [mem 0x000000007bcda000-0x000000007bcdafff] usable
> [    0.000000] reserve setup_data: [mem 0x000000007bcdb000-0x000000007bd60fff] reserved
> [    0.000000] reserve setup_data: [mem 0x000000007bd61000-0x000000007bffffff] usable
> [    0.000000] reserve setup_data: [mem 0x000000007c000000-0x000000008fffffff] reserved
> [    0.000000] reserve setup_data: [mem 0x00000000fed1c000-0x00000000fed44fff] reserved
> [    0.000000] reserve setup_data: [mem 0x00000000ff000000-0x00000000ffffffff] reserved
> [    0.000000] reserve setup_data: [mem 0x0000000100000000-0x000000407fffffff] usable
> [    0.000000] efi: EFI v2.40 by American Megatrends
> [    0.000000] efi:  ACPI=0x75f5c000  ACPI 2.0=0x75f5c000  ESRT=0x7bc4d018  SMBIOS=0xf05e0  SMBIOS 3.0=0x7bb2f000  MPS=0xfc9e0
> [    0.000000] efi: mem00: [Runtime Data       |RUN|  |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x000000007642e000-0x000000007bc50fff] (88MB)
> [    0.000000] efi: mem01: [Runtime Code       |RUN|  |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x000000007bc51000-0x000000007bcd9fff] (0MB)
> [    0.000000] efi: mem02: [Runtime Data       |RUN|  |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x000000007bcdb000-0x000000007bd60fff] (0MB)
> [    0.000000] efi: mem03: [Memory Mapped I/O  |RUN|  |  |  |  |  |  |   |  |  |  |UC] range=[0x0000000080000000-0x000000008fffffff] (256MB)
> [    0.000000] efi: mem04: [Memory Mapped I/O  |RUN|  |  |  |  |  |  |   |  |  |  |UC] range=[0x00000000fed1c000-0x00000000fed44fff] (0MB)
> [    0.000000] efi: mem05: [Memory Mapped I/O  |RUN|  |  |  |  |  |  |   |  |  |  |UC] range=[0x00000000ff000000-0x00000000ffffffff] (16MB)
> [    0.000000] SMBIOS 3.0.0 present.
> [    0.000000] DMI: Wiwynn Leopard-Orv2/Leopard-DDR BW, BIOS LBM05   09/30/2016
> [    0.000000] e820: last_pfn = 0x4080000 max_arch_pfn = 0x400000000
> [    0.000000] x86/PAT: Configuration [0-7]: WB  WC  UC- UC  WB  WC  UC- WT
> [    0.000000] x2apic: enabled by BIOS, switching to x2apic ops
> [    0.000000] e820: last_pfn = 0x7c000 max_arch_pfn = 0x400000000
> [    0.000000] esrt: Reserving ESRT space from 0x000000007bc4d018 to 0x000000007bc4d050.
> 
> Reverting commit 8e80632fb23f ("efi/esrt: Use efi_mem_reserve() and
> avoid a kmalloc()") on top of v4.11-rc1 fixes the problem. Bisecting
> this was interesting:
> 
> - Up until 8e80632fb23f ("efi/esrt: Use efi_mem_reserve() and avoid a
>   kmalloc()"), kexec worked.
> 
> - From 8e80632fb23f to 9d80448ac92b ("efi/arm64: Add debugfs node to
>   dump UEFI runtime page tables"), kexec just hung after the
>   "kexec_core: Starting new kernel" message.
> 
> - From 3dad6f7f6975 ("x86/efi: Defer efi_esrt_init until after
>   memblock_x86_fill") to 0a637ee61247 ("x86/efi: Allow invocation of
>   arbitrary boot services"), kexec hit the BUG_ON(!efi.systab) in
>   kexec_enter_virtual_mode().
> 
> - Finally, after 92dc33501bfb ("x86/efi: Round EFI memmap reservations
>   to EFI_PAGE_SIZE"), I get the panic described above.
> 
> Let me know if there is any more information I can provide.
> 
> Thanks!

Thanks
Dave
