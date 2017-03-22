From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH v2] efifb: avoid reconfiguration of BAR that covers the framebuffer
Date: Wed, 22 Mar 2017 11:08:48 +0000
Message-ID: <35F65528-FC1F-4813-A0C6-641CF864212A@linaro.org>
References: <1490123810-12383-1-git-send-email-ard.biesheuvel@linaro.org> <20170322102939.GB3519@red-moon>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <20170322102939.GB3519@red-moon>
Sender: linux-pci-owner@vger.kernel.org
To: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-efi@vger.kernel.org, matt@codeblueprint.co.uk, pjones@redhat.com, bhelgaas@google.com, hanjun.guo@linaro.org, heyi.guo@linaro.org, linux-pci@vger.kernel.org
List-Id: linux-efi@vger.kernel.org


> On 22 Mar 2017, at 10:29, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com> wr=
ote:
>=20
>> On Tue, Mar 21, 2017 at 07:16:50PM +0000, Ard Biesheuvel wrote:
>> On UEFI systems, the PCI subsystem is enumerated by the firmware,
>> and if a graphical framebuffer is exposed by a PCI device, its base
>> address and size are exposed to the OS via the Graphics Output
>> Protocol (GOP).
>>=20
>> On arm64 PCI systems, the entire PCI hierarchy is reconfigured from
>> scratch at boot. This may result in the GOP framebuffer address to
>> become stale, if the BAR covering the framebuffer is modified. This
>> will cause the framebuffer to become unresponsive, and may in some
>> cases result in unpredictable behavior if the range is reassigned to
>> another device.
>>=20
>> So add a quirk to the EFI fb driver to find the BAR associated with
>> the GOP base address, and set the IORESOURCE_PCI_FIXED attribute so
>> that the PCI core will leave it alone.
>>=20
>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>> ---
>> As it turns out, setting the IORESOURCE_PCI_FIXED flag is not sufficient
>> to make the PCI core leave the BARs alone, so instead, the BAR resource
>> is claimed in the quirk handler.
>>=20
>> As suggested by Lorenzo, a check is added that the device has memory
>> decoding enabled, and if it doesn't, no attempt is made to use the
>> EFI framebuffer.
>>=20
>> drivers/video/fbdev/efifb.c | 58 +++++++++++++++++++-
>> 1 file changed, 57 insertions(+), 1 deletion(-)
>>=20
>> diff --git a/drivers/video/fbdev/efifb.c b/drivers/video/fbdev/efifb.c
>> index 8c4dc1e1f94f..eeeaf78c4a5b 100644
>> --- a/drivers/video/fbdev/efifb.c
>> +++ b/drivers/video/fbdev/efifb.c
>> @@ -10,6 +10,7 @@
>> #include <linux/efi.h>
>> #include <linux/errno.h>
>> #include <linux/fb.h>
>> +#include <linux/pci.h>
>> #include <linux/platform_device.h>
>> #include <linux/screen_info.h>
>> #include <video/vga.h>
>> @@ -143,6 +144,9 @@ static struct attribute *efifb_attrs[] =3D {
>> };
>> ATTRIBUTE_GROUPS(efifb);
>>=20
>> +static bool pci_bar_found;    /* did we find a BAR matching the efifb ba=
se? */
>> +static bool pci_bar_disabled;    /* was it disabled? */
>> +
>> static int efifb_probe(struct platform_device *dev)
>> {
>>    struct fb_info *info;
>> @@ -152,7 +156,7 @@ static int efifb_probe(struct platform_device *dev)
>>    unsigned int size_total;
>>    char *option =3D NULL;
>>=20
>> -    if (screen_info.orig_video_isVGA !=3D VIDEO_TYPE_EFI)
>> +    if (screen_info.orig_video_isVGA !=3D VIDEO_TYPE_EFI || pci_bar_disa=
bled)
>>        return -ENODEV;
>>=20
>>    if (fb_get_options("efifb", &option))
>> @@ -360,3 +364,55 @@ static struct platform_driver efifb_driver =3D {
>> };
>>=20
>> builtin_platform_driver(efifb_driver);
>> +
>> +static void claim_efifb_bar(struct pci_dev *dev, int idx)
>> +{
>> +    u16 word;
>> +
>> +    pci_bar_found =3D true;
>> +
>> +    if (pci_claim_resource(dev, idx)) {
>=20
> I would not do that. If claiming the resource succeeds, it will become
> immutable (ie it becomes part of the resource tree), if it is your FB
> fine if it isn't this will mess things up since a) you won't be able to
> claim the PCI resources for the real FB and b) you won't be able to
> reallocate the PCI resources for the device we *think* is the FB but it
> actually isn't (unless we force a realloc).
>=20
> So, I would carry out the check below first, if the device is enabled
> we should flag its resource IORESOURCE_PCI_FIXED otherwise just do
> nothing and let PCI core (through arch specific realloc policy) handle
> it.
>=20

Well, it turned out that this does not actually work: the BAR is not reassig=
ned, but the same range ends up being given to another device in some cases.=



> Side note: I *think* it should be fine to claim a resource twice
> (ie in x86 the FB would have been claimed already by core x86 code),
> just thought it is worth checking.
>=20
> Lorenzo
>=20
>> +        pci_bar_disabled =3D true;
>> +        dev_err(&dev->dev, "BAR %d: failed to claim efifb BAR\n", idx);
>> +        return;
>> +    }
>> +
>> +    pci_read_config_word(dev, PCI_COMMAND, &word);
>> +    if (!(word & PCI_COMMAND_MEMORY)) {
>> +        pci_bar_disabled =3D true;
>> +        dev_err(&dev->dev,
>> +            "BAR %d: efifb BAR has memory decoding disabled!\n", idx);
>> +        return;
>> +    }
>> +
>> +    dev_info(&dev->dev, "BAR %d: claimed for efifb\n", idx);
>> +}
>> +
>> +static void efifb_fixup_resources(struct pci_dev *dev)
>> +{
>> +    u64 base =3D screen_info.lfb_base;
>> +    u64 size =3D screen_info.lfb_size;
>> +    int i;
>> +
>> +    if (pci_bar_found || screen_info.orig_video_isVGA !=3D VIDEO_TYPE_EFI=
)
>> +        return;
>> +
>> +    if (screen_info.capabilities & VIDEO_CAPABILITY_64BIT_BASE)
>> +        base |=3D (u64)screen_info.ext_lfb_base << 32;
>> +
>> +    if (!base)
>> +        return;
>> +
>> +    for (i =3D 0; i < PCI_STD_RESOURCE_END; i++) {
>> +        struct resource *res =3D &dev->resource[i];
>> +
>> +        if (!(res->flags & IORESOURCE_MEM))
>> +            continue;
>> +
>> +        if (res->start <=3D base && res->end >=3D base + size - 1) {
>> +            claim_efifb_bar(dev, i);
>> +            break;
>> +        }
>> +    }
>> +}
>> +DECLARE_PCI_FIXUP_HEADER(PCI_ANY_ID, PCI_ANY_ID, efifb_fixup_resources);=

>> --=20
>> 2.7.4
>>=20
