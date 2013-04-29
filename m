From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: [GIT PULL] EFI merge botch fix
Date: Mon, 29 Apr 2013 19:18:19 +0100
Message-ID: <20130429181819.GA2254@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Hi folks,

This commit fixes the merge botch I created when merging -rc8 into
tip/x86/efi, where I dropped the "select UCS2_STRING" string from
drivers/firmware/Kconfig. The string actually needs to be moved to
arch/ia64 because parts of the core EFI support in drivers/firmware/efi/
require the ucs2 string functions.

The following changes since commit e29c2de5f591490fd51225081e5d7579c6699247:

  Merge tag 'v3.9-rc8' into efi-for-tip (2013-04-22 12:53:22 +0100)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git efi-for-tip

for you to fetch changes up to da74caa6cead3f6c55dabcaa7b397b2fddd655e3:

  ia64, efi: select UCS2_STRING when building EFI support (2013-04-29 14:46:15 +0100)

----------------------------------------------------------------
Matt Fleming (1):
      ia64, efi: select UCS2_STRING when building EFI support

 arch/ia64/Kconfig | 1 +
 1 file changed, 1 insertion(+)

-- 
Matt Fleming, Intel Open Source Technology Center
