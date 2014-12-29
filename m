From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v4 4/8] efi: efistub: allow allocation alignment larger
 than EFI_PAGE_SIZE
Date: Mon, 29 Dec 2014 09:25:15 +0000
Message-ID: <CAKv+Gu_+scCHYuXccgsvn9THsbP24OfyjvjN9XtEVe4nMdQtig@mail.gmail.com>
References: <1419245944-2424-1-git-send-email-ard.biesheuvel@linaro.org>
	<1419245944-2424-5-git-send-email-ard.biesheuvel@linaro.org>
	<20141223164549.GB3810@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141223164549.GB3810-fF5Pk5pvG8Y@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Geoff Levand <geoff.levand-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 23 December 2014 at 16:45, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org> wrote:
> On Mon, Dec 22, 2014 at 10:59:00AM +0000, Ard Biesheuvel wrote:
>> On systems with 64 KB pages, it is preferable for UEFI memory map
>> entries to be 64 KB aligned multiples of 64 KB, because it relieves
>> us of having to deal with the residues.
>> So, if EFI_ALLOC_ALIGN is #define'd by the platform, use it to round
>> up all memory allocations made.
>>
>> Acked-by: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>
> Acked-by: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
>

Thanks Boris.

Do you have any comments regarding patches #3 and #6 in this series?
Patch #3 is actual common code, but patch #6 also touches a file under
drivers/firmware/efi/libstub (but it is only used by arm64 atm) With
your acks on those, I could ask Catalin or Will to take the whole
series through the arm64 tree.

Regards,
Ard.
