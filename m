From: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH 1/4] efi/libstub: Allocate headspace in
 efi_get_memory_map()
Date: Mon, 18 Jul 2016 16:11:47 +0100
Message-ID: <20160718151147.GH10069@leverpostej>
References: <1468788362-3962-1-git-send-email-jhugo@codeaurora.org>
 <1468788362-3962-2-git-send-email-jhugo@codeaurora.org>
 <20160718110001.GC10069@leverpostej>
 <8d1fd10a-97d0-df6e-0d52-dcc29671521d@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <8d1fd10a-97d0-df6e-0d52-dcc29671521d-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeffrey Hugo <jhugo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Cc: matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, timur-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Mon, Jul 18, 2016 at 09:03:31AM -0600, Jeffrey Hugo wrote:
> On 7/18/2016 5:00 AM, Mark Rutland wrote:
> >Hi,
> >
> >On Sun, Jul 17, 2016 at 02:45:59PM -0600, Jeffrey Hugo wrote:
> >>+	if (status == EFI_BUFFER_TOO_SMALL ||
> >>+				(*buff_size - *map_size) / sizeof(*m) < 8) {
> >> 		efi_call_early(free_pool, m);
> >>+		/*
> >>+		 * Make sure there is 8 entries worth of headroom so that the
> >>+		 * buffer can be reused for a new map after allocations are
> >>+		 * no longer permitted.  Its unlikely that the map will grow to
> >>+		 * exceed this headroom once we are ready to trigger
> >>+		 * ExitBootServices()
> >>+		 */
> >>+		*map_size += sizeof(*m) * 8;

> >As a general note, it's a shame that we don't know desc_size first time
> >through. If descs grow, 8 * sizeof(*m) might be too small. That's an
> >existing problem though, so I guess it makes sense to be consistent and
> >use sizeof(*m) here.
> 
> Yep.  Unless I've missed something, it seems like the two options
> are either make a decent attempt to guess at desc_size the first
> time (current approach), or intentionally fail the first time just
> to get the size.  The current approach doesn't seem perfect, but it
> does have a chance at passing with just one attempt.  I couldn't see
> a better solution, but if someone else has an idea, I'd like to hear
> it.

Sure, that was more of an observation than a critique. In the absence of
any suggestions better, sticking with sizeof(*m) makes sense.

If it does become a problem, we're likely to have to fix up other sites
regardless.

Thanks,
Mark.
