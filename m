From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: [GIT PULL] EFI changes for v3.15
Date: Mon, 17 Mar 2014 22:31:31 +0000
Message-ID: <20140317223131.GB2815@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Peter,

I've queued up a few fixes that avoid some crashes when running with
CONFIG_EFI_MIXED. Please pull into the queue for the merge window.

The following changes since commit 617b3c37da78cb89c63ed880b2405afc7490567b:

  Merge branch 'mixed-mode' into efi-for-mingo (2014-03-05 18:18:50 +0000)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-next

for you to fetch changes up to 9a11040ff962304c1838aa9a9f33be78784eae47:

  x86/efi: Restore 'attr' argument to query_variable_info() (2014-03-17 21:55:04 +0000)

----------------------------------------------------------------
 * Save and restore the segment registers when thunking

 * Correct arguments to query_variable_info() when thunking

 * Delete the dead code phys_efi_get_time()

----------------------------------------------------------------
Matt Fleming (3):
      x86/efi: Preserve segment registers in mixed mode
      x86/efi: Rip out phys_efi_get_time()
      x86/efi: Restore 'attr' argument to query_variable_info()

 arch/x86/platform/efi/efi.c         | 29 -----------------------------
 arch/x86/platform/efi/efi_64.c      |  2 +-
 arch/x86/platform/efi/efi_stub_64.S | 25 +++++++++++++++++--------
 3 files changed, 18 insertions(+), 38 deletions(-)

-- 
Matt Fleming, Intel Open Source Technology Center
