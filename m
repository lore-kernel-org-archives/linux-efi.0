From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 0/2] efi: Enhance capsule loader to support signed Quark images
Date: Wed, 15 Feb 2017 18:17:05 +0000
Message-ID: <CAKv+Gu_4UVAVp0WJT4drY8MijD7-CuhLUghVNhoLA-1VjQ_m4w@mail.gmail.com>
References: <cover.1487182480.git.jan.kiszka@siemens.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1487182480.git.jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jan Kiszka <jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Shevchenko <andy.shevchenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 15 February 2017 at 18:14, Jan Kiszka <jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org> wrote:
> See patch 2 for the background.
>
> Series has been tested on the Galileo Gen2, to exclude regressions, with
> a firmware.cap without security header and the SIMATIC IOT2040 which
> requires the header because of its mandatory secure boot.
>

Hello Jan,

What is a Quark? Is it in the UEFI spec?

> Jan Kiszka (2):
>   efi/capsule: Prepare for loading images with security header
>   efi/capsule: Add support for Quark security header
>
>  drivers/firmware/efi/capsule-loader.c | 73 ++++++++++++++++++++++++++++++-----
>  drivers/firmware/efi/capsule.c        | 19 +++++++--
>  include/linux/efi.h                   |  2 +-
>  3 files changed, 79 insertions(+), 15 deletions(-)
>
> --
> 2.1.4
>
