From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: [PATCH V3 08/11] kexec: Disable at runtime if the kernel
 enforces module loading restrictions
Date: Sun, 08 Sep 2013 10:32:56 -0700
Message-ID: <1378661576.2429.16.camel@dabdike.int.hansenpartnership.com>
References: <1378252218-18798-1-git-send-email-matthew.garrett@nebula.com>
	 <1378252218-18798-9-git-send-email-matthew.garrett@nebula.com>
	 <20130908064027.GA3587@kroah.com> <1378622648.2300.4.camel@x230>
	 <20130908072408.GA5092@kroah.com>
	 <CAGXu5jLwCt6RtQC+kxcUC69tMydx8DO2QWDv3jK6_mOyT_iNbA@mail.gmail.com>
	 <1378660284.2429.11.camel@dabdike.int.hansenpartnership.com>
	 <1378660541.2300.19.camel@x230>
	 <1378660975.2429.14.camel@dabdike.int.hansenpartnership.com>
	 <1378661252.2300.26.camel@x230>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1378661252.2300.26.camel@x230>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Cc: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Sun, 2013-09-08 at 17:27 +0000, Matthew Garrett wrote:
> > It's an argument that CAP_SYS_BOOT is too powerful yes, but if you
> > recall, I said I keep that one.  In the rather lame analogy, what I do
> > by giving away CAP_SYS_MODULE and enforcing module signing while keeping
> > CAP_SYS_BOOT is allow people into my conservatory to play with the
> > plants but not into my house to steal the silver ... saying CAP_SYS_BOOT
> > is too powerful doesn't affect that use case because I haven't given
> > away CAP_SYS_BOOT.
> 
> Ok, sorry, I had your meaning inverted. Yes, permitting the loading of
> signed modules while preventing the use of kexec is a completely
> reasonable configuration - so reasonable that it's what this patch
> causes the kernel to do automatically. 

Well, no, it doesn't because with this patch, *I* can't use kexec ...
you've just locked me out of my own house.

James
