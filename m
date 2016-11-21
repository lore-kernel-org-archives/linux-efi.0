From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 9/9] MODSIGN: Allow the "db" UEFI variable to be suppressed
Date: Mon, 21 Nov 2016 16:18:56 +0000
Message-ID: <CAKv+Gu96ihE7pHrCCeCpy78man-r821b3Vs4Tn_RsYyzY4HV2Q@mail.gmail.com>
References: <147931984418.16460.6639993676886095760.stgit@warthog.procyon.org.uk>
 <147931990959.16460.3038875071067540418.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <147931990959.16460.3038875071067540418.stgit-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-security-module <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Josh Boyer <jwboyer-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 16 November 2016 at 18:11, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> From: Josh Boyer <jwboyer-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org>
>
> If a user tells shim to not use the certs/hashes in the UEFI db variable
> for verification purposes, shim will set a UEFI variable called
> MokIgnoreDB.  Have the uefi import code look for this and ignore the db
> variable if it is found.
>

Similar concern as in the previous patch: it appears to me that you
can DoS a machine by setting MokIgnoreDB if, e.g., its modules are
signed against a cert that resides in db, and shim/mokmanager are not
being used.


> Signed-off-by: Josh Boyer <jwboyer-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org>
> Signed-off-by: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>
>  certs/load_uefi.c |   44 ++++++++++++++++++++++++++++++++++----------
>  1 file changed, 34 insertions(+), 10 deletions(-)
>
> diff --git a/certs/load_uefi.c b/certs/load_uefi.c
> index b44e464c3ff4..3d8845986019 100644
> --- a/certs/load_uefi.c
> +++ b/certs/load_uefi.c
> @@ -13,6 +13,26 @@ static __initdata efi_guid_t efi_cert_x509_sha256_guid = EFI_CERT_X509_SHA256_GU
>  static __initdata efi_guid_t efi_cert_sha256_guid = EFI_CERT_SHA256_GUID;
>
>  /*
> + * Look to see if a UEFI variable called MokIgnoreDB exists and return true if
> + * it does.
> + *
> + * This UEFI variable is set by the shim if a user tells the shim to not use
> + * the certs/hashes in the UEFI db variable for verification purposes.  If it
> + * is set, we should ignore the db variable also and the true return indicates
> + * this.
> + */
> +static __init bool uefi_check_ignore_db(void)
> +{
> +       efi_status_t status;
> +       unsigned int db = 0;
> +       unsigned long size = sizeof(db);
> +       efi_guid_t guid = EFI_SHIM_LOCK_GUID;
> +
> +       status = efi.get_variable(L"MokIgnoreDB", &guid, NULL, &size, &db);
> +       return status == EFI_SUCCESS;
> +}
> +
> +/*
>   * Get a certificate list blob from the named EFI variable.
>   */
>  static __init void *get_cert_list(efi_char16_t *name, efi_guid_t *guid,
> @@ -113,7 +133,9 @@ static __init efi_element_handler_t get_handler_for_dbx(const efi_guid_t *sig_ty
>  }
>
>  /*
> - * Load the certs contained in the UEFI databases
> + * Load the certs contained in the UEFI databases into the secondary trusted
> + * keyring and the UEFI blacklisted X.509 cert SHA256 hashes into the blacklist
> + * keyring.
>   */
>  static int __init load_uefi_certs(void)
>  {
> @@ -129,15 +151,17 @@ static int __init load_uefi_certs(void)
>         /* Get db, MokListRT, and dbx.  They might not exist, so it isn't
>          * an error if we can't get them.
>          */
> -       db = get_cert_list(L"db", &secure_var, &dbsize);
> -       if (!db) {
> -               pr_err("MODSIGN: Couldn't get UEFI db list\n");
> -       } else {
> -               rc = parse_efi_signature_list("UEFI:db",
> -                                             db, dbsize, get_handler_for_db);
> -               if (rc)
> -                       pr_err("Couldn't parse db signatures: %d\n", rc);
> -               kfree(db);
> +       if (!uefi_check_ignore_db()) {
> +               db = get_cert_list(L"db", &secure_var, &dbsize);
> +               if (!db) {
> +                       pr_err("MODSIGN: Couldn't get UEFI db list\n");
> +               } else {
> +                       rc = parse_efi_signature_list("UEFI:db",
> +                                                     db, dbsize, get_handler_for_db);
> +                       if (rc)
> +                               pr_err("Couldn't parse db signatures: %d\n", rc);
> +                       kfree(db);
> +               }
>         }
>
>         mok = get_cert_list(L"MokListRT", &mok_var, &moksize);
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-efi" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
