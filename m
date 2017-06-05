From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 01/13] x86/efi: Clean up efi CR3 save/restore
Date: Mon, 5 Jun 2017 16:03:00 +0000
Message-ID: <CAKv+Gu8HG+hJyYdBLz5eO1QNCgYN4yrxrT+epPmbTGiS4vBi7w@mail.gmail.com>
References: <20170602135207.21708-1-ard.biesheuvel@linaro.org>
 <20170602135207.21708-2-ard.biesheuvel@linaro.org> <20170605154058.r5b2eivguzhfrnnr@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170605154058.r5b2eivguzhfrnnr-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 5 June 2017 at 15:40, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> * Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
>
>> From: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>>
>> efi_call_phys_prolog() used to return a "pgd_t *" that meant one of
>> three different things depending on kernel and system configuration.
>> Clean it up so it uses a union and is more explicit about what's
>> going on.
>>
>> Signed-off-by: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>> Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>> Cc: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
>> Cc: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
>> Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>> Signed-off-by: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>> ---
>>  arch/x86/include/asm/efi.h     | 17 +++++++++++++++--
>>  arch/x86/platform/efi/efi.c    |  6 +++---
>>  arch/x86/platform/efi/efi_32.c | 12 ++++++------
>>  arch/x86/platform/efi/efi_64.c | 22 ++++++++++++----------
>>  4 files changed, 36 insertions(+), 21 deletions(-)
>
> Hm, this patch does not apply cleanly to v4.12-rc4:
>
>  Applying patch patches/x86efi_Clean_up_efi_CR3_saverestore-1.patch
>  patching file arch/x86/include/asm/efi.h
>  patching file arch/x86/platform/efi/efi.c
>  patching file arch/x86/platform/efi/efi_32.c
>  patching file arch/x86/platform/efi/efi_64.c
>  Hunk #1 FAILED at 69.
>  Hunk #2 FAILED at 86.
>  Hunk #3 succeeded at 152 with fuzz 1 (offset 44 lines).
>  Hunk #4 FAILED at 116.
>  3 out of 4 hunks FAILED -- rejects in file arch/x86/platform/efi/efi_64.c
>
> what tree is this against?
>

This is against v4.12-rc3, which lacked the EFI fix Matt sent out in
the mean time.

Feel free to drop it for now, and we can requeue it later if Andy is
willing to rebase it.

Thanks,
Ard.
