From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH 6/8] efi/arm*: libstub: wire up GOP handling into the ARM
 UEFI stub
Date: Thu, 10 Mar 2016 14:49:08 +0000
Message-ID: <20160310144908.GG15775@codeblueprint.co.uk>
References: <1457588408-19309-1-git-send-email-ard.biesheuvel@linaro.org>
 <1457588408-19309-7-git-send-email-ard.biesheuvel@linaro.org>
 <20160310082522.GB8618@gmail.com>
 <CAKv+Gu8hTSbZVgGj6epquwf6kkSJV+imAFvNobowFVtB5AUe2Q@mail.gmail.com>
 <20160310090345.GA19834@gmail.com>
 <CAKv+Gu_rtQjWJ-=Nf-dEYEHVB5dwKMA_Mv2rVujBz9t=3qnUrA@mail.gmail.com>
 <20160310092552.GA19588@gmail.com>
 <CAKv+Gu9ephpDq_KE_xxV+dXSit+VgBxqgXyAeKt4eXpb5KRJnw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu9ephpDq_KE_xxV+dXSit+VgBxqgXyAeKt4eXpb5KRJnw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Russell King - ARM Linux <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, 10 Mar, at 05:25:08PM, Ard Biesheuvel wrote:
> 
> Indeed. I think the efi_early struct is a separate structure that is
> set up by the early boot code, and has a number of function pointers
> of EFI boot services copied into it. Matt should know the details.
 
If you look at where the efi_early stuff came from originally, you'll
see it was merged as part of the mixed mode code for running 64-bit
kernels on 32-bit EFI,

commit 54b52d872680
Author: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Date:   Fri Jan 10 15:27:14 2014 +0000

    x86/efi: Build our own EFI services pointer table
    
    It's not possible to dereference the EFI System table directly when
    booting a 64-bit kernel on a 32-bit EFI firmware because the size of
    pointers don't match.
    
    In preparation for supporting the above use case, build a list of
    function pointers on boot so that callers don't have to worry about
    converting pointer sizes through multiple levels of indirection.
    
    Signed-off-by: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>


You basically cannot ever dereference a pointer in that mode, it's
crazy.
 
The subsequent efi_early() wrapper came when some of the EFI boot stub
code was migrated out of arch/x86 into drivers/firmware/efi/libstub.

I'm not suggesting it's the most beautiful code in the world, far from
it. It is a massive eyesore that has resulted in type bugs in the past
because of all the casting.

I've just never come up with a cleanup patch series that I was happy
with.

> > Furthermore, my suggestion would work with arbitrarily structured thunking: my
> > suggestion was to put a typed C layer in there - and the layer itself could then
> > call the vararg construct internally. It's a C type demuxing, only a syntactic
> > effort, it does not change any real call signature.
> >
> 
> I would welcome any improvement in this regard. Happy to contribute as well.
 
The only way I think a typed C layer would be maintainable is if it
was automatically generated. We're already suffering from the
multitude of different bitness functions, i.e. __setup_efi_pci32() vs
__setup_efi_pci64().
