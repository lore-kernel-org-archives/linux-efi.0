From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH V3 0/2] CPER ARM error information parsing
Date: Mon, 18 Dec 2017 14:43:27 +0000
Message-ID: <CAKv+Gu96MDkQMe6SvqOMOXAx4V4cJO5TrcZKZLDEpH7D--n_sw@mail.gmail.com>
References: <1513091898-21967-1-git-send-email-tbaicar@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1513091898-21967-1-git-send-email-tbaicar-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tyler Baicar <tbaicar-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 12 December 2017 at 15:18, Tyler Baicar <tbaicar-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org> wrote:
> Break out the ARM CPER code into a new file so it's separate from the main of
> the CPER code.
>
> Add parsing for the ARM error information value based on UEFI 2.7 spec tables
> 263-265.
>
> V3: Keep error type string definition in cper.c
>
> Tyler Baicar (2):
>   efi: move ARM CPER code to new file
>   efi: parse ARM error information value
>
>  drivers/firmware/efi/Kconfig    |   5 +
>  drivers/firmware/efi/Makefile   |   1 +
>  drivers/firmware/efi/cper-arm.c | 356 ++++++++++++++++++++++++++++++++++++++++
>  drivers/firmware/efi/cper.c     | 122 +-------------
>  include/linux/cper.h            |  48 ++++++
>  5 files changed, 413 insertions(+), 119 deletions(-)
>  create mode 100644 drivers/firmware/efi/cper-arm.c
>

This looks good to me. Although I haven't cross referenced every
little detail with the spec:

Reviewed-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
