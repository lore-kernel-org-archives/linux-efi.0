From: "Fleming, Matt" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: efi: be more paranoid about available space when creating variables
Date: Sat, 23 Mar 2013 20:24:18 +0000
Message-ID: <CAL01qpvaP7_YWS+vhjTskvisCyjxg-28WBAjSQftrSmnCphwdw@mail.gmail.com>
References: <1364004995.3728.76.camel@deadeye.wl.decadent.org.uk>
	<1364010441.3728.82.camel@deadeye.wl.decadent.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1364010441.3728.82.camel-nDn/Rdv9kqW9Jme8/bJn5UCKIB8iOfG2tUK59QYPAWc@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>
Cc: Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 23/03/13 03:47, Ben Hutchings wrote:
> On Sat, 2013-03-23 at 02:16 +0000, Ben Hutchings wrote:
>> Commit 68d929862e29 'efi: be more paranoid about available space when
>> creating variables' caused a regression on my EFI-booting desktop.
>> (I'm actually testing on 3.2.41 with several more fixes backported, but
>> this shouldn't matter.)
>>
>> The meaningful DMI IDs for this system are:
>>
>> /sys/devices/virtual/dmi/id/bios_date:08/22/2012
>> /sys/devices/virtual/dmi/id/bios_vendor:American Megatrends Inc.
>> /sys/devices/virtual/dmi/id/bios_version:4003
>> /sys/devices/virtual/dmi/id/board_name:P8Z68-V LX
>> /sys/devices/virtual/dmi/id/board_vendor:ASUSTeK Computer INC.
>>
> So it looks like we may actually have to disable all the size checks on
> this firmware!

Well, crap. I guess this was bound to be an issue sooner or later.
Thanks for doing the investigative work.

Looks like we're going to have to go down the road of blacklisting
known bad machines after all. I was reluctant to push for that
originally as the result of missing a machine from the blacklist might
result in said machine becoming bricked, but we've now got patches in
place to turn off the pstore efivars code, and I suspect that most
distros indeed do that.
