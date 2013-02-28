From: Tom Gundersen <teg-B22kvLQNl6c@public.gmane.org>
Subject: Re: [PATCH] efivars: Make efivarfs autoloading on mount request
Date: Thu, 28 Feb 2013 12:38:02 +0100
Message-ID: <CAG-2HqVWx7ORjk=5x_KJGS_enMphAhBH7iitE6Cro9ktg1=wDw@mail.gmail.com>
References: <1362047181.3128.22.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1362047181.3128.22.camel-sFMDBYUN5F8GjUHQrlYNx2Wm91YjaHnnhRte9Li2A+AAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Bottomley <jbottomley-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Hi James,

On Thu, Feb 28, 2013 at 11:26 AM, James Bottomley
<jbottomley-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org> wrote:
> Currently you can't mount efivarfs unless the efivar module is already
> inserted.  This is contrary to the usual way in linux, where we autoload
> the necessary filesystem modules when a mount request is received.  The
> reason this doesn't happen for efivarfs is because the module is called
> efivars not efivarfs.  Fix this by adding a module alias for efivarfs.

I posted a similar patch recently [0], but it does not really solve
the problem as /sys/firmware/efi/efivars (which is the standard
mountpoint for this fs) does not exist unless the efivars module is
loaded. I believe a proper solution is in the works [1], which will
split out all the various parts nicely into separate modules.

Cheers,

Tom

[0]: <http://www.mail-archive.com/linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg00560.html>
[1]: <http://www.mail-archive.com/linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg00657.html>
