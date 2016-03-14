From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: [GIT PULL] EFI urgent fix for v4.6 queue
Date: Mon, 14 Mar 2016 10:33:00 +0000
Message-ID: <1457951581-27353-1-git-send-email-matt@codeblueprint.co.uk>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Brian Gerst <brgerst-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Denys Vlasenko <dvlasenk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Maarten Lankhorst <maarten.lankhorst-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Raphael Hertzog <hertzog-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org>, Roger Shimizu <rogershimizu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Scott Ashcroft <scott.ashcroft-qw6QB7/foO7QT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Scott has reported another bug in the EFI mapping code which caused
page faults during SetVirtualAddressMap() because we're using 1GB
pages at the PUD level even though they may not be supported by the
cpu.

This patch is against tip/efi/core even though the bug has existed
since populate_pud() was first written in 2013. The reason I didn't
base it on tip/x86/urgent is because it would generate conflicts when
the stuff in tip/efi/core gets merged and since no one has ever
reported hitting it until now.

Let me know if you'd like me to respin this patch on top of something
else.

The following changes since commit 2ad510dc372c2caac9aada9ff6dd10e787616e1d:

  x86/efi: Only map kernel text for EFI mixed mode (2016-02-22 08:26:28 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-urgent

for you to fetch changes up to a239b3605abff1457005b413047ddeef057a0831:

  x86/mm/pat: Fix boot crash when 1GB pages are not supported by cpu (2016-03-14 10:13:05 +0000)

----------------------------------------------------------------
 * We currently always assume that 1GB PUD pages are supported by the
   cpu which has resulted in reports of boot crashes (PF_RSVD faults)
   during SetVirtualAddressMap() when that assumption turns out to be
   false. Only use 1GB pages if supported by the cpu - Matt Fleming

----------------------------------------------------------------
Matt Fleming (1):
      x86/mm/pat: Fix boot crash when 1GB pages are not supported by cpu

 arch/x86/mm/pageattr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
