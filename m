From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [GIT PULL 0/2] EFI fixes for v4.11
Date: Wed, 05 Apr 2017 12:08:31 +0200
Message-ID: <5013223.ea6UCckGV3@amdc3058>
References: <20170404152744.26687-1-ard.biesheuvel@linaro.org>
 <CGME20170405100833epcas1p4b5076679dc4f8644fa789b421a66f953@epcas1p4.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <20170404152744.26687-1-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, leif.lindholm@linaro.org, lorenzo.pieralisi@arm.com, linux-kernel@vger.kernel.org, Eugene Cohen <eugene@hp.com>, Matt Fleming <matt@codeblueprint.co.uk>, Peter Jones <pjones@redhat.com>
List-Id: linux-efi@vger.kernel.org


Hi,

On Tuesday, April 04, 2017 04:27:42 PM Ard Biesheuvel wrote:
> Hello all,
> 
> Please pull these fixes for EFI framebuffer support on ARM/arm64 systems.
> 
> The following changes since commit 822f5845f710e57d7e2df1fd1ee00d6e19d334fe:
> 
>   efi/esrt: Cleanup bad memory map log messages (2017-03-17 18:53:12 +0000)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git tags/efi-urgent
> 
> for you to fetch changes up to e73c2811538bd36ec1340d01bafdc080af31914e:
> 
>   efifb: Avoid reconfiguration of BAR that covers the framebuffer (2017-04-04 15:56:43 +0100)
> 
> ----------------------------------------------------------------
> Two fixes related to the EFI framebuffer driver:
> - Ignore Graphics Output Protocol (GOP) implementations that are marked as
>   BLT-only -- the framebuffer base address is invalid in this case, and the
>   Blt() method is not accessible to the kernel.
> - If the GOP framebuffer base address coincides with a memory BAR of a PCI
>   device that has memory decoding enabled, claim the memory resource so that
>   the PCI core will not attempt to move it later on.
> 
> ----------------------------------------------------------------
> Ard Biesheuvel (1):
>       efifb: Avoid reconfiguration of BAR that covers the framebuffer

This patch breaks build if PCI support is not enabled:

drivers/video/fbdev/efifb.c: In function ‘claim_efifb_bar’:
drivers/video/fbdev/efifb.c:386:2: error: implicit declaration of function ‘pci_claim_resource’ [-Werror=implicit-function-declaration]

(x86 ifdefs are not enough, the patch should also check for PCI support)

Also please cc: linux-fbdev mailing list & me on fbdev related patches.

> Cohen, Eugene (1):
>       efi/libstub: Skip GOP with PIXEL_BLT_ONLY format
> 
>  drivers/firmware/efi/libstub/gop.c |  6 ++--
>  drivers/video/fbdev/efifb.c        | 66 +++++++++++++++++++++++++++++++++++++-
>  2 files changed, 69 insertions(+), 3 deletions(-)

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics
