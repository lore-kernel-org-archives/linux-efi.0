From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [RFC 3/3] efi: add capsule update capability via sysfs
Date: Wed, 29 Apr 2015 16:25:26 -0700
Message-ID: <CALCETrV8bRj_CmCwZfHSV8bMF-vv0sab_7v5t0rpdhx2ib=wPw@mail.gmail.com>
References: <1430348859.2189.37.camel@HansenPartnership.com> <1430349130.2189.43.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1430349130.2189.43.camel-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Kweh, Hock Leong" <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, Apr 29, 2015 at 4:12 PM, James Bottomley
<James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org> wrote:
> From: James Bottomley <JBottomley-O3H1v1f1dlM@public.gmane.org>
>
> The firmware update should be applied simply by doing
>
> cat fw_file > /sys/firmware/capsule/update
>
> With a properly formatted fw_file.  Any error will be returned on close of
> stdout.  util-linux returns errors correctly from closing stdout, but firmware
> shippers should check whatever utilities package they use correctly captures
> the error return on close.

s/util-linux/coreutils/

This still makes my API sense itch.  It's kind of an abuse of open/write/close.

>
> Signed-off-by: James Bottomley <JBottomley-O3H1v1f1dlM@public.gmane.org>
> ---
>  drivers/firmware/efi/Makefile  |  2 +-
>  drivers/firmware/efi/capsule.c | 78 ++++++++++++++++++++++++++++++++++++++++++
>  drivers/firmware/efi/capsule.h |  2 ++
>  drivers/firmware/efi/efi.c     |  8 +++++
>  4 files changed, 89 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/firmware/efi/capsule.c
>  create mode 100644 drivers/firmware/efi/capsule.h
>
> diff --git a/drivers/firmware/efi/Makefile b/drivers/firmware/efi/Makefile
> index d8be608..698846e 100644
> --- a/drivers/firmware/efi/Makefile
> +++ b/drivers/firmware/efi/Makefile
> @@ -1,7 +1,7 @@
>  #
>  # Makefile for linux kernel
>  #
> -obj-$(CONFIG_EFI)                      += efi.o vars.o reboot.o
> +obj-$(CONFIG_EFI)                      += efi.o vars.o reboot.o capsule.o
>  obj-$(CONFIG_EFI_VARS)                 += efivars.o
>  obj-$(CONFIG_EFI_VARS_PSTORE)          += efi-pstore.o
>  obj-$(CONFIG_UEFI_CPER)                        += cper.o
> diff --git a/drivers/firmware/efi/capsule.c b/drivers/firmware/efi/capsule.c
> new file mode 100644
> index 0000000..1fd78e7
> --- /dev/null
> +++ b/drivers/firmware/efi/capsule.c
> @@ -0,0 +1,78 @@
> +#include <linux/efi.h>
> +#include <linux/slab.h>
> +#include <linux/transaction_helper.h>
> +
> +#include "capsule.h"
> +
> +static struct kset *capsule_kset;
> +static struct transaction_buf *capsule_buf;
> +
> +static int capsule_data_write(struct file *file, struct kobject *kobj,
> +                             struct bin_attribute *attr,
> +                             char *buffer, loff_t offset, size_t count)
> +{
> +       if (!capsule_buf) {
> +               capsule_buf = kmalloc(sizeof(*capsule_buf), GFP_KERNEL);
> +               if (!capsule_buf)
> +                       return -ENOMEM;
> +               transaction_init(capsule_buf);
> +       }
> +
> +       return transaction_write(capsule_buf, buffer, offset, count);
> +}

This seems unlikely to have good effects if two struct files are active at once.

Also, I think you crash if you open and close without calling write,
and I don't know what whether there can be spurious flushes (fsync?).

--Andy
