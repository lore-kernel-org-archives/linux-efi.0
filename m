From: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [PATCH v2 1/3] firmware loader: Introduce new API -
 request_firmware_abort()
Date: Tue, 18 Nov 2014 18:05:02 -0800
Message-ID: <20141119020502.GC6054@kroah.com>
References: <1414984030-13859-1-git-send-email-hock.leong.kweh@intel.com>
 <1414984030-13859-2-git-send-email-hock.leong.kweh@intel.com>
 <20141108190655.GA2638@kroah.com>
 <F54AEECA5E2B9541821D670476DAE19C2B8529E3@PGSMSX102.gar.corp.intel.com>
 <20141117151211.GB6810@console-pimps.org>
 <F54AEECA5E2B9541821D670476DAE19C2B85DA57@PGSMSX102.gar.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <F54AEECA5E2B9541821D670476DAE19C2B85DA57-j2khPEwRog0FyVwBAnZdSLfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Kweh, Hock Leong" <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, "Fleming, Matt" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sam Protsenko <semen.protsenko-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Henrique de Moraes Holschuh <hmh-N3TV7GIv+o9fyO9Q7EP/yw@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Ong, Boon Leong" <boon.leong.ong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, Nov 18, 2014 at 06:31:38AM +0000, Kweh, Hock Leong wrote:
> > -----Original Message-----
> > From: Matt Fleming [mailto:matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org]
> > Sent: Monday, November 17, 2014 11:12 PM
> > >
> > > - Only doing module unload is required to be aware of this synchronization
> > > 	-> Ensuring the call back does not fall into unloaded code which may
> > cause
> > > 	     undefined behavior.
> > > 	-> Ensuring the put_device() & module_put() code have finished in
> > firmware_class.c
> > > 	     function request_firmware_work_func() before the device is
> > unregistered
> > > 	     and module unloaded happen.
> > 
> > Shouldn't the existing module_{put,get}() and {put,get}_device() calls
> > provide all the necessary synchronisation?
> > 
> > Module unload should not be possible while other code is using the
> > module (and the module refcnt has been incremented accordindly).
> > 
> > Right?
> > 
> > --
> > Matt Fleming, Intel Open Source Technology Center
> 
> Hi Matt,
> 
> Yes, you are right. If the module refcount is not zero, you will get error
> message and returned while you do "rmmod". But I strongly believe if we
> have the capability in our code to take care of it by doing synchronization,
> we should take care of it in case people are doing "rmmod -f". Don't
> you think so?

If you do 'rmmod -f' you get to keep all of the broken pieces of your
kernel, no need to try to help out with crazy things like that.

greg k-h
