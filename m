From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [GIT PULL 0/2] EFI fixes for v4.11
Date: Wed, 5 Apr 2017 11:14:06 +0100
Message-ID: <CAKv+Gu_VaKNDmaWc2Gqpg1JB6pBthCVUOGEsONb8sj2Uos7qcg@mail.gmail.com>
References: <CGME20170405100833epcas1p4b5076679dc4f8644fa789b421a66f953@epcas1p4.samsung.com>
 <20170404152744.26687-1-ard.biesheuvel@linaro.org> <5013223.ea6UCckGV3@amdc3058>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5013223.ea6UCckGV3@amdc3058>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bartlomiej Zolnierkiewicz <b.zolnierkie-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Lorenzo Pieralisi <lorenzo.pieralisi-5wv7dgnIgG8@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Eugene Cohen <eugene-VXdhtT5mjnY@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 5 April 2017 at 11:08, Bartlomiej Zolnierkiewicz
<b.zolnierkie-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org> wrote:
>
> Hi,
>
> On Tuesday, April 04, 2017 04:27:42 PM Ard Biesheuvel wrote:
>> Hello all,
>>
>> Please pull these fixes for EFI framebuffer support on ARM/arm64 systems=
.
>>
>> The following changes since commit 822f5845f710e57d7e2df1fd1ee00d6e19d33=
4fe:
>>
>>   efi/esrt: Cleanup bad memory map log messages (2017-03-17 18:53:12 +00=
00)
>>
>> are available in the git repository at:
>>
>>   git://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git tags/efi-urg=
ent
>>
>> for you to fetch changes up to e73c2811538bd36ec1340d01bafdc080af31914e:
>>
>>   efifb: Avoid reconfiguration of BAR that covers the framebuffer (2017-=
04-04 15:56:43 +0100)
>>
>> ----------------------------------------------------------------
>> Two fixes related to the EFI framebuffer driver:
>> - Ignore Graphics Output Protocol (GOP) implementations that are marked =
as
>>   BLT-only -- the framebuffer base address is invalid in this case, and =
the
>>   Blt() method is not accessible to the kernel.
>> - If the GOP framebuffer base address coincides with a memory BAR of a P=
CI
>>   device that has memory decoding enabled, claim the memory resource so =
that
>>   the PCI core will not attempt to move it later on.
>>
>> ----------------------------------------------------------------
>> Ard Biesheuvel (1):
>>       efifb: Avoid reconfiguration of BAR that covers the framebuffer
>
> This patch breaks build if PCI support is not enabled:
>
> drivers/video/fbdev/efifb.c: In function =E2=80=98claim_efifb_bar=E2=80=
=99:
> drivers/video/fbdev/efifb.c:386:2: error: implicit declaration of functio=
n =E2=80=98pci_claim_resource=E2=80=99 [-Werror=3Dimplicit-function-declara=
tion]
>
> (x86 ifdefs are not enough, the patch should also check for PCI support)
>
> Also please cc: linux-fbdev mailing list & me on fbdev related patches.
>

Thanks for the report. The patch was tested successfully on an
impressive list of configurations by kbuild test robot, but
apparently, none of those has PCI disabled.

Ingo, since you have queued this already, how would you like to
proceed? I don't think we need anything beyond

diff --git a/drivers/video/fbdev/efifb.c b/drivers/video/fbdev/efifb.c
index 758960b6aec9..b827a8113e26 100644
--- a/drivers/video/fbdev/efifb.c
+++ b/drivers/video/fbdev/efifb.c
@@ -364,7 +364,7 @@ static struct platform_driver efifb_driver =3D {

 builtin_platform_driver(efifb_driver);

-#ifndef CONFIG_X86
+#if defined(CONFIG_PCI) && !defined(CONFIG_X86)

 static bool pci_bar_found;     /* did we find a BAR matching the efifb bas=
e? */


--=20
Ard.
