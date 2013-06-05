From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH] Modify UEFI anti-bricking code
Date: Wed, 5 Jun 2013 20:59:53 +0100
Message-ID: <20130605195953.GD30420@console-pimps.org>
References: <1370117180-1712-1-git-send-email-matthew.garrett@nebula.com>
 <1370276021.30695.4.camel@linux-s257.site>
 <1370277079.6315.14.camel@x230.lan>
 <1370316933.30695.7.camel@linux-s257.site>
 <CAL01qptzxe5L6Vq+nBZLq+bQNxbe_i_2OdKMNJGZQDfMihaHOw@mail.gmail.com>
 <1370444007.6315.32.camel@x230.lan>
 <20130605155904.GC30420@console-pimps.org>
 <1370448519.6315.36.camel@x230.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1370448519.6315.36.camel-+5W/JHIUVxg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Cc: "Fleming, Matt" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, joeyli <jlee-IBi9RG/b67k@public.gmane.org>, "rja-sJ/iWh9BUns@public.gmane.org" <rja-sJ/iWh9BUns@public.gmane.org>, "mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org" <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org" <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, "jkosina-AlSwsSmVLrQ@public.gmane.org" <jkosina-AlSwsSmVLrQ@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org" <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "hpa-VuQAYsv1563Yd54FQh9/CA@public.gmane.org" <hpa-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, "akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org" <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "oneukum-l3A5Bk7waGM@public.gmane.org" <oneukum-l3A5Bk7waGM@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, 05 Jun, at 04:08:39PM, Matthew Garrett wrote:
> On Wed, 2013-06-05 at 16:59 +0100, Matt Fleming wrote:
> 
> > +	/* clean DUMMY object */
> > +	efi.set_variable(efi_dummy_name, &EFI_DUMMY_GUID, 0, 0, NULL);
> 
> Hm. Actually, is that going to work? From the spec:
> 
> If a preexisting variable is rewritten with different attributes,
> SetVariable()shall not modify the variable and shall return
> EFI_INVALID_PARAMETER. 
> 
> So I think we probably need to fix the attributes to NV|RT|BS for both
> this call and the one in query_variable_store. We should probably also
> only do the workaround if the NV bit is set in the original query.

Yeah, that looks wrong.

Joey, care to resend an updated patch?

-- 
Matt Fleming, Intel Open Source Technology Center
