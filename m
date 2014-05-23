From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: EFI_STUB fails to boot non-EFI on arm64
Date: Fri, 23 May 2014 21:43:46 +0200
Message-ID: <CAKv+Gu-AqJ7wYFOr4_3NJO7B-wAk+CGiwfuHvmvdz8L4ZBTjFw@mail.gmail.com>
References: <20140523094513.GC9252@arm.com>
	<20140523131656.GR4179@bivouac.eciton.net>
	<20140523134720.GA9256@arm.com>
	<20140523150331.GS4179@bivouac.eciton.net>
	<CAKv+Gu-4ExoNfGVJzUK4v06XD5V3nYfRetoefY0RuFsN1CUOzg@mail.gmail.com>
	<20140523154551.GT4179@bivouac.eciton.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140523154551.GT4179-t77nlHhSwNqAroYi2ySoxKxOck334EZe@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 23 May 2014 17:45, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
>
> On Fri, May 23, 2014 at 05:17:39PM +0200, Ard Biesheuvel wrote:
> > >> Can we add another of detecting whether it's an EFI application and
> > >> avoid calling efi_init()? I can see x86 sets some efi_loader_signature
> > >> string in exit_boot() and checks against it later when calling
> > >> efi_init().
> > >
> > > Well, I agree that we shouldn't be spewing error messages for expected
> > > operation, but efi_init() is the function we call to determine
> > > whether we _are_ booting via UEFI - and it sets flags accordingly for
> > > the efi_enabled() macro.
> > >
> >
> > Considering that
> >
> > a) the raw Image loader and the stub enter the kernel through
> > different entry points (i.e., offset #0 and whatever entry point is
> > specified in the PE/COFF header, respectively), and
> > b) there is no decompressor etc involved so we jump straight into the
> > kernel startup code
> > c) head.S already deals with a similar problem, i.e., storing the CPU boot mode
> >
> > I would assume it shouldn't be so difficult to set a bit somewhere
> > indicating which case we are dealing with?
>
> That would certainly be possible, but what would be the benefit of
> having two separate mechanisms for determining whether we are booting
> via UEFI - which could potentially end up disagreeing?
>

Yeah, you're right. Also, the ARM requirements are sufficiently
different (as Roy points out) that the presence of the FDT nodes is
the most reliable indicator of whether you can proceed booting in EFI
mode.

-- 
Ard.
