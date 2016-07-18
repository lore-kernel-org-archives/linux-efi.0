From: Jeffrey Hugo <jhugo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: Re: [PATCH 1/4] efi/libstub: Allocate headspace in
 efi_get_memory_map()
Date: Mon, 18 Jul 2016 09:03:31 -0600
Message-ID: <8d1fd10a-97d0-df6e-0d52-dcc29671521d@codeaurora.org>
References: <1468788362-3962-1-git-send-email-jhugo@codeaurora.org>
 <1468788362-3962-2-git-send-email-jhugo@codeaurora.org>
 <20160718110001.GC10069@leverpostej>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160718110001.GC10069@leverpostej>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Cc: matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, timur-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 7/18/2016 5:00 AM, Mark Rutland wrote:
> Hi,
>
> On Sun, Jul 17, 2016 at 02:45:59PM -0600, Jeffrey Hugo wrote:
>> +	if (status == EFI_BUFFER_TOO_SMALL ||
>> +				(*buff_size - *map_size) / sizeof(*m) < 8) {
>>  		efi_call_early(free_pool, m);
>> +		/*
>> +		 * Make sure there is 8 entries worth of headroom so that the
>> +		 * buffer can be reused for a new map after allocations are
>> +		 * no longer permitted.  Its unlikely that the map will grow to
>> +		 * exceed this headroom once we are ready to trigger
>> +		 * ExitBootServices()
>> +		 */
>> +		*map_size += sizeof(*m) * 8;
>
> It's probably worth having something like...
>
>   #define EFI_MMAP_NR_SLACK_SLOTS	8
>
> ... at the top of the file, and changing the comment here to not refer
> to the specific value. That way we avoid duplicating the value, and
> making it easier to modify / backport in future.

You are right, that does make sense.  I'll wait a bit to see if there is 
any other feedback, and add this suggestion to V2.

> As a general note, it's a shame that we don't know desc_size first time
> through. If descs grow, 8 * sizeof(*m) might be too small. That's an
> existing problem though, so I guess it makes sense to be consistent and
> use sizeof(*m) here.

Yep.  Unless I've missed something, it seems like the two options are 
either make a decent attempt to guess at desc_size the first time 
(current approach), or intentionally fail the first time just to get the 
size.  The current approach doesn't seem perfect, but it does have a 
chance at passing with just one attempt.  I couldn't see a better 
solution, but if someone else has an idea, I'd like to hear it.

>
> Otherwise, this looks fine to me.
>
> Thanks,
> Mark.
>


-- 
Jeffrey Hugo
Qualcomm Datacenter Technologies as an affiliate of Qualcomm 
Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the
Code Aurora Forum, a Linux Foundation Collaborative Project.
