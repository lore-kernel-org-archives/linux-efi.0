From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: [GIT PULL] EFI urgent fix
Date: Fri, 21 Jun 2013 10:56:28 +0100
Message-ID: <20130621095628.GD5386@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

The following changes since commit f8b8404337de4e2466e2e1139ea68b1f8295974f:

  Modify UEFI anti-bricking code (2013-06-10 21:59:37 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-urgent

for you to fetch changes up to b8cb62f82103083a6e8fa5470bfe634a2c06514d:

  x86/efi: Fix dummy variable buffer allocation (2013-06-21 10:52:49 +0100)

----------------------------------------------------------------
 * Don't leak random kernel memory to EFI variable NVRAM when attempting
   to initiate garbage collection. Also, free the kernel memory when
   we're done with it instead of leaking - Ben Hutchings

----------------------------------------------------------------
Ben Hutchings (1):
      x86/efi: Fix dummy variable buffer allocation

 arch/x86/platform/efi/efi.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

-- 
Matt Fleming, Intel Open Source Technology Center
