From: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [GIT PULL] EFI urgent fixes
Date: Mon, 2 Mar 2015 14:24:10 +0100
Message-ID: <20150302132410.GA4300@gmail.com>
References: <20150302125104.GC24476@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150302125104.GC24476-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ivan Khoronzhuk <ivan.khoronzhuk-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org


* Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:

> Folks, please pull the following urgent changes.
> 
> The following changes since commit 43a9f69692b232d1c64c913a27507eb14a1c47fd:
> 
>   Revert "efi/libstub: Call get_memory_map() to obtain map and desc sizes" (2015-02-18 11:38:13 +0000)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-urgent
> 
> for you to fetch changes up to 6d9ff473317245e3e5cd9922b4520411c2296388:
> 
>   firmware: dmi_scan: Fix dmi_len type (2015-02-24 18:54:17 +0000)
> 
> ----------------------------------------------------------------
>  * Fix regression in DMI sysfs code for handling "End of Table" entry
>    and a type bug that could lead to integer overflow - Ivan Khoronzhuk
> 
>  * Fix boundary checking in efi_high_alloc() which can lead to memory
>    corruption in the EFI boot stubs - Yinghai Lu
> 
> ----------------------------------------------------------------
> Ivan Khoronzhuk (2):
>       firmware: dmi_scan: Fix dmi scan to handle "End of Table" structure
>       firmware: dmi_scan: Fix dmi_len type
> 
> Yinghai Lu (1):
>       efi/libstub: Fix boundary checking in efi_high_alloc()
> 
>  drivers/firmware/dmi_scan.c                    | 17 +++++++++--------
>  drivers/firmware/efi/libstub/efi-stub-helper.c |  8 ++++----
>  2 files changed, 13 insertions(+), 12 deletions(-)

Pulled, thanks Matt!

For future reference, plase leave out unreadable commit messages like 
this:

  While adding support loading kernel and initrd above 4G to grub2 in 
  legacy mode, I was referring to efi_high_alloc(). That will allocate 
  buffer for kernel and then initrd, and initrd will use kernel buffer 
  start as limit.

  During testing found two buffers will be overlapped when initrd size 
  is very big like 400M.

I pulled it, because you do explain the commit in the second half of 
the changelog, in parentheses - but instead of forcing readers through 
the crappy part, please just drop the crappy explanation and fix it 
up, or require your contributors to submit proper changelogs. (Yinghai 
Lu is a repeat offender in that area.)

Thanks,

	Ingo
