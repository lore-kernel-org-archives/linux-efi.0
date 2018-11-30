From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH 01/11] x86/efi: Allocate e820 buffer before calling efi_exit_boot_service
Date: Fri, 30 Nov 2018 09:26:32 +0100
Message-ID: <CAKv+Gu8OMvnxb-n+ubYETRNhm79_H1RkGp+-7N1KF6Hgg3cbCQ@mail.gmail.com>
References: <20181129171230.18699-1-ard.biesheuvel@linaro.org>
 <20181129171230.18699-2-ard.biesheuvel@linaro.org> <20181130072952.GA16084@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181130072952.GA16084@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-efi <linux-efi@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@kernel.org>, Arend Van Spriel <arend.vanspriel@broadcom.com>, Bhupesh Sharma <bhsharma@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@intel.com>, Eric Snowberg <eric.snowberg@oracle.com>, Hans de Goede <hdegoede@redhat.com>, Joe Perches <joe@perches.com>, Jon Hunter <jonathanh@nvidia.com>, Julien Thierry <julien.thierry@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Nathan Chancellor <natechancellor@gmail.com>, Peter Zijlstra <peterz@infradead.org>, "Prakhya, Sai Praneeth" <sai.praneeth.prakhya@intel.com>, Sedat Dilek <sedat.dilek@gmail.com>, YiFei Zhu <zhuyifei1999>
List-Id: linux-efi@vger.kernel.org

On Fri, 30 Nov 2018 at 08:29, Ingo Molnar <mingo@kernel.org> wrote:
>
>
> * Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
>
> > From: Eric Snowberg <eric.snowberg@oracle.com>
> >
> > Commit d64934019f6c ("x86/efi: Use efi_exit_boot_services()")
> > introduced a regression on systems with large memory maps
> > causing them to hang on boot. The first "goto get_map" that was removed
> > from exit_boot insured there was enough room for the memory map when
> > efi_call_early(exit_boot_services) was called. This happens when
> > (nr_desc > ARRAY_SIZE(params->e820_table).
> >
> > Chain of events:
> >   exit_boot()
> >     efi_exit_boot_services()
> >       efi_get_memory_map <- at this point the mm can't grow over 8 desc
> >       priv_func()
> >         exit_boot_func()
> >           allocate_e820ext() <- new mm grows over 8 desc from e820 alloc
> >       efi_call_early(exit_boot_services) <- mm key doesn't match so retry
> >       efi_call_early(get_memory_map) <- not enough room for new mm
> >       system hangs
> >
> > This patch allocates the e820 buffer before calling efi_exit_boot_services
> > and fixes the regression.
> >
> > Signed-off-by: Eric Snowberg <eric.snowberg@oracle.com>
> > Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> > ---
> >  arch/x86/boot/compressed/eboot.c | 65 ++++++++++++++++++++------------
> >  1 file changed, 41 insertions(+), 24 deletions(-)
>
> Any objections against marking this for -stable and filing it in
> efi/urgent? Boot hangs are show-stopper bugs, so distributions would want
> to backport this fix anyway.
>

No objections per se, but this is the kind of patch that might go the
other way as well, so I would prefer to give it some wider coverage at
first, given how quickly patches are taken into -stable.

I can make a note of it and send it to Greg halfway into the next -rc cycle.

> > +     boot_map.map =          &map;
> > +     boot_map.map_size =     &map_size;
> > +     boot_map.desc_size =    &desc_size;
> > +     boot_map.desc_ver =     NULL;
> > +     boot_map.key_ptr =      NULL;
> > +     boot_map.buff_size =    &buff_size;
>
> I have changed this to the canonical style, which is also used elsewhere
> in the file:
>
> >       map.buff_size           = &buff_size;
> >       priv.boot_params        = boot_params;
> >       priv.efi                = &boot_params->efi_info;
> > -     priv.e820ext            = NULL;
> > -     priv.e820ext_size       = 0;
>
> I.e.:
>
> +       boot_map.map            = &map;
> +       boot_map.map_size       = &map_size;
> +       boot_map.desc_size      = &desc_size;
> +       boot_map.desc_ver       = NULL;
> +       boot_map.key_ptr        = NULL;
> +       boot_map.buff_size      = &buff_size;
> +
> +       status = efi_get_memory_map(sys_table, &boot_map);
>

Excellent, thanks.
