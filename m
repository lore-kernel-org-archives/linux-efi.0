From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH v3] efi: Request desired alignment via the PE/COFF headers
Date: Wed, 15 Jul 2015 15:11:19 +0100
Message-ID: <20150715141119.GA6955@codeblueprint.co.uk>
References: <1405007963-520-1-git-send-email-mbrown@fensystems.co.uk>
 <loom.20150615T232724-11@post.gmane.org>
 <55804C91.4030000@fensystems.co.uk>
 <20150616173725.GE13153@oranje.fc.hp.com>
 <20150618220241.GA2776@codeblueprint.co.uk>
 <558345EB.8010408@fensystems.co.uk>
 <20150619122147.GC2776@codeblueprint.co.uk>
 <55840A3B.3000400@fensystems.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <55840A3B.3000400-OViyBiuKJBuK421+ScFKDQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michael Brown <mbrown-OViyBiuKJBuK421+ScFKDQ@public.gmane.org>
Cc: Linn Crosetto <linn-VXdhtT5mjnY@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Fri, 19 Jun, at 01:25:31PM, Michael Brown wrote:
> 
> You are right; this change can safely be reverted.  Sorry for the noise.

Guys, this is what I'm going to queue up for v4.3. My plan is to let it
bake in linux-next for a while, to try and shake out any problems.

Interestingly, I'm not sure that the size of the bzImage is actually
guaranteed to be a multiple of 32, since it appears that
arch/x86/boot/tools/build.c only deals with 16-byte "paragraphs".

---

>From 809ca3d4eac5836e5f48c19f28babff1e5b71c77 Mon Sep 17 00:00:00 2001
From: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Date: Wed, 15 Jul 2015 14:05:53 +0100
Subject: [PATCH] Revert "x86/efi: Request desired alignment via the PE/COFF
 headers"

This reverts commit aeffc4928ea21aab3c7be72f00e257799b661c29.

Linn reports that Signtool complains that kernels built with
CONFIG_EFI_STUB are violating the PE/COFF specification because the
SizeOfImage field is not a multiple of SectionAlignment.

This violation was introduced as an optimisation to skip having the
kernel relocate itself during boot and instead have the firmware place
it at a correctly aligned address.

No one else has complained and I'm not aware of any firmware
implementations that refuse to boot with commit aeffc4928ea2, but it's a
legitimate bug, so revert the offending commit.

Reported-by: Linn Crosetto <linn-VXdhtT5mjnY@public.gmane.org>
Cc: Michael Brown <mbrown-OViyBiuKJBuK421+ScFKDQ@public.gmane.org>
Signed-off-by: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 arch/x86/boot/header.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/boot/header.S b/arch/x86/boot/header.S
index 16ef02596db2..7a6d43a554d7 100644
--- a/arch/x86/boot/header.S
+++ b/arch/x86/boot/header.S
@@ -154,7 +154,7 @@ extra_header_fields:
 #else
 	.quad	0				# ImageBase
 #endif
-	.long	CONFIG_PHYSICAL_ALIGN		# SectionAlignment
+	.long	0x20				# SectionAlignment
 	.long	0x20				# FileAlignment
 	.word	0				# MajorOperatingSystemVersion
 	.word	0				# MinorOperatingSystemVersion
-- 
2.1.0

-- 
Matt Fleming, Intel Open Source Technology Center
