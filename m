From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH] x86/efi: Map EFI memmap entries in-order at runtime
Date: Fri, 4 Sep 2015 19:23:07 +0100
Message-ID: <20150904182307.GE2737@codeblueprint.co.uk>
References: <1441372447-23439-1-git-send-email-matt@codeblueprint.co.uk>
 <CAKv+Gu9bGcSVWuMkPVJGDkCPmWvFpjhh4odLWPBZ-wX3=LgGaw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu9bGcSVWuMkPVJGDkCPmWvFpjhh4odLWPBZ-wX3=LgGaw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, James Bottomley <JBottomley-wo1vFcy6AUs@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, 04 Sep, at 03:24:21PM, Ard Biesheuvel wrote:
> 
> Since the UEFI spec does not mandate an enumeration order for
> GetMemoryMap(), it seems to me that you still need to sort its output
> before laying out the VA space. Since you need to sort it anyway, why
> not simply sort it in reverse order and keep all the original code?
> Considering that this is meant for stable, that would keep the delta
> *much* smaller.

Hmm... that'd be a neat trick and while it would save on the diff
size, I don't think it would be smaller in terms of change complexity.

EDK2 sorts the memory map when EFI_PROPERTIES_TABLE is enabled, so we
can be reasonably sure the entry order returned by GetMemoryMap() is
compatible with the split regions, even if it's not mandated by the
spec.

For the non-EFI_PROPERTIES_TABLE case, things have been working fine
without the sorting, so I'm reluctant to introduce it now (it's also
much less of an issue there).

-- 
Matt Fleming, Intel Open Source Technology Center
