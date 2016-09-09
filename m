From: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
Subject: Re: [PATCH] efi: Use LocateHandleBuffer instead of LocateHandle
Date: Fri, 9 Sep 2016 13:59:51 +0200
Message-ID: <20160909115951.GA29385@wunner.de>
References: <1d7915dc0dd328ca04088f6b8b3fcfad5cec55a0.1473275006.git.lukas@wunner.de>
 <CAKv+Gu_kfnHfiBH__Wnvh39KMPj_-s39YyY=pT3roNv7iPPzrA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu_kfnHfiBH__Wnvh39KMPj_-s39YyY=pT3roNv7iPPzrA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, Sep 09, 2016 at 11:52:32AM +0100, Ard Biesheuvel wrote:
> On 8 September 2016 at 01:02, Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org> wrote:
> > Use LocateHandleBuffer instead of the LocateHandle + AllocatePool +
> > LocateHandle combo to save a bit on code.
> >
> > Usage of LocateHandle for UGA and GOP has been present in the efistub
> > since its introduction with commit 291f36325f9f ("x86, efi: EFI boot
> > stub support"). It was subsequently inherited by the PCI ROM retrieval
> > with commit dd5fc854de5f ("EFI: Stash ROMs if they're not in the PCI
> > BAR").
> >
> > One valid reason to not use LocateHandleBuffer would be if a specific
> > memory type is required for the buffer, and particularly if the buffer
> > needs to persist across ExitBootServices. The spec does not mandate
> > which type is used, edk2 seems to default to EfiBootServicesData.
> > In the three use cases modified by this commit (UGA, GOP, PCI), the
> > buffer is freed before ExitBootServices is called. Hence the memory
> > type is irrelevant.
> >
> > No functional change intended.
> >
> > Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> > Signed-off-by: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
> > ---
> >
> 
> What is the oldest UEFI version we claim to support? For ARM, this is
> not an issue, but it appears that LocateHandleBuffer () was introduced
> in v1.10

That's a fair point. I couldn't find any older specs than 1.10, only found
some sources saying the 1.02 spec was pulled for legal reasons.

I did notice the 1.10 spec says "The LocateHandleBuffer() is a new version
of LocateHandle() that allocates the required buffer for the caller."

Note the word "new".

According to Wikipedia, "Intel's first Itanium workstations and servers,
released in 2000, implemented EFI 1.02. Hewlett-Packard's first Itanium 2
systems, released in 2002, implemented EFI 1.10".

Since this code is only used by x86 and arm (not ia64), were x86_32
systems with EFI < 1.10 actually shipped?

I vaguely recall that Apple was among the first vendors adopting EFI
for x86 in 2005, but I could be wrong.

Thanks,

Lukas
