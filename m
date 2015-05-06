From: Ingo Molnar <mingo2.kernel.org-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [GIT PULL] EFI urgent fixes
Date: Wed, 6 May 2015 08:31:09 +0200
Message-ID: <20150506063109.GA26965@gmail.com>
References: <20150505162755.GA3767@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150505162755.GA3767-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org


* Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:

> Folks, please pull the following bug fixes for efivarfs, EFI boot stub
> and the EFI runtime map code.
> 
> The following changes since commit bfbaafae8519d82d10da6abe75f5766dd5b20475:
> 
>   firmware: dmi_scan: Prevent dmi_num integer overflow (2015-03-27 10:53:46 +0000)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-urgent
> 
> for you to fetch changes up to d67e199611b986b345ea3087ee2e4a15da1c98b3:
> 
>   efi: Fix error handling in add_sysfs_runtime_map_entry() (2015-05-05 16:20:13 +0100)
> 
> ----------------------------------------------------------------
>  * Avoid garbage names in efivarfs due to buggy firmware by zero'ing
>    EFI variable name - Ross Lagerwall
> 
>  * Stop erroneously dropping upper 32-bits of boot command line pointer
>    in EFI boot stub and stash them in ext_cmd_line_ptr - Roy Franz
> 
>  * Fix double-free bug in error handling code path of EFI runtime map
>    code - Dan Carpenter
> 
> ----------------------------------------------------------------
> Dan Carpenter (1):
>       efi: Fix error handling in add_sysfs_runtime_map_entry()
> 
> Ross Lagerwall (1):
>       efivarfs: Ensure VariableName is NUL-terminated
> 
> Roy Franz (1):
>       x86/efi: Store upper bits of command line buffer address in ext_cmd_line_ptr
> 
>  arch/x86/boot/compressed/eboot.c   | 2 ++
>  drivers/firmware/efi/runtime-map.c | 6 +++---
>  fs/efivarfs/super.c                | 2 +-
>  3 files changed, 6 insertions(+), 4 deletions(-)

Pulled into tip:x86/urgent, thanks a lot Matt!

	Ingo
