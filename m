From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH] efi: cper: avoid using get_seconds()
Date: Mon, 18 Jun 2018 17:50:46 +0200
Message-ID: <CAKv+Gu9OD6s24Aq1bLBr-yq_tn6wPR0TAkddO+VTwM7jR76dOQ@mail.gmail.com>
References: <20180618141811.3353245-1-arnd@arndb.de> <CAKv+Gu-r_+b_tCXeZeE6=EN3=1N98rheODOwV_4mpb9GMzdqrQ@mail.gmail.com>
 <CAK8P3a0dP+zvucn=_um1zRgBYQCskrhqa2KNSDtnpSu199baWw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAK8P3a0dP+zvucn=_um1zRgBYQCskrhqa2KNSDtnpSu199baWw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: y2038 Mailman List <y2038@lists.linaro.org>, Tyler Baicar <tbaicar@codeaurora.org>, Will Deacon <will.deacon@arm.com>, Ingo Molnar <mingo@kernel.org>, Borislav Petkov <bp@suse.de>, Yazen Ghannam <yazen.ghannam@amd.com>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, gengdongjiu <gengdongjiu@huawei.com>, linux-efi <linux-efi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On 18 June 2018 at 17:49, Arnd Bergmann <arnd@arndb.de> wrote:
> On Mon, Jun 18, 2018 at 5:47 PM, Ard Biesheuvel
> <ard.biesheuvel@linaro.org> wrote:
>> On 18 June 2018 at 16:17, Arnd Bergmann <arnd@arndb.de> wrote:
>
>>> -               atomic64_set(&seq, ((u64)get_seconds()) << 32);
>>> +       if (!atomic64_read(&seq)) {
>>> +               time64_t time = ktime_get_real_seconds();
>>> +
>>> +               /*
>>> +                * This code is unlikely to still be needed in year 2106,
>>> +                * but just in case, let's use a few more bits for timestamps
>>> +                * after y2038 to be sure they keep increasing monotonically
>>> +                * for the next few hundred years...
>>> +                */
>>> +               if (time < 0x80000000)
>>> +                       atomic64_set(&seq, (ktime_get_real_seconds()) << 32);
>>> +               else
>>> +                       atomic64_set(&seq, 0x8000000000000000ull |
>>> +                                          ktime_get_real_seconds() << 24);
>>> +       }
>>
>> Given that these values are never decoded and interpreted as
>> timestamps, can't we simply switch to the second flavour immediately?
>
> I considered that, but the downside would be that all future filenames would
> come before all past file names.

Won't we have that same problem in 2038?

> I don't know if the order is important at
> all, but the current implementation at least looks like it's intended to keep
> all file names strictly sorted across boots.
>
>          Arnd
