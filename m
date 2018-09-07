From: Bhupesh Sharma <bhsharma@redhat.com>
Subject: Re: [PATCH V4 0/3] Add efi page fault handler to recover from page
Date: Sat, 8 Sep 2018 00:33:55 +0530
Message-ID: <CACi5LpP4=VprRuabhKVXWy+JmKB1WNri+OA3aMSw=Q7-obo_TA@mail.gmail.com>
References: <1536276468-28499-1-git-send-email-sai.praneeth.prakhya@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1536276468-28499-1-git-send-email-sai.praneeth.prakhya@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
Cc: linux-efi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, x86@kernel.org, "Neri, Ricardo" <ricardo.neri@intel.com>, Matt Fleming <matt@codeblueprint.co.uk>, Al Stone <astone@redhat.com>, Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Peter Zijlstra <peterz@infradead.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: linux-efi@vger.kernel.org

On Fri, Sep 7, 2018 at 4:57 AM, Sai Praneeth Prakhya
<sai.praneeth.prakhya@intel.com> wrote:
> From: Sai Praneeth <sai.praneeth.prakhya@intel.com>
>
> There may exist some buggy UEFI firmware implementations that access efi
> memory regions other than EFI_RUNTIME_SERVICES_<CODE/DATA> even after
> the kernel has assumed control of the platform. This violates UEFI
> specification. Hence, provide a debug config option which when enabled
> recovers from page faults caused by buggy firmware.
>
> Page faults triggered by firmware happen at ring 0 and if unhandled,
> hangs the kernel. So, provide an efi specific page fault handler to:
> 1. Avoid panics/hangs caused by buggy firmware.
> 2. Shout loud that the firmware is buggy and hence is not a kernel bug.
>
> The efi page fault handler will check if the access is by
> efi_reset_system().
> 1. If so, then the efi page fault handler will reboot the machine
>    through BIOS and not through efi_reset_system().
> 2. If not, then the efi page fault handler will freeze efi_rts_wq and
>    schedules a new process.
>
> This issue was reported by Al Stone when he saw that reboot via EFI hangs
> the machine. Upon debugging, I found that it's efi_reset_system() that's
> touching memory regions which it shouldn't. To reproduce the same
> behavior, I have hacked OVMF and made efi_reset_system() buggy. Along
> with efi_reset_system(), I have also modified get_next_high_mono_count()
> and set_virtual_address_map(). They illegally access both boot time and
> other efi regions.
>
> Testing the patch set:
> ----------------------
> 1. Download buggy firmware from here [1].
> 2. Run a qemu instance with this buggy BIOS and boot mainline kernel.
> Add reboot=efi to the kernel command line arguments and after the kernel
> is up and running, type "reboot". The kernel should hang while rebooting.
> 3. With the same setup, boot kernel after applying patches and the
> reboot should work fine. Also please notice warning/error messages
> printed by kernel.
>
> Changes from RFC to V1:
> -----------------------
> 1. Drop "long jump" technique of dealing with illegal access and instead
>    use scheduling away from efi_rts_wq.
>
> Changes from V1 to V2:
> ----------------------
> 1. Shortened config name to CONFIG_EFI_WARN_ON_ILLEGAL_ACCESS from
>    CONFIG_EFI_WARN_ON_ILLEGAL_ACCESSES.
> 2. Made the config option available only to expert users.
> 3. efi_free_boot_services() should be called only when
>    CONFIG_EFI_WARN_ON_ILLEGAL_ACCESS is not enabled. Previously, this
>    was part of init/main.c file. As it is an architecture agnostic code,
>    moved the change to arch/x86/platform/efi/quirks.c file.
>
> Changes from V2 to V3:
> ----------------------
> 1. Drop treating illegal access to EFI_BOOT_SERVICES_<CODE/DATA> regions
>    separatley from illegal accesses to other regions like
>    EFI_CONVENTIONAL_MEMORY or EFI_LOADER_<CODE/DATA>.
>    In previous versions, illegal access to EFI_BOOT_SERVICES_<CODE/DATA>
>    regions were handled by mapping requested region to efi_pgd but from
>    V3 they are handled similar to illegal access to other regions i.e by
>    freezing efi_rts_wq and scheduling new process.
> 2. Change __efi_init_fixup attribute to __efi_init.
>
> Changes from V3 to V4:
> ----------------------
> 1. Drop saving original memory map passed by kernel. It also means less
>    checks in efi page fault handler.
> 2. Change the config name to EFI_PAGE_FAULT_HANDLER to reflect it's
>    functionality more appropriatley.
>
> Note:
> -----
> Patch set based on "next" branch in efi tree.
>
> [1] https://drive.google.com/drive/folders/1VozKTms92ifyVHAT0ZDQe55ZYL1UE5wt
>
> Sai Praneeth (3):
>   efi: Make efi_rts_work accessible to efi page fault handler
>   x86/efi: Add efi page fault handler to recover from page faults caused
>         by the firmware
>   x86/efi: Introduce EFI_PAGE_FAULT_HANDLER
>
>  arch/x86/Kconfig                        | 18 +++++++++
>  arch/x86/include/asm/efi.h              |  9 +++++
>  arch/x86/mm/fault.c                     |  9 +++++
>  arch/x86/platform/efi/quirks.c          | 70 +++++++++++++++++++++++++++++++++
>  drivers/firmware/efi/runtime-wrappers.c | 60 ++++++++--------------------
>  include/linux/efi.h                     | 37 +++++++++++++++++
>  6 files changed, 159 insertions(+), 44 deletions(-)
>
> Suggested-by: Matt Fleming <matt@codeblueprint.co.uk>
> Based-on-code-from: Ricardo Neri <ricardo.neri@intel.com>
> Signed-off-by: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
> Cc: Al Stone <astone@redhat.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Andy Lutomirski <luto@kernel.org>
> Cc: Bhupesh Sharma <bhsharma@redhat.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>
> --
> 2.7.4
>

