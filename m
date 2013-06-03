From: Matt Fleming <matt@console-pimps.org>
Subject: Re: [PATCH] efi, pstore: Cocci spatch "memdup.spatch"
Date: Mon, 3 Jun 2013 11:17:56 +0100
Message-ID: <20130603101756.GH2004@console-pimps.org>
References: <1370079602.29224.8.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1370079602.29224.8.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Meyer <thomas@m3y3r.de>
Cc: cbouatmailru@gmail.com, ccross@android.com, keescook@chromium.org, tony.luck@intel.com, matt.fleming@intel.com, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On Sat, 01 Jun, at 11:40:02AM, Thomas Meyer wrote:
> 
> Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
> ---
> 
> diff -u -p a/drivers/firmware/efi/efi-pstore.c b/drivers/firmware/efi/efi-pstore.c
> --- a/drivers/firmware/efi/efi-pstore.c
> +++ b/drivers/firmware/efi/efi-pstore.c
> @@ -79,10 +79,9 @@ static int efi_pstore_read_func(struct e
>  			   &entry->var.DataSize, entry->var.Data);
>  	size = entry->var.DataSize;
>  
> -	*cb_data->buf = kmalloc(size, GFP_KERNEL);
> +	*cb_data->buf = kmemdup(entry->var.Data, size, GFP_KERNEL);
>  	if (*cb_data->buf == NULL)
>  		return -ENOMEM;
> -	memcpy(*cb_data->buf, entry->var.Data, size);
>  	return size;
>  }

Who wants to pick this one up? Tony?

-- 
Matt Fleming, Intel Open Source Technology Center
