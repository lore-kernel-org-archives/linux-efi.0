From: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [GIT PULL 0/2] EFI changes for v4.3 (part two)
Date: Mon, 14 Sep 2015 12:25:34 +0200
Message-ID: <20150914102533.GA20088@gmail.com>
References: <1441372302-23242-1-git-send-email-matt@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1441372302-23242-1-git-send-email-matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Hanjun Guo <hanjun.guo-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "Jonathan (Zhixiong) Zhang" <zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
List-Id: linux-efi@vger.kernel.org


* Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:

> From: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
> Folks, please pull the remaining parts of the EFI changes for v4.3.
> 
> Nothing much has changed in terms of code since the last version of
> this part two pull request was sent on August 12th,
> 
>   https://lkml.kernel.org/r/1439396234-22863-1-git-send-email-matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org
> 
> The main difference is the improved commit message in PATCH 2, which
> now contains much more information as well as the user visible
> side-effects of the issue that the patch fixes.
> 
> There were also some improvements to the comments inside PATCH 1 as
> well as moving the function out of line at Ingo's suggestion.
> 
> The branch is based on tip/core/efi.
> 
> The following changes since commit 8d446c8647c9ab8fcb45a8fc7dbbafe1f83aa2f3:
> 
>   arm64/mm: Add PROT_DEVICE_nGnRnE and PROT_NORMAL_WT (2015-08-08 10:37:40 +0200)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git acpi/ghes
> 
> for you to fetch changes up to 404f03dbebede4d0ebeabd06e4b9120b481ae536:
> 
>   acpi, apei: Use appropriate pgprot_t to map GHES memory (2015-09-04 13:39:31 +0100)
> 
> ----------------------------------------------------------------
> Jonathan (Zhixiong) Zhang (2):
>       arm64: apei: Implement arch_apei_get_mem_attributes()
>       acpi, apei: Use appropriate pgprot_t to map GHES memory
> 
>  arch/arm64/include/asm/acpi.h |  5 +++++
>  arch/arm64/kernel/acpi.c      | 29 +++++++++++++++++++++++++++++
>  drivers/acpi/apei/ghes.c      | 10 +++++++---
>  3 files changed, 41 insertions(+), 3 deletions(-)

Applied to tip:core/efi, thanks Matt!

	Ingo
