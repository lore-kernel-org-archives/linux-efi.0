From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH 5/5] efi: Make efivarfs entries immutable by default
Date: Mon, 15 Feb 2016 10:50:04 +0000
Message-ID: <20160215105004.GC2591@codeblueprint.co.uk>
References: <1455276432-9931-1-git-send-email-matt@codeblueprint.co.uk>
 <1455276432-9931-6-git-send-email-matt@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1455276432-9931-6-git-send-email-matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Lee, Chun-Yi" <jlee-IBi9RG/b67k@public.gmane.org>, Matthew Garrett <mjg59-JW9irJGTvgXQT0dZR+AlfA@public.gmane.org>, Laszlo Ersek <lersek-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, 12 Feb, at 11:27:12AM, Matt Fleming wrote:
> From: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> 
> "rm -rf" is bricking some peoples' laptops because of variables being
> used to store non-reinitializable firmware driver data that's required
> to POST the hardware.
> 
> These are 100% bugs, and they need to be fixed, but in the mean time it
> shouldn't be easy to *accidentally* brick machines.
> 
> We have to have delete working, and picking which variables do and don't
> work for deletion is quite intractable, so instead make everything
> immutable by default (except for a whitelist), and make tools that
> aren't quite so broad-spectrum unset the immutable flag.
> 
> Signed-off-by: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Tested-by: "Lee, Chun-Yi" <jlee-IBi9RG/b67k@public.gmane.org>
> Acked-by: Matthew Garrett <mjg59-JW9irJGTvgXQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
> ---
>  Documentation/filesystems/efivarfs.txt         |  7 +++
>  drivers/firmware/efi/vars.c                    | 87 +++++++++++++++++++-------
>  fs/efivarfs/file.c                             | 70 +++++++++++++++++++++
>  fs/efivarfs/inode.c                            | 30 +++++----
>  fs/efivarfs/internal.h                         |  3 +-
>  fs/efivarfs/super.c                            |  9 ++-
>  include/linux/efi.h                            |  2 +
>  tools/testing/selftests/efivarfs/efivarfs.sh   | 19 +++++-
>  tools/testing/selftests/efivarfs/open-unlink.c | 72 ++++++++++++++++++++-
>  9 files changed, 258 insertions(+), 41 deletions(-)

Folks, please hold off on merging this patch as Laszlo has raised a
good point about including the efi-pstore variables in the whitelist.
