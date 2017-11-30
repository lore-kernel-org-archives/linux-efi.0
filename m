From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: [PATCH 1/4] MODSIGN: do not load mok when secure boot disabled
Date: Thu, 30 Nov 2017 07:51:03 -0800
Message-ID: <1512057063.3020.11.camel@HansenPartnership.com>
References: <20171129141139.20088-1-jlee@suse.com>
         <20171129141139.20088-2-jlee@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171129141139.20088-2-jlee-IBi9RG/b67k@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Lee, Chun-Yi" <joeyli.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-fs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Lee, Chun-Yi" <jlee-IBi9RG/b67k@public.gmane.org>, Josh Boyer <jwboyer-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, 2017-11-29 at 22:11 +0800, Lee, Chun-Yi wrote:
> The mok can not be trusted when the secure boot is disabled. Which
> means that the kernel embedded certificate is the only trusted key.
> 
> Due to db/dbx are authenticated variables, they needs manufacturer's
> KEK for update. So db/dbx are secure when secureboot disabled.
> 
> Cc: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> 
> Cc: Josh Boyer <jwboyer-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org>
> Signed-off-by: "Lee, Chun-Yi" <jlee-IBi9RG/b67k@public.gmane.org>
> ---
>  certs/load_uefi.c | 26 +++++++++++++++-----------
>  1 file changed, 15 insertions(+), 11 deletions(-)
> 
> diff --git a/certs/load_uefi.c b/certs/load_uefi.c
> index 3d88459..d6de4d0 100644
> --- a/certs/load_uefi.c
> +++ b/certs/load_uefi.c
> @@ -164,17 +164,6 @@ static int __init load_uefi_certs(void)
>  		}
>  	}
>  
> -	mok = get_cert_list(L"MokListRT", &mok_var, &moksize);
> -	if (!mok) {
> -		pr_info("MODSIGN: Couldn't get UEFI MokListRT\n");
> -	} else {
> -		rc = parse_efi_signature_list("UEFI:MokListRT",
> -					      mok, moksize,
> get_handler_for_db);
> -		if (rc)
> -			pr_err("Couldn't parse MokListRT signatures:
> %d\n", rc);
> -		kfree(mok);
> -	}
> -
>  	dbx = get_cert_list(L"dbx", &secure_var, &dbxsize);
>  	if (!dbx) {
>  		pr_info("MODSIGN: Couldn't get UEFI dbx list\n");
> @@ -187,6 +176,21 @@ static int __init load_uefi_certs(void)
>  		kfree(dbx);
>  	}
>  
> +	/* the MOK can not be trusted when secure boot is disabled
> */
> +	if (!efi_enabled(EFI_SECURE_BOOT))
> +		return 0;
> +
> +	mok = get_cert_list(L"MokListRT", &mok_var, &moksize);

This isn't really a criticism of your patch but the underlying: all of
the *RT variables, like MokListRT are insecure runtime variables and
can be tampered with.  I can agree that I can't see a tamper attack
between exit boot services and pulling this in to the key list, but I'd
feel a lot happier if the values were obtained directly from the BS
variable before exit boot services because that's means the path for
getting the values is directly within the secure envelope and doesn't
rely on passing via an insecure element.

James
