From: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/2] UEFI arm64: add noefi boot param
Date: Wed, 6 Aug 2014 14:29:41 +0100
Message-ID: <20140806132941.GJ4179@bivouac.eciton.net>
References: <20140806083825.GA31711@dhcp-16-198.nay.redhat.com>
 <20140806130623.GI4179@bivouac.eciton.net>
 <20140806132021.GB15082@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140806132021.GB15082-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Wed, Aug 06, 2014 at 02:20:21PM +0100, Matt Fleming wrote:
> > Since this is really turning an x86-specific feature into a generic
> > one, could it be moved to core code?
> > Maybe an efi.mask, reusing the efi_enabled defines, with an
> > efi_disabled macro?
>  
> Why the new efi_disabled() and efi.mask? This is all achievable with
> efi_enabled() and efi.flags, in fact, this kind of thing is exactly why
> they were invented.

Because this flag is indicating which facilities we should not try to
enable, rather than which facilities we have enabled.

The EFI_RUNTIME_SERVICES flag is set after successful call to
set_virtual_address_map. The apparent intent of "noefi" is to prevent
that call from being made in the first place.

Anyway, it was just a suggestion - main point was it would make sense
to share the code.
 
> > Also, since this patch (and its x86 predecessor) is not really
> > "noefi", could this be integrated with the "efi=" patch
> > (http://permalink.gmane.org/gmane.linux.kernel.efi/4405),
> > as an efi=noruntime option?
> > 
> > On x86, due to CSM, "noefi" was a useful fallback for completely
> > broken (U)EFI implementations - but on an arm* UEFI system, there will
> > be no fallback. Could it be wrapped in a kernel hacking config option?
>  
> I don't mind making "noefi" a synonym for "efi=noruntime" on x86, as
> long as we keep "noefi" around with the same semantics it's always had.

Yeah, that would be nice.

/
    Leif
