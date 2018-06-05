From: Sedat Dilek <sedat.dilek@gmail.com>
Subject: Re: [PATCH v2 2/2] x86: paravirt: make native_save_fl extern inline
Date: Tue, 5 Jun 2018 19:46:19 +0200
Message-ID: <CA+icZUXecX5s+ZD9Nfp3uXCWRyD7zbBg5WgxCintR9Baco6smA@mail.gmail.com>
References: <20180605170532.170361-1-ndesaulniers@google.com>
 <20180605170532.170361-3-ndesaulniers@google.com> <26c7fd1c-ab40-368f-c2e3-43a6b45157fd@zytor.com>
 <0dd024cd-e05a-0d67-c1bf-1a532714bb1a@zytor.com>
Reply-To: sedat.dilek@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <0dd024cd-e05a-0d67-c1bf-1a532714bb1a@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Nick Desaulniers <ndesaulniers@google.com>, akpm@linux-foundation.org, ard.biesheuvel@linaro.org, aryabinin@virtuozzo.com, akataria@vmware.com, boris.ostrovsky@oracle.com, brijesh.singh@amd.com, caoj.fnst@cn.fujitsu.com, gregkh@linuxfoundation.org, jan.kiszka@siemens.com, jarkko.sakkinen@linux.intel.com, jgross@suse.com, jpoimboe@redhat.com, kirill.shutemov@linux.intel.com, mingo@redhat.com, mjg59@google.com, mka@chromium.org, pombredanne@nexb.com, rostedt@goodmis.org, tglx@linutronix.de, thomas.lendacky@amd.com, tweek@google.com, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org, virtualization@lists.linux-foundation.org, astrachan@google.com, manojgupta@google.com, ghackmann@google.com, tstellar@redhat.com, keescook@google.com, yamada.masahiro@socion
List-Id: linux-efi@vger.kernel.org

On Tue, Jun 5, 2018 at 7:31 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 06/05/18 10:28, H. Peter Anvin wrote:
>> On 06/05/18 10:05, Nick Desaulniers wrote:
>>> +
>>> +/*
>>> + * void native_restore_fl(unsigned long flags)
>>> + * %rdi: flags
>>> + */
>>> +ENTRY(native_restore_fl)
>>> +    push %_ASM_DI
>>> +    popf
>>> +    ret
>>> +ENDPROC(native_restore_fl)
>>> +EXPORT_SYMBOL(native_restore_fl)
>>>
>>
>> To work on i386, this would have to be %_ASM_AX in that case.
>>
>> Something like this added to <asm/asm.h> might be useful; then you can
>> simply:
>>
>>       push %_ASM_ARG1
>>
>
> Version with fixed typo...

Small typo in the commit-subject... s/argument registes/argument registers

- sed@ -
