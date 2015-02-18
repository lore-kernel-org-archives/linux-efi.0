From: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [GIT PULL] EFI urgent fixes
Date: Wed, 18 Feb 2015 17:57:05 +0100
Message-ID: <20150218165705.GA28547@gmail.com>
References: <20150218115543.GA5648@codeblueprint.co.uk>
 <20150218134357.GA386@gmail.com>
 <D0B4679E-92EB-4A22-8D3E-9D0C27A09ACD@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <D0B4679E-92EB-4A22-8D3E-9D0C27A09ACD-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
List-Id: linux-efi@vger.kernel.org


* Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:

> 
> > On 18 feb. 2015, at 13:43, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> > 
> > 
> > * Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:
> > 
> >> Folks, please pull the following fixes. The revert addresses a
> >> regression that Ard hit when booting Qemu and Xen, and the other patch
> >> ensures that we don't triple fault when receiving an NMI or MCE during
> >> an EFI mixed mode call, which may happen, for instance, when running
> >> perf.
> >> 
> >> The pull is against tip/x86/efi because tip/x86/urgent doesn't contain
> >> commit d1a8d66b9177 ("efi/libstub: Call get_memory_map() to obtain map
> >> and desc sizes") needed for the revert.
> >> 
> >> If you'd prefer for me to resend this after the merge window closes,
> >> just let me know.
> >> 
> >> The following changes since commit 3c01b74e818a7a3b2ee9b0d584cca0bc154a031c:
> >> 
> >>  Merge tag 'efi-next' of git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi into x86/efi (2015-01-29 19:16:40 +0100)
> >> 
> >> are available in the git repository at:
> >> 
> >> 
> >>  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-urgent
> >> 
> >> for you to fetch changes up to 43a9f69692b232d1c64c913a27507eb14a1c47fd:
> >> 
> >>  Revert "efi/libstub: Call get_memory_map() to obtain map and desc sizes" (2015-02-18 11:38:13 +0000)
> >> 
> >> ----------------------------------------------------------------
> >> * Leave a valid 64-bit IDT installed during runtime EFI mixed mode
> >>   calls to avoid triple faults if an NMI/MCE is received.
> >> 
> >> * Revert Ard's change to the libstub get_memory_map() that went into
> >>   the v3.20 merge window because it causes boot regressions on Qemu and
> >>   Xen.
> >> 
> >> ----------------------------------------------------------------
> >> Matt Fleming (2):
> >>      x86/efi: Avoid triple faults during EFI mixed mode calls
> >>      Revert "efi/libstub: Call get_memory_map() to obtain map and desc sizes"
> >> 
> >> arch/x86/boot/compressed/Makefile              |   1 +
> >> arch/x86/boot/compressed/efi_stub_64.S         |  25 ----
> >> arch/x86/boot/compressed/efi_thunk_64.S        | 196 +++++++++++++++++++++++++
> >> arch/x86/platform/efi/efi_stub_64.S            | 161 --------------------
> >> arch/x86/platform/efi/efi_thunk_64.S           | 121 ++++++++++++---
> >> drivers/firmware/efi/libstub/efi-stub-helper.c |  16 +-
> >> 6 files changed, 307 insertions(+), 213 deletions(-)
> >> create mode 100644 arch/x86/boot/compressed/efi_thunk_64.S
> > 
> > Pulled, thanks Matt!
> > 
> > Btw., I find the revert a bit sad: in most cases breaking 
> > virtualized environments isn't a regression really, it's 
> > _them_ who couple to the kernel in an incestuous way that 
> > causes the problem: fixes should come from them ...
> > 
> 
> It potentially breaks physical environments as well, 
> [...]

Fair enough!

Thanks,

	Ingo
