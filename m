From: 'Matt Fleming' <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH v5 2/2] efi: a misc char interface for user to update efi
 firmware
Date: Wed, 9 Sep 2015 15:04:48 +0100
Message-ID: <20150909140448.GI4973@codeblueprint.co.uk>
References: <F54AEECA5E2B9541821D670476DAE19C4A85551A@PGSMSX102.gar.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <F54AEECA5E2B9541821D670476DAE19C4A85551A-j2khPEwRog0FyVwBAnZdSLfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Kweh, Hock Leong" <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "Ong, Boon Leong" <boon.leong.ong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sam Protsenko <semen.protsenko-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Fleming, Matt" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, 02 Sep, at 06:31:36AM, Kweh Hock Leong wrote:
> 
> I have done an experiment on that by using the misc char device file note.
> I included the flush() callback function to the fops. In flush(), I put a printk()
> and return -EINVAL. When I perform "cat XXX > /dev/XXX" on Intel Quark
> Galileo platform, I found that the flush() is not just being called at file
> close, it will also being called before the file write. And the error return, that I
> forced in the flush(), does not show up at shell terminal. This is the reason that
> I did not follow James recommendation and figure out to do it at write().

OK, that's interesting. Which cat tool is included with the Quark BSP?
 
-- 
Matt Fleming, Intel Open Source Technology Center
