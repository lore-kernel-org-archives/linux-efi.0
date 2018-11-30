From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] efi/fdt: More cleanups
Date: Fri, 30 Nov 2018 10:48:49 +0100
Message-ID: <20181130094849.GA128917@gmail.com>
References: <20181129171230.18699-1-ard.biesheuvel@linaro.org>
 <20181129171230.18699-3-ard.biesheuvel@linaro.org>
 <20181130075658.GB16084@gmail.com>
 <CAKv+Gu8dLTwQp-FemEB0Bhzc3KEYDqpP_Pke3Q+miCh3h2xxbw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu8dLTwQp-FemEB0Bhzc3KEYDqpP_Pke3Q+miCh3h2xxbw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-efi <linux-efi@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@kernel.org>, Arend Van Spriel <arend.vanspriel@broadcom.com>, Bhupesh Sharma <bhsharma@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@intel.com>, Eric Snowberg <eric.snowberg@oracle.com>, Hans de Goede <hdegoede@redhat.com>, Joe Perches <joe@perches.com>, Jon Hunter <jonathanh@nvidia.com>, Julien Thierry <julien.thierry@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Nathan Chancellor <natechancellor@gmail.com>, Peter Zijlstra <peterz@infradead.org>, "Prakhya, Sai Praneeth" <sai.praneeth.prakhya@intel.com>, Sedat Dilek <sedat.dilek@gmail.com>, YiFei Zhu <zhuyifei1999>
List-Id: linux-efi@vger.kernel.org


* Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:

> On Fri, 30 Nov 2018 at 08:57, Ingo Molnar <mingo@kernel.org> wrote:
> >
> >
> > * Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> >
> > > From: Julien Thierry <julien.thierry@arm.com>
> > >
> > > Closing bracket seems to end a for statement when it is actually ending
> > > the contained if. Add some brackets to have clear delimitation of each
> > > scope.
> > >
> > > No functional change/fix, just fix the indentation.
> > >
> > > Signed-off-by: Julien Thierry <julien.thierry@arm.com>
> > > Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> > > ---
> > >  drivers/firmware/efi/libstub/fdt.c | 5 +++--
> > >  1 file changed, 3 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/drivers/firmware/efi/libstub/fdt.c b/drivers/firmware/efi/libstub/fdt.c
> > > index 0c0d2312f4a8..a3614f9b5f75 100644
> > > --- a/drivers/firmware/efi/libstub/fdt.c
> > > +++ b/drivers/firmware/efi/libstub/fdt.c
> > > @@ -376,7 +376,7 @@ void *get_fdt(efi_system_table_t *sys_table, unsigned long *fdt_size)
> > >       tables = (efi_config_table_t *) sys_table->tables;
> > >       fdt = NULL;
> > >
> > > -     for (i = 0; i < sys_table->nr_tables; i++)
> > > +     for (i = 0; i < sys_table->nr_tables; i++) {
> > >               if (efi_guidcmp(tables[i].guid, fdt_guid) == 0) {
> > >                       fdt = (void *) tables[i].table;
> > >                       if (fdt_check_header(fdt) != 0) {
> > > @@ -385,7 +385,8 @@ void *get_fdt(efi_system_table_t *sys_table, unsigned long *fdt_size)
> > >                       }
> > >                       *fdt_size = fdt_totalsize(fdt);
> > >                       break;
> > > -      }
> > > +             }
> > > +     }
> >
> > So if we are doing trivial cleanups, how about the patch below on top? It
> > cleans up this file for good. Only minimally build tested.
> >
> > Thanks,
> >
> >         Ingo
> >
> > ======================>
> > Subject: efi/fdt: More cleanups
> > From: Ingo Molnar <mingo@kernel.org>
> >
> > Apply a number of cleanups:
> >
> >  - Introduce fdt_setprop_*var() helper macros to simplify and shorten repetitive
> >    sequences - this also makes it less likely that the wrong variable size is
> >    passed in. This change makes a lot of the property-setting calls single-line
> >    and easier to read.
> >
> 
> This change looks fine to me, but scripts/dtc/libfdt/libfdt.h is part
> of an external library, so we'd either need to contribute it there or
> define the macro in a local header.

Whichever variant you prefer. If the external library has a different 
license that requires a separate permission then for that too feel free 
to add:

  Signed-off-by: Ingo Molnar <mingo@kernel.org>

Thanks,

	Ingo
