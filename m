From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 8/9] MODSIGN: Import certificates from UEFI Secure Boot
Date: Fri, 02 Dec 2016 10:57:48 -0800
Message-ID: <1480705068.2410.64.camel@HansenPartnership.com>
References: <147931984418.16460.6639993676886095760.stgit@warthog.procyon.org.uk>
         <147931990222.16460.11621102657967011265.stgit@warthog.procyon.org.uk>
         <CAKv+Gu_QVyd1Jx7ZdnBzYmZzUnH4ZuhQgiGO-zx-JPViWosjXQ@mail.gmail.com>
         <1480015063.2444.9.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <1480015063.2444.9.camel@HansenPartnership.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>, David Howells <dhowells@redhat.com>
Cc: keyrings@vger.kernel.org, Matthew Garrett <matthew.garrett@nebula.com>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-security-module <linux-security-module@vger.kernel.org>, Josh Boyer <jwboyer@fedoraproject.org>, Mimi Zohar <zohar@linux.vnet.ibm.com>
List-Id: linux-efi@vger.kernel.org

On Thu, 2016-11-24 at 11:17 -0800, James Bottomley wrote:
> On Mon, 2016-11-21 at 16:16 +0000, Ard Biesheuvel wrote:
> > On 16 November 2016 at 18:11, David Howells <dhowells@redhat.com>
> > wrote:
> > > From: Josh Boyer <jwboyer@fedoraproject.org>
> > > 
> > > Secure Boot stores a list of allowed certificates in the 'db' 
> > > variable. This imports those certificates into the system trusted
> > > keyring.   This allows for a third party signing certificate to 
> > > be used in conjunction with signed modules.  By importing the 
> > > public certificate into the 'db' variable, a user can allow a 
> > > module signed with that certificate to load.  The shim UEFI 
> > > bootloader has a similar certificate list stored in the 
> > > 'MokListRT' variable.   We import those as well.
> > > 
> > 
> > This sounds like a bad idea to me. For the standard databases like 
> > db and dbx, we can rely on the firmware to ensure that they are 
> > what you expect.
> 
> Actually, I think it's a bad idea for the opposite reason: Shim
> explicitly pivots the root of trust away from the db keys to its own
> Moklist keys.  We have no choice and are forced to trust db for the
> secure boot part, but once we're in the kernel proper, I'd argue that
> we would only want to trust the pivoted root, i.e. Moklist.
> 
> Trusting both could generate unwanted consequences, like pressure on
> Microsoft to sign modules or worse, pressure on OEMs to include 
> module keys or hashes ... or worst of all OEMs signing external
> modules.
> 
> >  For MokListRt, not so much: anyone with sufficient
> > capabilities can generate such a variable from userland, and not 
> > every arch/distro combo will be using shim and/or mokmanager. (The 
> > debates are still ongoing, but my position is that there is no need
> > for shim at all on ARM given that the M$ problem only exists on
> > x86)
> 
> OK, so on this point, I'm already not using Shim on my x86 box. 
>  However, what you find if you're using grub is that because grub
> doesn't do signature verification, you still have to use the shim
> protocol callout, so you need something between UEFI and grub to load
> at least this protocol.  I suppose this would go away once we can
> persuade grub to verify signatures.

Hm, that got crickets.

Let me propose an alternative mechanism then.

My problem is that although I am forced to trust the secure boot keys
for the UEFI security boundary, I don't necessarily want to trust them
for signing things for my kernel, so I want to pivot (or at
leastselectively weed out) keys.  Shim already has this concept
partially with MokIgnoreDB.

For the purposes of the kernel, I think we simply need a variable, lets
call it MokKernelCerts, that gives the list of certificates to import
into the kernel keyring.  I think this variable should be BS NV only
(not RT) meaning we have to collect it before ExitBootServices().  The
reason for this is to ensure it's populated by a trusted entity within
the UEFI secure boot boundary.  This will cause a kexec problem, so we
might have to relax this and use a RT shadow as we already do for
MokList.  The idea is that we populate the kernel certificates only
from this variable, so policy can be decided by the bootloader (or
something else which runs within the secure boot environment).

You can stop reading here if you're not interested in *how* this policy
would work.

To make it work, Shim or one of the other intermediates would set up
the variable.  we could communicate policy to it with the usual Foo,
FooUpdate mechanism we already use for MokList.  The default policy (if
the variable doesn't exist on firstboot) can be whatever the distro
wants, so if Fedora wants all the secure boot certs, it can do that and
other distros can follow their own stricter or less strict policies. 
 The user would be able to overwrite this using the Update process,
which could be password verified like MokList already is.

Does this sound acceptable to everyone?

James

