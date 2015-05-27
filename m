From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: Capsule patches
Date: Wed, 27 May 2015 10:58:30 -0700
Message-ID: <1432749510.2194.35.camel@HansenPartnership.com>
References: <EAEC0BCD44614F499E7CCE37C3B71F113806869D60@BLRX7MCDC202.AMER.DELL.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <EAEC0BCD44614F499E7CCE37C3B71F113806869D60-6n1rj5y50trWnfa2oNyE5AVY21JRvFwKV6yJEvX+wlw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Parmeshwr_Prasad-DYMqY+WieiM@public.gmane.org
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

[adding linux-efi because that's where the experts hang out]
On Mon, 2015-05-25 at 16:14 +0530, Parmeshwr_Prasad-DYMqY+WieiM@public.gmane.org wrote:
> Hi James,
> 
> I am from dell.
> I was working on Capsule feature. I got some patches from you which
> supports user space interface for capsule.
> I have applied those patches on 4.0 kernel and booted my server. I am
> getting /sys/.../update entry to give capsule as interface.
> 
> I am attaching your patches.
> Along with this I have applied patched shared by Mutt.
> 
> I have done cat fw_file > /sys/firmware/capsule/update to give capsule
> file.
> 
> After doing this my kernel is hang. Any help how to debug this ?

The patch was just a RFC demonstrating how the user interface would
work ... and to secure agreement around that, since it had been one of
the contentious issues.

However, I'm fairly certain the back end (the call into ACPI) also
doesn't work properly.  Matt Fleming has some ideas about fixing that
up.  You'll need both pieces to get this fully functional.

James
