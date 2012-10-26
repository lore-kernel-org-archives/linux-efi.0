From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: [GIT PULL] EFI fixes for v3.7
Date: Fri, 26 Oct 2012 08:58:51 +0100
Message-ID: <1351238331.5303.23.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-efi <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Hi guys,

The following changes since commit ddffeb8c4d0331609ef2581d84de4d763607bd37:

  Linux 3.7-rc1 (2012-10-14 14:41:04 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-for-3.7

for you to fetch changes up to 5189c2a7c7769ee9d037d76c1a7b8550ccf3481c:

  x86: efi: Turn off efi_enabled after setup on mixed fw/kernel (2012-10-25 19:09:40 +0100)

----------------------------------------------------------------
EFI updates for 3.7

Fix oops with EFI variables on mixed 32/64-bit firmware/kernels and
document EFI git repository location on kernel.org.

----------------------------------------------------------------
Matt Fleming (1):
      MAINTAINERS: Add EFI git repository location

Olof Johansson (1):
      x86: efi: Turn off efi_enabled after setup on mixed fw/kernel

 MAINTAINERS                 |  1 +
 arch/x86/include/asm/efi.h  |  1 +
 arch/x86/kernel/setup.c     | 12 ++++++++++++
 arch/x86/platform/efi/efi.c | 18 ++++++++++--------
 4 files changed, 24 insertions(+), 8 deletions(-)

-- 
Matt Fleming, Intel Open Source Technology Center
