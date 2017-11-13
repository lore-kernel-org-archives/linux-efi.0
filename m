From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: Firmware signing -- Re: [PATCH 00/27] security, efi: Add kernel
 lockdown
Date: Mon, 13 Nov 2017 19:50:35 +0100
Message-ID: <20171113185035.GB22894@wotan.suse.de>
References: <1509660086.3416.15.camel@linux.vnet.ibm.com>
 <150842463163.7923.11081723749106843698.stgit@warthog.procyon.org.uk>
 <14219.1509660259@warthog.procyon.org.uk>
 <1509660641.3416.24.camel@linux.vnet.ibm.com>
 <20171107230700.GJ22894@wotan.suse.de>
 <20171108061551.GD7859@linaro.org>
 <20171108194626.GQ22894@wotan.suse.de>
 <20171109014841.GF7859@linaro.org>
 <20171110014641.GO22894@wotan.suse.de>
 <1510321506.3359.42.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1510321506.3359.42.camel@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>, "AKASHI, Takahiro" <takahiro.akashi@linaro.org>, Linus Torvalds <torvalds@linux-foundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jan Blunck <jblunck@infradead.org>, Julia Lawall <julia.lawall@lip6.fr>, David Howells <dhowells@redhat.com>, Andy Lutomirski <luto@kernel.org>, David Woodhouse <dwmw2@infradead.org>, Marcus Meissner <meissner@suse.de>, Gary Lin <GLin@suse.com>, Josh Triplett <josh@joshtriplett.org>, Ben Hutchings <ben@decadent.org.uk>, Kyle McMartin <kyle@kernel.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, Peter Jones <pjones@redhat.com>, linux-security-module@vger.kernel.org, gnomes@lxorguk.ukuu.org.uk, linux-efi <linux-efi@vger.kernel.org>, linux-kernel@vger.kern
List-Id: linux-efi@vger.kernel.org

On Fri, Nov 10, 2017 at 08:45:06AM -0500, Mimi Zohar wrote:
> On Fri, 2017-11-10 at 02:46 +0100, Luis R. Rodriguez wrote:
> > On Thu, Nov 09, 2017 at 10:48:43AM +0900, AKASHI, Takahiro wrote:
> > > On Wed, Nov 08, 2017 at 08:46:26PM +0100, Luis R. Rodriguez wrote:
> > > > But perhaps I'm not understanding the issue well, let me know.
> > > 
> > > My point is quite simple:
> > > my_deviceA_init() {
> > >         err = request_firmware(&fw, "deviceA"); <--- (a)
> > >         if (err)
> > >                 goto err_request;
> > > 
> > >         err = verify_firmware(fw);  <--- (b)
> > >         if (err)
> > >                 goto err_verify;
> > > 
> > >         load_fw_to_deviceA(fw);     <--- (c)
> > >         ...
> > > }
> > > 
> > > As legacy device drivers does not have (b), there is no chance to
> > > prevent loading a firmware at (c) for locked-down kernel.
> > 
> > Ah, I think your example requires another piece of code to make it clearer.
> > Here is an example legacy driver:
> > 
> > my_legacy_deviceB_init() {
> >         err = request_firmware(&fw, "deviceB"); <--- (a)
> >         if (err)
> >                 goto err_request;
> > 
> >         load_fw_to_deviceA(fw);     <--- (c)
> >         ...
> > }
> > 
> > There is no verify_firmware() call here, and as such the approach Linus
> > suggested a while ago cannot possibly fail on a "locked down kernel", unless
> > *very* legacy API call gets a verify_firmware() sprinkled.
> > 
> > One sensible thing to say here is then that all request_firmware() calls should
> > just fail on a "locked down kernel", however if this were true then even calls
> > which *did* issue a subsequent verify_firmware() would fail earlier therefore
> > making verify_firmware() pointless on new drivers.
> 
> As long as these "*very* legacy API calls", are calling
> kernel_read_file_from_path() to read the firmware, there shouldn't be
> a problem.

For the *default* validation approach, agreed that we can LSMify this now through
kernel_read_file() by checking the enum kernel_read_file_id for READING_FIRMWARE,
as you did with your proposed LSM hook fw_lockdown_read_file(), but *iff* we
agree on which mechanisms to support for the default validation approach.

I say support given LSM'ifying this means anyone can end up trying to scheme up
a kernel solution which is non-IMA appraisals. For instance, based on
discussions so far, perhaps a sensible initial *default* scheme to strive for
firmware which we may not get a vendor to sign for us, or for which we don't
have a key to trust for singing could be to use a simple hash of files. This
makes sense for firmware which is typically not updated regularly and for which
we lost a source of updates for.

There's still a similar catch-22 issue here though:

A few folks have argued that we should support custom key requirements
from the start, so we can support a vendor wishing to use their own keys
from the start. Using a specific key is much more efficient for device
drivers which for instance may have firmware updated much more regularly,
this way a hash update on the kernel is not needed per firmware update.
Even if we support both schemes from the start, supporting a "default"
scheme without having any drivers update implies *all* firmware API calls
would need to fit the default policy scheme initially supported. So if
hashes of files is what would be used to start off with we'd be forcing all
firmware API kernel calls to follow that scheme from the start and I don't
think that makes much sense.

Despite some folks not liking it, supporting an initial default scheme just be
to be firmware signed by the linux-firmware maintainer might be an easier first
optional policy to support.

It does not mean we don't have to support hashes from the start, we can,
however that could require a driver change where its hash is specified or
preferred, for instance.

Likewise, for alternative and custom signing requirements, we also can require
a different API call, but for this to work well, I think we'd need a different
firmware API call and an LSM hook other than kernel_read_file_from_path() which
can enable the custom requirements to be specified. Otherwise we run into
similar issue as Takahiro pointed out with verify_firmware(), where the default
policy (say a default key) would not have a match from the start so it would
fail from the start. There is also the technical limitation that
kernel_read_file_from_path() has no way of letting callers pass further
security criteria.

  Luis
