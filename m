From: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] efi: stub: use a pool allocation for the cmdline
Date: Fri, 10 Apr 2015 09:43:32 -0700
Message-ID: <CAFECyb9efREE=BU5RGSbzAGHqi5CkivUuTf=BRdq02GvFqJaOA@mail.gmail.com>
References: <1428670569-23089-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1428670569-23089-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Fri, Apr 10, 2015 at 5:56 AM, Ard Biesheuvel
<ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
> This changes the allocation for the ASCII-converted command
> line to use an ordinary memory pool rather than a separate
> page based allocation.
>
> Pool allocations are generally preferred over page based
> allocations due to the fact that they cause less fragmentation,
> but in the particular case of arm64, where page allocations are
> rounded up to 64 KB and where this allocation happens to be the
> only explicit low allocation, it results in the lowest 64 KB of
> memory to always be taken up by this particular allocation.
>
> So allocate from the EFI_LOADER_DATA pool instead.
>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
>  drivers/firmware/efi/libstub/efi-stub-helper.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/firmware/efi/libstub/efi-stub-helper.c b/drivers/firmware/efi/libstub/efi-stub-helper.c
> index f07d4a67fa76..c95a567ca132 100644
> --- a/drivers/firmware/efi/libstub/efi-stub-helper.c
> +++ b/drivers/firmware/efi/libstub/efi-stub-helper.c
> @@ -684,7 +684,8 @@ char *efi_convert_cmdline(efi_system_table_t *sys_table_arg,
>
>         options_bytes++;        /* NUL termination */
>
> -       status = efi_low_alloc(sys_table_arg, options_bytes, 0, &cmdline_addr);
> +       status = efi_call_early(allocate_pool, EFI_LOADER_DATA,
> +                               options_bytes, (void **)&cmdline_addr);
>         if (status != EFI_SUCCESS)
>                 return NULL;
>
> --
> 1.8.3.2
>

Hi Ard,

We can't do this without also changing the frees on the error paths in
arm-stub.c (line 289)
and eboot.c (line 1148) to be a pool free as well.
Also, for x86/x86_64 the address of the command line is put into a
boot_params structure,
which only has a __u32 field for the address of the command line, so
we could get an address
that won't fit if we use a pool allocation.
Looking at that bit of if it, I don't think we handle the case of no
32 bit addressable memory
existing at the time of the efi_low_alloc() for x86_64 systems, so if
a >32 bit address is returned here,
this won't be detected as a failure, and the cmdline address will be
the 32 bit truncated address.

I don't think that there is a way to control the address range
returned by pool allocations,
so I think we are stuck with the page based allocations if we have
address restrictions.

Roy
