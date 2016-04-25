From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 6/6] efi/arm*: add support to dump the EFI page tables
Date: Mon, 25 Apr 2016 13:26:07 +0200
Message-ID: <CAKv+Gu9fOnKK66Ee7N_5UXbZh_cZbQ0AnnPLHQhm8qCb-r5gVg@mail.gmail.com>
References: <1461343688-8552-1-git-send-email-ard.biesheuvel@linaro.org>
	<1461343688-8552-7-git-send-email-ard.biesheuvel@linaro.org>
	<20160422170112.GS10606@leverpostej>
	<CAKv+Gu-abf2g5htQSHA=ETnSfzVExFLwsjs2Kbs8fn86MfFv3Q@mail.gmail.com>
	<20160422172513.GV10606@leverpostej>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160422172513.GV10606@leverpostej>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Cc: "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Russell King - ARM Linux <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 22 April 2016 at 19:25, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org> wrote:
> On Fri, Apr 22, 2016 at 07:20:38PM +0200, Ard Biesheuvel wrote:
>> On 22 April 2016 at 19:01, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org> wrote:
>> > On Fri, Apr 22, 2016 at 06:48:08PM +0200, Ard Biesheuvel wrote:
>
>> >> +static struct ptdump_info efi_ptdump_info = {
>> >> +     .mm             = &efi_mm,
>> >> +     .markers        = efi_addr_markers,
>> >> +     .base_addr      = 0,
>> >> +     .max_addr       = SZ_1G,
>> >> +};
>> >
>> > I see that max_addr isn't used for arm64, and for ARM it's only used in
>> > one place. It doesn't seem great to have that on arm64 given it's
>> > unused.
>> >
>> > Do we actually need max_addr? Is there any reason not to always dump
>> > whole tables?
>> >
>> > I guess you're trying to avoid dumping the kernel VA range on 32-bit?
>>
>> Indeed. On ARM, the efi_page_tables dumps its copy of
>> kernel_page_tables. If that is OK (the information could potentially
>> be useful, I suppose) we can drop the max
>
> I'd argue it's always worth dumping the full tables (dropipng the max).
>
> For instance, we could have some bug that leaves the kernel VA range in
> the EFI tables inconsistent with what we expect/require, and having that
> exposed would make that clear.
>

Well, the problem here is that we only sync the EFI page tables with
the kernel page tables in switch_mm() (if they turn out to be out of
sync). This means we should either sync them in this code path as
well, or remove the kernel VA range from the output, since we'll be
dumping known stale data otherwise.

> Regardless, arbitrarily limiting the VA range of the arm64 dump doesn't
> seem great.
>

True. [0 .. TASK_SIZE) looks like a useful and not arbitrary range to
limit the EFI page table output to. Unfortunately, TASK_SIZE resolves
to a value that depends on TIF_32BIT, so will still need some
preprocessor conditional to select between TASK_SIZE_64 (on arm64) and
TASK_SIZE (on ARM)
