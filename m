From: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH 03/10] efi: Constify GetVariable() / SetVariable() arguments
Date: Fri, 6 Jan 2017 12:13:42 -0800
Message-ID: <CAGXu5j+qeb00iuM8rJfwFxfg23er4iPA3JBM7eZmBJ5+jGb5_A@mail.gmail.com>
References: <cover.1483318593.git.lukas@wunner.de> <2be92e87ff7855bcd88c86a7436f46d3488483f0.1483318593.git.lukas@wunner.de>
 <CAKv+Gu8UnAzQGsmyWYsWsOY3B+J9HXechwBX_Vk-rntBtO+Dug@mail.gmail.com>
 <20170106101652.GB21850@wunner.de> <CAKv+Gu-izRwdrUu7zZLSnf_mjCwFFZ0AsyF5iMR49+UXkmpsgQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKv+Gu-izRwdrUu7zZLSnf_mjCwFFZ0AsyF5iMR49+UXkmpsgQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Fenghua Yu <fenghua.yu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Anton Vorontsov <anton-9xeibp6oKSgdnm+yROfE0A@public.gmane.org>, Colin Cross <ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Artur Paszkiewicz <artur.paszkiewicz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Emese Revfy <re.emese-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, PaX Team <pageexec-Y8qEzhMunLyT9ig0jae3mg@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, Jan 6, 2017 at 8:28 AM, Ard Biesheuvel
<ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
> On 6 January 2017 at 10:16, Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org> wrote:
>> On Wed, Jan 04, 2017 at 05:38:13PM +0000, Ard Biesheuvel wrote:
>>> On 2 January 2017 at 10:24, Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org> wrote:
>>> > GUIDs and variable names passed to GetVariable() / SetVariable() are not
>>> > modified, so declare them const.  This allows the compiler to place them
>>> > in the rodata section instead of generating them on the stack at
>>> > runtime.  Pass GUIDs as literals rather than assigning them to temporary
>>> > variables to save a bit on code.
>>> >
>>> > Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
>>> > Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>>> > Cc: Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>>> > Cc: Fenghua Yu <fenghua.yu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>>> > Cc: Anton Vorontsov <anton-9xeibp6oKSgdnm+yROfE0A@public.gmane.org>
>>> > Cc: Colin Cross <ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>
>>> > Cc: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
>>> > Cc: Artur Paszkiewicz <artur.paszkiewicz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>>> > Cc: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>>> > Cc: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>>> > Signed-off-by: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
>>> > ---
>>> >  arch/ia64/kernel/efi.c                  | 15 ++++-----------
>>> >  arch/x86/platform/efi/quirks.c          |  2 +-
>>> >  drivers/firmware/efi/efi-pstore.c       |  4 ++--
>>> >  drivers/firmware/efi/efibc.c            |  3 +--
>>> >  drivers/firmware/efi/libstub/arm-stub.c |  5 ++---
>>> >  drivers/infiniband/hw/hfi1/efivar.c     |  6 +-----
>>> >  drivers/scsi/isci/probe_roms.c          |  2 +-
>>> >  7 files changed, 12 insertions(+), 25 deletions(-)
>>> >
>>> > diff --git a/arch/ia64/kernel/efi.c b/arch/ia64/kernel/efi.c
>>> > index f57d089..f1264ab 100644
>>> > --- a/arch/ia64/kernel/efi.c
>>> > +++ b/arch/ia64/kernel/efi.c
>>> > @@ -919,22 +919,15 @@ static void __init handle_palo(unsigned long phys_addr)
>>> >  efi_uart_console_only(void)
>>> >  {
>>> >         efi_status_t status;
>>> > -       char *s, name[] = "ConOut";
>>> > -       efi_guid_t guid = EFI_GLOBAL_VARIABLE_GUID;
>>> > -       efi_char16_t *utf16, name_utf16[32];
>>> > +       const char name[] = "ConOut";
>>> > +       const efi_char16_t name_utf16[] = { 'C', 'o', 'n', 'O', 'u', 't', 0 };
>>>
>>> I know you mention 'static' in 10/10, but I don't understand why you
>>> don't make these static to begin with. That also allows you to
>>> annotate them as __initconst, which is not possible for compound
>>> initializers (including the GUID)
>>
>> Right, I hadn't thought of __initconst.  In this particular case indeed
>> it might make sense to use "static const efi_guid_t guid __initconst = ...",
>> and arguably for the strings as well.  But where should I draw the line?
>>
>> There are a handful of other GUIDs used in __init functions, e.g. in
>> arch/ia64/ there's ESI_TABLE_GUID in kernel/esi.c:esi_init() and
>> SAL_SYSTEM_TABLE_GUID in sn/kernel/setup.c:early_sn_setup().
>> This patch set results in them being placed in rodata, but not
>> init.rodata.  Should I declare a temporary "static const __initconst"
>> variable for each of them?  That would give us 16 bytes in each of the
>> two cases being freed after kernel initialization.
>>
>> However string literals aren't put in init.rodata either even though
>> they're declared in an __init function.  E.g. early_sn_setup() contains
>> a string literal "failed to find SAL entry point\n".  That's 31 bytes.
>> esi_init() contains even 103 bytes of string literals.
>>
>> So I'm not sure if it's worth to move the GUIDs to init.rodata (at the
>> expense of an additional LoC to declare a temporary variable) even
>> though we waste more space for string literals.
>>
>
> For the string literals I think there are some solutions possible
> involving compiler plugins. Kees?

Not yet, but coming. The "initify" plugin will move string literals to
init, IIUC. There are still some false-positive warnings generated by
modpost when initify is enabled, so I haven't push it into my -next
tree yet.

-Kees

-- 
Kees Cook
Nexus Security
