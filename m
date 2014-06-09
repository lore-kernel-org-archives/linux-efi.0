From: One Thousand Gnomes <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>
Subject: Re: Why efi_set_rtc_mmss() is never used?
Date: Mon, 9 Jun 2014 13:46:35 +0100
Message-ID: <20140609134635.26abc019@alan.etchedpixels.co.uk>
References: <20140609110800.GJ15989@olila.local.net-space.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140609110800.GJ15989-fJNZiO034lp9pOct4yEdx/3oZC3j2Omk@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Daniel Kiper <daniel.kiper-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, xen-devel-GuqFBffKawtpuQazS67q72D2FQJk+8+b@public.gmane.org, boris.ostrovsky-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, david.vrabel-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, jbeulich-IBi9RG/b67k@public.gmane.org, konrad.wilk-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Mon, 9 Jun 2014 13:08:00 +0200
Daniel Kiper <daniel.kiper-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:

> Hi,
> 
> As I can see efi_set_rtc_mmss() is never used to set RTC.
> Even on EFI platform mach_set_rtc_mmss() is called and does
> that thing. Why it is done in that way? It is a bug or it was
> done intentionally. Am I missing something?

EFI services generally don't work properly. The less they are used the
better. We can realistically only make an EFI call with the same
parameters windows does under the same kind of circumstances because the
firmware on many motherboards is complete sh*te.

Alan
