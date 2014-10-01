From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: [PATCH 0/2] efi: Remove conditional in_nmi() runtime locking
Date: Wed,  1 Oct 2014 13:06:38 +0100
Message-ID: <1412165200-32141-1-git-send-email-matt@console-pimps.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

These two patches should address the concerns raised by Ingo and Peter
in relation to the EFI pull request containing v3.18 material,

  https://lkml.kernel.org/r/20140928202702.GB18635-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org

We can drop the in_nmi() checks altogether and just provide normal
locking semantics if we introduce a non-blocking SetVariable() operation
for the particular case of writing pstore data to the EFI backend from
the kdump callback, which aborts in the contended case.

This is currently holding up merging of the v3.18 EFI patches, so please
be timely with comments, if any.

@Linaro guys, I don't think you'll actually care all that much about
these changes since the in_nmi() goo was for x86's benefit, but I'm
Cc'ing you anyway to make sure everything looks OK.

Matt Fleming (2):
  efi: Provide a non-blocking SetVariable() operation
  efi: Delete the in_nmi() conditional runtime locking

 arch/x86/include/asm/efi.h              |  2 --
 drivers/firmware/efi/runtime-wrappers.c | 36 ++++++++++++++++---------
 drivers/firmware/efi/vars.c             | 47 +++++++++++++++++++++++++++++++++
 include/linux/efi.h                     |  6 +++++
 4 files changed, 76 insertions(+), 15 deletions(-)

-- 
1.9.3
