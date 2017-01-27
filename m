From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: [GIT PULL] EFI urgent fix
Date: Fri, 27 Jan 2017 22:06:03 +0000
Message-ID: <20170127220604.21302-1-matt@codeblueprint.co.uk>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Hanka Pavlikova <hanka-+ZI9xUNit7I@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Laura Abbott <labbott-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vojtech Pavlik <vojtech-+ZI9xUNit7I@public.gmane.org>, Waiman Long <waiman.long-ZPxbGqLxI0U@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Folks, please pull the below fix from Jiri which fixes a triple fault
affecting the Lenovo Yogas since v4.8.

The following changes since commit 7a308bb3016f57e5be11a677d15b821536419d36:

  Linux 4.10-rc5 (2017-01-22 12:54:15 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git tags/efi-urgent

for you to fetch changes up to 090abfc9dc7faf3f84799f956158c8c3af149a81:

  x86/efi: Always map first physical page into EFI pagetables (2017-01-27 20:20:01 +0000)

----------------------------------------------------------------
 * Fix triple fault on boot affecting Lenovo Yoga. The firmware on
   these machines will write to the zero page even though it's marked
   EFI_CONVENTIONAL_MEMORY, so we must ensure it's mapped in the EFI
   page tables - Jiri Kosina

----------------------------------------------------------------
Jiri Kosina (1):
      x86/efi: Always map first physical page into EFI pagetables

 arch/x86/platform/efi/efi_64.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)
