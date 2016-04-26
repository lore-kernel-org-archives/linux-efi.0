From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 0/6] arm64/ARM pt dumper changes
Date: Tue, 26 Apr 2016 13:34:06 +0200
Message-ID: <CAKv+Gu9h4r1ypiUo23ZGw=rF_NqLwWybwrhT-1gyAE9TYhN0zA@mail.gmail.com>
References: <1461343688-8552-1-git-send-email-ard.biesheuvel@linaro.org>
	<20160426112918.GK27312@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160426112918.GK27312-5wv7dgnIgG8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
Cc: "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Russell King - ARM Linux <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 26 April 2016 at 13:29, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org> wrote:
> On Fri, Apr 22, 2016 at 06:48:02PM +0200, Ard Biesheuvel wrote:
>> This series updates the kernel page table dumper to:
>> - not initialize the vmemmap region markers dynamically
>> - show region boundaries for the kasan shadow region
>> - include the UEFI runtime services mappings
>
> I've merged the first two patches of this series. I can take patch 4 too
> if you can rebase onto for-next/core.
>

Thanks, but it is not very useful without the last patch. I am trying
to respin the code so it can be shared between ARM and arm64 in a way
that addresses Mark's concerns. But since this is debug code anyway, I
am not sure when I will get around to doing that.

Thanks,
Ard.
