From: Nick Desaulniers <ndesaulniers@google.com>
Subject: Re: [PATCH v2 2/2] x86: paravirt: make native_save_fl extern inline
Date: Tue, 5 Jun 2018 10:52:42 -0700
Message-ID: <CAKwvOdk0v4gY04_pbMeUT7Ly5oRHetKorQXnjp_UVBabK74Ekw@mail.gmail.com>
References: <20180605170532.170361-1-ndesaulniers@google.com>
 <20180605170532.170361-3-ndesaulniers@google.com> <26c7fd1c-ab40-368f-c2e3-43a6b45157fd@zytor.com>
 <0dd024cd-e05a-0d67-c1bf-1a532714bb1a@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <0dd024cd-e05a-0d67-c1bf-1a532714bb1a@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
To: hpa@zytor.com
Cc: Andrew Morton <akpm@linux-foundation.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Andrey Ryabinin <aryabinin@virtuozzo.com>, akataria@vmware.com, boris.ostrovsky@oracle.com, brijesh.singh@amd.com, Cao jin <caoj.fnst@cn.fujitsu.com>, Greg KH <gregkh@linuxfoundation.org>, "J. Kiszka" <jan.kiszka@siemens.com>, jarkko.sakkinen@linux.intel.com, jgross@suse.com, Josh Poimboeuf <jpoimboe@redhat.com>, kirill.shutemov@linux.intel.com, mingo@redhat.com, mjg59@google.com, Matthias Kaehlcke <mka@chromium.org>, Philippe Ombredanne <pombredanne@nexb.com>, rostedt@goodmis.org, Thomas Gleixner <tglx@linutronix.de>, thomas.lendacky@amd.com, Thiebaud Weksteen <tweek@google.com>, linux-efi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, x86@kernel.org, virtualization@lists.
List-Id: linux-efi@vger.kernel.org

On 06/05/18 10:28, H. Peter Anvin wrote:
> On 06/05/18 10:05, Nick Desaulniers wrote:
>> +
>> +/*
>> + * void native_restore_fl(unsigned long flags)
>> + * %rdi: flags
>> + */
>> +ENTRY(native_restore_fl)
>> +    push %_ASM_DI
>> +    popf
>> +    ret
>> +ENDPROC(native_restore_fl)
>> +EXPORT_SYMBOL(native_restore_fl)
>>
>
> To work on i386, this would have to be %_ASM_AX in that case.

?

Does the kernel have a different calling convention for 32b x86? How
does that work? regparm=3? Does that need to be added to the
declaration?

> Something like this added to <asm/asm.h> might be useful; then you can
> simply:
>
>       push %_ASM_ARG1
>
> Version with fixed typo...

Oh, nice, thanks! I'll pick this up and add it to my patch set for v3
(or did you want me to review/sign-off now?) I can pick up Sedat's
suggestion.
-- 
Thanks,
~Nick Desaulniers
