From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [GIT PULL] EFI urgent fixes
Date: Fri, 26 Sep 2014 13:24:05 +0100
Message-ID: <20140926122405.GW18635@console-pimps.org>
References: <20140925073133.GQ18635@console-pimps.org>
 <20140925144127.GA3828@gmail.com>
 <1411730854.7866.10.camel@x220>
 <20140926113510.GA14625@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140926113510.GA14625-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Paul Bolle <pebolle-IWqWACnzNjzz+pZb47iToQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, 26 Sep, at 01:35:10PM, Ingo Molnar wrote:
> 
> A delta fix would be nice at this point, I've got the x86 side 
> tested and besides this build bug it's ready to go to Linus.

Given that the typo doesn't result in an actual build failure, do you
still want the following delta fix?

---

>From 7d4354dc767ba11d1555d27596a3dd3426eb3354 Mon Sep 17 00:00:00 2001
From: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Date: Fri, 26 Sep 2014 13:11:05 +0100
Subject: [PATCH] efi: Fix CONFIG_EFI_ARMSTUB typo for building libstub

commit 84be880560fb ("Revert "efi/x86: efistub: Move shared dependencies
to <asm/efi.h>"") introduced a typo into drivers/firmware/efi/Makefile
where CONFIG_EFI_ARM_STUB should instead be CONFIG_EFI_ARMSTUB.

The typo doesn't result in an actual build failure and was found with
Paul's "800 line perl monster" in linux-next.

The reason that we don't see a build failure is because arm64 (which is
now the only user of libstub) already includes logic to build libstub
from arch/arm64/Makefile.

Correct the typo anyway.

Reported-by: Paul Bolle <pebolle-IWqWACnzNjzz+pZb47iToQ@public.gmane.org>
Signed-off-by: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/firmware/efi/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/Makefile b/drivers/firmware/efi/Makefile
index aef6a95adef5..5b0d892a01c0 100644
--- a/drivers/firmware/efi/Makefile
+++ b/drivers/firmware/efi/Makefile
@@ -7,4 +7,4 @@ obj-$(CONFIG_EFI_VARS_PSTORE)		+= efi-pstore.o
 obj-$(CONFIG_UEFI_CPER)			+= cper.o
 obj-$(CONFIG_EFI_RUNTIME_MAP)		+= runtime-map.o
 obj-$(CONFIG_EFI_RUNTIME_WRAPPERS)	+= runtime-wrappers.o
-obj-$(CONFIG_EFI_ARM_STUB)		+= libstub/
+obj-$(CONFIG_EFI_ARMSTUB)		+= libstub/
-- 
1.9.3

-- 
Matt Fleming, Intel Open Source Technology Center
