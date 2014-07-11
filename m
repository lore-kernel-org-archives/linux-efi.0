From: Michael Brown <mbrown-OViyBiuKJBuK421+ScFKDQ@public.gmane.org>
Subject: Re: [PATCH v3] efi: Request desired alignment via the PE/COFF headers
Date: Fri, 11 Jul 2014 01:18:43 +0100
Message-ID: <53BF2D63.60808@fensystems.co.uk>
References: <1405007963-520-1-git-send-email-mbrown@fensystems.co.uk> <20140710203633.GC5952@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140710203633.GC5952-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 10/07/14 21:36, Matt Fleming wrote:
> On Thu, 10 Jul, at 04:59:23PM, Michael Brown wrote:
>> The kernel will align itself to the nearest boundary specified by the
>> kernel_alignment field in the bzImage header.  If the kernel is loaded
>> to an address which is not sufficiently aligned, it will therefore use
>> memory beyond that indicated solely by the init_size field.
>>
>> The PE/COFF headers now include a .bss section to describe the
>> requirements of the init_size field, but do not currently expose the
>> alignment requirement.  Consequently, a kernel loaded via the PE entry
>> point may still end up overwriting unexpected areas of memory.
>
> Is this actually true? There is code within the EFI boot stub to
> allocate space for the kernel image and perform the relocation if it's
> not already suitably aligned.
>
> Or is the above paragraph referring to the previously merged patch?

The "...headers now include..." part was referring to the previously 
merged patch to add the .bss section.

I haven't actually looked at the code which performs the alignment; I 
was going on hpa's concern that merely exposing init_size would be 
insufficient due to the potential for alignment.  My understanding 
(possibly incorrect) was that the alignment was carried out using 
something simple along the lines of:

   new_kernel_start = align ( kernel_start, kernel_alignment );
   memmove ( new_kernel_start, kernel_start, kernel_len );

i.e. that the memory used for alignment was not explicitly allocated. 
If the EFI boot stub instead allocates space for the aligned kernel 
using AllocatePages() (and allocates enough space for the whole of 
init_size), then the problem I described does not exist.

Michael
