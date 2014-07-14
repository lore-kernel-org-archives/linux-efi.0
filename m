From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH v3] efi: Request desired alignment via the PE/COFF headers
Date: Mon, 14 Jul 2014 14:10:42 +0100
Message-ID: <20140714131042.GJ5952@console-pimps.org>
References: <1405007963-520-1-git-send-email-mbrown@fensystems.co.uk>
 <20140710203633.GC5952@console-pimps.org>
 <53BF2D63.60808@fensystems.co.uk>
 <20140711074117.GE5952@console-pimps.org>
 <53BFFFCE.5040002@fensystems.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <53BFFFCE.5040002-OViyBiuKJBuK421+ScFKDQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michael Brown <mbrown-OViyBiuKJBuK421+ScFKDQ@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Fri, 11 Jul, at 04:16:30PM, Michael Brown wrote:
> 
> Since the patch itself is so trivial, I'm happy for you to commit it
> as your own, with whatever commit message you think makes most
> sense.

I was thinking something along these lines,

---

>From 997cea56672faf5521cd5718281b99d4e6afdb2d Mon Sep 17 00:00:00 2001
From: Michael Brown <mbrown-OViyBiuKJBuK421+ScFKDQ@public.gmane.org>
Date: Thu, 10 Jul 2014 16:59:23 +0100
Subject: [PATCH] x86/efi: Request desired alignment via the PE/COFF headers

The EFI boot stub goes to great pains to relocate the kernel image to
an appropriately aligned address, as indicated by the ->kernel_alignment
field in the bzImage header.  However, for the PE stub entry case, we
can request that the EFI PE/COFF loader do the work for us.

Fix by exposing the desired alignment via the SectionAlignment field
in the PE/COFF headers.  Despite its name, this field provides an
overall alignment requirement for the loaded file.  (Naturally, the
FileAlignment field describes the alignment for individual sections.)

There is no way in the PE/COFF headers to express the concept of
min_alignment; we therefore do not expose the minimum (as opposed to
preferred) alignment.

Signed-off-by: Michael Brown <mbrown-OViyBiuKJBuK421+ScFKDQ@public.gmane.org>
Signed-off-by: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 arch/x86/boot/header.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/boot/header.S b/arch/x86/boot/header.S
index 84c223479e3c..1fdb350c4a58 100644
--- a/arch/x86/boot/header.S
+++ b/arch/x86/boot/header.S
@@ -155,7 +155,7 @@ extra_header_fields:
 #else
 	.quad	0				# ImageBase
 #endif
-	.long	0x20				# SectionAlignment
+	.long	CONFIG_PHYSICAL_ALIGN		# SectionAlignment
 	.long	0x20				# FileAlignment
 	.word	0				# MajorOperatingSystemVersion
 	.word	0				# MinorOperatingSystemVersion
-- 
1.9.0

-- 
Matt Fleming, Intel Open Source Technology Center
