From: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 4.12 26/84] x86/xen/efi: Initialize only the EFI struct
 members used by Xen
Date: Thu, 20 Jul 2017 11:41:10 +0200
Message-ID: <20170720094110.sy552pxras33wig5@gmail.com>
References: <20170719092322.362625377@linuxfoundation.org>
 <20170719092323.396710042@linuxfoundation.org>
 <20170719103747.GZ4448@olila.local.net-space.pl>
 <20170720083910.aygobq7t7g7laszt@gmail.com>
 <20170720091639.GA1071@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170720091639.GA1071-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: Daniel Kiper <daniel.kiper-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Boris Ostrovsky <boris.ostrovsky-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, andrew.cooper3-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, jgross-IBi9RG/b67k@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, xen-devel-GuqFBffKawtpuQazS67q72D2FQJk+8+b@public.gmane.org
List-Id: linux-efi@vger.kernel.org


* Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org> wrote:

> On Thu, Jul 20, 2017 at 10:39:10AM +0200, Ingo Molnar wrote:
> > 
> > * Daniel Kiper <daniel.kiper-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
> > 
> > > Hey Greg,
> > > 
> > > On Wed, Jul 19, 2017 at 11:43:32AM +0200, Greg Kroah-Hartman wrote:
> > > > 4.12-stable review patch.  If anyone has any objections, please let me know.
> > > 
> > > Why did you skip this patch for 4.11? IMO it should be applied there too.
> > 
> > The thing is, this patch should probaly not even be in v4.12, as it should only 
> > make any difference if there's a separate _bug_ in the kernel.
> > 
> > This patch makes things more robust going forward, but I question that it needs to 
> > be in -stable.
> 
> Yeah, good point, I'm going to go drop it entirely from the 4.12-stable
> tree as it obviously isn't stable material, sorry for not catching that
> before.

I should have caught the tag as well when applying the upstream patch to begin 
with.

Thanks!

	Ingo
