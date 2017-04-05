From: Bartlomiej Zolnierkiewicz <b.zolnierkie-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [GIT PULL 0/2] EFI fixes for v4.11
Date: Wed, 05 Apr 2017 12:44:17 +0200
Message-ID: <6222690.3kM8OKJmde@amdc3058>
References: <CGME20170405100833epcas1p4b5076679dc4f8644fa789b421a66f953@epcas1p4.samsung.com>
 <5013223.ea6UCckGV3@amdc3058>
 <CAKv+Gu_VaKNDmaWc2Gqpg1JB6pBthCVUOGEsONb8sj2Uos7qcg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <CAKv+Gu_VaKNDmaWc2Gqpg1JB6pBthCVUOGEsONb8sj2Uos7qcg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Lorenzo Pieralisi <lorenzo.pieralisi-5wv7dgnIgG8@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Eugene Cohen <eugene-VXdhtT5mjnY@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wednesday, April 05, 2017 11:14:06 AM Ard Biesheuvel wrote:
> On 5 April 2017 at 11:08, Bartlomiej Zolnierkiewicz
> <b.zolnierkie-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org> wrote:
> >
> > Hi,
> >
> > On Tuesday, April 04, 2017 04:27:42 PM Ard Biesheuvel wrote:
> >> Hello all,
> >>
> >> Please pull these fixes for EFI framebuffer support on ARM/arm64 systems.
> >>
> >> The following changes since commit 822f5845f710e57d7e2df1fd1ee00d6e19d334fe:
> >>
> >>   efi/esrt: Cleanup bad memory map log messages (2017-03-17 18:53:12 +0000)
> >>
> >> are available in the git repository at:
> >>
> >>   git://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git tags/efi-urgent
> >>
> >> for you to fetch changes up to e73c2811538bd36ec1340d01bafdc080af31914e:
> >>
> >>   efifb: Avoid reconfiguration of BAR that covers the framebuffer (2017-04-04 15:56:43 +0100)
> >>
> >> ----------------------------------------------------------------
> >> Two fixes related to the EFI framebuffer driver:
> >> - Ignore Graphics Output Protocol (GOP) implementations that are marked as
> >>   BLT-only -- the framebuffer base address is invalid in this case, and the
> >>   Blt() method is not accessible to the kernel.
> >> - If the GOP framebuffer base address coincides with a memory BAR of a PCI
> >>   device that has memory decoding enabled, claim the memory resource so that
> >>   the PCI core will not attempt to move it later on.
> >>
> >> ----------------------------------------------------------------
> >> Ard Biesheuvel (1):
> >>       efifb: Avoid reconfiguration of BAR that covers the framebuffer
> >
> > This patch breaks build if PCI support is not enabled:
> >
> > drivers/video/fbdev/efifb.c: In function ‘claim_efifb_bar’:
> > drivers/video/fbdev/efifb.c:386:2: error: implicit declaration of function ‘pci_claim_resource’ [-Werror=implicit-function-declaration]
> >
> > (x86 ifdefs are not enough, the patch should also check for PCI support)
> >
> > Also please cc: linux-fbdev mailing list & me on fbdev related patches.
> >
> 
> Thanks for the report. The patch was tested successfully on an
> impressive list of configurations by kbuild test robot, but
> apparently, none of those has PCI disabled.

Well, it has been found by looking at the patch itself and since
none of defconfigs contains such configuration currently the issue
is rather minor one.

[ Also sorry for the late report but this is the first time I see
  these patches.  They were never posted to linux-fbdev or me. ]

> Ingo, since you have queued this already, how would you like to
> proceed? I don't think we need anything beyond

I see that Ingo fixed the patch himself so it is all fine now,
thanks!

> diff --git a/drivers/video/fbdev/efifb.c b/drivers/video/fbdev/efifb.c
> index 758960b6aec9..b827a8113e26 100644
> --- a/drivers/video/fbdev/efifb.c
> +++ b/drivers/video/fbdev/efifb.c
> @@ -364,7 +364,7 @@ static struct platform_driver efifb_driver = {
> 
>  builtin_platform_driver(efifb_driver);
> 
> -#ifndef CONFIG_X86
> +#if defined(CONFIG_PCI) && !defined(CONFIG_X86)
> 
>  static bool pci_bar_found;     /* did we find a BAR matching the efifb base? */

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics
