From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH v3] efi: Request desired alignment via the PE/COFF headers
Date: Thu, 10 Jul 2014 21:36:33 +0100
Message-ID: <20140710203633.GC5952@console-pimps.org>
References: <1405007963-520-1-git-send-email-mbrown@fensystems.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1405007963-520-1-git-send-email-mbrown-OViyBiuKJBuK421+ScFKDQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michael Brown <mbrown-OViyBiuKJBuK421+ScFKDQ@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Thu, 10 Jul, at 04:59:23PM, Michael Brown wrote:
> The kernel will align itself to the nearest boundary specified by the
> kernel_alignment field in the bzImage header.  If the kernel is loaded
> to an address which is not sufficiently aligned, it will therefore use
> memory beyond that indicated solely by the init_size field.
> 
> The PE/COFF headers now include a .bss section to describe the
> requirements of the init_size field, but do not currently expose the
> alignment requirement.  Consequently, a kernel loaded via the PE entry
> point may still end up overwriting unexpected areas of memory.
 
Is this actually true? There is code within the EFI boot stub to
allocate space for the kernel image and perform the relocation if it's
not already suitably aligned.

Or is the above paragraph referring to the previously merged patch?

-- 
Matt Fleming, Intel Open Source Technology Center
