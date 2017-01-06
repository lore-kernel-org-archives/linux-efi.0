From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 03/10] efi: Constify GetVariable() / SetVariable() arguments
Date: Fri, 6 Jan 2017 16:28:28 +0000
Message-ID: <CAKv+Gu-izRwdrUu7zZLSnf_mjCwFFZ0AsyF5iMR49+UXkmpsgQ@mail.gmail.com>
References: <cover.1483318593.git.lukas@wunner.de> <2be92e87ff7855bcd88c86a7436f46d3488483f0.1483318593.git.lukas@wunner.de>
 <CAKv+Gu8UnAzQGsmyWYsWsOY3B+J9HXechwBX_Vk-rntBtO+Dug@mail.gmail.com> <20170106101652.GB21850@wunner.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170106101652.GB21850-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Fenghua Yu <fenghua.yu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Anton Vorontsov <anton-9xeibp6oKSgdnm+yROfE0A@public.gmane.org>, Colin Cross <ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Artur Paszkiewicz <artur.paszkiewicz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 6 January 2017 at 10:16, Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org> wrote:
> On Wed, Jan 04, 2017 at 05:38:13PM +0000, Ard Biesheuvel wrote:
>> On 2 January 2017 at 10:24, Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org> wrote:
>> > GUIDs and variable names passed to GetVariable() / SetVariable() are not
>> > modified, so declare them const.  This allows the compiler to place them
>> > in the rodata section instead of generating them on the stack at
>> > runtime.  Pass GUIDs as literals rather than assigning them to temporary
>> > variables to save a bit on code.
>> >
>> > Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
>> > Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>> > Cc: Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>> > Cc: Fenghua Yu <fenghua.yu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>> > Cc: Anton Vorontsov <anton-9xeibp6oKSgdnm+yROfE0A@public.gmane.org>
>> > Cc: Colin Cross <ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>
>> > Cc: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
>> > Cc: Artur Paszkiewicz <artur.paszkiewicz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>> > Cc: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>> > Cc: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>> > Signed-off-by: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
>> > ---
>> >  arch/ia64/kernel/efi.c                  | 15 ++++-----------
>> >  arch/x86/platform/efi/quirks.c          |  2 +-
>> >  drivers/firmware/efi/efi-pstore.c       |  4 ++--
>> >  drivers/firmware/efi/efibc.c            |  3 +--
>> >  drivers/firmware/efi/libstub/arm-stub.c |  5 ++---
>> >  drivers/infiniband/hw/hfi1/efivar.c     |  6 +-----
>> >  drivers/scsi/isci/probe_roms.c          |  2 +-
>> >  7 files changed, 12 insertions(+), 25 deletions(-)
>> >
>> > diff --git a/arch/ia64/kernel/efi.c b/arch/ia64/kernel/efi.c
>> > index f57d089..f1264ab 100644
>> > --- a/arch/ia64/kernel/efi.c
>> > +++ b/arch/ia64/kernel/efi.c
>> > @@ -919,22 +919,15 @@ static void __init handle_palo(unsigned long phys_addr)
>> >  efi_uart_console_only(void)
>> >  {
>> >         efi_status_t status;
>> > -       char *s, name[] = "ConOut";
>> > -       efi_guid_t guid = EFI_GLOBAL_VARIABLE_GUID;
>> > -       efi_char16_t *utf16, name_utf16[32];
>> > +       const char name[] = "ConOut";
>> > +       const efi_char16_t name_utf16[] = { 'C', 'o', 'n', 'O', 'u', 't', 0 };
>>
>> I know you mention 'static' in 10/10, but I don't understand why you
>> don't make these static to begin with. That also allows you to
>> annotate them as __initconst, which is not possible for compound
>> initializers (including the GUID)
>
> Right, I hadn't thought of __initconst.  In this particular case indeed
> it might make sense to use "static const efi_guid_t guid __initconst = ...",
> and arguably for the strings as well.  But where should I draw the line?
>
> There are a handful of other GUIDs used in __init functions, e.g. in
> arch/ia64/ there's ESI_TABLE_GUID in kernel/esi.c:esi_init() and
> SAL_SYSTEM_TABLE_GUID in sn/kernel/setup.c:early_sn_setup().
> This patch set results in them being placed in rodata, but not
> init.rodata.  Should I declare a temporary "static const __initconst"
> variable for each of them?  That would give us 16 bytes in each of the
> two cases being freed after kernel initialization.
>
> However string literals aren't put in init.rodata either even though
> they're declared in an __init function.  E.g. early_sn_setup() contains
> a string literal "failed to find SAL entry point\n".  That's 31 bytes.
> esi_init() contains even 103 bytes of string literals.
>
> So I'm not sure if it's worth to move the GUIDs to init.rodata (at the
> expense of an additional LoC to declare a temporary variable) even
> though we waste more space for string literals.
>

For the string literals I think there are some solutions possible
involving compiler plugins. Kees?

>>
>> >         unsigned char data[1024];
>> >         unsigned long size = sizeof(data);
>> >         struct efi_generic_dev_path *hdr, *end_addr;
>> >         int uart = 0;
>> >
>> > -       /* Convert to UTF-16 */
>> > -       utf16 = name_utf16;
>> > -       s = name;
>> > -       while (*s)
>> > -               *utf16++ = *s++ & 0x7f;
>> > -       *utf16 = 0;
>> > -
>> > -       status = efi.get_variable(name_utf16, &guid, NULL, &size, data);
>> > +       status = efi.get_variable(name_utf16, &EFI_GLOBAL_VARIABLE_GUID,
>> > +                                 NULL, &size, data);
>> >         if (status != EFI_SUCCESS) {
>> >                 printk(KERN_ERR "No EFI %s variable?\n", name);
>> >                 return 0;
>> > diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
>> > index 10aca63..aad3701 100644
>> > --- a/arch/x86/platform/efi/quirks.c
>> > +++ b/arch/x86/platform/efi/quirks.c
>> > @@ -19,7 +19,7 @@
>> >  #define EFI_DUMMY_GUID \
>> >         EFI_GUID(0x4424ac57, 0xbe4b, 0x47dd, 0x9e, 0x97, 0xed, 0x50, 0xf0, 0x9f, 0x92, 0xa9)
>> >
>> > -static efi_char16_t efi_dummy_name[6] = { 'D', 'U', 'M', 'M', 'Y', 0 };
>> > +static const efi_char16_t efi_dummy_name[6] = { 'D', 'U', 'M', 'M', 'Y', 0 };
>> >
>> >  static bool efi_no_storage_paranoia;
>> >
>> > diff --git a/drivers/firmware/efi/efi-pstore.c b/drivers/firmware/efi/efi-pstore.c
>> > index f402ba2..0911449 100644
>> > --- a/drivers/firmware/efi/efi-pstore.c
>> > +++ b/drivers/firmware/efi/efi-pstore.c
>> > @@ -265,7 +265,6 @@ static int efi_pstore_write(enum pstore_type_id type,
>> >  {
>> >         char name[DUMP_NAME_LEN];
>> >         efi_char16_t efi_name[DUMP_NAME_LEN];
>> > -       efi_guid_t vendor = LINUX_EFI_CRASH_GUID;
>> >         int i, ret = 0;
>> >
>> >         sprintf(name, "dump-type%u-%u-%d-%lu-%c", type, part, count,
>> > @@ -274,7 +273,8 @@ static int efi_pstore_write(enum pstore_type_id type,
>> >         for (i = 0; i < DUMP_NAME_LEN; i++)
>> >                 efi_name[i] = name[i];
>> >
>> > -       efivar_entry_set_safe(efi_name, vendor, PSTORE_EFI_ATTRIBUTES,
>> > +       efivar_entry_set_safe(efi_name, LINUX_EFI_CRASH_GUID,
>> > +                             PSTORE_EFI_ATTRIBUTES,
>> >                               !pstore_cannot_block_path(reason),
>> >                               size, psi->buf);
>> >
>> > diff --git a/drivers/firmware/efi/efibc.c b/drivers/firmware/efi/efibc.c
>> > index 503bbe2..57ddf8c 100644
>> > --- a/drivers/firmware/efi/efibc.c
>> > +++ b/drivers/firmware/efi/efibc.c
>> > @@ -32,7 +32,6 @@ static void efibc_str_to_str16(const char *str, efi_char16_t *str16)
>> >  static int efibc_set_variable(const char *name, const char *value)
>> >  {
>> >         int ret;
>> > -       efi_guid_t guid = LINUX_EFI_LOADER_ENTRY_GUID;
>> >         struct efivar_entry *entry;
>> >         size_t size = (strlen(value) + 1) * sizeof(efi_char16_t);
>> >
>> > @@ -49,7 +48,7 @@ static int efibc_set_variable(const char *name, const char *value)
>> >
>> >         efibc_str_to_str16(name, entry->var.VariableName);
>> >         efibc_str_to_str16(value, (efi_char16_t *)entry->var.Data);
>> > -       memcpy(&entry->var.VendorGuid, &guid, sizeof(guid));
>> > +       entry->var.VendorGuid = LINUX_EFI_LOADER_ENTRY_GUID;
>> >
>> >         ret = efivar_entry_set(entry,
>> >                                EFI_VARIABLE_NON_VOLATILE
>> > diff --git a/drivers/firmware/efi/libstub/arm-stub.c b/drivers/firmware/efi/libstub/arm-stub.c
>> > index 6fca48c..da72bfb 100644
>> > --- a/drivers/firmware/efi/libstub/arm-stub.c
>> > +++ b/drivers/firmware/efi/libstub/arm-stub.c
>> > @@ -27,13 +27,12 @@ static int efi_get_secureboot(efi_system_table_t *sys_table_arg)
>> >         static efi_char16_t const sm_var_name[] = {
>> >                 'S', 'e', 't', 'u', 'p', 'M', 'o', 'd', 'e', 0 };
>> >
>> > -       efi_guid_t var_guid = EFI_GLOBAL_VARIABLE_GUID;
>> >         efi_get_variable_t *f_getvar = sys_table_arg->runtime->get_variable;
>> >         u8 val;
>> >         unsigned long size = sizeof(val);
>> >         efi_status_t status;
>> >
>> > -       status = f_getvar((efi_char16_t *)sb_var_name, (efi_guid_t *)&var_guid,
>> > +       status = f_getvar(sb_var_name, &EFI_GLOBAL_VARIABLE_GUID,
>> >                           NULL, &size, &val);
>> >
>> >         if (status != EFI_SUCCESS)
>> > @@ -42,7 +41,7 @@ static int efi_get_secureboot(efi_system_table_t *sys_table_arg)
>> >         if (val == 0)
>> >                 return 0;
>> >
>> > -       status = f_getvar((efi_char16_t *)sm_var_name, (efi_guid_t *)&var_guid,
>> > +       status = f_getvar(sm_var_name, &EFI_GLOBAL_VARIABLE_GUID,
>> >                           NULL, &size, &val);
>> >
>> >         if (status != EFI_SUCCESS)
>> > diff --git a/drivers/infiniband/hw/hfi1/efivar.c b/drivers/infiniband/hw/hfi1/efivar.c
>> > index 106349f..f769cc2 100644
>> > --- a/drivers/infiniband/hw/hfi1/efivar.c
>> > +++ b/drivers/infiniband/hw/hfi1/efivar.c
>> > @@ -66,7 +66,6 @@ static int read_efi_var(const char *name, unsigned long *size,
>> >  {
>> >         efi_status_t status;
>> >         efi_char16_t *uni_name;
>> > -       efi_guid_t guid;
>> >         unsigned long temp_size;
>> >         void *temp_buffer;
>> >         void *data;
>> > @@ -95,13 +94,10 @@ static int read_efi_var(const char *name, unsigned long *size,
>> >         for (i = 0; name[i]; i++)
>> >                 uni_name[i] = name[i];
>> >
>> > -       /* need a variable for our GUID */
>> > -       guid = HFI1_EFIVAR_GUID;
>> > -
>> >         /* call into EFI runtime services */
>> >         status = efi.get_variable(
>> >                         uni_name,
>> > -                       &guid,
>> > +                       &HFI1_EFIVAR_GUID,
>> >                         NULL,
>> >                         &temp_size,
>> >                         temp_buffer);
>> > diff --git a/drivers/scsi/isci/probe_roms.c b/drivers/scsi/isci/probe_roms.c
>> > index 8ac646e..d2c17c1 100644
>> > --- a/drivers/scsi/isci/probe_roms.c
>> > +++ b/drivers/scsi/isci/probe_roms.c
>> > @@ -34,7 +34,7 @@
>> >  #include "task.h"
>> >  #include "probe_roms.h"
>> >
>> > -static efi_char16_t isci_efivar_name[] = {
>> > +static const efi_char16_t isci_efivar_name[] = {
>> >         'R', 's', 't', 'S', 'c', 'u', 'O'
>> >  };
>> >
>> > --
>> > 2.11.0
>> >
