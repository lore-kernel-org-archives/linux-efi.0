From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 0/2] capsule pstore backend
Date: Fri, 3 Mar 2017 15:19:51 +0000
Message-ID: <CAKv+Gu-PjFD8eAAOau6wPXH+pQ8JfKh-huFqiB+Go+5YTth3tQ@mail.gmail.com>
References: <20170301175943.87444-1-qiuxu.zhuo@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170301175943.87444-1-qiuxu.zhuo-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Qiuxu Zhuo <qiuxu.zhuo-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 1 March 2017 at 17:59, Qiuxu Zhuo <qiuxu.zhuo-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> *** BLURB HERE ***
>

FYI the UEFI spec is vague about the exact format of the per-GUID
capsule configuration table entries, and so we have asked the USWG for
clarification. In the mean time, I'd like to refrain from merging
anything based on it, so unfortunately, we are going to have to park
this for now.

Regards,
Ard.

> Qiuxu Zhuo (2):
>   efi/capsule: Add 'capsule' lookup support
>   efi: capsule pstore backend
>
>  drivers/firmware/efi/Kconfig          |  21 ++
>  drivers/firmware/efi/Makefile         |   1 +
>  drivers/firmware/efi/capsule-pstore.c | 527 ++++++++++++++++++++++++++++++++++
>  drivers/firmware/efi/capsule.c        | 107 +++++++
>  drivers/firmware/efi/efi.c            |   4 +
>  include/linux/efi.h                   |   4 +
>  6 files changed, 664 insertions(+)
>  create mode 100644 drivers/firmware/efi/capsule-pstore.c
> --
>
> Change Log (v1->v2):
>   - Use memremap() instead of ioremap() for firmware tables
>   - Remove "default n" in Kconfig file
>   - Move check_capsule_support() up a bit
>   - Update SoB chain
> --
> 2.9.0.GIT
>
