From: "Rafael J. Wysocki" <rafael@kernel.org>
Subject: Re: [PATCH v2] device property: Get rid of union aliasing
Date: Mon, 14 May 2018 22:44:52 +0200
Message-ID: <CAJZ5v0iD3-gmOsRtH6H+EHz-wXyW_xJV+U_vbM94oVdz1=gkPg@mail.gmail.com>
References: <20180508131547.44366-1-andriy.shevchenko@linux.intel.com>
 <20180514121817.GA27869@wunner.de> <f2109d06a0755dd2d9dc807c1e13dd2c19903905.camel@linux.intel.com>
 <20180514154017.GA6734@wunner.de> <ddd9eae5cf848df9c25a49001845a3d80e429a6f.camel@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <ddd9eae5cf848df9c25a49001845a3d80e429a6f.camel@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Lukas Wunner <lukas@wunner.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-efi@vger.kernel.org, Sakari Ailus <sakari.ailus@linux.intel.com>, Mika Westerberg <mika.westerberg@linux.intel.com>, "Rafael J . Wysocki" <rjw@rjwysocki.net>, ACPI Devel Maling List <linux-acpi@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On Mon, May 14, 2018 at 6:13 PM, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> On Mon, 2018-05-14 at 17:40 +0200, Lukas Wunner wrote:
>> On Mon, May 14, 2018 at 03:48:09PM +0300, Andy Shevchenko wrote:
>> > On Mon, 2018-05-14 at 14:18 +0200, Lukas Wunner wrote:
>> > > On Tue, May 08, 2018 at 04:15:47PM +0300, Andy Shevchenko wrote:
>> > > > --- a/drivers/firmware/efi/apple-properties.c
>> > > > +++ b/drivers/firmware/efi/apple-properties.c
>> > > > @@ -13,6 +13,9 @@
>> > > > + * FIXME: The approach is still based on union aliasing and
>> > > > should be
>> > > > + * replaced by a proper resource provider.
>> > >
>> > > Why?  All Apple EFI properties are either boolean or u8 arrays.
>> > > You've correctly changed this file to always supply u8 arrays,
>> > > so I don't see where union aliasing is happening here?
>> >
>> > Okay, for now I can see only Thunderbolt user of these properties
>> > (is it
>> > correct?) in upstream which uses u8 arrays indeed.
>>
>> That is correct, thunderbolt.ko is so far the only user.
>>
>>
>> > Though the implementation is quite fragile in this sense, because it
>> > doesn't discourage people to use device_property_read_string() in
>> > case
>> > when it's indeed a string (I saw these kind of properties in the
>> > very
>> > dump you posted on your GH page).
>>
>> Well if that is your concern then you need to prevent functions which
>> retrieve properties to use the wrong type.
>>
>> E.g. to prevent retrieval of the u8 array as string, you'd have to
>> amend drivers/base/property.c:pset_prop_read_string_array() to
>> check the type of the property found and return -EINVAL if it's not
>> string.
>
> I think it's doable. I will hack a new version later this week.

So I'm assuming that I should disregard this patch and wait for an
update, right?

Thanks,
Rafael
