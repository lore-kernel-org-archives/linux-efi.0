From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 4/9] KEYS: Allow unrestricted boot-time addition of keys to secondary keyring
Date: Thu, 17 Nov 2016 09:56:00 +0000
Message-ID: <26349.1479376560@warthog.procyon.org.uk>
References: <20161117064100.hmjmfw42ytm526yh@p310> <147931984418.16460.6639993676886095760.stgit@warthog.procyon.org.uk> <147931987366.16460.12891767069975068260.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20161117064100.hmjmfw42ytm526yh@p310>
Content-ID: <26348.1479376560.1@warthog.procyon.org.uk>
Sender: owner-linux-security-module@vger.kernel.org
To: Petko Manolov <petkan@mip-labs.com>
Cc: dhowells@redhat.com, keyrings@vger.kernel.org, matthew.garrett@nebula.com, linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, Mimi Zohar <zohar@linux.vnet.ibm.com>
List-Id: linux-efi@vger.kernel.org

Petko Manolov <petkan@mip-labs.com> wrote:

> On 16-11-16 18:11:13, David Howells wrote:
> > Allow keys to be added to the system secondary certificates keyring during 
> > kernel initialisation in an unrestricted fashion.  Such keys are implicitly 
> > trusted and don't have their trust chains checked on link.
> 
> Well, I for one do not explicitly trust these keys.  I may even want to 
> completely remove or replace them.

Fine be me.  However, if you remove them all I would guess that you cannot
perform a secure boot.

Note that it's to be expected that the keys being loaded from the UEFI
database cannot have their signatures checked - which is why they would have
to be implicitly trusted.  For the same reason, the kernel does not check the
signatures on the keys compiled into the kernel image.

> > This allows keys in the UEFI database to be added in secure boot mode for
> > the purposes of module signing.
> 
> The key import should not be automatic, it should be optional.

You can argue this either way.  There's a config option to allow you to turn
this on or off.  Arguably, this should be split in two: one for the whitelist
(db, MokListRT) and one for the blacklist (dbx).

Further, possibly I should add an option that allows this to be restricted to
secure boot mode only.

> Same applies to the validation process.

Depends what you mean by "the validation process"?  The use of secure boot at
all?  The checking of signatures on keys?  Module signing?

David