Thanks Sai for this work. I think this a step in the right direction.
I tested this on qemu x86_64 with OVMF firmware modified to access
some random address in the EFI_Reserved_Region. I was able to reboot
the qemu instance successfully with the patches (see logs below) while
without the patchset, reboot earlier used to get stuck.

So, feel free to add:
Tested-by: Bhupesh Sharma <bhsharma@redhat.com>

Qemu Console Logs:
---------------------------

# reboot

<snip..>

[   11.400004] ------------[ cut here ]------------
[   11.400137] [Firmware Bug]: Page fault caused by firmware at PA: 0x7e924100
[   11.400484] WARNING: CPU: 0 PID: 1111 at
arch/x86/platform/efi/quirks.c:691
efi_recover_from_page_fault+0x3b/0xf0
[   11.400751] Modules linked in:
[   11.400992] CPU: 0 PID: 1111 Comm: init Not tainted 4.18.0-rc5+ #1
[   11.401146] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS 0.0.0 02/06/2015
[   11.401397] RIP: 0010:efi_recover_from_page_fault+0x3b/0xf0
[   11.401547] Code: e0 03 00 00 e0 6e 8d 91 0f 85 9e 00 00 00 48 81
ff ff 0f 00 00 0f 86 91 00 00 00 48 89 fe 48 c7 c7 b8 e6 5d 91 e8 65
41 00 00 <0f> 0b 83 3d dc 19 8a 01 09 0f 84 89 00 00 00 48 c7 04 24 02
00 00
[   11.402185] RSP: 0018:ffffb91080d6ba70 EFLAGS: 00000086
[   11.402330] RAX: 0000000000000000 RBX: ffff98b53e34c980 RCX: ffffffff91845d38
[   11.402502] RDX: 0000000000000001 RSI: 0000000000000086 RDI: ffffffff91e8986c
[   11.402706] RBP: ffffb91080d6bb58 R08: 7269662079622064 R09: 00000000000001fe
[   11.402881] R10: 0000000000000000 R11: 3030313432396537 R12: ffff98b53e34c980
[   11.403051] R13: 0000000000000002 R14: 000000000000000b R15: 0000000000000001
[   11.403259] FS:  00007f7d510fe700(0000) GS:ffff98b53f600000(0000)
knlGS:0000000000000000
[   11.403452] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   11.403602] CR2: 000000007e924100 CR3: 000000007ec9c000 CR4: 00000000000006f0
[   11.403823] Call Trace:
[   11.404368]  no_context+0x130/0x3a0
[   11.404509]  __do_page_fault+0x39a/0x4b0
[   11.404623]  page_fault+0x1e/0x30
[   11.404811] RIP: 0010:0xfffffffeffbba977
[   11.404908] Code: 89 d5 56 53 4d 89 c4 89 cb 48 83 ec 48 e8 cb 05
00 00 84 c0 41 88 c6 74 11 48 8d 15 3e 15 00 00 b9 00 00 00 80 e8 f8
07 00 00 <48> c7 04 25 00 41 92 7e 0a 00 00 00 48 83 3d c5 29 00 00 00
75 30
[   11.405544] RSP: 0018:ffffb91080d6bc00 EFLAGS: 00000082
[   11.405683] RAX: 0000000000000041 RBX: 0000000000000000 RCX: ffffb91080d6bae0
[   11.405849] RDX: 00000000000003f8 RSI: 0000000000000000 RDI: fffffffeffbba93f
[   11.406016] RBP: 0000000000000000 R08: 0000000000000041 R09: 0000000000000041
[   11.406184] R10: 00000000000003fd R11: 00000000000003f8 R12: 0000000000000000
[   11.406369] R13: 0000000000000000 R14: 0000000000000001 R15: 0000000000000000
[   11.406593]  ? serial8250_console_putchar+0x11/0x20
[   11.406725]  ? efi_call+0x58/0x90
[   11.406815]  ? msg_print_text+0x9c/0x100
[   11.406927]  ? virt_efi_reset_system+0x81/0x100
[   11.407042]  ? efi_reboot+0x85/0xe0
[   11.407131]  ? native_machine_emergency_restart+0x17f/0x260
[   11.407267]  ? clear_local_APIC.part.13+0x1e3/0x220
[   11.407394]  ? __do_sys_reboot+0x1ee/0x210
[   11.407501]  ? __switch_to_asm+0x40/0x70
[   11.407613]  ? __switch_to_asm+0x34/0x70
[   11.407716]  ? __switch_to_asm+0x40/0x70
[   11.407817]  ? __switch_to_asm+0x34/0x70
[   11.407916]  ? __switch_to_asm+0x40/0x70
[   11.408017]  ? __switch_to_asm+0x34/0x70
[   11.408117]  ? __switch_to_asm+0x40/0x70
[   11.408217]  ? __switch_to_asm+0x34/0x70
[   11.408317]  ? __switch_to_asm+0x40/0x70
[   11.408417]  ? __switch_to_asm+0x34/0x70
[   11.408515]  ? __switch_to_asm+0x40/0x70
[   11.408620]  ? __switch_to_asm+0x34/0x70
[   11.408718]  ? __switch_to_asm+0x40/0x70
[   11.408814]  ? __switch_to_asm+0x34/0x70
[   11.408909]  ? __switch_to_asm+0x40/0x70
[   11.409005]  ? __switch_to_asm+0x34/0x70
[   11.409113]  ? __switch_to_asm+0x40/0x70
[   11.409209]  ? __switch_to_asm+0x34/0x70
[   11.409303]  ? __switch_to_asm+0x40/0x70
[   11.409396]  ? __switch_to_asm+0x34/0x70
[   11.409491]  ? __switch_to_asm+0x40/0x70
[   11.409589]  ? __switch_to_asm+0x34/0x70
[   11.409685]  ? __switch_to_asm+0x40/0x70
[   11.409781]  ? __switch_to_asm+0x34/0x70
[   11.409879]  ? __switch_to_asm+0x40/0x70
[   11.409980]  ? __switch_to_asm+0x34/0x70
[   11.410079]  ? __switch_to_asm+0x40/0x70
[   11.410178]  ? __switch_to_asm+0x34/0x70
[   11.410281]  ? do_syscall_64+0x39/0xe0
[   11.410378]  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9
[   11.410554] ---[ end trace ad3d0a220a88a45b ]---
[   11.410742] efi: efi_reset_system() buggy! Reboot through BIOS

<snip..>

Thanks,
Bhupesh
