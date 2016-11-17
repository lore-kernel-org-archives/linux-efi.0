From: Petko Manolov <petkan@mip-labs.com>
Subject: Re: [PATCH 4/9] KEYS: Allow unrestricted boot-time addition of keys
 to secondary keyring
Date: Thu, 17 Nov 2016 08:41:00 +0200
Message-ID: <20161117064100.hmjmfw42ytm526yh@p310>
References: <147931984418.16460.6639993676886095760.stgit@warthog.procyon.org.uk>
 <147931987366.16460.12891767069975068260.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <147931987366.16460.12891767069975068260.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: keyrings@vger.kernel.org, matthew.garrett@nebula.com, linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, Mimi Zohar <zohar@linux.vnet.ibm.com>
List-Id: linux-efi@vger.kernel.org

On 16-11-16 18:11:13, David Howells wrote:
> Allow keys to be added to the system secondary certificates keyring during 
> kernel initialisation in an unrestricted fashion.  Such keys are implicitly 
> trusted and don't have their trust chains checked on link.

Well, I for one do not explicitly trust these keys.  I may even want to 
completely remove or replace them.

> This allows keys in the UEFI database to be added in secure boot mode for the 
> purposes of module signing.

The key import should not be automatic, it should be optional.  Same applies to 
the validation process.


		Petko


> Signed-off-by: David Howells <dhowells@redhat.com>
> ---
> 
>  certs/internal.h       |   18 ++++++++++++++++++
>  certs/system_keyring.c |   33 +++++++++++++++++++++++++++++++++
>  2 files changed, 51 insertions(+)
>  create mode 100644 certs/internal.h
> 
> diff --git a/certs/internal.h b/certs/internal.h
> new file mode 100644
> index 000000000000..5dcbefb0c23a
> --- /dev/null
> +++ b/certs/internal.h
> @@ -0,0 +1,18 @@
> +/* Internal definitions
> + *
> + * Copyright (C) 2016 Red Hat, Inc. All Rights Reserved.
> + * Written by David Howells (dhowells@redhat.com)
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public Licence
> + * as published by the Free Software Foundation; either version
> + * 2 of the Licence, or (at your option) any later version.
> + */
> +
> +/*
> + * system_keyring.c
> + */
> +#ifdef CONFIG_SECONDARY_TRUSTED_KEYRING
> +extern void __init add_trusted_secondary_key(const char *source,
> +					     const void *data, size_t len);
> +#endif
> diff --git a/certs/system_keyring.c b/certs/system_keyring.c
> index 50979d6dcecd..dfddcf6e6c88 100644
> --- a/certs/system_keyring.c
> +++ b/certs/system_keyring.c
> @@ -17,6 +17,7 @@
>  #include <keys/asymmetric-type.h>
>  #include <keys/system_keyring.h>
>  #include <crypto/pkcs7.h>
> +#include "internal.h"
>  
>  static struct key *builtin_trusted_keys;
>  #ifdef CONFIG_SECONDARY_TRUSTED_KEYRING
> @@ -242,3 +243,35 @@ int verify_pkcs7_signature(const void *data, size_t len,
>  EXPORT_SYMBOL_GPL(verify_pkcs7_signature);
>  
>  #endif /* CONFIG_SYSTEM_DATA_VERIFICATION */
> +
> +#ifdef CONFIG_SECONDARY_TRUSTED_KEYRING
> +/**
> + * add_trusted_secondary_key - Add to secondary keyring with no validation
> + * @source: Source of key
> + * @data: The blob holding the key
> + * @len: The length of the data blob
> + *
> + * Add a key to the secondary keyring without checking its trust chain.  This
> + * is available only during kernel initialisation.
> + */
> +void __init add_trusted_secondary_key(const char *source,
> +				      const void *data, size_t len)
> +{
> +	key_ref_t key;
> +
> +	key = key_create_or_update(make_key_ref(secondary_trusted_keys, 1),
> +				   "asymmetric",
> +				   NULL, data, len,
> +				   (KEY_POS_ALL & ~KEY_POS_SETATTR) |
> +				   KEY_USR_VIEW,
> +				   KEY_ALLOC_NOT_IN_QUOTA |
> +				   KEY_ALLOC_BYPASS_RESTRICTION);
> +
> +	if (IS_ERR(key))
> +		pr_err("Problem loading %s X.509 certificate (%ld)\n",
> +		       source, PTR_ERR(key));
> +	else
> +		pr_notice("Loaded %s cert '%s' linked to secondary sys keyring\n",
> +			  source, key_ref_to_ptr(key)->description);
> +}
> +#endif /* CONFIG_SECONDARY_TRUSTED_KEYRING */
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
