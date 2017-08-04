From: Baoquan He <bhe@redhat.com>
Subject: Re: [PATCH v8 0/2] x86/boot/KASLR: Restrict kernel to be randomized
 in mirror regions
Date: Fri, 4 Aug 2017 18:43:33 +0800
Message-ID: <20170804104333.GB29975@x1>
References: <1501831607-6776-1-git-send-email-bhe@redhat.com>
 <20170804075228.GA29975@x1>
 <20170804092241.GH1874@x1>
 <20170804095911.GD32462@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170804095911.GD32462@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: Chao Fan <fanc.fnst@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, matt@codeblueprint.co.uk, keescook@chromium.org, tglx@linutronix.de, hpa@zytor.com, izumi.taku@jp.fujitsu.com, thgarnie@google.com, n-horiguchi@ah.jp.nec.com, ard.biesheuvel@linaro.org, linux-efi@vger.kernel.org, x86@kernel.org
List-Id: linux-efi@vger.kernel.org

On 08/04/17 at 05:59pm, Chao Fan wrote:
> On Fri, Aug 04, 2017 at 05:22:41PM +0800, Baoquan He wrote:
> >On 08/04/17 at 03:52pm, Baoquan He wrote:
> >> Sorry, NACK this series, there's error to hang system. Before I just
> >> halt system intentionally with error() to check the efi memmap printing,
> >> didn't notice this. Checking the cause.
> >
> >I rebuilt the code or change the one of the replacement back, hang never
> >seen again. Not sure if I copied the wrong kernel or any other mistakes.
> >Have got a hardware system with efi enabled to try again, see if
> >anything wrong will happen. It's really weird. And Chao also is helping
> >to try on his side.
> 
> Hi Bao,
> 
> After testing for 10 times, no problem happened.
> Maybe you did something wrong in the first time.

Thanks, Chao. I tried several times on a machine with efi enabled, no
problem found.

Sorry, guys, so it's a false alarm.

> >
> >> 
> >> On 08/04/17 at 03:26pm, Baoquan He wrote:
> >> > Patch 1/2 is newly added to add efi_memdesc_ptr helper to wrap the
> >> > open code which gets the start of efi memmap descriptor and also
> >> > explain why it need be done like that, Ingo suggested it. 
> >> > 
> >> > And also replace several places of the open code with efi_memdesc_ptr
> >> > helper.
> >> > 
> >> > And also use efi_memdesc_ptr in process_efi_entries() which handle efi
> >> > mirror issue during KASLR.
> >> > 
> >> > 
> >> > Change:
> >> > v7->v8:
> >> >     Add efi_memdesc_ptr helper to wrap the open code which gets the
> >> >     start of map descriptor according to Ingo's suggestion.
> >> > 
> >> > v6->v7:
> >> >   Ingo pointed out several incorrect line break issues and unclear
> >> >   description of patch log. Correct them and rewrite patch log.
> >> > 
> >> >   And also rewrite the EFI warning message that if EFI memmap is above
> >> >   4G in 32bit system since 32bit system can not handle data above 4G at
> >> >   kernel decompression stage. This is suggested by Ingo too.
> >> > 
> >> > v5->v6:
> >> >   Code style issue fix according to Kees's comment.
> >> > 
> >> >   This is based on tip/x86/boot, patch 1,2,3/4 in v5 post has
> >> >   been put into tip/x86/boot now.
> >> > 
> >> > 
> >> > 
> >> > Baoquan He (2):
> >> >   efi: Introduce efi_memdesc_ptr to get pointer to memmap descriptor
> >> >   x86/boot/KASLR: Restrict kernel to be randomized in mirror regions
> >> > 
> >> >  arch/x86/boot/compressed/eboot.c               |  2 +-
> >> >  arch/x86/boot/compressed/kaslr.c               | 68 +++++++++++++++++++++++++-
> >> >  drivers/firmware/efi/libstub/efi-stub-helper.c |  4 +-
> >> >  include/linux/efi.h                            | 19 +++++++
> >> >  4 files changed, 88 insertions(+), 5 deletions(-)
> >> > 
> >> > -- 
> >> > 2.5.5
> >> > 
> >
> >
> 
> 
