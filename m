From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH 1/5] MODSIGN: do not load mok when secure boot disabled
Date: Tue, 13 Mar 2018 17:25:30 +0000
Message-ID: <CAKv+Gu_1+8AOy4Fj_yD6iEJQvjw3hA4KW11agU+ozujxMNQHVA@mail.gmail.com>
References: <20180313103803.13388-1-jlee@suse.com> <20180313103803.13388-2-jlee@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180313103803.13388-2-jlee@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
Cc: David Howells <dhowells@redhat.com>, linux-fs@vger.kernel.org, linux-efi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "Lee, Chun-Yi" <jlee@suse.com>, Josh Boyer <jwboyer@fedoraproject.org>, James Bottomley <James.Bottomley@hansenpartnership.com>
List-Id: linux-efi@vger.kernel.org

On 13 March 2018 at 10:37, Lee, Chun-Yi <joeyli.kernel@gmail.com> wrote:
> The mok can not be trusted when the secure boot is disabled. Which
> means that the kernel embedded certificate is the only trusted key.
>
> Due to db/dbx are authenticated variables, they needs manufacturer's
> KEK for update. So db/dbx are secure when secureboot disabled.
>

Did you consider the case where secure boot is not implemented? I
don't think db/dbx are secure in that case, although perhaps it may
not matter (a bit more information on the purpose of these patches and
all the shim lingo etc would be appreciated)

> Cc: David Howells <dhowells@redhat.com>
> Cc: Josh Boyer <jwboyer@fedoraproject.org>
> Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
> Signed-off-by: "Lee, Chun-Yi" <jlee@suse.com>
> ---
>  certs/load_uefi.c | 26 +++++++++++++++-----------
>  1 file changed, 15 insertions(+), 11 deletions(-)
>
> diff --git a/certs/load_uefi.c b/certs/load_uefi.c
> index 3d88459..d6de4d0 100644
> --- a/certs/load_uefi.c
> +++ b/certs/load_uefi.c
> @@ -164,17 +164,6 @@ static int __init load_uefi_certs(void)
>                 }
>         }
>
> -       mok = get_cert_list(L"MokListRT", &mok_var, &moksize);

Which tree does this apply to? My tree doesn't have get_cert_list()

> -       if (!mok) {
> -               pr_info("MODSIGN: Couldn't get UEFI MokListRT\n");
> -       } else {
> -               rc = parse_efi_signature_list("UEFI:MokListRT",
> -                                             mok, moksize, get_handler_for_db);
> -               if (rc)
> -                       pr_err("Couldn't parse MokListRT signatures: %d\n", rc);
> -               kfree(mok);
> -       }
> -
>         dbx = get_cert_list(L"dbx", &secure_var, &dbxsize);
>         if (!dbx) {
>                 pr_info("MODSIGN: Couldn't get UEFI dbx list\n");
> @@ -187,6 +176,21 @@ static int __init load_uefi_certs(void)
>                 kfree(dbx);
>         }
>
> +       /* the MOK can not be trusted when secure boot is disabled */
> +       if (!efi_enabled(EFI_SECURE_BOOT))
> +               return 0;
> +
> +       mok = get_cert_list(L"MokListRT", &mok_var, &moksize);
> +       if (!mok) {
> +               pr_info("MODSIGN: Couldn't get UEFI MokListRT\n");
> +       } else {
> +               rc = parse_efi_signature_list("UEFI:MokListRT",
> +                                             mok, moksize, get_handler_for_db);
> +               if (rc)
> +                       pr_err("Couldn't parse MokListRT signatures: %d\n", rc);
> +               kfree(mok);
> +       }
> +
>         return rc;
>  }
>  late_initcall(load_uefi_certs);
> --
> 2.10.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-efi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
