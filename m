From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: [PATCH] doc: efi-stub.txt: Fix arm64 paths
Date: Mon, 30 Nov 2015 11:32:37 +0000
Message-ID: <20151130113237.GC2441@codeblueprint.co.uk>
References: <1448726603-17600-1-git-send-email-alan@softiron.co.uk>
 <20151130112859.GB2441@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20151130112859.GB2441@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Alan Ott <alan@softiron.co.uk>
Cc: Jonathan Corbet <corbet@lwn.net>, Roy Franz <roy.franz@linaro.org>, linux-efi@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Leif Lindholm <leif.lindholm@linaro.org>
List-Id: linux-efi@vger.kernel.org

On Mon, 30 Nov, at 11:28:59AM, Matt Fleming wrote:
> On Sat, 28 Nov, at 11:03:23AM, Alan Ott wrote:
> > Update documented paths for arm64 files to match current tree.
> > ---
> >  Documentation/efi-stub.txt | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/Documentation/efi-stub.txt b/Documentation/efi-stub.txt
> > index 7747024..e157469 100644
> > --- a/Documentation/efi-stub.txt
> > +++ b/Documentation/efi-stub.txt
> > @@ -10,12 +10,12 @@ arch/x86/boot/header.S and arch/x86/boot/compressed/eboot.c,
> >  respectively. For ARM the EFI stub is implemented in
> >  arch/arm/boot/compressed/efi-header.S and
> >  arch/arm/boot/compressed/efi-stub.c. EFI stub code that is shared
> > -between architectures is in drivers/firmware/efi/efi-stub-helper.c.
> > +between architectures is in drivers/firmware/efi/libstub.
> >  
> >  For arm64, there is no compressed kernel support, so the Image itself
> >  masquerades as a PE/COFF image and the EFI stub is linked into the
> >  kernel. The arm64 EFI stub lives in arch/arm64/kernel/efi-entry.S
> > -and arch/arm64/kernel/efi-stub.c.
> > +and drivers/firmware/efi/libstub/arm64-stub.c.
> >  
> >  By using the EFI boot stub it's possible to boot a Linux kernel
> >  without the use of a conventional EFI boot loader, such as grub or
> 
> Thanks Alan, applied.

Umm.. actually could you resend this with your Signed-off-by tag,
please? Then I'll apply it.
