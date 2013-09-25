From: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 10/18] Do proper conversion from UTF-16 to UTF-8
Date: Wed, 25 Sep 2013 07:15:23 -0700
Message-ID: <CAFECyb8putN0Gy2OzpWYcjGSHmA0_aXx42=ToppXBJcffpxS0w@mail.gmail.com>
References: <1379889942-3135-1-git-send-email-roy.franz@linaro.org>
	<1379889942-3135-11-git-send-email-roy.franz@linaro.org>
	<e69e8c38-b195-4797-8ae2-65d69ed9d7aa@email.android.com>
	<CAFECyb_8hqLFajMUfwctVee8e8UvErmu4jmbPguWaeMc-MZuNA@mail.gmail.com>
	<523F8A3C.7010209@zytor.com>
	<20130925120149.GH21381@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130925120149.GH21381-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Grant Likely <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, Sep 25, 2013 at 5:01 AM, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org> wrote:
> On Sun, 22 Sep, at 05:24:28PM, H. Peter Anvin wrote:
>> On 09/22/2013 04:07 PM, Roy Franz wrote:
>> > On Sun, Sep 22, 2013 at 3:54 PM, H. Peter Anvin <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org> wrote:
>> >> Sorry this version is broken and doesn't even compile due to remaining options_size references.
>> >
>> > I compiled and tested this series on both x86_64 (using OVMF) and on
>> > the ARM simulator.  I just doubled checked
>> > my kernel .config to verify this was not being omitted and I'm pretty
>> > sure this doesn't have any compilation problems.
>> > I did make a few changes to get the untested version you sent out to
>> > compile, but they all seemed to be straightforward typo type fixes.
>> > I'll gladly address any defects in this patch, but I don't see an
>> > compilation problems.
>> >
>>
>> Ah yes, I see now... you fixed up the compile problem but did so
>> incorrectly.
>
> Folks, I'm gonna drop this patch for now. Feel free to resend it once
> everyone's happy with it. There's plenty of time to get this patch
> applied, it just doesn't make sense to hold up the rest of the series.

I'll get an updated (and independent) version out in the next couple days that
addresses HPA's feedback.

Thanks,
Roy
>
> --
> Matt Fleming, Intel Open Source Technology Center
