From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: [GIT PULL] EFI urgent fix for v4.6 queue
Date: Fri, 11 Mar 2016 11:19:22 +0000
Message-ID: <1457695163-29632-1-git-send-email-matt@codeblueprint.co.uk>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alexis Murzeau <amurzeau-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Maarten Lankhorst <maarten.lankhorst-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Raphael Hertzog <hertzog-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org>, Roger Shimizu <rogershimizu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Folks, the following patch fixes a bug that is triggered with the new
EFI page table code sitting in tip/efi/core and queued up for the
merge window.

It turns out that we were relying on the kernel's mappings for those
regions that are marked E820_RESERVED, etc in the e820 map. The
specific example in the bug report was page zero which was always
"special" on legacy BIOS.

On EFI, legitimate code/data can be placed there and so if it's part
of the EFI memory map, we must make sure we map it into the EFI page
tables. EFI runtime drivers may need to access it.

The following changes since commit 2ad510dc372c2caac9aada9ff6dd10e787616e1d:

  x86/efi: Only map kernel text for EFI mixed mode (2016-02-22 08:26:28 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-urgent

for you to fetch changes up to c7af05d993ef60102eea6e0056de7eb5f6d4e52d:

  x86/efi: Always map boot service regions into new EFI page tables (2016-03-11 11:08:36 +0000)

----------------------------------------------------------------
 * Fix a bug triggered with the new separate EFI page table code where
   EFI boot services regions that are marked E820_RESERVED are not
   mapped into the page tables, leading to an oops during
   SetVirtualAddressMap() - Matt Fleming

----------------------------------------------------------------
Matt Fleming (1):
      x86/efi: Always map boot service regions into new EFI page tables

 arch/x86/platform/efi/quirks.c | 79 +++++++++++++++++++++++++++++++++---------
 1 file changed, 62 insertions(+), 17 deletions(-)
