From: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH v4 00/13] UEFI boot and runtime services support for
 32-bit ARM
Date: Thu, 3 Dec 2015 10:18:24 +0000
Message-ID: <20151203101823.GA11337@arm.com>
References: <1448886507-3216-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1448886507-3216-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, kuleshovmail-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, ryan.harkin-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Hi Ard,

On Mon, Nov 30, 2015 at 01:28:14PM +0100, Ard Biesheuvel wrote:
> This series adds support for booting the 32-bit ARM kernel directly from
> UEFI firmware using a builtin UEFI stub. It mostly reuses refactored arm64
> code, and the differences (primarily the PE/COFF header and entry point and
> the efi_create_mapping() implementation) are split out into arm64 and ARM
> versions.
> 
> Since I did not receive any further comments in reply to v3 from the people who
> commented on v2, I think this series in now in sufficient shape to be pulled.
> Note that patch #1 touches mm/memblock.c and include/linux/memblock.h, for which
> get_maintainer.pl does not provide a maintainer, so it has been cc'ed to various
> past editors of those files, and to the linux-mm mailing list.
> 
> Since the series affects both arm64 and ARM, it is up to the maintainers to let
> me know how and when they wish to proceed with this. My suggestion would be to
> send out pull request for patches #1 - #5 to the arm64 maintainer, and for the
> whole series to the ARM maintainer. This should keep any conflicts on either
> side confined to the respective maintainer tree, rather then propagating all the
> way to -next.

For the arm64 bits (patches 2-5):

  Acked-by: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>

I'd really like an ack from the mm crowd on patch 1 before I queue it.

Will
