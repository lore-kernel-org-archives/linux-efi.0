From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2] arm64/efi: prefer AllocatePages() over efi_low_alloc()
 for vmlinux
Date: Tue, 28 Jul 2015 23:24:23 +0200
Message-ID: <CAKv+Gu_EtOV8wannMLG87ai_x3ARu4rUSo9D6w2DQ+Kb5Kjn-A@mail.gmail.com>
References: <1437737907-10477-1-git-send-email-ard.biesheuvel@linaro.org>
	<20150728211752.GE2773@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150728211752.GE2773-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 28 July 2015 at 23:17, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:
> On Fri, 24 Jul, at 01:38:27PM, Ard Biesheuvel wrote:
>> When allocating memory for the kernel image, try the AllocatePages()
>> boot service to obtain memory at the preferred offset of
>> 'dram_base + TEXT_OFFSET', and only revert to efi_low_alloc() if that
>> fails. This is the only way to allocate at the base of DRAM if DRAM
>> starts at 0x0, since efi_low_alloc() refuses to allocate at 0x0.
>>
>> Tested-by: Haojian Zhuang <haojian.zhuang-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>> ---
>> v2:
>> - reshuffle code flow to make it more logical, and have only a single
>>   memcpy() invocation at the end of the function
>> ---
>>  arch/arm64/kernel/efi-stub.c | 41 ++++++++++++++++++++++++++++++++---------
>>  1 file changed, 32 insertions(+), 9 deletions(-)
>
> Would it be easier if we allow efi_low_alloc() to return 0x0 for some
> uses? If you don't need the preference for low allocations, probably
> not, but I don't want to see us working around limitations in
> efi_low_alloc() instead of just fixing it.
>

This workaround fixes another issue as well: the arm64 kernel needs to
be loaded 512 KB above a 2MB aligned boundary, and using
efi_low_alloc() as we do loses (2 MB - 512 KB) at the bottom if part
of that 512 KB is occupied, since efi_low_alloc() is not aware of the
fact that the first 512 KB will remain unused.

What would be most helpful is if efi_low_alloc() could take an offset
param in addition to the alignment, i.e., alignment == 2MB and offset
== 512 KB. The offset would default to 0, reverting to the original
behavior.

If you'd be ok with such a change, I can propose it instead, and wire
it up into this function.

-- 
Ard.
