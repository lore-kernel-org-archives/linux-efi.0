From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: Re: [PATCH 4/9] KEYS: Allow unrestricted boot-time addition of keys
 to secondary keyring
Date: Mon, 21 Nov 2016 11:24:28 -0500
Message-ID: <1479745468.2487.60.camel@linux.vnet.ibm.com>
References: <1479737095.2487.34.camel@linux.vnet.ibm.com>
         <20161117064100.hmjmfw42ytm526yh@p310>
         <147931984418.16460.6639993676886095760.stgit@warthog.procyon.org.uk>
         <147931987366.16460.12891767069975068260.stgit@warthog.procyon.org.uk>
         <26349.1479376560@warthog.procyon.org.uk>
         <18864.1479741430@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <18864.1479741430@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: Petko Manolov <petkan@mip-labs.com>, keyrings@vger.kernel.org, matthew.garrett@nebula.com, linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ima-devel <linux-ima-devel@lists.sourceforge.net>
List-Id: linux-efi@vger.kernel.org

On Mon, 2016-11-21 at 15:17 +0000, David Howells wrote:
> Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> 
> > > > > This allows keys in the UEFI database to be added in secure boot mode
> > > > > for the purposes of module signing.
> > > > 
> > > > The key import should not be automatic, it should be optional.
> > > 
> > > You can argue this either way.  There's a config option to allow you to
> > > turn this on or off.  Arguably, this should be split in two: one for the
> > > whitelist (db, MokListRT) and one for the blacklist (dbx).
> > 
> > By "config", you're not referring to a Kconfig option, but a UEFI db
> > option, making it hidden/unknown to someone building a kernel.  If you
> > really want to add this support, make it clear and easily seen by
> > defining a "restrict_link_by_builtin_or_uefi" function.
> 
> No: by "config" I *am* referring to Kconfig.

Good,  I found the Kconfig LOAD_UEFI_KEYS option for loading the keys on
the keyring.  Lets say that someone does want to use those keys for
kernel modules, but only for kernel modules, not for any other types of
files (eg. kexec kernel image/initramfs)?

Mimi
