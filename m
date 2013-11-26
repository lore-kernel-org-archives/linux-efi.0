From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v4 05/12] efi: export more efi table variable to sysfs
Date: Tue, 26 Nov 2013 09:50:35 +0100
Message-ID: <20131126085035.GC20917@pd.tnic>
References: <1385445477-9665-1-git-send-email-dyoung@redhat.com>
 <1385445477-9665-6-git-send-email-dyoung@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1385445477-9665-6-git-send-email-dyoung@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Young <dyoung@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, x86@kernel.org, mjg59@srcf.ucam.org, hpa@zytor.com, James.Bottomley@HansenPartnership.com, vgoyal@redhat.com, ebiederm@xmission.com, horms@verge.net.au, kexec@lists.infradead.org, greg@kroah.com, matt@console-pimps.org, toshi.kani@hp.com
List-Id: linux-efi@vger.kernel.org

On Tue, Nov 26, 2013 at 01:57:50PM +0800, Dave Young wrote:
> diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
> index 2e2fbde..5d85956 100644
> --- a/drivers/firmware/efi/efi.c
> +++ b/drivers/firmware/efi/efi.c
> @@ -32,6 +32,9 @@ struct efi __read_mostly efi = {
>  	.hcdp       = EFI_INVALID_TABLE_ADDR,
>  	.uga        = EFI_INVALID_TABLE_ADDR,
>  	.uv_systab  = EFI_INVALID_TABLE_ADDR,
> +	.fw_vendor  = EFI_INVALID_TABLE_ADDR,
> +	.runtime    = EFI_INVALID_TABLE_ADDR,
> +	.config_table  = EFI_INVALID_TABLE_ADDR,

See what I mean with alignment?

Now this config_table thing sticks out and completely destroys the
balance in the universe.

:-)

>  };
>  EXPORT_SYMBOL(efi);
>  
> @@ -71,13 +74,54 @@ static ssize_t systab_show(struct kobject *kobj,
>  static struct kobj_attribute efi_attr_systab =
>  			__ATTR(systab, 0400, systab_show, NULL);
>  
> +static ssize_t fw_vendor_show(struct kobject *kobj,
> +				struct kobj_attribute *attr, char *buf)
> +{
> +	return sprintf(buf, "0x%lx\n", efi.fw_vendor);
> +}
> +
> +static ssize_t runtime_show(struct kobject *kobj,
> +				struct kobj_attribute *attr, char *buf)
> +{
> +	return sprintf(buf, "0x%lx\n", efi.runtime);
> +}
> +
> +static ssize_t config_table_show(struct kobject *kobj,
> +				struct kobj_attribute *attr, char *buf)
> +{
> +	return sprintf(buf, "0x%lx\n", efi.config_table);
> +}

Those are sooo similar, it's like the macro SHOW writes itself.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
