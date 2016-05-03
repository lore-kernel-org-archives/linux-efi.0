From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: efi: Add 'capsule' update support
Date: Tue, 3 May 2016 17:58:18 +0200
Message-ID: <CAKv+Gu-CBymL85xJnmC9d9nuUOuMU3kBAONWtj1-_ck4hEzxiQ@mail.gmail.com>
References: <20160502182500.GA3461@mwanda>
	<20160503145050.GY2839@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160503145050.GY2839-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 3 May 2016 at 16:50, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:
> On Mon, 02 May, at 09:25:00PM, Dan Carpenter wrote:
>> Hello Matt Fleming,
>>
>> The patch f0133f3c5b8b: "efi: Add 'capsule' update support" from Apr
>> 25, 2016, leads to the following static checker warning:
>>
>>       drivers/firmware/efi/capsule.c:109 efi_capsule_supported()
>>       warn: did you mean to pass the address of 'capsule'
>>
>> drivers/firmware/efi/capsule.c
>>     91  int efi_capsule_supported(efi_guid_t guid, u32 flags, size_t size, int *reset)
>>     92  {
>>     93          efi_capsule_header_t *capsule;
>>     94          efi_status_t status;
>>     95          u64 max_size;
>>     96          int rv = 0;
>>     97
>>     98          if (flags & ~EFI_CAPSULE_SUPPORTED_FLAG_MASK)
>>     99                  return -EINVAL;
>>    100
>>    101          capsule = kmalloc(sizeof(*capsule), GFP_KERNEL);
>>    102          if (!capsule)
>>    103                  return -ENOMEM;
>>    104
>>    105          capsule->headersize = capsule->imagesize = sizeof(*capsule);
>>    106          memcpy(&capsule->guid, &guid, sizeof(efi_guid_t));
>>    107          capsule->flags = flags;
>>    108
>>    109          status = efi.query_capsule_caps(&capsule, 1, &max_size, reset);
>>                                                 ^^^^^^^^
>> If we modify capsule inside this function call then at the end of the
>> function we aren't freeing the original pointer that we allocated.
>>
>>    110          if (status != EFI_SUCCESS) {
>>    111                  rv = efi_status_to_err(status);
>>    112                  goto out;
>>    113          }
>>    114
>>    115          if (size > max_size)
>>    116                  rv = -ENOSPC;
>>    117  out:
>>    118          kfree(capsule);
>>    119          return rv;
>>    120  }
>
> We should be fine here, the firmware should not modify the argument
> that we pass since we're simply querying whether or not the capsule is
> supported.
>
> Is there a cleanup that you'd suggest making to silence the static
> checker warning?

Well, I suppose we could simply allocate the pointer array and the
single member statically, i.e.,

efi_capsule_header_t capsule1;
efi_capsule_header_t *capsule[] = { &capsule1 };

That way, we can get rid of the heap allocation entirely, and we take
the address of the array, i.e., without the &
