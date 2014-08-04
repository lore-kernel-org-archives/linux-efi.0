From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3] efi: implement mandatory locking for UEFI Runtime Services
Date: Mon, 4 Aug 2014 17:05:53 +0200
Message-ID: <CAKv+Gu_rcWtRtNPy5BHH7B4s0wDF3odN-=LD8YsnRCiDLGyFsA@mail.gmail.com>
References: <1405062556-14540-1-git-send-email-ard.biesheuvel@linaro.org>
	<20140804130011.GI15082@console-pimps.org>
	<CAKv+Gu-LQ9ahV5js0V5XgyRwUkrc3BOT9YoZj=mvwCEMQVXfow@mail.gmail.com>
	<20140804144957.GK15082@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140804144957.GK15082-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 4 August 2014 16:49, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org> wrote:
> On Mon, 04 Aug, at 03:13:28PM, Ard Biesheuvel wrote:
>>
>> Well, again, the spec allows it. But I am happy to remove it as it
>> does not affect ARM anyway
>
> Right, I understand why you added these now.
>
> My personal opinion is that we shouldn't do the NMI dancing unless
> absolutely necessary, e.g. because of corresponding kernel code paths.
> The fact that the spec allows it doesn't necessarily mean we should
> support it.
>

I agree. But for me, it is not obvious which functions can or cannot
be called from NMI context on x86, so I played it safe by just
covering everything that the spec allows, the idea being that if other
uses exists, they violate the spec anyway and handling NMI in those
cases may well break other stuff.

> But I do like the idea of documenting that the spec allows for things
> that we don't support, because that at least informs developers, when
> they come snooping around this file, that they've got some additional
> work to do if they want to call these functions from NMI context.
>
> So the table you included is cool, and I think some additional sentences
> along the lines of "... but we don't support calling all these functions
> from NMI context" would be a good addition.
>
> What do you think?
>

I think that makes sense. As I said, I don't have a strong preference
either way regarding the NMI handling, as it does not affect the
systems I am primarily concerned with (and it sounds like a big hack
anyway). What I /am/ concerned with is not getting code into the
kernel that turns out to be non-compliant a couple of months down the
road and having to fix it urgently then.

So other than GetVariable and SetVariable, or there any other services
that need the NMI treatment?

-- 
Ard.
