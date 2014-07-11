From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH v3] efi: Request desired alignment via the PE/COFF headers
Date: Fri, 11 Jul 2014 08:41:17 +0100
Message-ID: <20140711074117.GE5952@console-pimps.org>
References: <1405007963-520-1-git-send-email-mbrown@fensystems.co.uk>
 <20140710203633.GC5952@console-pimps.org>
 <53BF2D63.60808@fensystems.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <53BF2D63.60808-OViyBiuKJBuK421+ScFKDQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michael Brown <mbrown-OViyBiuKJBuK421+ScFKDQ@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, 11 Jul, at 01:18:43AM, Michael Brown wrote:
> 
> The "...headers now include..." part was referring to the previously
> merged patch to add the .bss section.
> 
> I haven't actually looked at the code which performs the alignment;
> I was going on hpa's concern that merely exposing init_size would be
> insufficient due to the potential for alignment.  My understanding
> (possibly incorrect) was that the alignment was carried out using
> something simple along the lines of:
> 
>   new_kernel_start = align ( kernel_start, kernel_alignment );
>   memmove ( new_kernel_start, kernel_start, kernel_len );
> 
> i.e. that the memory used for alignment was not explicitly
> allocated. If the EFI boot stub instead allocates space for the
> aligned kernel using AllocatePages() (and allocates enough space for
> the whole of init_size), then the problem I described does not
> exist.

Right, this shouldn't be a problem because we do in fact allocate space
using the EFI boottime services in efi_relocate_kernel(), taking the
alignment into account, and then perform the kernel image copy.

I still think your change makes sense, I'm just inclined to delete the
paragraph referring to the corruption bug (which we've established
doesn't exist).

-- 
Matt Fleming, Intel Open Source Technology Center
