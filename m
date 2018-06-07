From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [PATCH v6 2/5] efi: Add embedded peripheral firmware support
Date: Thu, 7 Jun 2018 17:57:02 +0200
Message-ID: <20180607155702.GA5527@wotan.suse.de>
References: <20180601125330.25054-1-hdegoede@redhat.com>
 <20180601125330.25054-3-hdegoede@redhat.com>
 <20180605210753.GC4511@wotan.suse.de>
 <30260c62-eb8b-7d88-4ce1-83e969546790@redhat.com>
 <20180606214205.GI4511@wotan.suse.de>
 <4cb520a0-d3c8-477d-5d05-7b05637f5faf@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4cb520a0-d3c8-477d-5d05-7b05637f5faf@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Hans de Goede <hdegoede@redhat.com>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Julia Lawall <julia.lawall@lip6.fr>, Martijn Coenen <maco@android.com>, Andy Gross <andy.gross@linaro.org>, David Brown <david.brown@linaro.org>, Bjorn Andersson <bjorn.andersson@linaro.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Peter Jones <pjones@redhat.com>, Dave Olsthoorn <dave@bewaar.me>, Will Deacon <will.deacon@arm.com>, Andy Lutomirski <luto@kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, David Howells <dhowells@redhat.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Josh Triplett <josh@>
List-Id: linux-efi@vger.kernel.org

On Thu, Jun 07, 2018 at 03:46:11PM +0200, Hans de Goede wrote:
> On 06-06-18 23:42, Luis R. Rodriguez wrote:
> > On Wed, Jun 06, 2018 at 08:39:15PM +0200, Hans de Goede wrote:
> > > On 05-06-18 23:07, Luis R. Rodriguez wrote:
> > > 2) Should this flag then be checked inside _request_firmware() before it
> > > calls fw_get_efi_embedded_fw() (which may be an empty stub),
> > 
> > You are the architect behind this call, so its up to you.
> > 
> > To answer this you have to review the other flags and see if other users of the
> > other flags may want your functionality. For instance the Android folks for
> > instance rely on the FW_OPT_NOFALLBACK - the sysfs fallback mechanism to
> > account for odd partition layouts. Could they ever want to use your fallback
> > mechanism? Granted your mechanism is for x86, but they could eventually add
> > support for it on ARM.
> > 
> > Checking if the firmware is on the EFI platform firmware list is much faster
> > than the fallback mechanism, that would be one gain for them, as such it may
> > make sense to check for firmware_request_platform() before using the sysfs
> > fallback mechanism.  However if Android folks want to always override the
> > platform firmware with the sysfs fallback interface we'd need another flag
> > added and call to then change the order later if we checked for for the
> > platform firmware first.
> 
> I believe we agreed a while back that the platform fallback would
> replace the sysfs one when requested. I believe that still makes
> sense. If a driver wants both it can simply call request_firmware_foo
> itself twice and determine the order itself.

Fine by me, so in your case the syfs fallback will be ignored.

Which gets me thinking that perhaps we should have a separate
syfs fallback call. There are only two drivers that use it
explicitly:

  o CONFIG_LEDS_LP55XX_COMMON
	request_firmware_nowait(THIS_MODULE, false, ...);
  o CONFIG_DELL_RBU
	request_firmware_nowait(THIS_MODULE, FW_ACTION_NOHOTPLUG, ...)

And FW_ACTION_NOHOTPLUG is 0.

The above revelation of the async call being data driven is a good
opportunity to break that tradition to the more preferred functional
one. And so we'd also get rid of the FW_ACTION_NOHOTPLUG option
all together.

So a new firmware_request_sysfs_async() I suppose.

  Luis
