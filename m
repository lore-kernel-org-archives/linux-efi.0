From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 01/11] x86/efi: Allocate e820 buffer before calling
 efi_exit_boot_service
Date: Fri, 30 Nov 2018 09:36:01 +0100
Message-ID: <20181130083601.GA97998@gmail.com>
References: <20181129171230.18699-1-ard.biesheuvel@linaro.org>
 <20181129171230.18699-2-ard.biesheuvel@linaro.org>
 <20181130072952.GA16084@gmail.com>
 <CAKv+Gu8OMvnxb-n+ubYETRNhm79_H1RkGp+-7N1KF6Hgg3cbCQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu8OMvnxb-n+ubYETRNhm79_H1RkGp+-7N1KF6Hgg3cbCQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-efi <linux-efi@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@kernel.org>, Arend Van Spriel <arend.vanspriel@broadcom.com>, Bhupesh Sharma <bhsharma@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@intel.com>, Eric Snowberg <eric.snowberg@oracle.com>, Hans de Goede <hdegoede@redhat.com>, Joe Perches <joe@perches.com>, Jon Hunter <jonathanh@nvidia.com>, Julien Thierry <julien.thierry@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Nathan Chancellor <natechancellor@gmail.com>, Peter Zijlstra <peterz@infradead.org>, "Prakhya, Sai Praneeth" <sai.praneeth.prakhya@intel.com>, Sedat Dilek <sedat.dilek@gmail.com>, YiFei Zhu <zhuyifei1999>
List-Id: linux-efi@vger.kernel.org


* Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:

> On Fri, 30 Nov 2018 at 08:29, Ingo Molnar <mingo@kernel.org> wrote:
> >
> >
> > * Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> >
> > > From: Eric Snowberg <eric.snowberg@oracle.com>
> > >
> > > Commit d64934019f6c ("x86/efi: Use efi_exit_boot_services()")
> > > introduced a regression on systems with large memory maps
> > > causing them to hang on boot. The first "goto get_map" that was removed
> > > from exit_boot insured there was enough room for the memory map when
> > > efi_call_early(exit_boot_services) was called. This happens when
> > > (nr_desc > ARRAY_SIZE(params->e820_table).
> > >
> > > Chain of events:
> > >   exit_boot()
> > >     efi_exit_boot_services()
> > >       efi_get_memory_map <- at this point the mm can't grow over 8 desc
> > >       priv_func()
> > >         exit_boot_func()
> > >           allocate_e820ext() <- new mm grows over 8 desc from e820 alloc
> > >       efi_call_early(exit_boot_services) <- mm key doesn't match so retry
> > >       efi_call_early(get_memory_map) <- not enough room for new mm
> > >       system hangs
> > >
> > > This patch allocates the e820 buffer before calling efi_exit_boot_services
> > > and fixes the regression.
> > >
> > > Signed-off-by: Eric Snowberg <eric.snowberg@oracle.com>
> > > Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> > > ---
> > >  arch/x86/boot/compressed/eboot.c | 65 ++++++++++++++++++++------------
> > >  1 file changed, 41 insertions(+), 24 deletions(-)
> >
> > Any objections against marking this for -stable and filing it in
> > efi/urgent? Boot hangs are show-stopper bugs, so distributions would want
> > to backport this fix anyway.
> >
> 
> No objections per se, but this is the kind of patch that might go the
> other way as well, so I would prefer to give it some wider coverage at
> first, given how quickly patches are taken into -stable.
> 
> I can make a note of it and send it to Greg halfway into the next -rc cycle.

So there should be at least one week of testing because I just sent the 
EFI fixes to Linus, plus -stable gets at least a week of testing as well.

Also, in practice, -next and early -rc cycles get only the fraction of 
testing that later -rc's or -stable gets. So if we want this in -stable 
we might as well do it now - or the real testing gets delayed by ~3 
months in practice. That's also the pattern encouraged by Linus: if it's 
a fix that matters then it should be upstreamed with the usual regression 
fixes.

Anyway, your call!

Thanks,

	Ingo
