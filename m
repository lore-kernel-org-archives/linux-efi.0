From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH 5/8] efi: Get the secure boot status [ver #6]
Date: Mon, 23 Jan 2017 21:26:42 +0000
Message-ID: <20170123212642.GA2766@codeblueprint.co.uk>
References: <20170116144954.GB27351@codeblueprint.co.uk>
 <20170111143304.GA29649@codeblueprint.co.uk>
 <148120020832.5854.5448601415491330495.stgit@warthog.procyon.org.uk>
 <148120024570.5854.10638278395097394138.stgit@warthog.procyon.org.uk>
 <7948.1484148443@warthog.procyon.org.uk>
 <794.1484581158@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <794.1484581158-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, 16 Jan, at 03:39:18PM, David Howells wrote:
> Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:
> 
> > On Wed, 11 Jan, at 03:27:23PM, David Howells wrote:
> > > Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:
> > > 
> > > > > +	movb	$0, BP_secure_boot(%rsi)
> > > > >  #ifdef CONFIG_EFI_STUB
> > > > >  	/*
> > > > >  	 * The entry point for the PE/COFF executable is efi_pe_entry, so
> > > > 
> > > > Is clearing ::secure_boot really necessary? Any code path that goes
> > > > via efi_main() will set it correctly and all other code paths should
> > > > get it cleared in sanitize_boot_params(), no?
> > > 
> > > No.
> > > 
> > > The boot_params->secure_boot parameter exists whether or not efi_main() is
> > > traversed (ie. if EFI isn't enabled or CONFIG_EFI_STUB=n) and, if not cleared,
> > > is of uncertain value.
> > >
> > > Further, sanitize_boot_params() has to be modified by this patch so as not to
> > > clobber the secure_boot flag.
> > 
> > Any new parameters that boot loaders do not know about should be
> > cleared to zero by default in the boot loader because boot_params
> > itself should be zero'd when allocated.
> 
> Do you mean the boot loader or the boot wrapper?  If the loader, that is
> outside my control - and given the purpose of the value, I'm not sure I
> want to rely on that.
 
The boot loader, not the wrapper unless there is no boot loader, such
as when the kernel image is loaded directly via EFI firmware (the
original EFI stub use case).

> > There are two cases to consider:
> > 
> >  1) boot_params is not zero'd
> >  2) boot_params is zero'd
> > 
> > 1) This is a broken boot loader implementation that violates the x86
> > boot specification and I would never expect ->secure_boot to have a
> > valid value.
> 
> If there's a boot specification that must be complied with, why does
> sanitize_boot_params() even exist?  Why does the comment on it say:
> 
>  * Deal with bootloaders which fail to initialize unknown fields in
>  * boot_params to zero.  The list fields in this list are taken from
>  * analysis of kexec-tools; if other broken bootloaders initialize a
>  * different set of fields we will need to figure out how to disambiguate.
 
It exists to catch those boot loaders that don't keep to the spec,
e.g. kexec-tools.

> > It should not be special-cased in sanitize_boot_params(), it should be
> > zero'd.
> 
> Sigh.  sanitize_boot_params() is part of the problem.  The startup sequence
> goes something like this:
> 
>  (0) We enter the boot wrapper.
> 
>  (1) We clear the secure-boot status value [my patch adds this].
> 
>  (2) The boot wrapper *may* invoke efi_main() - which will determine the
>      secure-boot status.
> 
>  (3) The boot wrapper calls extract_kernel() to decompress the kernel.
> 
>  (4) extract_kernel() calls sanitize_boot_params() which would otherwise clear
>      the secure-boot flag.
 
The ->sentinel flag should be clear (because you zero'd boot_params on
alloc), so the code inside of sanitize_boot_params() should never
trigger for the secure boot case.

The comment for 'struct boot_params' explains this better than I can:

        /*
         * The sentinel is set to a nonzero value (0xff) in header.S.
         *
         * A bootloader is supposed to only take setup_header and put
         * it into a clean boot_params buffer. If it turns out that
         * it is clumsy or too generous with the buffer, it most
         * probably will pick up the sentinel variable too. The fact
         * that this variable then is still 0xff will let kernel
         * know that some variables in boot_params are invalid and
         * kernel should zero out certain portions of boot_params.
         */
        __u8  sentinel;                                 /* 0x1ef */

>  (5) The boot wrapper jumps into the main kernel image, which now does not see
>      the secure boot status value we calculated.
> 
> So, no, sanitize_boot_params() must *not* zero the value unless we change the
> call point for s_b_p().

See the point above about the ->sentinel flag.

> > 2) In this case ->secure_boot should be zero unless modified inside of
> > efi_main().
> 
> I have no idea whether this is guaranteed or not.
> 
> > Did you hit the scenario where ->secure_boot has a garbage value while
> > developing these patches? I wouldn't expect to see it in practice.
> 
> I haven't actually checked what the value was before I cleared it.  But, I've
> found that security people get seriously paranoid about assuming things to be
> implicitly so;-).

The thing is, we don't clear any older fields explicitly and we can't
clear not-yet-invented new fields in the future if they're being set
by the boot loader and not in the EFI stub. Let's not make this one
field unnecessarily different from everything else.

Additionally, the way you've written the code prohibits someone from
adding secure boot support to a boot loader that doesn't enter the
kernel via the EFI stub.

I have no idea whether any boot loaders exist that work that way, but
I don't see why we should actively prohibit them from working, when
allowing them to work is as simple as: Don't zero the field in the
boot stub.
