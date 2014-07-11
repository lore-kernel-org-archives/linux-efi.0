From: Michael Brown <mbrown-OViyBiuKJBuK421+ScFKDQ@public.gmane.org>
Subject: Re: [PATCH v3] efi: Request desired alignment via the PE/COFF headers
Date: Fri, 11 Jul 2014 16:16:30 +0100
Message-ID: <53BFFFCE.5040002@fensystems.co.uk>
References: <1405007963-520-1-git-send-email-mbrown@fensystems.co.uk> <20140710203633.GC5952@console-pimps.org> <53BF2D63.60808@fensystems.co.uk> <20140711074117.GE5952@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140711074117.GE5952-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 11/07/14 08:41, Matt Fleming wrote:
>> i.e. that the memory used for alignment was not explicitly
>> allocated. If the EFI boot stub instead allocates space for the
>> aligned kernel using AllocatePages() (and allocates enough space for
>> the whole of init_size), then the problem I described does not
>> exist.
>
> Right, this shouldn't be a problem because we do in fact allocate space
> using the EFI boottime services in efi_relocate_kernel(), taking the
> alignment into account, and then perform the kernel image copy.
>
> I still think your change makes sense, I'm just inclined to delete the
> paragraph referring to the corruption bug (which we've established
> doesn't exist).

Since the patch itself is so trivial, I'm happy for you to commit it as 
your own, with whatever commit message you think makes most sense.

Michael
