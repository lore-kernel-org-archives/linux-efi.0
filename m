From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: [GIT PULL] EFI urgent fixes
Date: Thu, 25 Apr 2013 09:49:10 +0100
Message-ID: <5178EE06.8020107@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Hi folks,

The following changes since commit 8c58bf3eec3b8fc8162fe557e9361891c20758f2:

  x86,efi: Implement efi_no_storage_paranoia parameter (2013-04-17 15:13:38 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-urgent

for you to fetch changes up to f697036b93aa7345d4cbb3c854a76456c0ddac45:

  efi: Check EFI revision in setup_efi_vars (2013-04-24 16:19:01 +0100)

----------------------------------------------------------------
 * The EFI variable anti-bricking algorithm merged in -rc8 broke booting
   on some Apple machines because they implement EFI spec 1.10, which
   doesn't provide a QueryVariableInfo() runtime function and the logic
   used to check for the existence of that function was insufficient.
   Fix from Josh Boyer.

 * The anti-bricking algorithm also introduced a compiler warning on
   32-bit. Fix from Borislav Petkov.

----------------------------------------------------------------
Borislav Petkov (1):
      x86, efi: Fix a build warning

Josh Boyer (1):
      efi: Check EFI revision in setup_efi_vars

 arch/x86/boot/compressed/eboot.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

-- 
Matt Fleming, Intel Open Source Technology Center
