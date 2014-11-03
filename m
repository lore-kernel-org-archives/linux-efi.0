From: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 1/3] firmware loader: Introduce new API -
 request_firmware_abort()
Date: Mon, 3 Nov 2014 12:07:20 +0000
Message-ID: <1415016440.7122.891.camel@mfleming-mobl1.ger.corp.intel.com>
References: <1414984030-13859-1-git-send-email-hock.leong.kweh@intel.com>
	 <1414984030-13859-2-git-send-email-hock.leong.kweh@intel.com>
	 <20141103101558.GA11739@khazad-dum.debian.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141103101558.GA11739-ZGHd14iZgfaRjzvQDGKj+xxZW9W5cXbT@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Henrique de Moraes Holschuh <hmh-N3TV7GIv+o9fyO9Q7EP/yw@public.gmane.org>
Cc: Kweh Hock Leong <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Sam Protsenko <semen.protsenko-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ong Boon Leong <boon.leong.ong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, 2014-11-03 at 08:15 -0200, Henrique de Moraes Holschuh wrote:
> On Mon, 03 Nov 2014, Kweh Hock Leong wrote:
> > Note for people who use request_firmware_nowait():
> > You are required to do your own synchronization after you call
> > request_firmware_abort() in order to continue unloading the
> > module. The example synchronization code shows below:
> > 
> > while (THIS_MODULE && module_refcount(THIS_MODULE))
> > 	msleep(20);
> 
> This is _so_ asking for people to get it wrong, it is not funny :-(

Yeah. How about we make request_firmware_abort() synchronous so that
drivers don't have to perform these reference counting games?
