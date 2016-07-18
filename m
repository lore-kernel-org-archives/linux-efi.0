From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/4] efi/libstub: Allocate headspace in efi_get_memory_map()
Date: Mon, 18 Jul 2016 17:14:46 +0200
Message-ID: <CAKv+Gu9fy0KRr9u3Euva8Jc1U-uGhCuSB5Fyt6C-o-7tD0+Phw@mail.gmail.com>
References: <1468788362-3962-1-git-send-email-jhugo@codeaurora.org>
 <1468788362-3962-2-git-send-email-jhugo@codeaurora.org> <20160718110001.GC10069@leverpostej>
 <8d1fd10a-97d0-df6e-0d52-dcc29671521d@codeaurora.org> <20160718151147.GH10069@leverpostej>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160718151147.GH10069@leverpostej>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Cc: Jeffrey Hugo <jhugo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Timur Tabi <timur-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 18 July 2016 at 17:11, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org> wrote:
> On Mon, Jul 18, 2016 at 09:03:31AM -0600, Jeffrey Hugo wrote:
>> On 7/18/2016 5:00 AM, Mark Rutland wrote:
>> >Hi,
>> >
>> >On Sun, Jul 17, 2016 at 02:45:59PM -0600, Jeffrey Hugo wrote:
>> >>+   if (status == EFI_BUFFER_TOO_SMALL ||
>> >>+                           (*buff_size - *map_size) / sizeof(*m) < 8) {
>> >>            efi_call_early(free_pool, m);
>> >>+           /*
>> >>+            * Make sure there is 8 entries worth of headroom so that the
>> >>+            * buffer can be reused for a new map after allocations are
>> >>+            * no longer permitted.  Its unlikely that the map will grow to
>> >>+            * exceed this headroom once we are ready to trigger
>> >>+            * ExitBootServices()
>> >>+            */
>> >>+           *map_size += sizeof(*m) * 8;
>
>> >As a general note, it's a shame that we don't know desc_size first time
>> >through. If descs grow, 8 * sizeof(*m) might be too small. That's an
>> >existing problem though, so I guess it makes sense to be consistent and
>> >use sizeof(*m) here.
>>
>> Yep.  Unless I've missed something, it seems like the two options
>> are either make a decent attempt to guess at desc_size the first
>> time (current approach), or intentionally fail the first time just
>> to get the size.  The current approach doesn't seem perfect, but it
>> does have a chance at passing with just one attempt.  I couldn't see
>> a better solution, but if someone else has an idea, I'd like to hear
>> it.
>
> Sure, that was more of an observation than a critique. In the absence of
> any suggestions better, sticking with sizeof(*m) makes sense.
>
> If it does become a problem, we're likely to have to fix up other sites
> regardless.
>

It is worth noting that the EDK2 implementation deliberately uses a
desc_size that exceeds the size of the type. So '8 * sizeof(*m)' is
almost never going to be 8 slots' worth of headroom.

-- 
Ard.
