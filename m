From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH] efi: stub: define DISABLE_BRANCH_PROFILING for all
 architectures
Date: Tue, 5 Jan 2016 15:39:18 +0000
Message-ID: <20160105153918.GA2714@codeblueprint.co.uk>
References: <1450862968-20222-1-git-send-email-ard.biesheuvel@linaro.org>
 <20160104123145.GB1616@arm.com>
 <CAKv+Gu-n-7tk1NXYAbf7+O79gYG82QOsbzLuYG1yX=LSizksWQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu-n-7tk1NXYAbf7+O79gYG82QOsbzLuYG1yX=LSizksWQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, 05 Jan, at 03:56:39PM, Ard Biesheuvel wrote:
> (+ Arnd)
> 
> On 4 January 2016 at 13:31, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org> wrote:
> > On Wed, Dec 23, 2015 at 10:29:28AM +0100, Ard Biesheuvel wrote:
> >> This moves the DISABLE_BRANCH_PROFILING define from the x86 specific
> >> to the general CFLAGS definition for the stub. This fixes build errors
> >> when building for arm64 with CONFIG_PROFILE_ALL_BRANCHES_ENABLED.
> >>
> >> Reported-by: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
> >> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> >> ---
> >>  drivers/firmware/efi/libstub/Makefile | 4 ++--
> >>  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > Cheers, Ard. The kernel now builds and boots as an EFI application for
> > me when the dreaded #define if config option is enabled:
> >
> >   Tested-by: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
> >
> > Will
> >
> 
> @Matt: this is causing randconfig build errors for ARM in -next. Mind
> if we take this through some other tree?

Go ahead.

Reviewed-by: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
