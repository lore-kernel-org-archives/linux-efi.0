From: Steve McIntyre <steve-nt0JYOx6u4DQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 5/5] efi: Make efivarfs entries immutable by default.
Date: Wed, 3 Feb 2016 15:00:48 +0000
Message-ID: <20160203150043.GB3319@einval.com>
References: <1454504567-2826-1-git-send-email-pjones@redhat.com>
 <1454504567-2826-5-git-send-email-pjones@redhat.com>
 <20160203141354.GH2597@codeblueprint.co.uk>
 <20160203141959.GA3319@einval.com>
 <20160203145005.GH10351@bivouac.eciton.net>
 <20160203145621.GI2597@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160203145621.GI2597-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Wed, Feb 03, 2016 at 02:56:21PM +0000, Matt Fleming wrote:
>On Wed, 03 Feb, at 02:50:05PM, Leif Lindholm wrote:
>> On Wed, Feb 03, 2016 at 02:20:04PM +0000, Steve McIntyre wrote:
>> > Although if we're at the stage of doing things this wat then is there
>> > much to be gained by having a filesystem interface in the first place?
>> 
>> These systems would be manually brickable regardless of what interface
>> you implemented, or under which operating system. Probably even from
>> the UEFI Shell.
>
>Right, and the old efivar sysfs code has a 1024-byte limit on the size
>of data, which is impractical.

*nod* - as discussed on irc. I hadn't realised that limitation.

-- 
Steve McIntyre, Cambridge, UK.                                steve-nt0JYOx6u4DQT0dZR+AlfA@public.gmane.org
"Since phone messaging became popular, the young generation has lost the
 ability to read or write anything that is longer than one hundred and sixty
 characters."  -- Ignatios Souvatzis
