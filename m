From: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH 5/6] efi: Disable secure boot if shim is in insecure mode
 [ver #2]
Date: Wed, 23 Nov 2016 13:38:17 +0000
Message-ID: <20161123133817.GF24624@leverpostej>
References: <147986054870.13790.8640536414645705863.stgit@warthog.procyon.org.uk>
 <147986058486.13790.8455439853105793460.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <147986058486.13790.8455439853105793460.stgit-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Josh Boyer <jwboyer-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org>, keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Wed, Nov 23, 2016 at 12:23:04AM +0000, David Howells wrote:
> +	/* See if a user has put shim into insecure mode.  If so, and if the
> +	 * variable doesn't have the runtime attribute set, we might as well
> +	 * honor that.
> +	 */
> +	size = sizeof(moksbstate);
> +	status = get_efi_var(shim_MokSBState_name, &shim_guid,
> +			     &attr, &size, &moksbstate);
> +
> +	/* If it fails, we don't care why.  Default to secure */
> +	if (status != EFI_SUCCESS)
> +		return 1;

I was going to suggest branching to out_efi_err, but I see that wouldn't
work when EFI_NOT_FOUND was returned. It might be worth noting
explicitly that we can't use that, so as to avoid 'obvious' cleanup in
future.

Thanks,
Mark.
