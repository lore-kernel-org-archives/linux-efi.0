From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3] efi/arm64: handle missing virtual mapping for UEFI
 System Table
Date: Fri, 4 Jul 2014 19:19:33 +0200
Message-ID: <CAKv+Gu_-=NtVNFLEh35Pv8OO6nLe1YhPjS13MYZa93YOXFOh6Q@mail.gmail.com>
References: <1404487509-26084-1-git-send-email-ard.biesheuvel@linaro.org>
	<1404492756.19665.57.camel@deneb.redhat.com>
	<20140704170110.GM16404@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140704170110.GM16404-5wv7dgnIgG8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
Cc: Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 4 July 2014 19:01, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org> wrote:
> On Fri, Jul 04, 2014 at 05:52:36PM +0100, Mark Salter wrote:
>> On Fri, 2014-07-04 at 17:25 +0200, Ard Biesheuvel wrote:
>> > If we cannot resolve the virtual address of the UEFI System Table, its physical
>> > offset must be missing from the virtual memory map, and there is really no point
>> > in proceeding with installing the virtual memory map and the runtime services
>> > dispatch table. So back out gracefully.
>> >
>> > Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>> > ---
>>
>> Acked-by: Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>
> Thanks. Do I take this patch or Matt already has other EFI patches to
> push? If the latter:
>
> Acked-by: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>

Thanks. You can take it for 3.16 if you like, otherwise it is probably
better if we ask Matt to take it through his tree with some other
stuff we have in flight at the moment.

-- 
Ard.
