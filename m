From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 4/6] efi: Get the secure boot status
Date: Tue, 22 Nov 2016 10:49:24 +0000
Message-ID: <CAKv+Gu-8TpFMk_Y9pNOvp9qdBa22cUY0NQvsk4=HQzFa17-6bw@mail.gmail.com>
References: <20161117123731.GA11573@wunner.de> <147977472115.6360.13015228230799369019.stgit@warthog.procyon.org.uk>
 <20161122104401.GC1552@wunner.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161122104401.GC1552-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
Cc: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-security-module <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 22 November 2016 at 10:44, Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org> wrote:
> On Tue, Nov 22, 2016 at 12:32:01AM +0000, David Howells wrote:
>> Get the firmware's secure-boot status in the kernel boot wrapper and stash
>> it somewhere that the main kernel image can find.
>
> That's a bit terse.  You could write here that you're moving the
> existing ARM function to generic stub code to be able to reuse it
> on x86.
>
> Further comments below.
>
>
>>
>> Signed-off-by: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
>> Signed-off-by: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> ---
>>
>>  Documentation/x86/zero-page.txt           |    2 +
>>  arch/x86/boot/compressed/eboot.c          |    5 ++
>>  arch/x86/include/uapi/asm/bootparam.h     |    3 +
>>  drivers/firmware/efi/libstub/Makefile     |    2 -
>>  drivers/firmware/efi/libstub/arm-stub.c   |   46 --------------------
>>  drivers/firmware/efi/libstub/secureboot.c |   66 +++++++++++++++++++++++++++++
>>  include/linux/efi.h                       |    2 +
>>  7 files changed, 78 insertions(+), 48 deletions(-)
>>  create mode 100644 drivers/firmware/efi/libstub/secureboot.c
>>
>> diff --git a/Documentation/x86/zero-page.txt b/Documentation/x86/zero-page.txt
>> index 95a4d34af3fd..b8527c6b7646 100644
>> --- a/Documentation/x86/zero-page.txt
>> +++ b/Documentation/x86/zero-page.txt
>> @@ -31,6 +31,8 @@ Offset      Proto   Name            Meaning
>>  1E9/001      ALL     eddbuf_entries  Number of entries in eddbuf (below)
>>  1EA/001      ALL     edd_mbr_sig_buf_entries Number of entries in edd_mbr_sig_buffer
>>                               (below)
>> +1EB/001      ALL     kbd_status      Numlock is enabled
>> +1EC/001      ALL     secure_boot     Secure boot is enabled in the firmware
>>  1EF/001      ALL     sentinel        Used to detect broken bootloaders
>>  290/040      ALL     edd_mbr_sig_buffer EDD MBR signatures
>>  2D0/A00      ALL     e820_map        E820 memory map table
>> diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
>> index c8c32ebcdfdb..fd6506de480d 100644
>> --- a/arch/x86/boot/compressed/eboot.c
>> +++ b/arch/x86/boot/compressed/eboot.c
>> @@ -12,6 +12,7 @@
>>  #include <asm/efi.h>
>>  #include <asm/setup.h>
>>  #include <asm/desc.h>
>> +#include <asm/bootparam_utils.h>
>>
>>  #include "../string.h"
>>  #include "eboot.h"
>> @@ -1158,6 +1159,10 @@ struct boot_params *efi_main(struct efi_config *c,
>>       else
>>               setup_boot_services32(efi_early);
>>
>> +     sanitize_boot_params(boot_params);
>
> What is the connection of this change to the rest of the patch?
> Needs an explanation in the commit message.
>
>
>> +
>> +     boot_params->secure_boot = efi_get_secureboot();
>> +
>>       setup_graphics(boot_params);
>>
>>       setup_efi_pci(boot_params);
>> diff --git a/arch/x86/include/uapi/asm/bootparam.h b/arch/x86/include/uapi/asm/bootparam.h
>> index b10bf319ed20..5138dacf8bb8 100644
>> --- a/arch/x86/include/uapi/asm/bootparam.h
>> +++ b/arch/x86/include/uapi/asm/bootparam.h
>> @@ -135,7 +135,8 @@ struct boot_params {
>>       __u8  eddbuf_entries;                           /* 0x1e9 */
>>       __u8  edd_mbr_sig_buf_entries;                  /* 0x1ea */
>>       __u8  kbd_status;                               /* 0x1eb */
>> -     __u8  _pad5[3];                                 /* 0x1ec */
>> +     __u8  secure_boot;                              /* 0x1ec */
>> +     __u8  _pad5[2];                                 /* 0x1ed */
>>       /*
>>        * The sentinel is set to a nonzero value (0xff) in header.S.
>>        *
>> diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmware/efi/libstub/Makefile
>> index 6621b13c370f..9af966863612 100644
>> --- a/drivers/firmware/efi/libstub/Makefile
>> +++ b/drivers/firmware/efi/libstub/Makefile
>> @@ -28,7 +28,7 @@ OBJECT_FILES_NON_STANDARD   := y
>>  # Prevents link failures: __sanitizer_cov_trace_pc() is not linked in.
>>  KCOV_INSTRUMENT                      := n
>>
>> -lib-y                                := efi-stub-helper.o gop.o
>> +lib-y                                := efi-stub-helper.o gop.o secureboot.o
>>
>>  # include the stub's generic dependencies from lib/ when building for ARM/arm64
>>  arm-deps := fdt_rw.c fdt_ro.c fdt_wip.c fdt.c fdt_empty_tree.c fdt_sw.c sort.c
>> diff --git a/drivers/firmware/efi/libstub/arm-stub.c b/drivers/firmware/efi/libstub/arm-stub.c
>> index b4f7d78f9e8b..552ee61ddbed 100644
>> --- a/drivers/firmware/efi/libstub/arm-stub.c
>> +++ b/drivers/firmware/efi/libstub/arm-stub.c
>> @@ -20,52 +20,6 @@
>>
>>  bool __nokaslr;
>>
>> -static int efi_get_secureboot(efi_system_table_t *sys_table_arg)
>> -{
>> -     static efi_char16_t const sb_var_name[] = {
>> -             'S', 'e', 'c', 'u', 'r', 'e', 'B', 'o', 'o', 't', 0 };
>> -     static efi_char16_t const sm_var_name[] = {
>> -             'S', 'e', 't', 'u', 'p', 'M', 'o', 'd', 'e', 0 };
>> -
>> -     efi_guid_t var_guid = EFI_GLOBAL_VARIABLE_GUID;
>> -     efi_get_variable_t *f_getvar = sys_table_arg->runtime->get_variable;
>> -     u8 val;
>> -     unsigned long size = sizeof(val);
>> -     efi_status_t status;
>> -
>> -     status = f_getvar((efi_char16_t *)sb_var_name, (efi_guid_t *)&var_guid,
>> -                       NULL, &size, &val);
>> -
>> -     if (status != EFI_SUCCESS)
>> -             goto out_efi_err;
>> -
>> -     if (val == 0)
>> -             return 0;
>> -
>> -     status = f_getvar((efi_char16_t *)sm_var_name, (efi_guid_t *)&var_guid,
>> -                       NULL, &size, &val);
>> -
>> -     if (status != EFI_SUCCESS)
>> -             goto out_efi_err;
>> -
>> -     if (val == 1)
>> -             return 0;
>> -
>> -     return 1;
>> -
>> -out_efi_err:
>> -     switch (status) {
>> -     case EFI_NOT_FOUND:
>> -             return 0;
>> -     case EFI_DEVICE_ERROR:
>> -             return -EIO;
>> -     case EFI_SECURITY_VIOLATION:
>> -             return -EACCES;
>> -     default:
>> -             return -EINVAL;
>> -     }
>> -}
>> -
>>  efi_status_t efi_open_volume(efi_system_table_t *sys_table_arg,
>>                            void *__image, void **__fh)
>>  {
>> diff --git a/drivers/firmware/efi/libstub/secureboot.c b/drivers/firmware/efi/libstub/secureboot.c
>> new file mode 100644
>> index 000000000000..e44d8c9ee150
>> --- /dev/null
>> +++ b/drivers/firmware/efi/libstub/secureboot.c
>> @@ -0,0 +1,66 @@
>> +/*
>> + * Secure boot handling.
>> + *
>> + * Copyright (C) 2013,2014 Linaro Limited
>> + *     Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
>> + * Copyright (C) 2013 Red Hat, Inc.
>> + *     Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> + *
>> + * This file is part of the Linux kernel, and is made available under the
>> + * terms of the GNU General Public License version 2.
>> + *
>> + */
>> +
>> +#include <linux/efi.h>
>> +#include <linux/sort.h>
>
> You don't need sort.h.
>
>
>> +#include <asm/efi.h>
>> +
>> +#include "efistub.h"
>
> From a cursory look at efistub.h, you don't seem to need this either.
>
>
>> +
>> +int efi_get_secureboot(void)
>
> It looks like you didn't compile-test this on ARM.
>
> You dropped the efi_system_table_t *sys_table_arg argument but this
> isn't defined anywhere as a static global.
>

That is actually a thing that has been annoying me: the efi_call_xxx
macros on ARM/arm64 rely on sys_table_arg being defined in the current
scope, which hides this dependency from users of the macro, and is
also a pain given that you are forced to use the exact name
'sys_table_arg'. Patches that clean that up are gladly accepted, or I
may take a stab at this myself (but not for a week or two)

>
>> +{
>> +     static const efi_char16_t const sb_var_name[] = {
>> +             'S', 'e', 'c', 'u', 'r', 'e', 'B', 'o', 'o', 't', 0 };
>> +     static const efi_char16_t const sm_var_name[] = {
>> +             'S', 'e', 't', 'u', 'p', 'M', 'o', 'd', 'e', 0 };
>> +
>> +     static const efi_guid_t var_guid = EFI_GLOBAL_VARIABLE_GUID;
>> +
>
> Gratuitous newline in-between variable declarations.
>
>> +     u8 val;
>> +     unsigned long size = sizeof(val);
>> +     efi_status_t status;
>> +
>> +#define f_getvar(...) efi_call_runtime(get_variable, __VA_ARGS__)
>> +
>> +     status = f_getvar((efi_char16_t *)sb_var_name, (efi_guid_t *)&var_guid,
>> +                       NULL, &size, &val);
>
> Just replace the f_getvar yourself instead of having cpp do it:
>
>         status = efi_call_runtime(get_variable, (efi_char16_t *)sb_var_name,
>                                   (efi_guid_t *)&var_guid, NULL, &size, &val);
>
>
>> +
>> +     if (status != EFI_SUCCESS)
>> +             goto out_efi_err;
>> +
>> +     if (val == 0)
>> +             return 0;
>> +
>> +     status = f_getvar((efi_char16_t *)sm_var_name, (efi_guid_t *)&var_guid,
>> +                       NULL, &size, &val);
>
> Same here.
>
>
>> +
>> +     if (status != EFI_SUCCESS)
>> +             goto out_efi_err;
>> +
>> +     if (val == 1)
>> +             return 0;
>> +
>> +     return 1;
>> +
>> +out_efi_err:
>> +     switch (status) {
>> +     case EFI_NOT_FOUND:
>> +             return 0;
>> +     case EFI_DEVICE_ERROR:
>> +             return -EIO;
>> +     case EFI_SECURITY_VIOLATION:
>> +             return -EACCES;
>> +     default:
>> +             return -EINVAL;
>> +     }
>
> The "out_efi_err" portion differs from the previous version of this
> patch.  Setting a __u8 to a negative value, is this really what you
> want?
>
> Thanks,
>
> Lukas
>
>> +}
>> diff --git a/include/linux/efi.h b/include/linux/efi.h
>> index 24db4e5ec817..615d8704f048 100644
>> --- a/include/linux/efi.h
>> +++ b/include/linux/efi.h
>> @@ -1477,6 +1477,8 @@ efi_status_t efi_setup_gop(efi_system_table_t *sys_table_arg,
>>  bool efi_runtime_disabled(void);
>>  extern void efi_call_virt_check_flags(unsigned long flags, const char *call);
>>
>> +int efi_get_secureboot(void);
>> +
>>  /*
>>   * Arch code can implement the following three template macros, avoiding
>>   * reptition for the void/non-void return cases of {__,}efi_call_virt():
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-efi" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
