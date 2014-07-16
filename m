From: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH v2] arm64/efi: efistub: jump to 'stext' directly, not
 through the header
Date: Wed, 16 Jul 2014 16:53:45 +0100
Message-ID: <20140716155345.GB30313@leverpostej>
References: <1405421886-11692-1-git-send-email-ard.biesheuvel@linaro.org>
 <1405522297.25580.72.camel@deneb.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1405522297.25580.72.camel-PDpCo7skNiwAicBL8TP8PQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Catalin Marinas <Catalin.Marinas-5wv7dgnIgG8@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, Jul 16, 2014 at 03:51:37PM +0100, Mark Salter wrote:
> On Tue, 2014-07-15 at 12:58 +0200, Ard Biesheuvel wrote:
> > After the EFI stub has done its business, it jumps into the kernel by branching
> > to offset #0 of the loaded Image, which is where it expects to find the header
> > containing a 'branch to stext' instruction.
> > 
> > However, the header is not covered by any PE/COFF section, so the header may
> > not actually be loaded at the expected offset. So instead, jump to 'stext'
> > directly, which is at the base of the PE/COFF .text section, by supplying a
> > symbol 'stext_offset' to efi-entry.o which contains the relative offset of
> > stext into the Image. Also replace other open coded calculations of the same
> > value with a reference to 'stext_offset'
> 
> Have you actually seen a situation where the header isn't there?
> Isn't the kernel header actually part of the pe/coff file and
> firmware loads the whole file into RAM?

>From my understanding of Ard's earlier comments, this part isn't
guaranteed per the UEFI spec.

I would rather we weren't relying on implementation details.

Thanks,
Mark.
