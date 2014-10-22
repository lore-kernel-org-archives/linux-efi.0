From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/2] efi: dmi: add support for SMBIOS 3.0 UEFI
 configuration table
Date: Wed, 22 Oct 2014 13:19:00 +0200
Message-ID: <CAKv+Gu-BKvGX2Z0A+06Q283UqoUn2pFQd274kQGkC-=Dh-UpvQ@mail.gmail.com>
References: <1413477343-10686-1-git-send-email-ard.biesheuvel@linaro.org>
	<20141022111056.GW22224@bivouac.eciton.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141022111056.GW22224-t77nlHhSwNqAroYi2ySoxKxOck334EZe@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org" <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Suravee Suthikulpanit <suravee.suthikulpanit-5C7GfCeVMHo@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 22 October 2014 13:10, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
> On Thu, Oct 16, 2014 at 06:35:42PM +0200, Ard Biesheuvel wrote:
>> This adds support to the UEFI side for detecting the presence of
>> a SMBIOS 3.0 64-bit entry point. This allows the actual SMBIOS
>> structure table to reside at a physical offset over 4 GB, which
>> cannot be supported by the legacy SMBIOS 32-bit entry point.
>>
>> Since the firmware can legally provide both entry points, store
>> the SMBIOS 3.0 entry point in a separate variable, and let the
>> DMI decoding layer decide which one will be used.
>>
>> Tested-by: Suravee Suthikulpanit <suravee.suthikulpanit-5C7GfCeVMHo@public.gmane.org>
>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>> ---
>>  drivers/firmware/efi/efi.c | 4 ++++
>>  include/linux/efi.h        | 6 +++++-
>>  2 files changed, 9 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
>> index 64ecbb501c50..3947caccff2d 100644
>> --- a/drivers/firmware/efi/efi.c
>> +++ b/drivers/firmware/efi/efi.c
>> @@ -30,6 +30,7 @@ struct efi __read_mostly efi = {
>>       .acpi       = EFI_INVALID_TABLE_ADDR,
>>       .acpi20     = EFI_INVALID_TABLE_ADDR,
>>       .smbios     = EFI_INVALID_TABLE_ADDR,
>> +     .smbios3    = EFI_INVALID_TABLE_ADDR,
>>       .sal_systab = EFI_INVALID_TABLE_ADDR,
>>       .boot_info  = EFI_INVALID_TABLE_ADDR,
>>       .hcdp       = EFI_INVALID_TABLE_ADDR,
>> @@ -64,6 +65,8 @@ static ssize_t systab_show(struct kobject *kobj,
>>               str += sprintf(str, "ACPI=0x%lx\n", efi.acpi);
>>       if (efi.smbios != EFI_INVALID_TABLE_ADDR)
>>               str += sprintf(str, "SMBIOS=0x%lx\n", efi.smbios);
>> +     if (efi.smbios3 != EFI_INVALID_TABLE_ADDR)
>> +             str += sprintf(str, "SMBIOS3=0x%lx\n", efi.smbios3);
>
> The specification also refers to it as the less version-sensitive
> "64-bit entry point". Would it make sense to instead call it
> SMBIOS64/efi.smbios64?
>

Very good point. It also makes it more self-explanatory, and of
course, it has a ring to it that will make people want to support it!
I will change it.

-- 
Ard.

>>       if (efi.hcdp != EFI_INVALID_TABLE_ADDR)
>>               str += sprintf(str, "HCDP=0x%lx\n", efi.hcdp);
>>       if (efi.boot_info != EFI_INVALID_TABLE_ADDR)
>> @@ -238,6 +241,7 @@ static __initdata efi_config_table_type_t common_tables[] = {
>>       {MPS_TABLE_GUID, "MPS", &efi.mps},
>>       {SAL_SYSTEM_TABLE_GUID, "SALsystab", &efi.sal_systab},
>>       {SMBIOS_TABLE_GUID, "SMBIOS", &efi.smbios},
>> +     {SMBIOS3_TABLE_GUID, "SMBIOS 3.0", &efi.smbios3},
>>       {UGA_IO_PROTOCOL_GUID, "UGA", &efi.uga},
>>       {NULL_GUID, NULL, NULL},
>>  };
>> diff --git a/include/linux/efi.h b/include/linux/efi.h
>> index 45cb4ffdea62..8760b9aed2bb 100644
>> --- a/include/linux/efi.h
>> +++ b/include/linux/efi.h
>> @@ -542,6 +542,9 @@ void efi_native_runtime_setup(void);
>>  #define SMBIOS_TABLE_GUID    \
>>      EFI_GUID(  0xeb9d2d31, 0x2d88, 0x11d3, 0x9a, 0x16, 0x0, 0x90, 0x27, 0x3f, 0xc1, 0x4d )
>>
>> +#define SMBIOS3_TABLE_GUID    \
>> +    EFI_GUID(  0xf2fd1544, 0x9794, 0x4a2c, 0x99, 0x2e, 0xe5, 0xbb, 0xcf, 0x20, 0xe3, 0x94 )
>> +
>>  #define SAL_SYSTEM_TABLE_GUID    \
>>      EFI_GUID(  0xeb9d2d32, 0x2d88, 0x11d3, 0x9a, 0x16, 0x0, 0x90, 0x27, 0x3f, 0xc1, 0x4d )
>>
>> @@ -805,7 +808,8 @@ extern struct efi {
>>       unsigned long mps;              /* MPS table */
>>       unsigned long acpi;             /* ACPI table  (IA64 ext 0.71) */
>>       unsigned long acpi20;           /* ACPI table  (ACPI 2.0) */
>> -     unsigned long smbios;           /* SM BIOS table */
>> +     unsigned long smbios;           /* SM BIOS table (32 bit entry point) */
>> +     unsigned long smbios3;          /* SM BIOS table (64 bit entry point) */
>>       unsigned long sal_systab;       /* SAL system table */
>>       unsigned long boot_info;        /* boot info table */
>>       unsigned long hcdp;             /* HCDP table */
>> --
>> 1.8.3.2
>>
>
> Again, Apart from the one comment:
> Acked-by: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
