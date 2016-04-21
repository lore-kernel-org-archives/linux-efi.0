From: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCHv2 0/5] efi: detect erroneous firmware IRQ manipulation
Date: Thu, 21 Apr 2016 13:52:37 +0100
Message-ID: <20160421125236.GL6879@leverpostej>
References: <1461238529-12810-1-git-send-email-mark.rutland@arm.com>
 <20160421114737.GQ2904@bivouac.eciton.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160421114737.GQ2904-t77nlHhSwNqAroYi2ySoxKxOck334EZe@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Thu, Apr 21, 2016 at 12:47:37PM +0100, Leif Lindholm wrote:
> On Thu, Apr 21, 2016 at 12:35:24PM +0100, Mark Rutland wrote:
> > Some firmware erroneously unmask IRQs (and potentially other architecture
> > specific exceptions) during runtime services functions, in violation of both
> > common sense and the UEFI specification. This can result in a number of issues
> > if said exceptions are taken when they are expected to be masked, and
> > additionally can confuse IRQ tracing if the original mask state is not
> > restored prior to returning from firmware.
> > 
> > In practice it's difficult to check that firmware never unmasks exceptions, but
> > we can at least check that the IRQ flags are at least consistent upon entry to
> > and return from a runtime services function call. This series implements said
> > check in the shared EFI runtime wrappers code, after an initial round of
> > refactoring such that this can be generic.

[...]

> So, I think this is a good thing, but the diffs end up being quite
> hard to deciphre. Is there any non-insane shuffling around of things
> that can make the changeset more clear?

This is the clearest/simplest way I had found to organise them.

I think the arm and arm64 diffs are fairly clear, so I assume you're
mainly asking w.r.t. the x86 patch, which is less so due to the volume
of lines that fall out of the diff context. The 32-bit side of that is
simple, so I could split that into two patches, leaving the diff pain
only with the 64-bit patch.

Otherwise, short of moving things into a different file I think this is
a losing battle against git's diff engine.

Thanks,
Mark.
