From: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
Subject: Re: [PATCH 5/8] efi: Get the secure boot status [ver #5]
Date: Fri, 9 Dec 2016 01:35:27 +0100
Message-ID: <20161209003527.GA9062@wunner.de>
References: <20161208124236.GA8757@wunner.de>
 <20161208065735.GB8549@wunner.de>
 <148111668193.23390.6340512985876251017.stgit@warthog.procyon.org.uk>
 <148111671977.23390.12452925207541146423.stgit@warthog.procyon.org.uk>
 <6009.1481184981@warthog.procyon.org.uk>
 <14655.1481218273@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <14655.1481218273-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Thu, Dec 08, 2016 at 05:31:13PM +0000, David Howells wrote:
> Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org> wrote:
> > > +out_efi_err:
> > > +	pr_efi_err(sys_table_arg, "Could not determine UEFI Secure Boot status.\n");
> > > +	if (status == EFI_NOT_FOUND)
> > > +		return efi_secureboot_mode_disabled;
> > > +	return efi_secureboot_mode_unknown;
> > > +}
> > 
> > In the out_efi_err path, the if-statement needs to come before the
> > pr_efi_err() call.  Otherwise it would be a change of behaviour for
> > ARM to what we have now.
> 
> As I understand it, if the BIOS is an EFI BIOS, these variables must exist -
> in which case I would argue that the pr_efi_err-statement should be before
> the if-statement.

The existing efi_get_secureboot() in arm-stub.c returns 0 in the
EFI_NOT_FOUND case and the "Could not determine ..."  error is only
printed if the return value is < 0.  So you're introducing a change
of behaviour.

If you feel the change is justified, fine, I won't argue against it
since I don't have a dog in this fight.

But obviously it's something that a reader of your patch will trip over,
so at least explain it in the commit message.  It would also be good to
explain why you're moving the pr_efi_err() calls in the first place.
ISTR it has to do with the different interpretation of an error,
what I wrote in my previous e-mail: x86 defaults to considering secureboot
disabled on error, ARM to enabled.  I'm not even sure that's correct,
I'd have to go re-read the whole thread, which again shows that there's
too little documentation in the commit message.

Thanks,

Lukas
