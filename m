From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 3/3] efi/libstub: fix deletion of FDT memory nodes
Date: Wed, 7 Oct 2015 17:02:37 +0100
Message-ID: <CAKv+Gu_0haKU-nBB6t+iWeLteLDHz8YLOByfo7fWsrAr7txXpg@mail.gmail.com>
References: <1444206929-13374-1-git-send-email-ard.biesheuvel@linaro.org>
	<1444206929-13374-4-git-send-email-ard.biesheuvel@linaro.org>
	<1444232962.25536.7.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1444232962.25536.7.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Grant Likely <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 7 October 2015 at 16:49, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Wed, 2015-10-07 at 09:35 +0100, Ard Biesheuvel wrote:
>> This fixes two issues with the EFI libstub code that removes the memory
>> nodes from the FDT:
>> a) fdt_del_node() invalidates the iterator, so we should restart from the
>>    top after calling it;
>> b) use fixed length of 6 when matching against 'memory' using strncmp(),
>>    since otherwise, substrings like 'm' or 'mem' could match as well.
>>
>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>> ---
>>  drivers/firmware/efi/libstub/fdt.c | 5 +++--
>>  1 file changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/firmware/efi/libstub/fdt.c b/drivers/firmware/efi/libstub/fdt.c
>> index 0ef16923b4f0..2c7d09936479 100644
>> --- a/drivers/firmware/efi/libstub/fdt.c
>> +++ b/drivers/firmware/efi/libstub/fdt.c
>> @@ -200,6 +200,7 @@ efi_status_t update_fdt(efi_system_table_t *sys_table, void *orig_fdt,
>>        * Delete any memory nodes present. We must delete nodes which
>>        * early_init_dt_scan_memory may try to use.
>>        */
>> +restart:
>>       prev = 0;
>>       for (;;) {
>>               const char *type;
>> @@ -210,9 +211,9 @@ efi_status_t update_fdt(efi_system_table_t *sys_table, void *orig_fdt,
>>                       break;
>>
>>               type = fdt_getprop(fdt, node, "device_type", &len);
>> -             if (type && strncmp(type, "memory", len) == 0) {
>> +             if (type && strncmp(type, "memory", 6) == 0) {
>
> I see what you're trying to fix here, but I think using 6 is wrong
> also. A plain strcmp() would work as long as property is a string.
>

That is what Leif suggested as well, but it pulls in yet another
string function into the stub, so I tried to avoid it. I think this
particular case is safe, since the property names are in the string
table, which is after the nodes in the DTB structure, so 'type' is
guaranteed not to point right before the end of a mapped region.

>
>>                       fdt_del_node(fdt, node);
>> -                     continue;
>> +                     goto restart;
>>               }
>>
>>               prev = node;
>
> Maybe do:
>
>                 if (type && strncmp(type, "memory", len) == 0) {
>                         fdt_del_node(fdt, node);
> -                       continue;
> -               }
> -
> -               prev = node;
> +                       prev = NULL;
> +               } else
> +                       prev = node;
>         }
>
>
> instead of adding a goto.
>

Yes, that is actually better. Thanks.
