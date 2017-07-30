From: Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: Re: [PATCH v1 3/6] staging: unisys: Switch to use new generic UUID API
Date: Sun, 30 Jul 2017 20:26:48 +0300
Message-ID: <CAHp75Vf+Us5n2_u94sVGs7xuvfF-qoaG4tvmixvqRARo68TT7w@mail.gmail.com>
References: <20170719182857.73693-1-andriy.shevchenko@linux.intel.com>
 <20170719182857.73693-4-andriy.shevchenko@linux.intel.com>
 <1501063301.29303.247.camel@linux.intel.com> <20170730153224.GA31755@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170730153224.GA31755@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, devel@linuxdriverproject.org, sparmaintainer@unisys.com, devel@driverdev.osuosl.org, "open list:TI WILINK WIRELES..." <linux-wireless@vger.kernel.org>, linux-watchdog@vger.kernel.org, linux-efi <linux-efi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Lukas Wunner <lukas@wunner.de>
List-Id: linux-efi@vger.kernel.org

On Sun, Jul 30, 2017 at 6:32 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Wed, Jul 26, 2017 at 01:01:41PM +0300, Andy Shevchenko wrote:
>> On Wed, 2017-07-19 at 21:28 +0300, Andy Shevchenko wrote:
>> > There are new types and helpers that are supposed to be used in new
>> > code.
>> >
>> > As a preparation to get rid of legacy types and API functions do
>> > the conversion here.
>> >
>> > While here, re-indent couple of lines to increase readability.
>>
>> This looks like no user space UUID API is involved, can be routed via
>> either tree (uuid or staging).
>>
>> Anyone to comment?
>
> Doesn't apply to the staging tree at all :(

No surprises, it was cooked against uuid tree in the first place.
If you agree to take it through staging tree I will prepare a rebased version.
Does it sound good?


-- 
With Best Regards,
Andy Shevchenko
