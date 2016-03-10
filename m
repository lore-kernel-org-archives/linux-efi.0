From: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 6/8] efi/arm*: libstub: wire up GOP handling into the ARM
 UEFI stub
Date: Thu, 10 Mar 2016 10:03:45 +0100
Message-ID: <20160310090345.GA19834@gmail.com>
References: <1457588408-19309-1-git-send-email-ard.biesheuvel@linaro.org>
 <1457588408-19309-7-git-send-email-ard.biesheuvel@linaro.org>
 <20160310082522.GB8618@gmail.com>
 <CAKv+Gu8hTSbZVgGj6epquwf6kkSJV+imAFvNobowFVtB5AUe2Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu8hTSbZVgGj6epquwf6kkSJV+imAFvNobowFVtB5AUe2Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Russell King - ARM Linux <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org


* Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:

> > So screen_info_guid should probably not be a 'const': you have to cast it away
> > anyway, adding artificial linebreaks and uglifying the code. It's also a bad
> > practice to cast away const-ness, it hinders move-consts-to-readonly-sections
> > efforts.
> 
> The problem here is that the UEFI spec never uses const qualifiers in
> its APIs for by-ref parameters that are obviously never modified by
> the caller, such as these GUIDs. [...]

Ah, ok. Two related thoughts came up:

1)

While I was looking at this code and was asking myself why the EFI runtime is 
generally invoked via a relatively fragile, non-type-checking vararg construct.

Wouldn't you be better off by explicitly defining all the API variants, and then 
internally calling the EFI runtime?

That would neatly solve such const artifacts as well.

So instead of:


+       status = efi_call_early(allocate_pool, EFI_RUNTIME_SERVICES_DATA,
+                               sizeof(*si), (void **)&si);

we could have something like:

	status = efi_early__allocate_pool(EFI_RUNTIME_SERVICES_DATA, sizeof(*si), &si);

	...

	efi_early__free_pool(si);


i.e. it would look a lot more like a properly distributed, typed, structured 
family of C function APIs, instead of this single central bastard of an ioctl() 
interface.

There's over 100 invocations of the EFI runtime in the Linux kernel, I think it 
would be worth the effort. The wrapper inlines should be mostly trivial.

That would also add an opportunity to actually document most of these calls.

2)

Another suggestion: would it make sense to unify the 'EFI' and 'EFI early' calls - 
is there any deep reason why they are invoked via separate names? Why not use a 
single namespace:

	efi__allocate_pool()
	efi__free_pool()

and have a 'current EFI configuration' pointer internaly that can be switched from 
the early to the later variant during bootup. The various typed API wrappers would 
use this pointer.

Thanks,

	Ingo
