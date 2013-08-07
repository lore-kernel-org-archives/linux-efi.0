From: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 03/17] Add system pointer argument to shared EFI stub
 related functions so they no longer use global system table pointer as they
 did when part of eboot.c.
Date: Wed, 7 Aug 2013 10:10:54 -0700
Message-ID: <CAFECyb8NbZ=hrAGyoV-UPUhh-Jst6ZVRk9RUQj_Kb1qq_xuUAg@mail.gmail.com>
References: <1375847113-24884-1-git-send-email-roy.franz@linaro.org>
	<1375847113-24884-4-git-send-email-roy.franz@linaro.org>
	<20130807130851.GC2515@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130807130851.GC2515-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Russell King - ARM Linux <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dave Martin <dave.martin-5wv7dgnIgG8@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, Aug 7, 2013 at 6:08 AM, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org> wrote:
> On Tue, 06 Aug, at 08:44:59PM, Roy Franz wrote:
>> Signed-off-by: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>> ---
>>  arch/x86/boot/compressed/eboot.c       |   38 +++++++------
>>  drivers/firmware/efi/efi-stub-helper.c |   96 +++++++++++++++++---------------
>>  2 files changed, 72 insertions(+), 62 deletions(-)
>
> For future reference you should really use a shorter first line in your
> git commit message, which would produe a shorter subject when mailing
> your patches.
>
> I'll fix up the commit messages when I apply these patches, so don't
> worry about it for now.
>
> [...]
>
>> @@ -19,15 +19,16 @@ struct initrd {
>>
>>
>>
>> -static void efi_char16_printk(efi_char16_t *str)
>> +static void efi_char16_printk(efi_system_table_t *sys_table_arg,
>> +                           efi_char16_t *str)
>>  {
>>       struct efi_simple_text_output_protocol *out;
>>
>> -     out = (struct efi_simple_text_output_protocol *)sys_table->con_out;
>> +     out = (struct efi_simple_text_output_protocol *)sys_table_arg->con_out;
>>       efi_call_phys2(out->output_string, out, str);
>>  }
>>
>> -static void efi_printk(char *str)
>> +static void efi_printk(efi_system_table_t *sys_table_arg, char *str)
>>  {
>>       char *s8;
>>
>
> Hmm... I'm not necessarily convinced this is an improvement over using
> some kind of a global pointer to the EFI System Table.
>
> Parameterizing stuff like this is useful when the argument changes at
> runtime from call to call, but that isn't the case for the boot stubs. I
> don't think there's anything wrong with a global in this scenario, and
> this patch is a fair amount of churn for no real improvement.
>
> --
> Matt Fleming, Intel Open Source Technology Center

Hi Matt,

I went this way since the shared code is in a separate file - I really
didn't like using a global variable as part of the interface to
the shared code.  This has the nice side benefit of allowing the ARM
stub to not use any global variables, so we don't have to do
any GOT fixups to relocate the code - it is position independent if we
don't use global variables.

Roy
