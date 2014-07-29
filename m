From: Prarit Bhargava <prarit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] x86, efi: print debug values in Kib not MB
Date: Tue, 29 Jul 2014 18:05:04 -0400
Message-ID: <53D81A90.5000906@redhat.com>
References: <1406653761-3884-1-git-send-email-prarit@redhat.com> <alpine.DEB.2.02.1407291327450.13073@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.02.1407291327450.13073-X6Q0R45D7oAcqpCFd4KODRPsWskHk0ljAL8bYrjMMd8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lszubowi-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org



On 07/29/2014 04:29 PM, David Rientjes wrote:
> On Tue, 29 Jul 2014, Prarit Bhargava wrote:
> 
>> diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
>> index 87fc96b..3875090 100644
>> --- a/arch/x86/platform/efi/efi.c
>> +++ b/arch/x86/platform/efi/efi.c
>> @@ -384,10 +384,10 @@ static void __init print_efi_memmap(void)
>>  	     p < memmap.map_end;
>>  	     p += memmap.desc_size, i++) {
>>  		md = p;
>> -		pr_info("mem%02u: type=%u, attr=0x%llx, range=[0x%016llx-0x%016llx) (%lluMB)\n",
>> +		pr_info("mem%02u: type=%u, attr=0x%llx, range=[0x%016llx-0x%016llx) (%lluKiB)\n",
>>  			i, md->type, md->attribute, md->phys_addr,
>>  			md->phys_addr + (md->num_pages << EFI_PAGE_SHIFT),
>> -			(md->num_pages >> (20 - EFI_PAGE_SHIFT)));
>> +			(md->num_pages << 2));
>>  	}
>>  #endif  /*  EFI_DEBUG  */
>>  }
> 
> If EFI_PAGE_SHIFT were to ever change from its hard-coded 12, then this 
> would be wrong.  Any reason to not simply print EFI_PAGE_SIZE and 
> md->num_pages?

Hmm ... maybe it might be better to print out (md->num_pages * EFI_PAGE_SIZE) >>
10 ?  I'll just double check that in a kernel and repost.

Thanks for the suggestion David :)

P.
> 
