From: "Luis R. Rodriguez" <mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: Firmware signing -- Re: [PATCH 00/27] security, efi: Add kernel
 lockdown
Date: Mon, 4 Dec 2017 20:51:55 +0100
Message-ID: <20171204195155.GU729@wotan.suse.de>
References: <1509660641.3416.24.camel@linux.vnet.ibm.com>
 <20171107230700.GJ22894@wotan.suse.de>
 <20171108061551.GD7859@linaro.org>
 <20171108194626.GQ22894@wotan.suse.de>
 <20171109014841.GF7859@linaro.org>
 <1510193857.4484.95.camel@linux.vnet.ibm.com>
 <20171109044619.GG7859@linaro.org>
 <20171111023240.2398ca55@alans-desktop>
 <20171113174250.GA22894@wotan.suse.de>
 <20171113210848.4dc344bd@alans-desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171113210848.4dc344bd@alans-desktop>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alan Cox <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>
Cc: "Luis R. Rodriguez" <mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "AKASHI, Takahiro" <takahiro.akashi-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Jan Blunck <jblunck-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Julia Lawall <julia.lawall-L2FTfq7BK8M@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Marcus Meissner <meissner-l3A5Bk7waGM@public.gmane.org>, Gary Lin <GLin-IBi9RG/b67k@public.gmane.org>, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matthew Garrett <mjg59-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, Nov 13, 2017 at 09:08:48PM +0000, Alan Cox wrote:
> On Mon, 13 Nov 2017 18:42:50 +0100
> "Luis R. Rodriguez" <mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> 
> > On Sat, Nov 11, 2017 at 02:32:40AM +0000, Alan Cox wrote:
> > > > My assumption here is:
> > > > 1) there are some less important and so security-insensitive firmwares,
> > > >    by which I mean that such firmwares won't be expected to be signed in
> > > >    terms of vulnerability or integrity.
> > > >    (I can't give you examples though.)
> > > > 2) firmware's signature will be presented separately from the firmware
> > > >    blob itself. Say, "firmware.bin.p7s" for "firmware.bin"  
> > > 
> > > For x86 at least any firmware on any system modern enough to support
> > > 'secure' boot should already be signed. The only major exception is
> > > likely to be for things like random USB widgets.  
> > 
> > Alan, the firmware being considered here is /lib/firmware firmware, which
> > is not signed today. Its unclear to me how you mean that /lib/firmware files
> > are already signed or verified today
> 
> By the hardware they get loaded onto. Pretty much all of the hardware on
> PC class systems at least is signed and checked by the platform or the
> device itself. For a 'secure' boot era PC that's pretty much everything
> except USB toys and FPGA.
> 
> So you don't actually need to sign a lot of PC class firmware because
> it's already signed.

It would seem that this logic can trump the need for /lib/firmware signing. And
for users where this is *not done* they can open code it, just as is being done
for cfg80211 to help a new kernel config replace CRDA. Additionally for non-UEFI
platforms which *also* need firmware signing, one viable option is to rely
on IMA.

If we have enough open-coded uses similar to cfg80211 we can revisit this
question  later.

I am curious though, is the above notion of having hardware require signed
firmware an implication brought down by UEFI? If so do you have any pointers
to where this is stipulated? Or is it just a best practice we assume some
manufacturers are implementing?

  Luis
