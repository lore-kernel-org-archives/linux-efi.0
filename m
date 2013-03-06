From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: [GIT PULL] EFI changes for v3.9-rc2
Date: Wed, 06 Mar 2013 15:28:38 +0000
Message-ID: <1362583718.15011.89.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "H. Peter Anvin" <hpa-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-efi <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Hi guys,

The following changes since commit feff5dc4f98330d8152b521acc2e18c16712e6c8:

  efivarfs: return accurate error code in efivarfs_fill_super() (2013-03-06 14:46:30 +0000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-for-3.9-rc2

for you to fetch changes up to feff5dc4f98330d8152b521acc2e18c16712e6c8:

  efivarfs: return accurate error code in efivarfs_fill_super() (2013-03-06 14:46:30 +0000)

----------------------------------------------------------------
EFI changes for v3.9-rc2,

  * Make the EFI variable code more paranoid about running out of
    space in NVRAM, since this is the root cause of the recent issue
    where machines refuse to boot - from Matthew Garrett.

  * Some efivarfs patches that fix regressions introduced in v3.9-rc1.

----------------------------------------------------------------

-- 
Matt Fleming, Intel Open Source Technology Center
