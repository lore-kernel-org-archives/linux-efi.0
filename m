From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/3] efi/libstub: move FDT sanity check out of allocation loop
Date: Tue, 17 Nov 2015 13:09:50 +0100
Message-ID: <CAKv+Gu_329dVZrSF05QvSLv_vezDvT_AP3yK5FtVuhpJnqLSZQ@mail.gmail.com>
References: <1444206929-13374-1-git-send-email-ard.biesheuvel@linaro.org>
	<1444206929-13374-2-git-send-email-ard.biesheuvel@linaro.org>
	<20151117114718.GF12586@leverpostej>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151117114718.GF12586@leverpostej>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Grant Likely <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 17 November 2015 at 12:47, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org> wrote:
> On Wed, Oct 07, 2015 at 09:35:27AM +0100, Ard Biesheuvel wrote:
>> The memory allocation for the updated FDT may execute several times
>> if the allocation turns out to be insufficiently large. There is no
>> need to sanity check the original FDT each time, so take it out of
>> the loop.
>>
>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>
> Acked-by: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
>

Thanks.

In the mean time, I noticed that this could be refactored even
further, since checking the size only makes sense if the FDT was
loaded from a file, and checking the header is redundant if the FDT
was loaded from a config table.

-- 
Ard.


>> ---
>>  drivers/firmware/efi/libstub/fdt.c | 42 ++++++++++++--------
>>  1 file changed, 26 insertions(+), 16 deletions(-)
>>
>> diff --git a/drivers/firmware/efi/libstub/fdt.c b/drivers/firmware/efi/libstub/fdt.c
>> index ef5d764e2a27..354172bee81c 100644
>> --- a/drivers/firmware/efi/libstub/fdt.c
>> +++ b/drivers/firmware/efi/libstub/fdt.c
>> @@ -16,6 +16,26 @@
>>
>>  #include "efistub.h"
>>
>> +static efi_status_t sanity_check_fdt(efi_system_table_t *sys_table,
>> +                                  void *fdt, unsigned long fdt_size)
>> +{
>> +     if (fdt_check_header(fdt)) {
>> +             pr_efi_err(sys_table, "Device Tree header not valid!\n");
>> +             return EFI_LOAD_ERROR;
>> +     }
>> +
>> +     /*
>> +      * We don't get the size of the FDT if we get if from a
>> +      * configuration table.
>> +      */
>> +     if (fdt_size && fdt_totalsize(fdt) > fdt_size) {
>> +             pr_efi_err(sys_table, "Truncated device tree! foo!\n");
>> +             return EFI_LOAD_ERROR;
>> +     }
>> +
>> +     return EFI_SUCCESS;
>> +}
>> +
>>  efi_status_t update_fdt(efi_system_table_t *sys_table, void *orig_fdt,
>>                       unsigned long orig_fdt_size,
>>                       void *fdt, int new_fdt_size, char *cmdline_ptr,
>> @@ -29,22 +49,6 @@ efi_status_t update_fdt(efi_system_table_t *sys_table, void *orig_fdt,
>>       u32 fdt_val32;
>>       u64 fdt_val64;
>>
>> -     /* Do some checks on provided FDT, if it exists*/
>> -     if (orig_fdt) {
>> -             if (fdt_check_header(orig_fdt)) {
>> -                     pr_efi_err(sys_table, "Device Tree header not valid!\n");
>> -                     return EFI_LOAD_ERROR;
>> -             }
>> -             /*
>> -              * We don't get the size of the FDT if we get if from a
>> -              * configuration table.
>> -              */
>> -             if (orig_fdt_size && fdt_totalsize(orig_fdt) > orig_fdt_size) {
>> -                     pr_efi_err(sys_table, "Truncated device tree! foo!\n");
>> -                     return EFI_LOAD_ERROR;
>> -             }
>> -     }
>> -
>>       if (orig_fdt)
>>               status = fdt_open_into(orig_fdt, fdt, new_fdt_size);
>>       else
>> @@ -213,6 +217,12 @@ efi_status_t allocate_new_fdt_and_exit_boot(efi_system_table_t *sys_table,
>>               return status;
>>       }
>>
>> +     if (fdt_addr) {
>> +             status = sanity_check_fdt(sys_table, (void*)fdt_addr, fdt_size);
>> +             if (status != EFI_SUCCESS)
>> +                     goto fail;
>> +     }
>> +
>>       pr_efi(sys_table,
>>              "Exiting boot services and installing virtual address map...\n");
>>
>> --
>> 1.9.1
>>
