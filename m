From: Jiri Slaby <jslaby-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH v4 19/27] x86: assembly, make some functions local
Date: Wed, 4 Oct 2017 09:22:16 +0200
Message-ID: <5a3785ea-d2d8-dd51-4b02-12f4ca5507d7@suse.cz>
References: <20171002091246.28432-1-jslaby@suse.cz>
 <20171002091246.28432-19-jslaby@suse.cz>
 <CAKv+Gu9C88ToAx+8KcGacUECo7ExnTTBmibEjpB2WkfFvjoZvw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKv+Gu9C88ToAx+8KcGacUECo7ExnTTBmibEjpB2WkfFvjoZvw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-GB
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: "mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org" <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, xen-devel <xen-devel-GuqFBffKawtpuQazS67q72D2FQJk+8+b@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 10/02/2017, 02:48 PM, Ard Biesheuvel wrote:
> On 2 October 2017 at 10:12, Jiri Slaby <jslaby-AlSwsSmVLrQ@public.gmane.org> wrote:
>> There is a couple of assembly functions, which are invoked only locally
>> in the file they are defined. In C, we mark them "static". In assembly,
>> annotate them using SYM_{FUNC,CODE}_START_LOCAL (and switch their
>> ENDPROC to SYM_{FUNC,CODE}_END too). Whether FUNC or CODE depends on
>> ENDPROC/END for a particular function (C or non-C).
>>
> 
> I wasn't cc'ed on the cover letter, so I am missing the rationale of
> replacing ENTRY/ENDPROC with other macros.

There was no cover letter. I am attaching what is in PATCH 1/27 instead:
Introduce new C macros for annotations of functions and data in
assembly. There is a long-standing mess in macros like ENTRY, END,
ENDPROC and similar. They are used in different manners and sometimes
incorrectly.

So introduce macros with clear use to annotate assembly as follows:

a) Support macros for the ones below
   SYM_T_FUNC -- type used by assembler to mark functions
   SYM_T_OBJECT -- type used by assembler to mark data
   SYM_T_NONE -- type used by assembler to mark entries of unknown type

   They are defined as STT_FUNC, STT_OBJECT, and STT_NOTYPE
   respectively. According to the gas manual, this is the most portable
   way. I am not sure about other assemblers, so we can switch this back
   to %function and %object if this turns into a problem. Architectures
   can also override them by something like ", @function" if they need.

   SYM_A_ALIGN, SYM_A_NONE -- align the symbol?
   SYM_V_GLOBAL, SYM_V_WEAK, SYM_V_LOCAL -- visibility of symbols

b) Mostly internal annotations, used by the ones below
   SYM_ENTRY -- use only if you have to (for non-paired symbols)
   SYM_START -- use only if you have to (for paired symbols)
   SYM_END -- use only if you have to (for paired symbols)

c) Annotations for code
   SYM_FUNC_START_LOCAL_ALIAS -- use where there are two local names for
	one function
   SYM_FUNC_START_ALIAS -- use where there are two global names for one
	function
   SYM_FUNC_END_ALIAS -- the end of LOCAL_ALIASed or ALIASed function

   SYM_FUNC_START -- use for global functions
   SYM_FUNC_START_NOALIGN -- use for global functions, w/o alignment
   SYM_FUNC_START_LOCAL -- use for local functions
   SYM_FUNC_START_LOCAL_NOALIGN -- use for local functions, w/o
	alignment
   SYM_FUNC_START_WEAK -- use for weak functions
   SYM_FUNC_START_WEAK_NOALIGN -- use for weak functions, w/o alignment
   SYM_FUNC_END -- the end of SYM_FUNC_START_LOCAL, SYM_FUNC_START,
	SYM_FUNC_START_WEAK, ...

   SYM_FUNC_INNER_LABEL -- only for labels in the middle of functions
   SYM_FUNC_INNER_LABEL_NOALIGN -- only for labels in the middle of
	functions, w/o alignment

   For functions with special (non-C) calling conventions:
   SYM_CODE_START -- use for non-C (special) functions
   SYM_CODE_START_NOALIGN -- use for non-C (special) functions, w/o
	alignment
   SYM_CODE_START_LOCAL -- use for local non-C (special) functions
   SYM_CODE_START_LOCAL_NOALIGN -- use for local non-C (special)
	functions, w/o alignment
   SYM_CODE_END -- the end of SYM_CODE_START_LOCAL or SYM_CODE_START

   SYM_CODE_INNER_LABEL -- only for labels in the middle of code
   SYM_CODE_INNER_LABEL_NOALIGN -- only for labels in the middle of code

d) For data
   SYM_DATA_START -- global data symbol
   SYM_DATA_END -- the end of the SYM_DATA_START symbol
   SYM_DATA_END_LABEL -- the labeled end of SYM_DATA_START symbol
   SYM_DATA_SIMPLE -- start+end wrapper around simple global data
   SYM_DATA_SIMPLE_LOCAL -- start+end wrapper around simple local data

==========

The macros allow to pair starts and ends of functions and mark functions
correctly in the output ELF objects.

All users of the old macros in x86 are converted to use these in further
patches.

thanks,
-- 
js
suse labs
