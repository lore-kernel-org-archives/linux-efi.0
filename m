From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH] arm64/efi: isolate EFI stub from the kernel proper
Date: Wed, 23 Sep 2015 09:44:45 -0700
Message-ID: <CAKv+Gu_DF5n1Fe3QE8W2AzZXf4OGq3V73oTWgwPvYmKgMzGBKA@mail.gmail.com>
References: <1442311903-19213-1-git-send-email-ard.biesheuvel@linaro.org>
	<20150915144629.GG31157@arm.com>
	<CAKv+Gu8j1APZkGnFhZArNAtoyYOokP2bgemYH5n7Pn8jQ1b1XA@mail.gmail.com>
	<CAKv+Gu_KuOxA+EMSV0YcQR9rmO+R=-y9tivweNym3o+E4DrnHQ@mail.gmail.com>
	<20150917160925.GP25634@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150917160925.GP25634-5wv7dgnIgG8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
Cc: "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mark Rutland <Mark.Rutland-5wv7dgnIgG8@public.gmane.org>, "msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Catalin Marinas <Catalin.Marinas-5wv7dgnIgG8@public.gmane.org>, "leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 17 September 2015 at 09:09, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org> wrote:
> Hi Ard,
>
> On Thu, Sep 17, 2015 at 11:51:07AM +0100, Ard Biesheuvel wrote:
>> On 15 September 2015 at 17:24, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
>> > On 15 September 2015 at 16:46, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org> wrote:
>> >> On Tue, Sep 15, 2015 at 11:11:43AM +0100, Ard Biesheuvel wrote:
>> >>> Since arm64 does not use a builtin decompressor, the EFI stub is built
>> >>> into the kernel proper. So far, this has been working fine, but actually,
>> >>> since the stub is in fact a PE/COFF relocatable binary that is executed
>> >>> at an unknown offset in the 1:1 mapping provided by the UEFI firmware, we
>> >>> should not be seamlessly sharing code with the kernel proper, which is a
>> >>> position dependent executable linked at a high virtual offset.
>> >>>
>> >>> So instead, separate the contents of libstub and its dependencies, by
>> >>> putting them into their own namespace by prefixing all of its symbols
>> >>> with __efistub. This way, we have tight control over what parts of the
>> >>> kernel proper are referenced by the stub.
>> >>
>> >> Could we add an __efistub annotation to spit out warnings if the stub
>> >> calls into unexpected kernel code, like we do for __init/__ref?
>> >>
>> >
>> > Currently, it will break the build rather than warn if you use a
>> > disallowed symbol, which I think is not unreasonable.
>> >
>> > But I suppose that the objcopy step in this patch could rename the
>> > sections to .efistub.xxx sections, which would allow us to reuse some
>> > of the section mismatch code.
>> > However, this would involve marking things like the generic string and
>> > memcpy routines __efistub as well, which I think may be too much.
>> > Also, note that the logic is inverted here: with __init, we disallow
>> > normal code to call __init functions, but with __efistub, it will be
>> > the other way around, which may be more difficult to accomplish
>> > (Rutland and I did discuss this option when we talked about this over
>> > IRC)
>> >
>>
>> OK, I have given this a go, and as it turns out, it implies that we go
>> and mark generic pieces of lib/ as __section(.text.efistubok) in order
>> for modpost.c to accept it. Tweaking modpost.c itself seems quite
>> doable, since the logic is fairly flexible and can easily be augmented
>> to complain about unauthorized references from the stub to the kernel
>> proper.
>>
>> So what we could do is fold libfdt and lib/sort.c (which are the
>> primary generic dependencies) into the stub, but we would still need
>> to retain the symbol prefixing bit to prevent the stub's symbols from
>> clashing with the ones from the kernel proper. And with the symbol
>> prefixing in place, we have something that is even stronger than
>> section mismatch, which is to error out on undefined references rather
>> than warn about section mismatches.
>>
>> I think the current approach is better, but only if we agree that we
>> should do something in the first place. (Currently, there are no known
>> issues, just the awareness that things are not quite as tidy as they
>> should be)
>
> I agree, but thanks for looking into it. The only downside I still see
> with symbol namespacing is that the error produced won't be as obvious
> as something akin to a section mismatch, but then again, it's mainly you
> hacking on the stub so it's not really an issue :)
>

OK, so it seems we are mostly aligned with regard to the solution this
patch proposes. Perhaps we need to discuss whether we feel the problem
needs solving in the first place.

To elaborate a bit, the concern is that the EFI stub, which executes
in the context of the UEFI boot services environment, should be
allowed to access random other code bits of the kernel that are built
to be executed from a virtual offset that is not set up yet when UEFI
runs. At the moment, this works fine, since the AArch64 small code
model uses relative references primarily, and we happen not to be
relying on any static data structures containing pointers.

In fact, using the -fpic model (as I do in this patch for the stub
components), which naively seems more appropriate for code that needs
to execute at an a priori unknown offset, is very likely to make
things worse rather than better, since the default visibility and ELF
symbol preemption rules implemented by GCC mandate that all references
to externally visible (i.e., non-static global) variables are
preemptible, which means all external symbol references must go via
[absolute] GOT entries.

Since -fpic is not helping to prevent absolute references from being
emitted, I should probably remove it from this patch. That means that
the sole remaining purpose is to control which core kernel code is
referenced by the stub, not to build the stub code itself in a
different way.

Thoughts, please?

-- 
Ard.
