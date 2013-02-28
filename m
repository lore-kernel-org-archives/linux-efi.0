From: James Bottomley <jbottomley-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH] efivars: Make efivarfs autoloading on mount request
Date: Thu, 28 Feb 2013 11:55:28 +0000
Message-ID: <1362052527.3128.29.camel@dabdike.int.hansenpartnership.com>
References: <1362047181.3128.22.camel@dabdike.int.hansenpartnership.com>
	 <CAG-2HqVWx7ORjk=5x_KJGS_enMphAhBH7iitE6Cro9ktg1=wDw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAG-2HqVWx7ORjk=5x_KJGS_enMphAhBH7iitE6Cro9ktg1=wDw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Content-ID: <523134FC4FC4064D89BA4181346C6E0E-ruSsrxOD6xDby3iVrkZq2A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tom Gundersen <teg-B22kvLQNl6c@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, 2013-02-28 at 12:38 +0100, Tom Gundersen wrote:
> Hi James,
> 
> On Thu, Feb 28, 2013 at 11:26 AM, James Bottomley
> <jbottomley-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org> wrote:
> > Currently you can't mount efivarfs unless the efivar module is already
> > inserted.  This is contrary to the usual way in linux, where we autoload
> > the necessary filesystem modules when a mount request is received.  The
> > reason this doesn't happen for efivarfs is because the module is called
> > efivars not efivarfs.  Fix this by adding a module alias for efivarfs.
> 
> I posted a similar patch recently [0], but it does not really solve
> the problem as /sys/firmware/efi/efivars (which is the standard
> mountpoint for this fs) does not exist unless the efivars module is
> loaded. I believe a proper solution is in the works [1], which will
> split out all the various parts nicely into separate modules.

That depends whether you mount there or not.  If you want a filesystem
in /sys, then you have the same problem as debugfs and cgroupfs, so it
can't be done without distro support: specifically a fstab entry, so
this patch is as far as the kernel should go.

Even a split won't solve the problem that the directory won't exist
until the modules are loaded and the modules are autoloaded by the mount
call, so the problem is the same whether the modules are split or
monolithic.

We definitely need this patch in 3.8 because that's where the efivarfs
filesystem was added, so it should probably have a cc stable which I
forgot.

James
