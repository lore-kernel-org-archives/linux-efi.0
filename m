From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 02/27] Add a SysRq option to lift kernel lockdown
Date: Thu, 19 Oct 2017 23:12:30 +0100
Message-ID: <10671.1508451150@warthog.procyon.org.uk>
References: <97659d0c-6992-3025-0f85-819d23e954cc@infradead.org> <150842463163.7923.11081723749106843698.stgit@warthog.procyon.org.uk> <150842464774.7923.7951986297563109339.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <97659d0c-6992-3025-0f85-819d23e954cc-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Content-ID: <10670.1508451150.1-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jforbes-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:

> > +config ALLOW_LOCKDOWN_LIFT
> > +	bool
> > +	help
> > +	  Allow the lockdown on a kernel to be lifted, thereby restoring the
> > +	  ability of userspace to access the kernel image (eg. by SysRq+x under
> 
> how about:                                                                on
> 
> > +	  x86).

I'll just get rid of this config option, I think - it doesn't make anything
available outside of lock_down.c.

> > +#ifdef CONFIG_ALLOW_LOCKDOWN_LIFT_BY_KEY
> 
> is that the same as: CONFIG_ALLOW_LOCKDOWN_LIFT_BY_SYSRQ ?
> tested?

My test machine doesn't have a physical keyboard attached, but you're right.

David
