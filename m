From: Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: Re: [PATCH v2] device property: Get rid of union aliasing
Date: Mon, 14 May 2018 23:55:32 +0300
Message-ID: <CAHp75VfzFSZpCw1tsiWcLL9GHDvCMb076eXXJELTF1bPmJwEAw@mail.gmail.com>
References: <20180508131547.44366-1-andriy.shevchenko@linux.intel.com>
 <20180514121817.GA27869@wunner.de> <f2109d06a0755dd2d9dc807c1e13dd2c19903905.camel@linux.intel.com>
 <20180514154017.GA6734@wunner.de> <ddd9eae5cf848df9c25a49001845a3d80e429a6f.camel@linux.intel.com>
 <CAJZ5v0iD3-gmOsRtH6H+EHz-wXyW_xJV+U_vbM94oVdz1=gkPg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAJZ5v0iD3-gmOsRtH6H+EHz-wXyW_xJV+U_vbM94oVdz1=gkPg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Lukas Wunner <lukas@wunner.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-efi <linux-efi@vger.kernel.org>, Sakari Ailus <sakari.ailus@linux.intel.com>, Mika Westerberg <mika.westerberg@linux.intel.com>, "Rafael J . Wysocki" <rjw@rjwysocki.net>, ACPI Devel Maling List <linux-acpi@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On Mon, May 14, 2018 at 11:44 PM, Rafael J. Wysocki <rafael@kernel.org> wrote:
> On Mon, May 14, 2018 at 6:13 PM, Andy Shevchenko
> <andriy.shevchenko@linux.intel.com> wrote:
>> On Mon, 2018-05-14 at 17:40 +0200, Lukas Wunner wrote:
>>> On Mon, May 14, 2018 at 03:48:09PM +0300, Andy Shevchenko wrote:

>>> Well if that is your concern then you need to prevent functions which
>>> retrieve properties to use the wrong type.
>>>
>>> E.g. to prevent retrieval of the u8 array as string, you'd have to
>>> amend drivers/base/property.c:pset_prop_read_string_array() to
>>> check the type of the property found and return -EINVAL if it's not
>>> string.
>>
>> I think it's doable. I will hack a new version later this week.
>
> So I'm assuming that I should disregard this patch and wait for an
> update, right?

Right.

-- 
With Best Regards,
Andy Shevchenko
