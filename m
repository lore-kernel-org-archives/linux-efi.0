From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [GIT PULL 0/2] EFI urgent fixes
Date: Wed, 8 Jun 2016 09:24:36 +0200
Message-ID: <20160608072436.GA9706@gmail.com>
References: <1464690224-4503-1-git-send-email-matt@codeblueprint.co.uk>
 <20160606100253.GQ2658@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160606100253.GQ2658@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, Dan Williams <dan.j.williams@intel.com>, Dennis Chen <dennis.chen@arm.com>, "K. Y. Srinivasan" <kys@microsoft.com>, Mark Rutland <mark.rutland@arm.com>, Mark Salter <msalter@redhat.com>, Steve Capper <steve.capper@arm.com>, Steve McIntyre <steve@einval.com>, Steven Rostedt <rostedt@goodmis.org>, Vitaly Kuznetsov <vkuznets@redhat.com>, Will Deacon <will.deacon@arm.com>
List-Id: linux-efi@vger.kernel.org


* Matt Fleming <matt@codeblueprint.co.uk> wrote:

> On Tue, 31 May, at 11:23:42AM, Matt Fleming wrote:
> > Folks, please pull the following urgent patches which fix a boot crash
> > when using the "noefi" parameter and the debug output on arm.
> > 
> > The following changes since commit 1a695a905c18548062509178b98bc91e67510864:
> > 
> >   Linux 4.7-rc1 (2016-05-29 09:29:24 -0700)
> > 
> > are available in the git repository at:
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-urgent
> > 
> > for you to fetch changes up to 1f0cf3892caeab20a99c19f5523499be77b533cd:
> > 
> >   efi/arm: Fix the format of debug message from efi (2016-05-30 22:51:53 +0100)
> > 
> > ----------------------------------------------------------------
> >  * Fix crash when booting with the "noefi" kernel parameter, caused by
> >    recent changes to for_each_efi_memory_desc_in_map() - Vitaly Kuznetsov
> > 
> >  * Unscramble the debug output on arm when efi=debug and memblock=debug
> >    is passed on the kernel cmdline - Dennis Chen
> > 
> > ----------------------------------------------------------------
> > Dennis Chen (1):
> >       efi/arm: Fix the format of debug message from efi
> > 
> > Vitaly Kuznetsov (1):
> >       efi: Fix for_each_efi_memory_desc_in_map() for empty memmaps
> > 
> >  drivers/firmware/efi/arm-init.c | 14 ++++++--------
> >  include/linux/efi.h             |  2 +-
> >  2 files changed, 7 insertions(+), 9 deletions(-)
> 
> Ping? I see these patches queued up in tip/efi/urgent but they don't
> appear to be in Linus' tree yet.

Yeah, will get them to Linus later today.

Thanks,

	Ingo
