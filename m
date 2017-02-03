From: Dave Young <dyoung@redhat.com>
Subject: Re: [PATCH V2 0/4] efi/x86: move efi bgrt init code to early init
Date: Fri, 3 Feb 2017 15:12:09 +0800
Message-ID: <20170203071209.GA5623@dhcp-128-65.nay.redhat.com>
References: <20170116024554.461236678@redhat.com>
 <CAKv+Gu9C75q3J_8w68d+m=ZMcUh2MxU+c-1xvLwyY+mceSigbg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu9C75q3J_8w68d+m=ZMcUh2MxU+c-1xvLwyY+mceSigbg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Matt Fleming <matt@codeblueprint.co.uk>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, Nicolai Stange <nicstange@gmail.com>, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "hpa@zytor.com" <hpa@zytor.com>, Dan Williams <dan.j.williams@intel.com>, Mika =?iso-8859-1?Q?Penttil=E4?= <mika.penttila@nextfour.com>, Bhupesh Sharma <bhsharma@redhat.com>
List-Id: linux-efi@vger.kernel.org

On 01/27/17 at 05:03pm, Ard Biesheuvel wrote:
> On 16 January 2017 at 02:45, Dave Young <dyoung@redhat.com> wrote:
> > Hi,
> >
> > Here the the update of the series for moving bgrt init code to early init.
> >
> > Main changes is:
> > - Move the 1st patch to the last because it does not block the 2nd patch
> > any more with Peter's patch to prune invlid memmap entries:
> > https://git.kernel.org/cgit/linux/kernel/git/efi/efi.git/commit/?h=next&id=b2a91
> > a35445229
> > But it is still tood to have since efi_mem_reserve only cares about boot related
> > mem ranges.
> >
> > - Other comments about code itself, details please the the patches themselves.
> >
> >  arch/x86/include/asm/efi.h       |    1
> >  arch/x86/kernel/acpi/boot.c      |   12 +++++++
> >  arch/x86/platform/efi/efi-bgrt.c |   59 ++++++++++++++++-----------------------
> >  arch/x86/platform/efi/efi.c      |   26 +++--------------
> >  arch/x86/platform/efi/quirks.c   |    2 -
> >  drivers/acpi/bgrt.c              |   28 +++++++++++++-----
> >  drivers/firmware/efi/fake_mem.c  |    3 +
> >  drivers/firmware/efi/memmap.c    |   22 +++++++++++++-
> >  include/linux/efi-bgrt.h         |    7 +---
> >  include/linux/efi.h              |    5 +--
> >  init/main.c                      |    1
> >  11 files changed, 92 insertions(+), 74 deletions(-)
> >
> 
> Dave,
> 
> I have pushed these to efi/next: please double check if I did it
> correctly. I had some trouble applying these given that I rebased
> efi/next onto -rc4. However, the fact that you are not using standard
> git cover letters and emails doesn't help things, so could you
> *please* use standard git send-email to post to linux-efi in the
> future? Thanks.

Ard, apologize for late reply due to a one week holiday. I double-checked
the efi-next commits, I think they are correct. As for the email format
I use quilt to send the series so that the cover letter is not git
formatted. The patches are based on mainline linus tree, maybe this is
the reason of the trouble I will check if it is efi/next mergeble with
"git am" before sending out next time and will switch to git-send-email
if it does not work.

Thanks
Dave
