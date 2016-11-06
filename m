From: Andreas Noever <andreas.noever-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 3/3] thunderbolt: Use Device ROM retrieved from EFI
Date: Mon, 7 Nov 2016 00:02:32 +0100
Message-ID: <CAMxnaaVfT+gxgq4q76Jz8gY_OfaBr_ToXQ8f-bYGwjcd2eS=9A@mail.gmail.com>
References: <cover.1478145888.git.lukas@wunner.de> <776fcc302f58628d1a122ba929751760c554cbfc.1478145888.git.lukas@wunner.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <776fcc302f58628d1a122ba929751760c554cbfc.1478145888.git.lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, Nov 3, 2016 at 11:18 AM, Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org> wrote:
> Macs with Thunderbolt 1 do not have a unit-specific DROM: The DROM is
> empty with uid 0x1000000000000. (Apple started factory-burning a unit-
> specific DROM with Thunderbolt 2.)
>
> Instead, the NHI EFI driver supplies a DROM in a device property. Use
> it if available. It's only available when booting with the efistub.
> If it's not available, silently fall back to our hardcoded DROM.
>
> The size of the DROM is always 256 bytes. The number is hardcoded into
> the NHI EFI driver. This commit can deal with an arbitrary size however,
> just in case they ever change that.
>
> Background information: The EFI firmware volume contains ROM files for
> the NHI, GMUX and several other chips as well as key material. This
> strategy allows Apple to deploy ROM or key updates by simply publishing
> an EFI firmware update on their website. Drivers do not access those
> files directly but rather through a file server via EFI protocol
> AC5E4829-A8FD-440B-AF33-9FFE013B12D8. Files are identified by GUID, the
> NHI DROM has 339370BD-CFC6-4454-8EF7-704653120818.
>
> The NHI EFI driver amends that file with a unit-specific uid. The uid
> has 64 bit but its entropy is much lower: 24 bit represent the model,
> 24 bit are taken from a serial number, 16 bit are fixed. The NHI EFI
> driver obtains the serial number via the DataHub protocol, copies it
> into the DROM, calculates the CRC and submits the result as a device
> property.
>
> A modification is needed in the resume code where we currently read the
> uid of all switches in the hierarchy to detect plug events that occurred
> during sleep. On Thunderbolt 1 root switches this will now lead to a
> mismatch between the uid of the empty DROM and the EFI DROM. Exempt the
> root switch from this check: It's built in, so the uid should never
> change. However we continue to *read* the uid of the root switch, this
> seems like a good way to test its reachability after resume.

Nice work! I have just one comment (see below).

btw: any success in decoding the path crumbs property?

> Cc: Pedro Vila=C3=A7a <reverser-P1ImLx+pFc0@public.gmane.org>
> Cc: Andreas Noever <andreas.noever-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Tested-by: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org> [MacBookPro9,1]
> Tested-by: Pierre Moreau <pierre.morrow-GANU6spQydw@public.gmane.org> [MacBookPro11,3]
> Signed-off-by: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
> ---
>  drivers/thunderbolt/Kconfig  |  1 +
>  drivers/thunderbolt/eeprom.c | 42 ++++++++++++++++++++++++++++++++++++++=
++++
>  drivers/thunderbolt/switch.c |  2 +-
>  3 files changed, 44 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/thunderbolt/Kconfig b/drivers/thunderbolt/Kconfig
> index c121acc..0056df7 100644
> --- a/drivers/thunderbolt/Kconfig
> +++ b/drivers/thunderbolt/Kconfig
> @@ -1,6 +1,7 @@
>  menuconfig THUNDERBOLT
>         tristate "Thunderbolt support for Apple devices"
>         depends on PCI
> +       select APPLE_PROPERTIES
>         select CRC32
>         help
>           Cactus Ridge Thunderbolt Controller driver
> diff --git a/drivers/thunderbolt/eeprom.c b/drivers/thunderbolt/eeprom.c
> index 2b9602c..785a171 100644
> --- a/drivers/thunderbolt/eeprom.c
> +++ b/drivers/thunderbolt/eeprom.c
> @@ -5,6 +5,7 @@
>   */
>
>  #include <linux/crc32.h>
> +#include <linux/property.h>
>  #include <linux/slab.h>
>  #include "tb.h"
>
> @@ -360,6 +361,39 @@ static int tb_drom_parse_entries(struct tb_switch *s=
w)
>  }
>
>  /**
> + * tb_drom_copy_efi - copy drom supplied by EFI to sw->drom if present
> + */
> +static int tb_drom_copy_efi(struct tb_switch *sw, u16 *size)
> +{
> +       struct device *dev =3D &sw->tb->nhi->pdev->dev;
> +       int len, res;
> +
> +       len =3D device_property_read_u8_array(dev, "ThunderboltDROM", NUL=
L, 0);
> +       if (len < 0 || len < sizeof(struct tb_drom_header))
> +               return -EINVAL;
> +
> +       sw->drom =3D kmalloc(len, GFP_KERNEL);
> +       if (!sw->drom)
> +               return -ENOMEM;
> +
> +       res =3D device_property_read_u8_array(dev, "ThunderboltDROM", sw-=
>drom,
> +                                                                       l=
en);
> +       if (res)
> +               goto err;
> +
> +       *size =3D ((struct tb_drom_header *)sw->drom)->data_len +
> +                                                         TB_DROM_DATA_ST=
ART;
> +       if (*size > len)
> +               goto err;
> +
> +       return 0;
> +
> +err:
> +       kfree(sw->drom);
Please also set sw->drom to NULL here. Otherwise sw->drom will be
freed again in the error path of tb_switch_alloc or in tb_switch_free.

Otherwise:
Acked-by: Andreas Noever <andreas.noever-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Thanks,
Andreas
> +       return -EINVAL;
> +}
> +
> +/**
>   * tb_drom_read - copy drom to sw->drom and parse it
>   */
>  int tb_drom_read(struct tb_switch *sw)
> @@ -374,6 +408,13 @@ int tb_drom_read(struct tb_switch *sw)
>
>         if (tb_route(sw) =3D=3D 0) {
>                 /*
> +                * Apple's NHI EFI driver supplies a DROM for the root sw=
itch
> +                * in a device property. Use it if available.
> +                */
> +               if (tb_drom_copy_efi(sw, &size) =3D=3D 0)
> +                       goto parse;
> +
> +               /*
>                  * The root switch contains only a dummy drom (header onl=
y,
>                  * no entries). Hardcode the configuration here.
>                  */
> @@ -418,6 +459,7 @@ int tb_drom_read(struct tb_switch *sw)
>         if (res)
>                 goto err;
>
> +parse:
>         header =3D (void *) sw->drom;
>
>         if (header->data_len + TB_DROM_DATA_START !=3D size) {
> diff --git a/drivers/thunderbolt/switch.c b/drivers/thunderbolt/switch.c
> index 9840fde..c6f30b1 100644
> --- a/drivers/thunderbolt/switch.c
> +++ b/drivers/thunderbolt/switch.c
> @@ -460,7 +460,7 @@ int tb_switch_resume(struct tb_switch *sw)
>                 tb_sw_warn(sw, "uid read failed\n");
>                 return err;
>         }
> -       if (sw->uid !=3D uid) {
> +       if (sw !=3D sw->tb->root_switch && sw->uid !=3D uid) {
>                 tb_sw_info(sw,
>                         "changed while suspended (uid %#llx -> %#llx)\n",
>                         sw->uid, uid);
> --
> 2.10.1
>
