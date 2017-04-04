From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [GIT PULL 00/12] EFI updates for v4.12
Date: Tue, 4 Apr 2017 17:06:41 +0100
Message-ID: <CAKv+Gu9zJ+LwL6fszp9m08xycXN-2n6JqDvGR6PEhEn=0bRuCQ@mail.gmail.com>
References: <20170404160245.27812-1-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170404160245.27812-1-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>, Andy Lutomirski <luto@kernel.org>, Baoquan He <bhe@redhat.com>, Bhupesh Sharma <bhsharma@redhat.com>, Borislav Petkov <bp@alien8.de>, Eugene Cohen <eugene@hp.com>, Evgeny Kalugin <evgeny.kalugin@intel.com>, Jeffrey Hugo <jhugo@codeaurora.org>, Leif Lindholm <leif.lindholm@linaro.org>, Mark Rutland <mark.rutland@arm.com>, Matt Fleming <matt@codeblueprint.co.uk>, Richard Ruigrok <rruigrok@codeaurora.org>, Roy Franz <roy.franz@cavium.com>
List-Id: linux-efi@vger.kernel.org

On 4 April 2017 at 17:02, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> Hello all,
>
> This is what we have queued up for v4.12 so far. Please pull it so that it
> gets some exposure in -next before the merge window.
>
> The following changes since commit 4495c08e84729385774601b5146d51d9e5849f81:
>
>   Linux 4.11-rc2 (2017-03-12 14:47:08 -0700)
>
> are available in the git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git tags/efi-next
>
> for you to fetch changes up to efc491b0f06f65ea588f6591f0bc31db779e0594:
>
>   ef/libstub: arm/arm64: Randomize the base of the UEFI rt services region (2017-04-02 16:36:29 +0100)
>
> ----------------------------------------------------------------
> EFI changes for v4.12:
> - move BGRT handling to drivers/acpi so it can be shared between x86
>   and ARM
> - bring the EFI stub's initrd and FDT allocation logic in line with
>   the latest changes to the arm64 boot protocol
> - some changes to the EFI stub's command line parsing routines -- share
>   more code, fix a minor buglet and add support for the 'quiet' command
>   line parameter on ARM/arm64 (whose EFI stub is a bit noisy by default)
> - randomize the virtual mapping of the UEFI runtime services on ARM/arm64
> - other minor enhancements and fixes
>
> ----------------------------------------------------------------
> Andy Lutomirski (1):
>       x86/efi: Clean up efi CR3 save/restore
>
> Ard Biesheuvel (7):
>       efi: arm-stub: Correct FDT and initrd allocation rules for arm64
>       efi: arm-stub: Round up FDT allocation to mapping size
>       efi/arm32-stub: Allow boottime allocations in the vmlinux region
>       efi/libstub: Fix harmless command line parsing bug
>       efi/libstub: Unify command line param parsing
>       efi/libstub: arm/arm64: Disable debug prints on 'quiet' cmdline arg
>       ef/libstub: arm/arm64: Randomize the base of the UEFI rt services region
>
> Baoquan He (1):
>       x86/efi: Clean up a minor mistake in code comment
>
> Bhupesh Sharma (2):
>       x86/efi-bgrt: Move efi-bgrt handling out of arch/x86
>       efi: bgrt: Enable ACPI BGRT handling on arm64
>
> Evgeny Kalugin (1):
>       pstore: return error code (if any) from efi_pstore_write
>
>  arch/arm/include/asm/efi.h                         |  14 +-
>  arch/arm64/include/asm/efi.h                       |  24 +++-
>  arch/arm64/kernel/acpi.c                           |   3 +
>  arch/x86/include/asm/efi.h                         |  17 ++-
>  arch/x86/kernel/acpi/boot.c                        |   6 -
>  arch/x86/platform/efi/Makefile                     |   1 -
>  arch/x86/platform/efi/efi.c                        |   6 +-
>  arch/x86/platform/efi/efi_32.c                     |  12 +-
>  arch/x86/platform/efi/efi_64.c                     |  24 ++--
>  drivers/acpi/Kconfig                               |   2 +-
>  drivers/acpi/bgrt.c                                |   6 +
>  drivers/firmware/efi/Makefile                      |   1 +
>  .../platform => drivers/firmware}/efi/efi-bgrt.c   |   0
>  drivers/firmware/efi/efi-pstore.c                  |   6 +-
>  drivers/firmware/efi/libstub/arm-stub.c            |  80 ++++++-----
>  drivers/firmware/efi/libstub/arm32-stub.c          | 150 ++++++++++++++++++---
>  drivers/firmware/efi/libstub/arm64-stub.c          |   4 +-
>  drivers/firmware/efi/libstub/efi-stub-helper.c     |  32 +++--
>  drivers/firmware/efi/libstub/efistub.h             |   9 ++
>  drivers/firmware/efi/libstub/fdt.c                 |  57 ++++----
>  drivers/firmware/efi/libstub/secureboot.c          |   2 +
>  include/linux/efi-bgrt.h                           |   5 +
>  include/linux/efi.h                                |   5 +-
>  23 files changed, 328 insertions(+), 138 deletions(-)
>  rename {arch/x86/platform => drivers/firmware}/efi/efi-bgrt.c (100%)


It appears I accidentally sent out the following patches again in
reply to this pull request.

Ard Biesheuvel (1):
      efifb: Avoid reconfiguration of BAR that covers the framebuffer

Cohen, Eugene (1):
      efi/libstub: Skip GOP with PIXEL_BLT_ONLY format

Those are fixes for v4.11, not updates for v4.12 -- please disregard.
Apologies for the mixup.
