From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 4/5] efi: efistub: refactor stub components
Date: Tue, 1 Jul 2014 17:18:08 +0200
Message-ID: <CAKv+Gu9tY7RqVXdWejwOPnpBTX0S5M9QxBH2te71kpysOV3vWA@mail.gmail.com>
References: <1403792617-25792-1-git-send-email-ard.biesheuvel@linaro.org>
	<1403792617-25792-5-git-send-email-ard.biesheuvel@linaro.org>
	<20140701151130.GF7539@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140701151130.GF7539-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 1 July 2014 17:11, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org> wrote:
> On Thu, 26 Jun, at 04:23:36PM, Ard Biesheuvel wrote:
>> In order to move from the #include "../../../xxxxx.c" anti-pattern used by
>> both the x86 and arm64 versions of the stub to a static library linked into
>> either the kernel proper (arm64) or a separate boot executable (x86), there
>> is some prepatory work required.
>>
>> This patch does the following:
>> - move forward declarations of functions shared between the arch specific and
>>   the generic parts of the stub to include/linux/efi.h
>> - move forward declarations of functions shared between various .c files of the
>>   generic stub code to a new local header file called "efistub.h"
>> - add #includes to all .c files which were formerly relying on the #includor to
>>   include the correct header files
>> - remove all static modifiers from functions which will need to be externally
>>   visible once we move to a static library
>>
>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>
> [...]
>
>> diff --git a/include/linux/efi.h b/include/linux/efi.h
>> index 0ceb816bdfc2..3a64f2f85821 100644
>> --- a/include/linux/efi.h
>> +++ b/include/linux/efi.h
>> @@ -1163,4 +1163,46 @@ static inline void
>>  efi_runtime_map_setup(void *map, int nr_entries, u32 desc_size) {}
>>  #endif
>>
>> +/* prototypes shared between arch specific and generic stub code */
>> +
>> +#define pr_efi(sys_table, msg)     efi_printk(sys_table, "EFI stub: "msg)
>> +#define pr_efi_err(sys_table, msg) efi_printk(sys_table, "EFI stub: ERROR: "msg)
>> +
>> +void efi_printk(efi_system_table_t *sys_table_arg, char *str);
>> +
>> +void efi_free(efi_system_table_t *sys_table_arg, unsigned long size,
>> +           unsigned long addr);
>> +
>> +char *efi_convert_cmdline(efi_system_table_t *sys_table_arg,
>> +                       efi_loaded_image_t *image, int *cmd_line_len);
>> +
>
> We've been very good so far at not splattering include/linux/efi.h with
> any of the EFI boot stub prototypes, and it would be awesome if we
> didn't have to start now.
>
> Is there any way we could avoid doing this? Arguably everything should
> be in the new efistub.h, no?
>

There are bits that are shared between code under arch/xxx and
drivers/firmware/efi, and what those bits are is different between the
archs. I used <asm/efi.h> just for convenience, but perhaps we could
add <asm/efistub.h> for each arch, and #include it in both "efistub.h"
under drivers/firmware/efi and the stub bits that live under arch/xxx?
Then any other users of <asm/efi.h> won't have to see it.

-- 
Ard.
