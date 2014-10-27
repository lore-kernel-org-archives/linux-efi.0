From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 10/10] arm64: dmi: set DMI string as dump stack arch description
Date: Mon, 27 Oct 2014 13:57:34 +0100
Message-ID: <CAKv+Gu8yfgDX3OrAb20Rco5A_mvU1NGQFSdRkUuxkpf4E_aOrQ@mail.gmail.com>
References: <1413987713-30528-1-git-send-email-ard.biesheuvel@linaro.org>
	<1413987713-30528-11-git-send-email-ard.biesheuvel@linaro.org>
	<20141027122451.GT8768@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141027122451.GT8768-5wv7dgnIgG8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
Cc: "leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mark Rutland <Mark.Rutland-5wv7dgnIgG8@public.gmane.org>, Catalin Marinas <Catalin.Marinas-5wv7dgnIgG8@public.gmane.org>, "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "yi.li-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <yi.li-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 27 October 2014 13:24, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org> wrote:
> On Wed, Oct 22, 2014 at 03:21:53PM +0100, Ard Biesheuvel wrote:
>> This sets the DMI string, containing system type, serial number,
>> firmware version etc. as dump stack arch description, so that oopses
>> and other kernel stack dumps automatically have this information
>> included, if available.
>>
>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>> ---
>>  arch/arm64/kernel/efi.c | 2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
>> index 0e9da0067ef2..baab9344a32b 100644
>> --- a/arch/arm64/kernel/efi.c
>> +++ b/arch/arm64/kernel/efi.c
>> @@ -477,6 +477,8 @@ static int __init arm64_dmi_init(void)
>>        * itself, depends on dmi_scan_machine() having been called already.
>>        */
>>       dmi_scan_machine();
>> +     if (dmi_available)
>> +             dmi_set_dump_stack_arch_desc();
>
> This looks fine, but I don't understand why you would ever *not* want to
> call this when DMI is available. In other words, why can't this be part
> of dmi_scan_machine?
>

/**
 * dmi_set_dump_stack_arch_desc - set arch description for dump_stack()
 *
 * Invoke dump_stack_set_arch_desc() with DMI system information so that
 * DMI identifiers are printed out on task dumps.  Arch boot code should
 * call this function after dmi_scan_machine() if it wants to print out DMI
 * identifiers on task dumps.
 */

Apparently, the author of the function had reason to assume that not
all architectures that implement DMI would choose to use the DMI
string as arch description even if it is available.

Currently, ia64 and x86 call this function unconditionally, which
means the arch description is cleared if it was set before, and moving
the call to dmi_scan_machine() should retain the same behavior. For
the arm64 case, I think calling it conditionally is better: if we ever
want to populate the arch description from DT, the unconditional call
would clear its contents even on non-DMI systems.

-- 
Ard.
