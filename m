From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 4/6] efi: Get the secure boot status
Date: Tue, 22 Nov 2016 14:47:27 +0000
Message-ID: <7199.1479826047@warthog.procyon.org.uk>
References: <20161122104401.GC1552@wunner.de> <20161117123731.GA11573@wunner.de> <147977472115.6360.13015228230799369019.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20161122104401.GC1552@wunner.de>
Content-ID: <7198.1479826047.1@warthog.procyon.org.uk>
Sender: owner-linux-security-module@vger.kernel.org
To: Lukas Wunner <lukas@wunner.de>
Cc: dhowells@redhat.com, Matthew Garrett <matthew.garrett@nebula.com>, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, keyrings@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

Lukas Wunner <lukas@wunner.de> wrote:

> > +int efi_get_secureboot(void)
> 
> It looks like you didn't compile-test this on ARM.

Yes.  What arm config would you suggest?

> > +#define f_getvar(...) efi_call_runtime(get_variable, __VA_ARGS__)
> > +
> > +	status = f_getvar((efi_char16_t *)sb_var_name, (efi_guid_t *)&var_guid,
> > +			  NULL, &size, &val);
>
> Just replace the f_getvar yourself instead of having cpp do it:
>
> 	status = efi_call_runtime(get_variable, (efi_char16_t *)sb_var_name,
> 				  (efi_guid_t *)&var_guid, NULL, &size, &val);

That makes it less clear.  I think something like this makes it much more
obvious:

    static efi_status_t get_efi_var(const efi_char16_t *name,
				const efi_guid_t *vendor,
				u32 *attr,
				unsigned long *data_size, void *data)
    {
	return efi_call_runtime(get_variable,
				(efi_char16_t *)name, (efi_guid_t *)vendor,
				attr, data_size, data);
    }

And then doing:

	status = get_efi_var(efi_SecureBoot_name, &efi_variable_guid,
			     NULL, &size, &val);

which the compiler will inline.

> The "out_efi_err" portion differs from the previous version of this
> patch.  Setting a __u8 to a negative value, is this really what you
> want?

Eh?  efi_get_secureboot() returns an int as before.  The out_efi_err: portions
are exactly the same:

> -static int efi_get_secureboot(...)	> +int efi_get_secureboot(...)
> ...					> ...
> -out_efi_err:				> +out_efi_err:
> -	switch (status) {		> +	switch (status) {
> -	case EFI_NOT_FOUND:		> +	case EFI_NOT_FOUND:
> -		return 0;		> +		return 0;
> -	case EFI_DEVICE_ERROR:		> +	case EFI_DEVICE_ERROR:
> -		return -EIO;		> +		return -EIO;
> -	case EFI_SECURITY_VIOLATION:	> +	case EFI_SECURITY_VIOLATION:
> -		return -EACCES;		> +		return -EACCES;
> -	default:			> +	default:
> -		return -EINVAL;		> +		return -EINVAL;
> -	}				> +	}
> -}

David
