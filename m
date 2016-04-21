From: Octavian Purdila <octavian.purdila@intel.com>
Subject: Re: [RFC PATCH v2 05/10] i2c: add support for ACPI reconfigure notifications
Date: Fri, 22 Apr 2016 00:41:07 +0300
Message-ID: <CAE1zotJsvw_oM61Kheo_g-C5ZcRaT-4AxOb6U0QbgXC06M0wTg@mail.gmail.com>
References: <1461105548-20618-1-git-send-email-octavian.purdila@intel.com>
	<1461105548-20618-6-git-send-email-octavian.purdila@intel.com>
	<CAHp75VdCX65bftG+5D2r1N0nwYV0tSDf6+ZgJYPgxu9AV54eKA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <CAHp75VdCX65bftG+5D2r1N0nwYV0tSDf6+ZgJYPgxu9AV54eKA@mail.gmail.com>
Sender: linux-acpi-owner@vger.kernel.org
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, Mark Brown <broonie@kernel.org>, Wolfram Sang <wsa@the-dreams.de>, Joel Becker <jlbec@evilplan.org>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, linux-efi@vger.kernel.org, linux-i2c <linux-i2c@vger.kernel.org>, linux-spi <linux-spi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Irina Tirdea <irina.tirdea@intel.com>
List-Id: linux-efi@vger.kernel.org

On Fri, Apr 22, 2016 at 12:27 AM, Andy Shevchenko
<andy.shevchenko@gmail.com> wrote:
>

Hi Andy and thanks for the review!

> On Wed, Apr 20, 2016 at 1:39 AM, Octavian Purdila
> <octavian.purdila@intel.com> wrote:
> > This patch adds supports for I2C device enumeration and removal via
> > ACPI reconfiguration notifications that are send as a result of an
> > ACPI table load or unload operation.
>
> >
> >         acpi_dev_free_resource_list(&resource_list);
> >
> > +       strlcpy(info->type, dev_name(&adev->dev), sizeof(info->type));
>
> strscpy() ?

That is the original code, I just moved it in a different function.
Its probably best if we use a separate patch for this, but is it worth
it?

>
> > +static int acpi_i2c_match_adapter(struct device *dev, void *data)
> > +{
> > +       struct i2c_adapter *adapter = i2c_verify_adapter(dev);
> > +
> > +       if (!adapter)
> > +               return 0;
> > +
>
> > +       return ACPI_HANDLE(dev) == (acpi_handle)data;
>
> What is suppose to return? Hidden bool to integer conversion is not
> best option I suppose.
>

per bus_find_device() :

 * The callback should return 0 if the device doesn't match and
non-zero
 * if it does.  If the callback returns non-zero, this function will
 * return to the caller and not iterate over any more devices.
 */
struct device *bus_find_device(struct bus_type *bus,
                               struct device *start, void *data,
                               int (*match)(struct device *dev, void *data))


> > +}
> > +
> > +static int acpi_i2c_match_device(struct device *dev, void *data)
> > +{
> > +       return ACPI_COMPANION(dev) == data;
>
> Ditto.
>
> > +}
>
> --
> With Best Regards,
> Andy Shevchenko
