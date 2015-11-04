From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: [GIT PULL] EFI urgent fix
Date: Wed,  4 Nov 2015 10:47:16 +0000
Message-ID: <1446634037-10251-1-git-send-email-matt@codeblueprint.co.uk>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, "Huang, Ying" <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Laszlo Ersek <lersek-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Folks, the LKP robot reported an issue with Paolo's recent bug fix
that syncs the identity mapping in 'initial_page_table'. Turns out
that KERNEL_PGD_PTRS is not the correct constant to use when copying
to the lower region because that's every PGD from PAGE_OFFSET to the
end of the addressable memory.

Crucially, KERNEL_PGD_PTRS > KERNEL_PGD_BOUNDARY and so the patch ends
up trashing some of the kernel mappings in 'initial_page'table,
leading to boot crashes on 32-bit SMP when bringing APs online.

The following changes since commit 9ee870feaa9e0c6abef95a3b1fc518d88adfa2d3:

  Merge branch 'x86/cpufeature' into x86/urgent, to pick up pending Intel MID change (2015-11-03 12:00:40 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-urgent

for you to fetch changes up to 5965d1bbeba70fe3626e4537f4729283cb0e75f7:

  x86/setup: Fix recent boot crash on 32-bit SMP machines (2015-11-04 09:26:24 +0000)

----------------------------------------------------------------
 * Avoid trashing the kernel mappings in 'initial_page_table' when
   copying the identity mapping from 'swapper_pg_dir'. This bug was
   introduced by a bug fix in v4.3 which erroneously copies too many
   entries from 'swapper_pg_dir'.

----------------------------------------------------------------
Matt Fleming (1):
      x86/setup: Fix recent boot crash on 32-bit SMP machines

 arch/x86/kernel/setup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
