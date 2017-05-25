From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/5] Add the ability to lock down access to the running kernel image
Date: Thu, 25 May 2017 07:53:22 +0100
Message-ID: <19783.1495695202@warthog.procyon.org.uk>
References: <80bdc6c9-004b-800f-ffd0-4b5ebf8cdeba@schaufler-ca.com> <149563711758.9419.11406612723056598045.stgit@warthog.procyon.org.uk> <149563714531.9419.16811189348445249219.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <80bdc6c9-004b-800f-ffd0-4b5ebf8cdeba-iSGtlc1asvQWG2LlvL+J4A@public.gmane.org>
Content-ID: <19782.1495695202.1-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Casey Schaufler <casey-iSGtlc1asvQWG2LlvL+J4A@public.gmane.org>
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Casey Schaufler <casey-iSGtlc1asvQWG2LlvL+J4A@public.gmane.org> wrote:

> > +#ifdef CONFIG_LOCK_DOWN_KERNEL
> > +extern bool kernel_is_locked_down(void);
> > +#else
> > +static inline bool kernel_is_locked_down(void)
> 
> Should this be a bool or an int? I can imagine that someone is going to want
> various different degrees of lock down for kernels. As an int you could
> return a bitmap indicating which features were locked. This would allow
> additional things to be locked down without changing the interface.

At the moment it makes no difference, since the return value is only ever
passed directly to an if-statement.

Also, do you have an idea as to how is should be divided up?

There aren't so many cases, at least not yet, that they can't be fixed up,
perhaps with a coccinelle script.

David
