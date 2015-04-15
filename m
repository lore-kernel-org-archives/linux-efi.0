From: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] x86_64/efi: enforce 32 bit address for command line buffer
Date: Wed, 15 Apr 2015 11:56:05 -0700
Message-ID: <CAFECyb9oF45aLHPqu91yQ0w-KzkL-2io3SLD8gjtO4q2z+=XyA@mail.gmail.com>
References: <1429058752-13478-1-git-send-email-roy.franz@linaro.org>
	<20150415131826.GE4804@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150415131826.GE4804-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Wed, Apr 15, 2015 at 6:18 AM, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:
> On Tue, 14 Apr, at 05:45:52PM, Roy Franz wrote:
>> The boot_params structure has a 32 bit field for storing the address of
>> the kernel command line.  When the EFI stub allocates memory for the command
>> line, it allocates at as low and address as possible, but does not ensure
>> that the address of memory allocated is below 4G.
>> This patch enforces this limit, and the stub now returns an error if the
>> command line buffer is allocated at too high of an address.
>> For 32 bit systems, the EFI mandated 1-1 memory mapping ensures
>> that all memory is 32 bit addressable, so we don't have a problem.
>> Also, mixed-mode booting on EFI platforms does not use the stub
>> code, so we don't need to handle the case of booting a 32 bit
>> kernel on a 64 bit EFI platform.
>>
>> Signed-off-by: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>> ---
>>  arch/x86/boot/compressed/eboot.c | 13 +++++++++++++
>>  1 file changed, 13 insertions(+)
>>
>> diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
>> index ef17683..82dbe27 100644
>> --- a/arch/x86/boot/compressed/eboot.c
>> +++ b/arch/x86/boot/compressed/eboot.c
>> @@ -1108,6 +1108,19 @@ struct boot_params *make_boot_params(struct efi_config *c)
>>       cmdline_ptr = efi_convert_cmdline(sys_table, image, &options_size);
>>       if (!cmdline_ptr)
>>               goto fail;
>> +
>> +#ifdef CONFIG_X86_64
>> +     /*
>> +      * hdr->cmd_line_ptr is a 32 bit field, so on 64 bit systems we need
>> +      * to ensure that the allocated buffer for the commandline is 32 bit
>> +      * addressable.
>> +       */
>> +     if ((u64)(cmdline_ptr) + options_size > (u64)U32_MAX) {
>> +             efi_printk(sys_table, "Failed to alloc lowmem for command line\n");
>> +             efi_free(sys_table, options_size, (unsigned long)cmdline_ptr);
>> +             goto fail;
>> +     }
>> +#endif /* CONFIG_X86_64 */
>>       hdr->cmd_line_ptr = (unsigned long)cmdline_ptr;
>>
>>       hdr->ramdisk_image = 0;
>
> Good catch. But actually, we have boot_params->ext_cmd_line_ptr for
> exactly this problem.
>
> So yes, that's a valid bug, but I don't think this is how we should fix
> it.
Yeah, I guess it shouldn't surprise me that there is support for 64
bit addresses  there :)

I'l spin another patch that sets boot_params->ext_cmd_line_ptr with
the upper 32 bits of the address.
Should I conditionalize this with #ifdef CONFIG_X86_64, or just do it
unconditionally, with it being a NOP
on 32 bit?  (I guess I may end up with an extra cast for the 32 bit case)

Roy


>
> --
> Matt Fleming, Intel Open Source Technology Center
