From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH V4 0/3] Add efi page fault handler to recover from page
Date: Fri, 7 Sep 2018 12:42:51 +0200
Message-ID: <CAKv+Gu8F76ngzr_zgAXZhDPNb2SobYc4A8L3Rq-h1kMrbFqK+A@mail.gmail.com>
References: <1536276468-28499-1-git-send-email-sai.praneeth.prakhya@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1536276468-28499-1-git-send-email-sai.praneeth.prakhya@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
Cc: linux-efi <linux-efi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, the arch/x86 maintainers <x86@kernel.org>, "Neri, Ricardo" <ricardo.neri@intel.com>, Matt Fleming <matt@codeblueprint.co.uk>, Al Stone <astone@redhat.com>, Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, Bhupesh Sharma <bhsharma@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Peter Zijlstra <peterz@infradead.org>
List-Id: linux-efi@vger.kernel.org

On 7 September 2018 at 01:27, Sai Praneeth Prakhya
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

Thanks Sai! I am pretty happy how this patch set turned out. It still
requires the blessing of the x86 maintainers, of course, but from my
pov, this is good to go (but I will fold patch #3 into #2)

Thomas, Ingo, Peter, Andy, Boris: any remaining concerns?


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
