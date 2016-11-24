From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: [PATCH 8/9] MODSIGN: Import certificates from UEFI Secure Boot
Date: Thu, 24 Nov 2016 11:17:43 -0800
Message-ID: <1480015063.2444.9.camel@HansenPartnership.com>
References: <147931984418.16460.6639993676886095760.stgit@warthog.procyon.org.uk>
         <147931990222.16460.11621102657967011265.stgit@warthog.procyon.org.uk>
         <CAKv+Gu_QVyd1Jx7ZdnBzYmZzUnH4ZuhQgiGO-zx-JPViWosjXQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKv+Gu_QVyd1Jx7ZdnBzYmZzUnH4ZuhQgiGO-zx-JPViWosjXQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-security-module <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Josh Boyer <jwboyer-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, 2016-11-21 at 16:16 +0000, Ard Biesheuvel wrote:
> On 16 November 2016 at 18:11, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> wrote:
> > From: Josh Boyer <jwboyer-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org>
> > 
> > Secure Boot stores a list of allowed certificates in the 'db' 
> > variable. This imports those certificates into the system trusted 
> > keyring.   This allows for a third party signing certificate to be 
> > used in conjunction with signed modules.  By importing the public 
> > certificate into the 'db' variable, a user can allow a module 
> > signed with that certificate to load.  The shim UEFI bootloader has 
> > a similar certificate list stored in the 'MokListRT' variable.  We
> > import those as well.
> > 
> 
> This sounds like a bad idea to me. For the standard databases like db
> and dbx, we can rely on the firmware to ensure that they are what you
> expect.

Actually, I think it's a bad idea for the opposite reason: Shim
explicitly pivots the root of trust away from the db keys to its own
Moklist keys.  We have no choice and are forced to trust db for the
secure boot part, but once we're in the kernel proper, I'd argue that
we would only want to trust the pivoted root, i.e. Moklist.

Trusting both could generate unwanted consequences, like pressure on
Microsoft to sign modules or worse, pressure on OEMs to include module
keys or hashes ... or worst of all OEMs signing external modules.

>  For MokListRt, not so much: anyone with sufficient
> capabilities can generate such a variable from userland, and not 
> every arch/distro combo will be using shim and/or mokmanager. (The 
> debates are still ongoing, but my position is that there is no need 
> for shim at all on ARM given that the M$ problem only exists on x86)

OK, so on this point, I'm already not using Shim on my x86 box. 
 However, what you find if you're using grub is that because grub
doesn't do signature verification, you still have to use the shim
protocol callout, so you need something between UEFI and grub to load
at least this protocol.  I suppose this would go away once we can
persuade grub to verify signatures.

James
