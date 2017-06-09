From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [GIT PULL] Another EFI BGRT fix for v4.12
Date: Fri,  9 Jun 2017 08:45:57 +0000
Message-ID: <20170609084558.26766-1-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Maniaxx <tripleshiftone-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

The following changes since commit 7425826f4f7ac60f2538b06a7f0a5d1006405159:

  efi/bgrt: Skip efi_bgrt_init() in case of non-EFI boot (2017-05-28 11:06:17 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git tags/efi-urgent

for you to fetch changes up to 0a97e704d93fe4facf2bffe3c78095b9d441df42:

  efi: fix boot panic because of invalid bgrt image address (2017-06-09 08:38:49 +0000)

----------------------------------------------------------------
Another BGRT regression fix from Dave Young, to avoid a crash on buggy
firmware that puts a bogus image address in the BGRT table.

----------------------------------------------------------------
Dave Young (1):
      efi: fix boot panic because of invalid bgrt image address

 drivers/firmware/efi/efi-bgrt.c | 26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)
