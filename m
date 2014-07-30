From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 1/3] arm64: spin-table: handle unmapped cpu-release-addrs
Date: Wed, 30 Jul 2014 21:17:02 +0200
Message-ID: <CAKv+Gu8ne8k2NV12SyWye5aYJKHG0wHKAO+=V=1L89_hvyGopw@mail.gmail.com>
References: <1406717944-24725-1-git-send-email-ard.biesheuvel@linaro.org>
	<1406717944-24725-2-git-send-email-ard.biesheuvel@linaro.org>
	<20140730113013.GL12239@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140730113013.GL12239-5wv7dgnIgG8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Mark Rutland <Mark.Rutland-5wv7dgnIgG8@public.gmane.org>, "leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

]On 30 July 2014 13:30, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org> wrote:
> On Wed, Jul 30, 2014 at 11:59:02AM +0100, Ard Biesheuvel wrote:
>> From: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
>>
>> In certain cases the cpu-release-addr of a CPU may not fall in the
>> linear mapping (e.g. when the kernel is loaded above this address due to
>> the presence of other images in memory). This is problematic for the
>> spin-table code as it assumes that it can trivially convert a
>> cpu-release-addr to a valid VA in the linear map.
>>
>> This patch modifies the spin-table code to use a temporary cached
>> mapping to write to a given cpu-release-addr, enabling us to support
>> addresses regardless of whether they are covered by the linear mapping.
>>
>> Signed-off-by: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
>> Tested-by: Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> [ardb: added (__force void *) cast]
>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>> ---
>>  arch/arm64/kernel/smp_spin_table.c | 22 +++++++++++++++++-----
>>  1 file changed, 17 insertions(+), 5 deletions(-)
>
> I'm nervous about this. What if the spin table sits in the same physical 64k
> frame as a read-sensitive device and we're running with 64k pages?
>

Actually, booting.txt requires cpu-release-addr to point to a
/memreserve/d part of memory, which implies DRAM (or you wouldn't have
to memreserve it)
That means it should always be covered by the linear mapping, unless
it is located before Image in DRAM, which is the case addressed by
this patch.

-- 
Ard.
