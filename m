From: Michael Brown <mbrown-OViyBiuKJBuK421+ScFKDQ@public.gmane.org>
Subject: Re: [PATCH v3] efi: Request desired alignment via the PE/COFF headers
Date: Mon, 14 Jul 2014 14:28:27 +0100
Message-ID: <53C3DAFB.1080107@fensystems.co.uk>
References: <1405007963-520-1-git-send-email-mbrown@fensystems.co.uk> <20140710203633.GC5952@console-pimps.org> <53BF2D63.60808@fensystems.co.uk> <20140711074117.GE5952@console-pimps.org> <53BFFFCE.5040002@fensystems.co.uk> <20140714131042.GJ5952@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140714131042.GJ5952-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 14/07/14 14:10, Matt Fleming wrote:
> On Fri, 11 Jul, at 04:16:30PM, Michael Brown wrote:
> The EFI boot stub goes to great pains to relocate the kernel image to
> an appropriately aligned address, as indicated by the ->kernel_alignment
> field in the bzImage header.  However, for the PE stub entry case, we
> can request that the EFI PE/COFF loader do the work for us.
>
> Fix by exposing the desired alignment via the SectionAlignment field
> in the PE/COFF headers.  Despite its name, this field provides an
> overall alignment requirement for the loaded file.  (Naturally, the
> FileAlignment field describes the alignment for individual sections.)
>
> There is no way in the PE/COFF headers to express the concept of
> min_alignment; we therefore do not expose the minimum (as opposed to
> preferred) alignment.
>
> Signed-off-by: Michael Brown <mbrown-OViyBiuKJBuK421+ScFKDQ@public.gmane.org>
> Signed-off-by: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Looks good to me.

Michael
