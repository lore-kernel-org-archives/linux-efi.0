From: Andy Shevchenko <andy.shevchenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 7/7] efi/capsule: Add support for Quark security header
Date: Fri, 24 Mar 2017 22:36:25 +0200
Message-ID: <CAHp75VdswATVLGmc9PgeLHVJaj_KoA2s_O-uaxOaUSmLXfe0xA@mail.gmail.com>
References: <cover.1490376860.git.jan.kiszka@siemens.com> <cab06bccee2d89d7bd0e0408d9541bfd262212a9.1490376860.git.jan.kiszka@siemens.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cab06bccee2d89d7bd0e0408d9541bfd262212a9.1490376860.git.jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jan Kiszka <jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Bryan O'Donoghue <pure.logic-SyKdqv6vbfZdzvEItQ6vdLNAH6kLmebB@public.gmane.org>, Hock Leong Kweh <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Sascha Weisenberger <sascha.weisenberger-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, Mar 24, 2017 at 7:34 PM, Jan Kiszka <jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org> wrote:
> The firmware for Quark X102x prepends a security header to the capsule
> which is needed to support the mandatory secure boot on this processor.
> The header can be detected by checking for the "_CSH" signature and -
> to avoid any GUID conflict - validating its size field to contain the
> expected value. Then we need to look for the EFI header right after the
> security header and pass the image displacement in cap_info.
>
> To be minimal invasive and maximal safe, the quirk version of
> efi_capsule_identify_image is only effective on Quark processors.


> +static const struct x86_cpu_id quark_ids[] = {
> +       { X86_VENDOR_INTEL, 5, 9 },     /* Intel Quark X1000 */
> +       { }
> +};
> +
> +int efi_capsule_identify_image(struct efi_capsule_info *cap_info, void *header,
> +                              size_t hdr_bytes)
> +{
> +       struct quark_security_header *csh = header;
> +

> +       if (!x86_match_cpu(quark_ids))
> +               return __efi_capsule_identify_image(cap_info, header,
> +                                                   hdr_bytes);

I would slightly differently, i.e. introduce a helper
capsule_identify_image_qrk() and do here something like


#define ICPU(family, model, data) ...

static const struct x86_cpu_id efi_capsule_quirk_ids[] = {
      ICPU(5, 9, qrk_capsule_identify_image),
      {}
};

...
       id = x86_match_cpu(efi_capsule_quirk_ids);
       if (id)
          return ((...)id->data)(...);

       return __efi_capsule_identify_image(cap_info, header,  hdr_bytes);

> +
> +       /* Only process data block that is larger than the security header */
> +       if (hdr_bytes < sizeof(struct quark_security_header))
> +               return 0;
> +
> +       if (csh->csh_signature != QUARK_CSH_SIGNATURE ||
> +           csh->headersize != QUARK_SECURITY_HEADER_SIZE)
> +               return __efi_capsule_identify_image(cap_info, header,
> +                                                   hdr_bytes);
> +
> +       /* Only process data block if EFI header is included */
> +       if (hdr_bytes < QUARK_SECURITY_HEADER_SIZE +
> +                       sizeof(efi_capsule_header_t))
> +               return 0;
> +
> +       pr_debug("Quark security header detected\n");
> +
> +       if (csh->rsvd_next_header != 0) {
> +               pr_err("multiple Quark security headers not supported\n");
> +               return -EINVAL;
> +       }
> +
> +       cap_info->total_size = csh->modulesize;
> +       cap_info->efi_hdr_displacement = csh->headersize;
> +
> +       return 1;
> +}


-- 
With Best Regards,
Andy Shevchenko
