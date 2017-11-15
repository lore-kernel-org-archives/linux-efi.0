From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: Re: Firmware signing -- Re: [PATCH 00/27] security, efi: Add kernel
 lockdown
Date: Wed, 15 Nov 2017 14:56:57 -0500
Message-ID: <1510775817.3711.315.camel@linux.vnet.ibm.com>
References: <20171113174250.GA22894@wotan.suse.de>
         <20171113210848.4dc344bd@alans-desktop>
         <454.1510609487@warthog.procyon.org.uk>
         <CA+55aFzrK29hbxoKs3GsvVUY4_uR7aBgZv2eeVyVq7MzfATY3w@mail.gmail.com>
         <1510662098.3711.139.camel@linux.vnet.ibm.com>
         <CA+55aFzvuvqOfsJ9arzcc1QbTGs+U-TsNmsyem9UAVVQC8YkZQ@mail.gmail.com>
         <CACdnJuvP=0AHGtfGJ5+cT+kHRy3fU4BLjwkvzP0rLO6q5ejAQQ@mail.gmail.com>
         <CA+55aFxeLwgwxh2iJTf6Dz0T_a_TZfTdhBw5TkcSsCmjt2N5pw@mail.gmail.com>
         <20171114205014.GJ729@wotan.suse.de>
         <1510746597.3711.268.camel@linux.vnet.ibm.com>
         <20171115175246.GN729@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20171115175246.GN729@wotan.suse.de>
Sender: owner-linux-security-module@vger.kernel.org
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Johannes Berg <johannes@sipsolutions.net>, Matthew Garrett <mjg59@google.com>, David Howells <dhowells@redhat.com>, Alan Cox <gnomes@lxorguk.ukuu.org.uk>, "AKASHI, Takahiro" <takahiro.akashi@linaro.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jan Blunck <jblunck@infradead.org>, Julia Lawall <julia.lawall@lip6.fr>, Marcus Meissner <meissner@suse.de>, Gary Lin <GLin@suse.com>, LSM List <linux-security-module@vger.kernel.org>, linux-efi <linux-efi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On Wed, 2017-11-15 at 18:52 +0100, Luis R. Rodriguez wrote:
> On Wed, Nov 15, 2017 at 06:49:57AM -0500, Mimi Zohar wrote:
> > On Tue, 2017-11-14 at 21:50 +0100, Luis R. Rodriguez wrote:
> > 
> > > Johannes made cfg80211 recently just use request_firmware() now via commit on
> > > linux-next 90a53e4432 ("cfg80211: implement regdb signature checking") [0] as
> > > he got tired of waiting firmware signing, but note he implemented a signature
> > > checking on its own so he open codes verify_pkcs7_signature() after the
> > > request_firmware() call. If we are happy to live with this, then so be it.
> > > 
> > > [0] https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/commit/?id=90a53e4432b12288316efaa5f308adafb8d304b0
> > 
> > Johannes was tired of waiting?  Commit 5a9196d "ima: add support for
> > measuring and appraising firmware" has been in the kernel since linux-
> > 3.17.
> > 
> > The original firmware hook for verifying firmware signatures were
> > replaced with the common LSM pre and post kernel_read_file() hooks
> > in linux-4.6.y.
> > 
> > Even if you wanted to support firmware signature verification without
> > IMA-appraisal, it should be using the LSM hooks.
> 
> request_firmware() uses kernel_read_file_from_path() underneath the hood,
> and so its used for both:
> 
> 	/lib/firmware/regulatory.db
> 	/lib/firmware/regulatory.db.p7s

The firmware signature validation should occur as part of
kernel_read_file_from_path(), not as a stand alone verification.

Why not extend kernel_read_file_from_path() to pass the detached signature?  Since the signature would only be used for the verification, there's no need to return the open file descriptor.

Or if you prefer, call kernel_read_file_from_path() for the detached signature first, and then call it again for the firmware with a pointer to the detached signature.

> 
> The later only if CONFIG_CFG80211_REQUIRE_SIGNED_REGDB, which defaults
> to y anyway.
> 
> What I meant was that net/wireless/reg.c now open codes firmware signature
> validation on its own rather than using a helper. IMA appraisal will still
> be used if enabled given kernel_read_file_from_path() is used.
> 
> The open coding of the firmware signature check is what I wanted to highlight.

How are the keys in the CFG80211_EXTRA_REGDB_KEYDIR verified?  The
call to key_create_or_update() with the KEY_ALLOC_BYPASS_RESTRICTION
option by-passes any requirement that the keys in this directory are
signed.  This by-passes the concept of extending the secure boot
signature chain of trust.  To safely validate the keys use the
restrict_link_by_builtin_trusted option.

Mimi

