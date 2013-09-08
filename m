From: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [PATCH V3 08/11] kexec: Disable at runtime if the kernel
 enforces module loading restrictions
Date: Sun, 8 Sep 2013 10:22:49 -0700
Message-ID: <20130908172249.GB20959@kroah.com>
References: <1378252218-18798-1-git-send-email-matthew.garrett@nebula.com>
 <1378252218-18798-9-git-send-email-matthew.garrett@nebula.com>
 <20130908064027.GA3587@kroah.com>
 <1378622648.2300.4.camel@x230>
 <20130908072408.GA5092@kroah.com>
 <CAGXu5jLwCt6RtQC+kxcUC69tMydx8DO2QWDv3jK6_mOyT_iNbA@mail.gmail.com>
 <20130908161859.GA18946@kroah.com>
 <1378657487.2300.10.camel@x230>
 <20130908163926.GA19665@kroah.com>
 <1378659580.2300.15.camel@x230>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1378659580.2300.15.camel@x230>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Cc: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Sun, Sep 08, 2013 at 04:59:40PM +0000, Matthew Garrett wrote:
> On Sun, 2013-09-08 at 09:39 -0700, Greg KH wrote:
> 
> > But I want, for other reasons (i.e. safety in layers), signed kernel
> > modules.  I also might actually want some debugfs files in some random
> > driver (like this series removes).
> 
> You want a configuration that makes no sense. There's no reason that the
> kernel should make that easy.

It makes sense to me in that it is something I can do today, why stop
that?

> > Heck, look at Red Hat.  They have been shipping signed kernel modules
> > for _years_ and yet they do not disable kexec.  Have they been "doing it
> > wrong" all of this time?   Perhaps people want signed modules just for
> > support reasons, not "security" reasons.
> 
> Then they do what Red Hat does and don't set CONFIG_SIG_ENFORCE.

But what if I only want signed modules to be loaded?  Isn't that a valid
thing to want, yet still be able to also do other things with my system?

I sure think it is, and I have a real-world valid use case for this
exact type of thing, as I have already described, which meets my
security guarantees just fine.  I can go into details if you need me to
do so.

> > Don't take away those options.
> 
> Where's the option to let me let unprivileged users set random MSRs?

Can that happen today?

> Where's the option to let root disable STRICT_DEVMEM at runtime?

Again, can that happen today?

> We don't offer these options because *they make no sense*. Locking
> your door while leaving your window open may make you feel better, but
> it doesn't improve the security of your house.

Yes it does, it keeps the people who only try the front door from coming
in, a very common threat model.  It isn't "perfect" security, but I'm
not saying that it is, and no one else is either.

It's doing one thing, and doing it well.  The fact that you want to now
have that "one thing" mean "something else" is what I am objecting to.

Security is a series of "levels", all of which depend on different
threat models and scenarios.  Provide the ability to achieve different
levels of security, but don't force your idea of system-wide security on
others who may not agree with it.

thanks,

greg k-h
