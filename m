From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [GIT PULL 0/5] EFI urgent fixes
Date: Tue, 16 Feb 2016 13:15:45 +0100
Message-ID: <20160216121545.GA9395@gmail.com>
References: <1455276432-9931-1-git-send-email-matt@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1455276432-9931-1-git-send-email-matt@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, "Lee, Chun-Yi" <jlee@suse.com>, Matthew Garrett <mjg59@coreos.com>, Peter Jones <pjones@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: linux-efi@vger.kernel.org


* Matt Fleming <matt@codeblueprint.co.uk> wrote:

> Folks,
> 
> Please pull the following EFI patches from Peter that prevent
> accidental deletion of EFI variables through efivarfs which can lead
> to bricked machines.
> 
> These obviously need backporting to stable, so I'll take care of
> sending the backports separately because we don't need to send the
> entire 5 patch series.
> 
> The following changes since commit 59fd1214561921343305a0e9dc218bf3d40068f3:
> 
>   x86/mm/numa: Fix 32-bit memblock range truncation bug on 32-bit NUMA kernels (2016-02-08 12:10:03 +0100)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-urgent
> 
> for you to fetch changes up to ed8b0de5a33d2a2557dce7f9429dca8cb5bc5879:
> 
>   efi: Make efivarfs entries immutable by default (2016-02-10 16:25:52 +0000)
> 
> ----------------------------------------------------------------
>  * Prevent accidental deletion of EFI variables through efivarfs that
>    may brick machines. We use a whitelist of known-safe variables to
>    allow things like installing distributions to work out of the box, and
>    instead restrict vendor-specific variable deletion by making
>    non-whitelist variables immutable - Peter Jones
> 
> ----------------------------------------------------------------
> Peter Jones (5):
>       lib/ucs2_string: Add ucs2 -> utf8 helper functions
>       efi: Use ucs2_as_utf8 in efivarfs instead of open coding a bad version
>       efi: Do variable name validation tests in utf8
>       efi: Make our variable validation list include the guid
>       efi: Make efivarfs entries immutable by default
> 
>  Documentation/filesystems/efivarfs.txt         |   7 ++
>  drivers/firmware/efi/efivars.c                 |  35 +++---
>  drivers/firmware/efi/vars.c                    | 143 ++++++++++++++++++-------
>  fs/efivarfs/file.c                             |  70 ++++++++++++
>  fs/efivarfs/inode.c                            |  30 ++++--
>  fs/efivarfs/internal.h                         |   3 +-
>  fs/efivarfs/super.c                            |  16 +--
>  include/linux/efi.h                            |   5 +-
>  include/linux/ucs2_string.h                    |   4 +
>  lib/ucs2_string.c                              |  62 +++++++++++
>  tools/testing/selftests/efivarfs/efivarfs.sh   |  19 +++-
>  tools/testing/selftests/efivarfs/open-unlink.c |  72 ++++++++++++-
>  12 files changed, 383 insertions(+), 83 deletions(-)

Pulled, thanks Matt!

	Ingo
