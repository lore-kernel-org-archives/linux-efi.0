From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH 00/11] EFI runtime services virtual mapping
Date: Mon, 14 Oct 2013 14:04:51 +0100
Message-ID: <20131014130451.GA10834@console-pimps.org>
References: <1379602494-26684-1-git-send-email-bp@alien8.de>
 <20131008164551.GB16793@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20131008164551.GB16793-fF5Pk5pvG8Y@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, fwts-devel-nLRlyDuq1AZFpShjVBNYrg@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Tue, 08 Oct, at 06:45:51PM, Borislav Petkov wrote:
> @@ -141,34 +151,75 @@ static long efi_runtime_ioctl(struct file *file, unsigned int cmd,
>  			return -EFAULT;
>  
>  		convert_from_guid(&vendor, &vendor_guid);
> -		status = efi.get_variable(pgetvariable->VariableName, &vendor,
> -					&attr, &datasize, pgetvariable->Data);
> +
> +		vardata = kmalloc(datasize, GFP_KERNEL);
> +		if (!vardata)
> +			return -ENOMEM;
> +
> +		namelen = ucs2_strsize(pgetvariable->VariableName, 1024);
> +
> +		varname = kmalloc(namelen, GFP_KERNEL);
> +		if (!varname)
> +			return -ENOMEM;
> +
> +		if (copy_from_user(varname, pgetvariable->VariableName, namelen))
> +			return -EFAULT;
> +

		varname = kmalloc(namelen + 1, GFP_KERNEL);
		varname[namelen] = 0;

Note that ucs2_strsize() doesn't count the terminating NUL.

-- 
Matt Fleming, Intel Open Source Technology Center
