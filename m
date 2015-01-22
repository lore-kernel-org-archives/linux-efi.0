From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] arm64/efi: move virtmap init to early initcall
Date: Thu, 22 Jan 2015 17:37:58 +0000
Message-ID: <CAKv+Gu-TLnXOHtq1+rWJRPdLbTfau0t_c0+2KAbqk85wrF1zDg@mail.gmail.com>
References: <1421920900-27028-1-git-send-email-ard.biesheuvel@linaro.org>
	<20150122155924.GC28096@e104818-lin.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150122155924.GC28096-M2fw3Uu6cmfZROr8t4l/smS4ubULX0JqMm0uRHvK7Nw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
Cc: "leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mark Rutland <Mark.Rutland-5wv7dgnIgG8@public.gmane.org>, Will Deacon <Will.Deacon-5wv7dgnIgG8@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "lauraa-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org" <lauraa-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 22 January 2015 at 15:59, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org> wrote:
> On Thu, Jan 22, 2015 at 10:01:40AM +0000, Ard Biesheuvel wrote:
>> Now that the create_mapping() code in mm/mmu.c is able to support
>> setting up kernel page tables at initcall time, we can move the whole
>> virtmap creation to arm64_enable_runtime_services() instead of having
>> a distinct stage during early boot. This also allows us to drop the
>> arm64-specific EFI_VIRTMAP flag.
>>
>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>
> Applied. Thanks.
>

Wow that was quick. I noticed that you mangled my S-o-b line though:
not something I care deeply about, just a FYI
