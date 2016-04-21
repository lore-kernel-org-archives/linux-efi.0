From: Andy Shevchenko <andy.shevchenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH v2 05/10] i2c: add support for ACPI reconfigure notifications
Date: Fri, 22 Apr 2016 00:27:14 +0300
Message-ID: <CAHp75VdCX65bftG+5D2r1N0nwYV0tSDf6+ZgJYPgxu9AV54eKA@mail.gmail.com>
References: <1461105548-20618-1-git-send-email-octavian.purdila@intel.com>
	<1461105548-20618-6-git-send-email-octavian.purdila@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-spi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1461105548-20618-6-git-send-email-octavian.purdila-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-spi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Octavian Purdila <octavian.purdila-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "Rafael J. Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>, Len Brown <lenb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Wolfram Sang <wsa-z923LK4zBo2bacvFa/9K2g@public.gmane.org>, Joel Becker <jlbec-aKy9MeLSZ9dg9hUCZPvPmw@public.gmane.org>, "linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-i2c-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-spi <linux-spi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, irina.tirdea-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Wed, Apr 20, 2016 at 1:39 AM, Octavian Purdila
<octavian.purdila-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> This patch adds supports for I2C device enumeration and removal via
> ACPI reconfiguration notifications that are send as a result of an
> ACPI table load or unload operation.

>
>         acpi_dev_free_resource_list(&resource_list);
>
> +       strlcpy(info->type, dev_name(&adev->dev), sizeof(info->type));

strscpy() ?

> +static int acpi_i2c_match_adapter(struct device *dev, void *data)
> +{
> +       struct i2c_adapter *adapter = i2c_verify_adapter(dev);
> +
> +       if (!adapter)
> +               return 0;
> +

> +       return ACPI_HANDLE(dev) == (acpi_handle)data;

What is suppose to return? Hidden bool to integer conversion is not
best option I suppose.

> +}
> +
> +static int acpi_i2c_match_device(struct device *dev, void *data)
> +{
> +       return ACPI_COMPANION(dev) == data;

Ditto.

> +}

-- 
With Best Regards,
Andy Shevchenko
--
To unsubscribe from this list: send the line "unsubscribe linux-spi" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
