From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH v4 19/27] x86: assembly, make some functions local
Date: Wed, 4 Oct 2017 08:33:27 +0100
Message-ID: <CAKv+Gu-7q_Pr5SoUY_kUstaVusUxvXt9e8xeChQySGZ6h+jdAg@mail.gmail.com>
References: <20171002091246.28432-1-jslaby@suse.cz> <20171002091246.28432-19-jslaby@suse.cz>
 <CAKv+Gu9C88ToAx+8KcGacUECo7ExnTTBmibEjpB2WkfFvjoZvw@mail.gmail.com> <5a3785ea-d2d8-dd51-4b02-12f4ca5507d7@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5a3785ea-d2d8-dd51-4b02-12f4ca5507d7@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Jiri Slaby <jslaby@suse.cz>, Mark Rutland <mark.rutland@arm.com>
Cc: "mingo@redhat.com" <mingo@redhat.com>, "tglx@linutronix.de" <tglx@linutronix.de>, "hpa@zytor.com" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, xen-devel <xen-devel@lists.xenproject.org>
List-Id: linux-efi@vger.kernel.org

Hello Jiri,

On 4 October 2017 at 08:22, Jiri Slaby <jslaby@suse.cz> wrote:
> On 10/02/2017, 02:48 PM, Ard Biesheuvel wrote:
>> On 2 October 2017 at 10:12, Jiri Slaby <jslaby@suse.cz> wrote:
>>> There is a couple of assembly functions, which are invoked only locally
>>> in the file they are defined. In C, we mark them "static". In assembly,
>>> annotate them using SYM_{FUNC,CODE}_START_LOCAL (and switch their
>>> ENDPROC to SYM_{FUNC,CODE}_END too). Whether FUNC or CODE depends on
>>> ENDPROC/END for a particular function (C or non-C).
>>>
>>
>> I wasn't cc'ed on the cover letter, so I am missing the rationale of
>> replacing ENTRY/ENDPROC with other macros.
>
> There was no cover letter. I am attaching what is in PATCH 1/27 instead:
> Introduce new C macros for annotations of functions and data in
> assembly. There is a long-standing mess in macros like ENTRY, END,
> ENDPROC and similar. They are used in different manners and sometimes
> incorrectly.
>

I must say, I don't share this sentiment.

In arm64, we use ENTRY/ENDPROC for functions with external linkage,
and the bare symbol name/ENDPROC for functions with local linkage. I
guess we could add ENDOBJECT if we wanted to, but we never really felt
the need.

> So introduce macros with clear use to annotate assembly as follows:
>
> a) Support macros for the ones below
>    SYM_T_FUNC -- type used by assembler to mark functions
>    SYM_T_OBJECT -- type used by assembler to mark data
>    SYM_T_NONE -- type used by assembler to mark entries of unknown type
>

Is is necessary to mark an entry as having no type? What is the
default type for an unmarked entry?

>    They are defined as STT_FUNC, STT_OBJECT, and STT_NOTYPE
>    respectively. According to the gas manual, this is the most portable
>    way. I am not sure about other assemblers, so we can switch this back
>    to %function and %object if this turns into a problem. Architectures
>    can also override them by something like ", @function" if they need.
>
>    SYM_A_ALIGN, SYM_A_NONE -- align the symbol?
>    SYM_V_GLOBAL, SYM_V_WEAK, SYM_V_LOCAL -- visibility of symbols
>

Linkage != visibility

> b) Mostly internal annotations, used by the ones below
>    SYM_ENTRY -- use only if you have to (for non-paired symbols)
>    SYM_START -- use only if you have to (for paired symbols)
>    SYM_END -- use only if you have to (for paired symbols)
>
> c) Annotations for code
>    SYM_FUNC_START_LOCAL_ALIAS -- use where there are two local names for
>         one function
>    SYM_FUNC_START_ALIAS -- use where there are two global names for one
>         function
>    SYM_FUNC_END_ALIAS -- the end of LOCAL_ALIASed or ALIASed function
>
>    SYM_FUNC_START -- use for global functions
>    SYM_FUNC_START_NOALIGN -- use for global functions, w/o alignment
>    SYM_FUNC_START_LOCAL -- use for local functions
>    SYM_FUNC_START_LOCAL_NOALIGN -- use for local functions, w/o
>         alignment
>    SYM_FUNC_START_WEAK -- use for weak functions
>    SYM_FUNC_START_WEAK_NOALIGN -- use for weak functions, w/o alignment
>    SYM_FUNC_END -- the end of SYM_FUNC_START_LOCAL, SYM_FUNC_START,
>         SYM_FUNC_START_WEAK, ...
>
>    SYM_FUNC_INNER_LABEL -- only for labels in the middle of functions
>    SYM_FUNC_INNER_LABEL_NOALIGN -- only for labels in the middle of
>         functions, w/o alignment
>
>    For functions with special (non-C) calling conventions:
>    SYM_CODE_START -- use for non-C (special) functions
>    SYM_CODE_START_NOALIGN -- use for non-C (special) functions, w/o
>         alignment
>    SYM_CODE_START_LOCAL -- use for local non-C (special) functions
>    SYM_CODE_START_LOCAL_NOALIGN -- use for local non-C (special)
>         functions, w/o alignment
>    SYM_CODE_END -- the end of SYM_CODE_START_LOCAL or SYM_CODE_START
>
>    SYM_CODE_INNER_LABEL -- only for labels in the middle of code
>    SYM_CODE_INNER_LABEL_NOALIGN -- only for labels in the middle of code
>
> d) For data
>    SYM_DATA_START -- global data symbol
>    SYM_DATA_END -- the end of the SYM_DATA_START symbol
>    SYM_DATA_END_LABEL -- the labeled end of SYM_DATA_START symbol
>    SYM_DATA_SIMPLE -- start+end wrapper around simple global data
>    SYM_DATA_SIMPLE_LOCAL -- start+end wrapper around simple local data
>

I am sorry but I think this is terrible. Do we really need 20+ new
macros to wrap every single assembler directive involved in defining
symbols and setting their attributes?

Is this issue you are solving widely perceived as a problem?
