From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [Patch v3 0/4] Protect against concurrent calls into UV BIOS
Date: Thu, 14 Feb 2019 09:17:37 +0100
Message-ID: <CAKv+Gu9MkLBv_unbhjikwOTit4xC0-WmS_HMLr1RQ+FZAoW_9g@mail.gmail.com>
References: <20190213193413.25560-1-hedi.berriche@hpe.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20190213193413.25560-1-hedi.berriche@hpe.com>
Sender: stable-owner@vger.kernel.org
To: Hedi Berriche <hedi.berriche@hpe.com>, Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Bhupesh Sharma <bhsharma@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, linux-efi <linux-efi@vger.kernel.org>, the arch/x86 maintainers <x86@kernel.org>, Russ Anderson <rja@hpe.com>, Mike Travis <mike.travis@hpe.com>, Dimitri Sivanich <sivanich@hpe.com>, Steve Wahl <steve.wahl@hpe.com>, stable <stable@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On Wed, 13 Feb 2019 at 20:34, Hedi Berriche <hedi.berriche@hpe.com> wrote:
>
> - Changes since v2
>   Addressed comments from Ard Biesheuvel:
>  * expose efi_runtime_lock to UV platform only instead of globally
>  * remove unnecessary #ifdef CONFIG_EFI from bios_uv.c
>
> - Changes since v1:
>   Addressed comments from Bhupesh Sharma, Thomas Gleixner, and Ard Biesheuvel:
>  * made __uv_bios_call() static
>  * moved the efi_enabled() cleanup to its own patchlet
>  * explained the reason for renaming the efi_runtime_lock semaphore
>  * dropped the reviewed-bys as they should be given on the mailing list
>  * Cc'ng stable@vger.kernel.org given the nature of the problem addressed by the patches
>

Hi Hedi,

The patches look good to me now.

For the series,

Reviewed-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

However, I don't think all the patches should go to -stable. Only 4/4
fixes an actual bug, and the remaining patches don't look like they
are prerequisites for that change.

Also, if your colleagues reviewed your patches, now would be the time
to ask them to give their Reviewed-by as well.

-- 
Ard.



> ---
>
> Calls into UV BIOS were not being serialised which is wrong as it violates EFI
> runtime rules, and bad as it does result in all sorts of potentially hard to
> track down hangs and panics when efi_scratch.prev_mm gets clobbered whenever
> efi_switch_mm() gets called concurrently from two different CPUs.
>
> Patch #1 removes an unnecessary #ifdef CONFIG_EFI guard from bios_uv.c.
>
> Patch #2 removes uv_bios_call_reentrant() because it's dead code.
>
> Patch #3 is a cleanup that drops test_bit() in favour of the ad hoc efi_enabled().
>
> Patch #4 makes uv_bios_call() variants use the efi_runtime_lock semaphore to
> protect against concurrency.
>
> Cc: Russ Anderson <rja@hpe.com>
> Cc: Mike Travis <mike.travis@hpe.com>
> Cc: Dimitri Sivanich <sivanich@hpe.com>
> Cc: Steve Wahl <steve.wahl@hpe.com>
> Cc: stable@vger.kernel.org # v4.9+
>
> Hedi Berriche (4):
>   x86/platform/UV: remove unnecessary #ifdef CONFIG_EFI
>   x86/platform/UV: kill uv_bios_call_reentrant() as it has no callers
>   x86/platform/UV: use efi_enabled() instead of test_bit()
>   x86/platform/UV: use efi_runtime_lock to serialise BIOS calls
>
>  arch/x86/include/asm/uv/bios.h          | 13 ++++-----
>  arch/x86/platform/uv/bios_uv.c          | 35 ++++++++++++++-----------
>  drivers/firmware/efi/runtime-wrappers.c |  7 +++++
>  3 files changed, 34 insertions(+), 21 deletions(-)
>
> --
> 2.20.1
>
