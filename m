From: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [PATCH v2 1/3] firmware loader: Introduce new API -
 request_firmware_abort()
Date: Sat, 8 Nov 2014 11:06:55 -0800
Message-ID: <20141108190655.GA2638@kroah.com>
References: <1414984030-13859-1-git-send-email-hock.leong.kweh@intel.com>
 <1414984030-13859-2-git-send-email-hock.leong.kweh@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1414984030-13859-2-git-send-email-hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kweh Hock Leong <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Sam Protsenko <semen.protsenko-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ong Boon Leong <boon.leong.ong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, Nov 03, 2014 at 11:07:08AM +0800, Kweh Hock Leong wrote:
> From: "Kweh, Hock Leong" <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
> Besides aborting through user helper interface, a new API
> request_firmware_abort() allows kernel driver module to abort the
> request_firmware() / request_firmware_nowait() when they are no
> longer needed. It is useful for cancelling an outstanding firmware
> load if initiated from inside a module where that module is in the
> process of being unloaded, since the unload function may not have
> a handle to the struct firmware_buf.
> 
> Note for people who use request_firmware_nowait():
> You are required to do your own synchronization after you call
> request_firmware_abort() in order to continue unloading the
> module. The example synchronization code shows below:
> 
> while (THIS_MODULE && module_refcount(THIS_MODULE))
> 	msleep(20);

As others have pointed out, this isn't ok, and is totally racy and
should never end up in a driver.  Never mess with THIS_MODULE from
within the same module, otherwise it's racy and broken code.

So can you please rework this to not require this?

thanks,

greg k-h
