From: Bhupesh Sharma <bhsharma-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: arm64 crashkernel fails to boot on acpi-only machines due to ACPI
 regions being no longer mapped as NOMAP
Date: Tue, 9 Jan 2018 17:16:12 +0530
Message-ID: <CACi5LpNq0USxDDJ-c=zYdFpR6fQx59aHJN9Z1SRCsXG89OQsZg@mail.gmail.com>
References: <CACi5LpMUnUKxiALAHW9_PE2RYC8GNWLPGpdJ5ca53g=v3rNkfg@mail.gmail.com>
 <20171222083308.cy3vwlyhig22q5ee@fireball> <CACi5LpNF5i3Eo7nMLr_z9r4VVbXhDwSJCQoiOh-A_jB6hV0_2Q@mail.gmail.com>
 <20171225032500.GA8877@linaro.org> <CACi5LpMzYidDaC0_yfwgVOisH-FqcNViYj+Z54uKfUtHkJKKXA@mail.gmail.com>
 <20171226013217.GA2119@dhcp-128-65.nay.redhat.com> <20171226013517.GA2186@dhcp-128-65.nay.redhat.com>
 <20171226022807.GB8877@linaro.org> <CACi5LpNRtXh-j9Y9HwRatDZwRMr++-ZeaSnk62vD3btpxsVv7w@mail.gmail.com>
 <CACi5LpNeSNHoUcM9xOq0bjN_okaEUDbaz1qyuqAct7BSNLQqKQ@mail.gmail.com> <20180109030717.GA18820@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180109030717.GA18820-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: AKASHI Takahiro <takahiro.akashi-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Bhupesh Sharma <bhsharma-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Bhupesh SHARMA <bhupesh.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Tue, Jan 9, 2018 at 10:12 AM, AKASHI Takahiro
<takahiro.akashi-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
> Bhupesh,
>
> On Tue, Jan 09, 2018 at 01:30:07AM +0530, Bhupesh Sharma wrote:
>> Hello Akashi,
>>
>> On Tue, Dec 26, 2017 at 8:26 AM, Bhupesh Sharma <bhsharma-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>> > On Tue, Dec 26, 2017 at 7:58 AM, AKASHI Takahiro
>> > <takahiro.akashi-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
>> >> On Tue, Dec 26, 2017 at 09:35:17AM +0800, Dave Young wrote:
>> >>> [snip]
>> >>> > > > Well, we may be able to change pr_warn() to pr_warn_once() here, but
>> >>> > > > I hope that adding "numa=off" to kernel command line should also work.
>> >>> > >
>> >>> > > Hmm, adding "numa=off" to crashkernel bootargs works, and TBH it was
>> >>> > > my initial thought process as well, but I am not sure if this will
>> >>> > > cause any regressions on aarch64 systems which use crashdump feature.
>> >>> >
>> >>> > It should be fine since we use numa=off by default for all other arches
>> >>> > ie. x86, ppc64 and s390. Actually disabling numa in kdump kernel can save
>> >>> > mm component memory usage.
>> >>> >
>> >>>
>> >>> Forgot to say I means in RHEL and Fedora we use numa=off for kdump..
>> >>
>> >> Thank you for the clarification.
>> >> (It might be better to make numa off automatically if maxcpus == 0 (and 1?).)
>> >>
>> >
>> > Not sure if we can leave this to the distribution-specific kdump
>> > scripts (as the crashkernel boot can be held up for sufficient time
>> > and may appear stuck). The distribution scripts may be different (for
>> > e.g. ubuntu and RHEL/fedora) across distributions and may have
>> > different bootarg options.
>> >
>> > So how about considering a kernel fix only which doesn't require
>> > relying on changing the distribution-specific kdump scripts, as we
>> > should avoid introducing a regression while trying to fix a regression
>> > :)
>> >
>> > Just my 2 cents.
>> >
>>
>> Sorry for the delay but I was on holidays in the last week.
>>
>> Are you planning to send a patch to fix this issue or do you want me
>> to send a RFC version instead?
>
> I should have submitted my own patch before my new year holidays,
> but I will do so as soon as possible.

Thanks for the confirmation.
I will look forward to the patches and give them a go on the arm64
boards available with me.

Regards,
Bhupesh

>
>> i think this is a blocking issue for aarch64 kdump support on newer
>> kernels (v4.14) and we are already hearing about this issue from other
>> users as well, so it would be great to get this fixed now that we have
>> root-caused the issue and found a possible way around.
>>
>> Regards,
>> Bhupesh
