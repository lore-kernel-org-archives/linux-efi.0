From: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Subject: Re: [PATCH v3 03/13] arm64: improve CONFIG_STRICT_DEVMEM handling
Date: Tue, 25 Nov 2014 18:48:00 +0100
Message-ID: <20141125174800.GA3938@pd.tnic>
References: <1416315432-8534-1-git-send-email-ard.biesheuvel@linaro.org>
 <1416315432-8534-4-git-send-email-ard.biesheuvel@linaro.org>
 <20141125173925.GE3331@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20141125173925.GE3331-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, geoff.levand-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, Nov 25, 2014 at 05:39:25PM +0000, Matt Fleming wrote:
> On Tue, 18 Nov, at 01:57:02PM, Ard Biesheuvel wrote:
> > Improve the handling of /dev/mem mappings under CONFIG_STRICT_DEVMEM by:
> > - allowing read-only access to parts of System RAM that are not
> >   considered memory by the kernel, this is mainly intended for exposing
> >   UEFI Configuration tables to userland;
> > - avoid using non-cached mappings for those parts of System RAM, as it
> >   may result in mismatched attributes.
> 
> Is this really the best way to expose EFI config tables?
> 
> We already have parts in /sys/firmware/efi/ and in particular we expose
> the runtime mappings there for kexec on x86.

Yeah!

> Hooking this into the /dev/mem infrastructure just seems wrong to me.

And this virtmap.c thing is arm-only, AFAICT, but it looks like generic
code and like a wholly new way of doing the efi page table.

This thing needs to be properly split into generic pieces which go into
drivers/firmware/efi/ and arm-specific which would make that EFI_VIRTMAP
into an arch bit.

And so on and so on...

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
