From: Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: Re: [PATCH v1 4/6] vmbus: Switch to use new generic UUID API
Date: Thu, 20 Jul 2017 00:54:42 +0300
Message-ID: <CAHp75VdYnKGdyy=OwHoWw5Sch9t+E7gd1tqg0YfZjiicR-Q3Jw@mail.gmail.com>
References: <20170719182857.73693-1-andriy.shevchenko@linux.intel.com>
 <20170719182857.73693-5-andriy.shevchenko@linux.intel.com> <MWHPR21MB04791ED8A0F0F935176AE9B3CAA60@MWHPR21MB0479.namprd21.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <MWHPR21MB04791ED8A0F0F935176AE9B3CAA60@MWHPR21MB0479.namprd21.prod.outlook.com>
Sender: linux-acpi-owner@vger.kernel.org
To: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>, "sparmaintainer@unisys.com" <sparmaintainer@unisys.com>, "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>, "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>, "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Lukas Wunner <lukas@wunner.de>, KY Srinivasan <kys@microsoft.com>, Stephen Hemminger <sthemmin@microsoft.com>
List-Id: linux-efi@vger.kernel.org

On Wed, Jul 19, 2017 at 11:18 PM, Haiyang Zhang <haiyangz@microsoft.com> wrote:

>>  struct hv_fcopy_hdr {
>>       __u32 operation;
>> -     uuid_le service_id0; /* currently unused */
>> -     uuid_le service_id1; /* currently unused */
>> +     __u8 service_id0[16]; /* currently unused */
>> +     __u8 service_id1[16]; /* currently unused */
>>  } __attribute__((packed));
>
> Even user space may not have all guid_t operations, could you still
> put guid_t here for consistency?

I'm not sure how this code has been designed, though uuid_le followed
by guid_t are kernel internal types mistakenly put to UAPI in the
first place.

Consistency here is how we treat those types in user space, starting
from v4.13 uuid_be gone from that header. uuid_le is luckily will be
gone soon.

> This file is also used by our kernel
> mode code.

It will work still the same after this change.

-- 
With Best Regards,
Andy Shevchenko
