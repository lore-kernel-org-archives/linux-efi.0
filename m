From: Jiri Slaby <jslaby-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH v4 19/27] x86: assembly, make some functions local
Date: Fri, 6 Oct 2017 14:53:08 +0200
Message-ID: <9dfcee94-2058-8986-526c-f7ef9ebada66@suse.cz>
References: <20171002091246.28432-1-jslaby@suse.cz>
 <20171002091246.28432-19-jslaby@suse.cz>
 <CAKv+Gu9C88ToAx+8KcGacUECo7ExnTTBmibEjpB2WkfFvjoZvw@mail.gmail.com>
 <5a3785ea-d2d8-dd51-4b02-12f4ca5507d7@suse.cz>
 <CAKv+Gu-7q_Pr5SoUY_kUstaVusUxvXt9e8xeChQySGZ6h+jdAg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKv+Gu-7q_Pr5SoUY_kUstaVusUxvXt9e8xeChQySGZ6h+jdAg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-GB
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Cc: "mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org" <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, xen-devel <xen-devel-GuqFBffKawtpuQazS67q72D2FQJk+8+b@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Hi,

On 10/04/2017, 09:33 AM, Ard Biesheuvel wrote:
> On 4 October 2017 at 08:22, Jiri Slaby <jslaby-AlSwsSmVLrQ@public.gmane.org> wrote:
>> On 10/02/2017, 02:48 PM, Ard Biesheuvel wrote:
>>> On 2 October 2017 at 10:12, Jiri Slaby <jslaby-AlSwsSmVLrQ@public.gmane.org> wrote:
>>>> There is a couple of assembly functions, which are invoked only locally
>>>> in the file they are defined. In C, we mark them "static". In assembly,
>>>> annotate them using SYM_{FUNC,CODE}_START_LOCAL (and switch their
>>>> ENDPROC to SYM_{FUNC,CODE}_END too). Whether FUNC or CODE depends on
>>>> ENDPROC/END for a particular function (C or non-C).
>>>>
>>>
>>> I wasn't cc'ed on the cover letter, so I am missing the rationale of
>>> replacing ENTRY/ENDPROC with other macros.
>>
>> There was no cover letter. I am attaching what is in PATCH 1/27 instead:
>> Introduce new C macros for annotations of functions and data in
>> assembly. There is a long-standing mess in macros like ENTRY, END,
>> ENDPROC and similar. They are used in different manners and sometimes
>> incorrectly.
>>
> 
> I must say, I don't share this sentiment.
> 
> In arm64, we use ENTRY/ENDPROC for functions with external linkage,
> and the bare symbol name/ENDPROC for functions with local linkage. I
> guess we could add ENDOBJECT if we wanted to, but we never really felt
> the need.

Yes and this is exactly the reason for the new macros. Now, it's a
complete mess. One arch does this, another does that. And we are in a
state to have reliable stacktraces, let objtool check functions, let
objtool generate annotations (e.g. for ORC unwinder), etc.

Without knowing what is start, where is its end, what is function, what
is object (data) etc., it can barely check or even generate anything
automatically. Not speaking about impaired macros like your name/ENDPROC
above.

There was a cleanup in x86 done by Josh and others that we have at least
correct ENTRY+END and ENTRY+ENDPROC annotations in most cases now. Even
though it was concluded the names are weird (leftover from the past). So
yes, there was a discussion about the cleanup, naming and such. And I
came up with the names in this e-mail.

http://lkml.kernel.org/r/%3C20170217104757.28588-1-jslaby-AlSwsSmVLrQ@public.gmane.org%3E

>> So introduce macros with clear use to annotate assembly as follows:
>>
>> a) Support macros for the ones below
>>    SYM_T_FUNC -- type used by assembler to mark functions
>>    SYM_T_OBJECT -- type used by assembler to mark data
>>    SYM_T_NONE -- type used by assembler to mark entries of unknown type
>>
> 
> Is is necessary to mark an entry as having no type? What is the
> default type for an unmarked entry?

The default is indeed T_NONE. The thing is that most macros use
SYM_START and SYM_END which requires the type as argument. So for
convenience, we define also SYM_T_NONE used e.g. to define SYM_CODE_END:
#define SYM_CODE_END(name)                              \
        SYM_END(CODE, name, SYM_T_NONE)

Despite it needs not be there. But users of the macros should not care.

>>    They are defined as STT_FUNC, STT_OBJECT, and STT_NOTYPE
>>    respectively. According to the gas manual, this is the most portable
>>    way. I am not sure about other assemblers, so we can switch this back
>>    to %function and %object if this turns into a problem. Architectures
>>    can also override them by something like ", @function" if they need.
>>
>>    SYM_A_ALIGN, SYM_A_NONE -- align the symbol?
>>    SYM_V_GLOBAL, SYM_V_WEAK, SYM_V_LOCAL -- visibility of symbols
>>
> 
> Linkage != visibility

OK, I can fix this.

>> d) For data
>>    SYM_DATA_START -- global data symbol
>>    SYM_DATA_END -- the end of the SYM_DATA_START symbol
>>    SYM_DATA_END_LABEL -- the labeled end of SYM_DATA_START symbol
>>    SYM_DATA_SIMPLE -- start+end wrapper around simple global data
>>    SYM_DATA_SIMPLE_LOCAL -- start+end wrapper around simple local data
>>
> 
> I am sorry but I think this is terrible. Do we really need 20+ new
> macros to wrap every single assembler directive involved in defining
> symbols and setting their attributes?

Basically, most code uses SYM_FUNC_START/END and SYM_DATA_START/END (or
SYM_DATA_SIMPLE). The rest is special cases that _have_ to be annotated
as such anyway (by e.g. SYM_CODE_START/END). Objtool cannot check the
code without this reliably and it is exactly the same as using either
END or ENDPROC for a particular function except people use these in a
wrong way as they are undocumented.

> Is this issue you are solving widely perceived as a problem?

So yes, I believe so.

thanks,
-- 
js
suse labs
