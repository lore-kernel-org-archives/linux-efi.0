From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 4/6] efi: Get the secure boot status
Date: Wed, 23 Nov 2016 00:02:27 +0000
Message-ID: <17874.1479859347@warthog.procyon.org.uk>
References: <20161122203058.GA1844@wunner.de> <20161122104401.GC1552@wunner.de> <20161117123731.GA11573@wunner.de> <147977472115.6360.13015228230799369019.stgit@warthog.procyon.org.uk> <7199.1479826047@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20161122203058.GA1844@wunner.de>
Content-ID: <17873.1479859347.1@warthog.procyon.org.uk>
Sender: owner-linux-security-module@vger.kernel.org
To: Lukas Wunner <lukas@wunner.de>
Cc: dhowells@redhat.com, Matthew Garrett <matthew.garrett@nebula.com>, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, keyrings@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

Lukas Wunner <lukas@wunner.de> wrote:

> On Tue, Nov 22, 2016 at 02:47:27PM +0000, David Howells wrote:
> > Lukas Wunner <lukas@wunner.de> wrote:
> > > The "out_efi_err" portion differs from the previous version of this
> > > patch.  Setting a __u8 to a negative value, is this really what you
> > > want?
> > 
> > Eh?  efi_get_secureboot() returns an int as before.  The out_efi_err:
> > portions are exactly the same:
> 
> By "the previous version of this patch" I was referring to your
> submission of Nov 16, not the existing code in the kernel.
> Your patch didn't contain the out_efi_err portion.
> 
> You're assigning a negative value to boot_params->secure_boot
> (which is declared __u8).

Ah, yes.  Sorry, you confused me by specifying a comparison against the last
version.

David
