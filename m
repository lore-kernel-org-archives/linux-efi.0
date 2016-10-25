From: David Daney <ddaney-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH] efi: Add SHIM and image security database GUID definitions
Date: Tue, 25 Oct 2016 11:15:18 -0700
Message-ID: <580FA136.80006@caviumnetworks.com>
References: <20161025174209.29073-1-jwboyer@fedoraproject.org> <CAKv+Gu8jkPMG4KGjg+UTeuLOe6m=g3KMKsC=BgwVegyBYnHm0g@mail.gmail.com> <CA+5PVA53Tf2QVN0j0JFO9_v-hGbsg9HByOGGfLCGsgeGCz5UKA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CA+5PVA53Tf2QVN0j0JFO9_v-hGbsg9HByOGGfLCGsgeGCz5UKA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Josh Boyer <jwboyer-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 10/25/2016 11:04 AM, Josh Boyer wrote:
> On Tue, Oct 25, 2016 at 1:44 PM, Ard Biesheuvel
> <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
>> Hi Josh,
>>
>> On 25 October 2016 at 18:42, Josh Boyer <jwboyer-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org> wrote:
>>> Add the definitions for shim and image security database, both of which
>>> are used widely in various Linux distros.
>>>
>>> Signed-off-by: Josh Boyer <jwboyer-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org>
>>> ---
>>>   include/linux/efi.h | 3 +++
>>>   1 file changed, 3 insertions(+)
>>>
>>> diff --git a/include/linux/efi.h b/include/linux/efi.h
>>> index 2d089487d2da..ce943d5accfd 100644
>>> --- a/include/linux/efi.h
>>> +++ b/include/linux/efi.h
>>> @@ -592,6 +592,9 @@ void efi_native_runtime_setup(void);
>>>   #define EFI_MEMORY_ATTRIBUTES_TABLE_GUID       EFI_GUID(0xdcfa911d, 0x26eb, 0x469f,  0xa2, 0x20, 0x38, 0xb7, 0xdc, 0x46, 0x12, 0x20)
>>>   #define EFI_CONSOLE_OUT_DEVICE_GUID            EFI_GUID(0xd3b36f2c, 0xd551, 0x11d4,  0x9a, 0x46, 0x00, 0x90, 0x27, 0x3f, 0xc1, 0x4d)
>>>
>>> +#define EFI_IMAGE_SECURITY_DATABASE_GUID       EFI_GUID(0xd719b2cb, 0x3d3a, 0x4596, 0xa3, 0xbc, 0xda, 0xd0, 0x0e, 0x67, 0x65, 0x6f)
>>> +#define EFI_SHIM_LOCK_GUID                             EFI_GUID(0x605dab50, 0xe046, 0x4300, 0xab, 0xb6, 0x3d, 0xd8, 0x10, 0xdd, 0x8b, 0x23)
>>> +
>>
>> Given that this patch is not part of the series, could you explain
>> what the point is of having these definitions in the kernel if they
>> are never referenced?
>
> Sure.
>
> The idea is to make sure a commonly used definition is both accessible
> and reserved in the kernel.

It is not in a uapi directory, so it cannot be used outside of the 
kernel.  If it is not referenced in the kernel, there is no reason to 
add it.

It is a GUID, you don't have to reserve it.  By its very nature it will 
always exist and be immutable.   You can add it at the time that it is 
actually used without fear that someone else will generate a conflicting 
definition.

>  At the moment, most of the major distros
> are carrying a similar patch and projects like mokutil and xen are
> defining it themselves.
>
> josh
> --
> To unsubscribe from this list: send the line "unsubscribe linux-efi" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
