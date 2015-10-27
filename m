From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH] arm64/efi: move arm64 specific stub C code to libstub
Date: Tue, 27 Oct 2015 21:07:35 +0000
Message-ID: <20151027210735.GA8973@codeblueprint.co.uk>
References: <1445611694-31838-1-git-send-email-ard.biesheuvel@linaro.org>
 <20151026211133.GB3526@codeblueprint.co.uk>
 <CAKv+Gu-2-=b-+X8xRpVFO5oFE2_0Eho2-H6VWYWWqonOdaKL5w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu-2-=b-+X8xRpVFO5oFE2_0Eho2-H6VWYWWqonOdaKL5w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jeremy Linton <jeremy.linton-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, "Suzuki K. Poulose" <Suzuki.Poulose-5wv7dgnIgG8@public.gmane.org>, Andrey Ryabinin <ryabinin.a.a-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, 27 Oct, at 11:10:43AM, Ard Biesheuvel wrote:
> On 27 October 2015 at 06:11, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:
> > On Fri, 23 Oct, at 04:48:14PM, Ard Biesheuvel wrote:
> >> Now that we added special handling to the C files in libstub, move
> >> the one remaining arm64 specific EFI stub C file to libstub as
> >> well, so that it gets the same treatment. This should prevent future
> >> changes from resulting in binaries that may execute incorrectly in
> >> UEFI context.
> >
> > Sorry, I'm coming at this cache-cold: What special handling was added
> > to libstub that you want to make use of here?
> >
> 
> This is about the libstub patches that you reviewed ~2 weeks ago and
> that have been queued in Catalin's arm64 tree for 4.4
> 
> >> With efi-entry.S the only remaining EFI stub source file under
> >> arch/arm64, we can also simplify the Makefile logic somewhat.
> >>
> >> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> >> ---
> >>
> >> I would like to suggest that this be taken on top of the stuff that is
> >> queued for 4.4 at the moment (if it is not too late already).
> >
> > That's upto the tip folks (Cc'd). Ingo, would you consider applying
> > a minimal build cleanup patch like this for v4.4?
> >
> 
> Actually, the suggestion was aimed at Catalin, who has all the libstub
> and KASAN patches queued that this patch depends on.
> Apologies for the confusion.

Fair enough. In that case (for the drivers/firmware bits),

Reviewed-by: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
