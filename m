From: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 1/3] Documentation: arm: add UEFI support documentation
Date: Tue, 10 Dec 2013 10:29:34 -0800
Message-ID: <CAFECyb93r5QGWRYDQxzWJ-xtptWBAEiQtAx=woLC5x+3WhbNqQ@mail.gmail.com>
References: <1385656883-4420-1-git-send-email-leif.lindholm@linaro.org>
	<CAHCPf3s_SXYXLRwvn7tzqTCQ-gB=emRMK_dXkEmw_HWigiD7Mw@mail.gmail.com>
	<20131210123035.D1586C40A27@trevor.secretlab.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20131210123035.D1586C40A27-WNowdnHR2B42iJbIjFUEsiwD8/FfD2ys@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Grant Likely <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Matt Sealey <neko-HhXTZounMxbZATc7fWT8Dg@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Patch Tracking <patches-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linaro-uefi <linaro-uefi-cunTk1MwBs8s++Sfvej+rw@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Rob Landley <rob-VoJi6FS/r0vR7s880joybQ@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Tue, Dec 10, 2013 at 4:30 AM, Grant Likely <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
> On Fri, 6 Dec 2013 11:20:45 -0600, Matt Sealey <neko-HhXTZounMxbZATc7fWT8Dg@public.gmane.org> wrote:
>> On Wed, Dec 4, 2013 at 4:44 PM, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org> wrote:
>> > On Wed, Dec 04, 2013 at 03:06:47PM -0600, Matt Sealey wrote:
>> Grant suggested I should propose some patches; sure, if I'm not otherwise busy.
>>
>> Maybe the Linaro guys can recommend a platform (real or emulated) that
>> would be best to test it on with the available UEFI?
>
> Roy Franz (cc'd) has got UEFI running under QEMU. A few modifications
> were required to both stock UEFI and QEMU. I'm not sure what the status
> of mainlining those patches is. I think there are still a few things
> that Roy has to fix, but you should be able to get the current patches
> from him to get going.
>
> g.
>

Hi Grant and Matt,

I have put together a quick wiki page describing the current status,
with git trees for
UEFI and QEMU, and instructions for running the model.  I just whipped
this up now, so it
is pretty basic, but should have all the required information.

https://wiki.linaro.org/LEG/Engineering/Kernel/UEFI/VersatileExpress/QEMU

Please let me know if you have any questions.

Thanks,
Roy
