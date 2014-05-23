From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: [GIT PULL] EFI changes for arm64
Date: Fri, 23 May 2014 23:23:52 +0100
Message-ID: <20140523222352.GB23963@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Catalin reports that the arm64 EFI changes in tip/arm64/efi are causing
boot issues when trying to run on a non-EFI machine. The below fix from
Leif skips the EFI code on such machines.

The following changes since commit 345c736edd07b657a8c48190baed2719b85d0938:

  efi/arm64: ignore dtb= when UEFI SecureBoot is enabled (2014-04-30 19:57:06 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git arm64-efi

for you to fetch changes up to 74bcc2499291d38b6253f9dbd6af33a195222208:

  arm64: efi: only attempt efi map setup if booting via EFI (2014-05-23 15:29:43 +0100)

----------------------------------------------------------------
Leif Lindholm (1):
      arm64: efi: only attempt efi map setup if booting via EFI

 arch/arm64/kernel/efi.c | 3 +++
 1 file changed, 3 insertions(+)

-- 
Matt Fleming, Intel Open Source Technology Center
