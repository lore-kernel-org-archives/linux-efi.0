From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH v2] x86/mm: warn on W+x mappings
Date: Mon, 12 Oct 2015 15:49:28 +0100
Message-ID: <20151012144928.GF2579@codeblueprint.co.uk>
References: <1443814185-21552-1-git-send-email-sds@tycho.nsa.gov>
 <20151003112701.GA4531@gmail.com>
 <5612CBE8.2010504@tycho.nsa.gov>
 <20151006073205.GA11115@gmail.com>
 <5613EAD5.2070405@tycho.nsa.gov>
 <20151012113605.GB7384@pd.tnic>
 <20151012124113.GD2579@codeblueprint.co.uk>
 <20151012124936.GA6260@gmail.com>
 <20151012125548.GE2579@codeblueprint.co.uk>
 <20151012141754.GA6621@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151012141754.GA6621-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Stephen Smalley <sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Denys Vlasenko <dvlasenk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Brian Gerst <brgerst-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, 12 Oct, at 04:17:54PM, Ingo Molnar wrote:
> 
> * Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:
> 
> > On Mon, 12 Oct, at 02:49:36PM, Ingo Molnar wrote:
> > > 
> > > 
> > > So why not unmap them after bootup? Is there any reason to call into EFI code 
> > > while the system is up and running?
> > 
> > That's where the runtime services code lives. So if you want things like EFI 
> > variables (used by the distro installer, among other things) you need to map the 
> > runtime regions.
> 
> So EFI variables could be queried during bootup and saved on the Linux side.
 
Right, we could do that, but then we wouldn't be able to support
creation/updating variables at runtime, such as when you install a
distribution for the first time, or want to boot a new kernel filename
directly from the firmware without a boot loader (and need to modify
the BootXXXX variables).

And it's not just EFI variables that need runtime support either, for
some platforms the only way to reboot/poweroff is with EFI, such as on
the ASUS T100TA (Intel Baytrail-T).

That's not to say your suggestion doesn't make sense for some cases, I
can definitely see how turning off runtime support but providing a
cache of EFI variables would be useful for some scenarios. But I don't
think it's ever going to be workable as a default option.

> Calling into firmware after the kernel has booted up is fragile in general - 
> beyond W+X the security considerations.

It isn't intended to be fragile, and effort has gone into defining the
context under which the EFI runtime services can operate (though there
are obviously gaps in that specification).

The entire point of the EFI runtime services is that they can be
invoked from the OS, and because hardware/firmware developers rely on
that when designing platforms, it's going to be something that Linux
is going to have to be able to do. Of course, that doesn't we
shouldn't be able to turn it off if the user is happy to sacrifice
some platform functionality.

Additionally, if we've got suggestions for the firmware developers on
what we want the runtime context to look like, let's propose it to
them. They're pretty receptive in my experience.

-- 
Matt Fleming, Intel Open Source Technology Center
