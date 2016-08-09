From: "Jan Beulich" <JBeulich-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] EFI: make for_each_efi_memory_desc_in_map() cope
 with running on Xen
Date: Tue, 09 Aug 2016 08:07:36 -0600
Message-ID: <57A9FFC8020000780010453E@prv-mh.provo.novell.com>
References: <57A9C9A60200007800104268@prv-mh.provo.novell.com>
 <c5dc2cae-1189-f2dd-6c6b-2c310a9d829f@suse.cz>
 <57A9F94E0200007800104477@prv-mh.provo.novell.com>
 <20160809134935.GE1183@leverpostej>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160809134935.GE1183@leverpostej>
Content-Disposition: inline
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Cc: matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, Vitaly Kuznetsov <vkuznets-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jiri Slaby <jslaby-AlSwsSmVLrQ@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

>>> On 09.08.16 at 15:49, <mark.rutland-5wv7dgnIgG8@public.gmane.org> wrote:
> On Tue, Aug 09, 2016 at 07:39:58AM -0600, Jan Beulich wrote:
>> >>> On 09.08.16 at 15:03, <jslaby-AlSwsSmVLrQ@public.gmane.org> wrote:
>> > On 08/09/2016, 12:16 PM, Jan Beulich wrote:
>> >> While commit 55f1ea15216 ("efi: Fix for_each_efi_memory_desc_in_map()
>> >> for empty memmaps") made an attempt to deal with empty memory maps, it
>> >> didn't address the case where the desc_size field never gets set, as is
>> >> apparently the case when running under Xen.
>> >> 
>> >> Reported-by: <lists-Ilq5uHa1fWNWk0Htik3J/w@public.gmane.org>
>> >> Cc: Vitaly Kuznetsov <vkuznets-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> >> Cc: Jiri Slaby <jslaby-AlSwsSmVLrQ@public.gmane.org>
>> >> Signed-off-by: Jan Beulich <jbeulich-IBi9RG/b67k@public.gmane.org>
>> >> Tested-by: <lists-Ilq5uHa1fWNWk0Htik3J/w@public.gmane.org>
>> >> ---
>> >>  include/linux/efi.h |    2 +-
>> >>  1 file changed, 1 insertion(+), 1 deletion(-)
>> >> 
>> >> --- 4.8-rc1/include/linux/efi.h
>> >> +++ 4.8-rc1-EFI-memdesc-iterator-Xen/include/linux/efi.h
>> >> @@ -946,7 +946,7 @@ extern int efi_memattr_apply_permissions
>> >>  /* Iterate through an efi_memory_map */
>> >>  #define for_each_efi_memory_desc_in_map(m, md)				   \
>> >>  	for ((md) = (m)->map;						   \
>> >> -	     ((void *)(md) + (m)->desc_size) <= (m)->map_end;		   \
>> >> +	     ((void *)(md) + (m)->desc_size - 1) < (m)->map_end;	   \
>> > 
>> > Is there any specific reason you change both the size and the comparator?
>> > 
>> > IMO, either (readable)
>> >   ((void *)(md) + (m)->desc_size) < (m)->map_end;
>> > or (mindfuck version)
>> >   ((void *)(md) + (m)->desc_size - 1) <= (m)->map_end;
>> > is correct, not their mix.
>> 
>> We're not talking about an off-by-one getting fixed here: map_end
>> points past the valid range. The adjustment leverages overflow (or
>> underflow, to be precise) to produce correct behavior when
>> (m)->desc_size is zero.
> 
> That deserves a comment in the code, given the Xen case is not
> particularly obvious, and it's caught out at least one reviewer.
> 
> What is map_end initialised to in the Xen case? Is that Xen with an
> empty map, of Xen generally?

All fields are zero under Xen, as the raw EFI memory map doesn't
get exposed to the Dom0 kernel.

Jan
