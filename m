From: Alex Thorlton <athorlton-sJ/iWh9BUns@public.gmane.org>
Subject: Re: [PATCH] Remove EFI memmap quirk for UV2+
Date: Mon, 14 Dec 2015 12:20:53 -0600
Message-ID: <20151214182053.GL164416@stormcage.americas.sgi.com>
References: <1449867585-189233-1-git-send-email-athorlton@sgi.com>
 <1449867585-189233-2-git-send-email-athorlton@sgi.com>
 <20151214084157.GB28073@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151214084157.GB28073-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Alex Thorlton <athorlton-sJ/iWh9BUns@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Dimitri Sivanich <sivanich-sJ/iWh9BUns@public.gmane.org>, Hedi Berriche <hedi-sJ/iWh9BUns@public.gmane.org>, Mike Travis <travis-sJ/iWh9BUns@public.gmane.org>, Len Brown <len.brown-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Mon, Dec 14, 2015 at 09:41:58AM +0100, Ingo Molnar wrote:
> * Alex Thorlton <athorlton-sJ/iWh9BUns@public.gmane.org> wrote:
> Ok, this looks good to me and I'll apply it if it looks good to Matt as well.

Cool!  Thanks, Ingo.

> Btw., can UV1 users fix this via a BIOS update?

Unfortunately, no.  This fix was put into UV2+ BIOS a while back, but we
haven't spun a new UV1 BIOS for several years, and don't intend to
release another version.  This issue is likely going to follow UV1s to
their grave :(

- Alex
