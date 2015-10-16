From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: [GIT PULL] EFI urgent fix
Date: Fri, 16 Oct 2015 11:01:45 +0100
Message-ID: <1444989706-11602-1-git-send-email-matt@codeblueprint.co.uk>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Laszlo Ersek <lersek-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

From: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Folks, the below fix from Paolo addresses an issue causing 32-bit
non-PAE kernels to triple fault on EFI boot. The issue is that the
physical address of the GDT that gets used in efi_call_phys_prolog()
won't be covered by the identitty mapping in initial_page_table.

The following changes since commit 8a53554e12e98d1759205afd7b8e9e2ea0936f48:

  x86/efi: Fix multiple GOP device support (2015-10-14 16:02:43 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-urgent

for you to fetch changes up to f5f3497cad8c8416a74b9aaceb127908755d020a:

  x86/setup: Extend low identity map to cover whole kernel range (2015-10-16 10:52:29 +0100)

----------------------------------------------------------------
 * Ensure that the identity mapping in initial_page_table is updated
   to cover the entire kernel range. This fixes a triple fault on
   non-PAE kernels when booting on 32-bit EFI due to accessing an
   unmapped GDT in efi_call_phys_prolog() - Paolo Bonzini

----------------------------------------------------------------
Paolo Bonzini (1):
      x86/setup: Extend low identity map to cover whole kernel range

 arch/x86/kernel/setup.c | 8 ++++++++
 1 file changed, 8 insertions(+)
