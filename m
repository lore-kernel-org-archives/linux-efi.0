From: "Jan Beulich" <JBeulich-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] EFI: make for_each_efi_memory_desc_in_map() cope
 with running on Xen
Date: Tue, 09 Aug 2016 08:09:29 -0600
Message-ID: <57AA00390200007800104541@prv-mh.provo.novell.com>
References: <57A9C9A60200007800104268@prv-mh.provo.novell.com>
 <c5dc2cae-1189-f2dd-6c6b-2c310a9d829f@suse.cz>
 <57A9F94E0200007800104477@prv-mh.provo.novell.com>
 <97e96c16-09dc-773f-3beb-4fefc589921a@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <97e96c16-09dc-773f-3beb-4fefc589921a-AlSwsSmVLrQ@public.gmane.org>
Content-Disposition: inline
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jiri Slaby <jslaby-AlSwsSmVLrQ@public.gmane.org>
Cc: matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, Vitaly Kuznetsov <vkuznets-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

>>> On 09.08.16 at 15:51, <jslaby-AlSwsSmVLrQ@public.gmane.org> wrote:
> On 08/09/2016, 03:39 PM, Jan Beulich wrote:
>>>>> On 09.08.16 at 15:03, <jslaby-AlSwsSmVLrQ@public.gmane.org> wrote:
>>> On 08/09/2016, 12:16 PM, Jan Beulich wrote:
>>>> While commit 55f1ea15216 ("efi: Fix for_each_efi_memory_desc_in_map()
>>>> for empty memmaps") made an attempt to deal with empty memory maps, it
>>>> didn't address the case where the desc_size field never gets set, as is
>>>> apparently the case when running under Xen.
>>>>
>>>> Reported-by: <lists-Ilq5uHa1fWNWk0Htik3J/w@public.gmane.org>
>>>> Cc: Vitaly Kuznetsov <vkuznets-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>>>> Cc: Jiri Slaby <jslaby-AlSwsSmVLrQ@public.gmane.org>
>>>> Signed-off-by: Jan Beulich <jbeulich-IBi9RG/b67k@public.gmane.org>
>>>> Tested-by: <lists-Ilq5uHa1fWNWk0Htik3J/w@public.gmane.org>
>>>> ---
>>>>  include/linux/efi.h |    2 +-
>>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>>
>>>> --- 4.8-rc1/include/linux/efi.h
>>>> +++ 4.8-rc1-EFI-memdesc-iterator-Xen/include/linux/efi.h
>>>> @@ -946,7 +946,7 @@ extern int efi_memattr_apply_permissions
>>>>  /* Iterate through an efi_memory_map */
>>>>  #define for_each_efi_memory_desc_in_map(m, md)				   \
>>>>  	for ((md) = (m)->map;						   \
>>>> -	     ((void *)(md) + (m)->desc_size) <= (m)->map_end;		   \
>>>> +	     ((void *)(md) + (m)->desc_size - 1) < (m)->map_end;	   \
>>>
>>> Is there any specific reason you change both the size and the comparator?
>>>
>>> IMO, either (readable)
>>>   ((void *)(md) + (m)->desc_size) < (m)->map_end;
>>> or (mindfuck version)
>>>   ((void *)(md) + (m)->desc_size - 1) <= (m)->map_end;
>>> is correct, not their mix.
>> 
>> We're not talking about an off-by-one getting fixed here: map_end
>> points past the valid range. The adjustment leverages overflow (or
>> underflow, to be precise) to produce correct behavior when
>> (m)->desc_size is zero.
> 
> And what would be map_end in case desc_size is zero so that the test fails?

Zero.

> Anyway, if I understand correctly, you subtract one from the pointer.
> Note that behaviour of this is undefined according to the C standard and
> may result in unpredictable results. Pointer can only point inside an
> object (or array) or one element *past* the end, not before.

Considering an object spanning the entire address space, I'm not
sure there's anything really undefined here. But of course the whole
arithmetic could instead be done with unsigned longs (using respective
casts).

Jan
