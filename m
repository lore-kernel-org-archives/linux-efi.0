From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 5/8] efi: Get the secure boot status [ver #5]
Date: Thu, 08 Dec 2016 17:31:13 +0000
Message-ID: <14655.1481218273@warthog.procyon.org.uk>
References: <20161208124236.GA8757@wunner.de> <20161208065735.GB8549@wunner.de> <148111668193.23390.6340512985876251017.stgit@warthog.procyon.org.uk> <148111671977.23390.12452925207541146423.stgit@warthog.procyon.org.uk> <6009.1481184981@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161208124236.GA8757-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
Content-ID: <14654.1481218273.1-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org> wrote:

> > +out_efi_err:
> > +	pr_efi_err(sys_table_arg, "Could not determine UEFI Secure Boot status.\n");
> > +	if (status == EFI_NOT_FOUND)
> > +		return efi_secureboot_mode_disabled;
> > +	return efi_secureboot_mode_unknown;
> > +}
> 
> In the out_efi_err path, the if-statement needs to come before the
> pr_efi_err() call.  Otherwise it would be a change of behaviour for
> ARM to what we have now.

As I understand it, if the BIOS is an EFI BIOS, these variables must exist -
in which case I would argue that the pr_efi_err-statement should be before the
if-statement.

David
