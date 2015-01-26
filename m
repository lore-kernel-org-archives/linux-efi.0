From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [RFD] efi assisted kdump
Date: Mon, 26 Jan 2015 16:39:41 +0000
Message-ID: <20150126163941.GD3320@codeblueprint.co.uk>
References: <20150124132637.GB2139@darkstar.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150124132637.GB2139-4/PLUo9XfK/1wF9wiOj0lkEOCMrvLtNR@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Kweh Hock Leong <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Sat, 24 Jan, at 09:26:37PM, Dave Young wrote:
> 
> There's several things I need to ask for help from EFI gurus to see if it is doable:
> 
> * Make sure in case EFI warm reboot the memory of previous kernel can be retained.
 
The only way to reserve memory across a reboot is with EFI capsules.

> * How to determine if kernel is boot with EFI warm reboot in stub

The presence of a capsule would indicate whether we were invoked from a
crash handler.
 
> * What is the right way to pass informations from 1st kernel to 2nd kernel.
>   Is it ok for saving something with efi variables? 

EFI capsules would the be most natural mechanism, but you could
conceivably do it with EFI variables (there's an upper limit on the size
of variable data, though).

> * Other possible problems what I missed

Support for runtime EFI capsules was rather spotty last time I looked.
Things may have moved on, but it's definitely something to watch out
for.

There have been patches on linux-efi in recent months for making use of
EFI capsules,

  https://lkml.kernel.org/r/1412692886-25306-1-git-send-email-matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org
  https://lkml.kernel.org/r/1414984030-13859-1-git-send-email-hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org

I could take a look at resubmitting the first series above if that would
be useful for doing kexec across a reset.

-- 
Matt Fleming, Intel Open Source Technology Center
