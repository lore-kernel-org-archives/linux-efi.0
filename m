From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH 01/13] x86/efi: Clean up efi CR3 save/restore
Date: Mon, 5 Jun 2017 09:14:05 -0700
Message-ID: <CALCETrX=14Mg+ZFdfTOBJh_KEBqk_bRNYvKR5DhUjyci0DqiBA@mail.gmail.com>
References: <20170602135207.21708-1-ard.biesheuvel@linaro.org>
 <20170602135207.21708-2-ard.biesheuvel@linaro.org> <20170605154058.r5b2eivguzhfrnnr@gmail.com>
 <CAKv+Gu8HG+hJyYdBLz5eO1QNCgYN4yrxrT+epPmbTGiS4vBi7w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKv+Gu8HG+hJyYdBLz5eO1QNCgYN4yrxrT+epPmbTGiS4vBi7w@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@alien8.de>, Matt Fleming <matt@codeblueprint.co.uk>
List-Id: linux-efi@vger.kernel.org

On Mon, Jun 5, 2017 at 9:03 AM, Ard Biesheuvel
<ard.biesheuvel@linaro.org> wrote:
> On 5 June 2017 at 15:40, Ingo Molnar <mingo@kernel.org> wrote:
>>
>> * Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
>>
>>> From: Andy Lutomirski <luto@kernel.org>
>>>
>>> efi_call_phys_prolog() used to return a "pgd_t *" that meant one of
>>> three different things depending on kernel and system configuration.
>>> Clean it up so it uses a union and is more explicit about what's
>>> going on.
>>>
>>> Signed-off-by: Andy Lutomirski <luto@kernel.org>
>>> Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>>> Cc: Borislav Petkov <bp@alien8.de>
>>> Cc: Andy Lutomirski <luto@amacapital.net>
>>> Cc: Ingo Molnar <mingo@kernel.org>
>>> Signed-off-by: Matt Fleming <matt@codeblueprint.co.uk>
>>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>>> ---
>>>  arch/x86/include/asm/efi.h     | 17 +++++++++++++++--
>>>  arch/x86/platform/efi/efi.c    |  6 +++---
>>>  arch/x86/platform/efi/efi_32.c | 12 ++++++------
>>>  arch/x86/platform/efi/efi_64.c | 22 ++++++++++++----------
>>>  4 files changed, 36 insertions(+), 21 deletions(-)
>>
>> Hm, this patch does not apply cleanly to v4.12-rc4:
>>
>>  Applying patch patches/x86efi_Clean_up_efi_CR3_saverestore-1.patch
>>  patching file arch/x86/include/asm/efi.h
>>  patching file arch/x86/platform/efi/efi.c
>>  patching file arch/x86/platform/efi/efi_32.c
>>  patching file arch/x86/platform/efi/efi_64.c
>>  Hunk #1 FAILED at 69.
>>  Hunk #2 FAILED at 86.
>>  Hunk #3 succeeded at 152 with fuzz 1 (offset 44 lines).
>>  Hunk #4 FAILED at 116.
>>  3 out of 4 hunks FAILED -- rejects in file arch/x86/platform/efi/efi_64.c
>>
>> what tree is this against?
>>
>
> This is against v4.12-rc3, which lacked the EFI fix Matt sent out in
> the mean time.
>
> Feel free to drop it for now, and we can requeue it later if Andy is
> willing to rebase it.

I had hoped this would make it into 4.12-rc1 so I could base PCID on
top of it.  I'll probably resend it once PCID lands and base it on
PCID instead.  (It's a trivial one-line conflict, but still...)

--Andy
