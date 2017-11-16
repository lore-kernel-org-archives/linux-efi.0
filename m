From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: Re: Firmware signing -- Re: [PATCH 00/27] security, efi: Add kernel
 lockdown
Date: Wed, 15 Nov 2017 19:05:01 -0500
Message-ID: <1510790701.3711.359.camel@linux.vnet.ibm.com>
References: <454.1510609487@warthog.procyon.org.uk>
         <CA+55aFzrK29hbxoKs3GsvVUY4_uR7aBgZv2eeVyVq7MzfATY3w@mail.gmail.com>
         <1510662098.3711.139.camel@linux.vnet.ibm.com>
         <CA+55aFzvuvqOfsJ9arzcc1QbTGs+U-TsNmsyem9UAVVQC8YkZQ@mail.gmail.com>
         <CACdnJuvP=0AHGtfGJ5+cT+kHRy3fU4BLjwkvzP0rLO6q5ejAQQ@mail.gmail.com>
         <CA+55aFxeLwgwxh2iJTf6Dz0T_a_TZfTdhBw5TkcSsCmjt2N5pw@mail.gmail.com>
         <20171114205014.GJ729@wotan.suse.de>
         <1510746597.3711.268.camel@linux.vnet.ibm.com>
         <20171115175246.GN729@wotan.suse.de>
         <1510775817.3711.315.camel@linux.vnet.ibm.com>
         <20171115204651.GO729@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20171115204651.GO729@wotan.suse.de>
Sender: owner-linux-security-module@vger.kernel.org
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Johannes Berg <johannes@sipsolutions.net>, Matthew Garrett <mjg59@google.com>, David Howells <dhowells@redhat.com>, Alan Cox <gnomes@lxorguk.ukuu.org.uk>, "AKASHI, Takahiro" <takahiro.akashi@linaro.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jan Blunck <jblunck@infradead.org>, Julia Lawall <julia.lawall@lip6.fr>, Marcus Meissner <meissner@suse.de>, Gary Lin <GLin@suse.com>, LSM List <linux-security-module@vger.kernel.org>, linux-efi <linux-efi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On Wed, 2017-11-15 at 21:46 +0100, Luis R. Rodriguez wrote:
> On Wed, Nov 15, 2017 at 02:56:57PM -0500, Mimi Zohar wrote:
> > On Wed, 2017-11-15 at 18:52 +0100, Luis R. Rodriguez wrote:
> > > On Wed, Nov 15, 2017 at 06:49:57AM -0500, Mimi Zohar wrote:
> > > > On Tue, 2017-11-14 at 21:50 +0100, Luis R. Rodriguez wrote:
> > > > 
> > > > > Johannes made cfg80211 recently just use request_firmware() now via commit on
> > > > > linux-next 90a53e4432 ("cfg80211: implement regdb signature checking") [0] as
> > > > > he got tired of waiting firmware signing, but note he implemented a signature
> > > > > checking on its own so he open codes verify_pkcs7_signature() after the
> > > > > request_firmware() call. If we are happy to live with this, then so be it.
> > > > > 
> > > > > [0] https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/commit/?id=90a53e4432b12288316efaa5f308adafb8d304b0
> > > > 
> > > > Johannes was tired of waiting?  Commit 5a9196d "ima: add support for
> > > > measuring and appraising firmware" has been in the kernel since linux-
> > > > 3.17.
> > > > 
> > > > The original firmware hook for verifying firmware signatures were
> > > > replaced with the common LSM pre and post kernel_read_file() hooks
> > > > in linux-4.6.y.
> > > > 
> > > > Even if you wanted to support firmware signature verification without
> > > > IMA-appraisal, it should be using the LSM hooks.
> > > 
> > > request_firmware() uses kernel_read_file_from_path() underneath the hood,
> > > and so its used for both:
> > > 
> > > 	/lib/firmware/regulatory.db
> > > 	/lib/firmware/regulatory.db.p7s
> > 
> > The firmware signature validation should occur as part of
> > kernel_read_file_from_path(), not as a stand alone verification.
> > 
> > Why not extend kernel_read_file_from_path() to pass the detached signature?
> > Since the signature would only be used for the verification, there's no need
> > to return the open file descriptor.
> 
> This goes along with the question if there were an other users who wanted it,
> or more importantly -- if firmware signing was desirable for any reason, a
> modified kernel_read_file_from_path_signed() could in turn be used, *or* an LSM
> added to handle READING_FIRMWARE and READING_FIRMWARE_PREALLOC_BUFFER.  The
> above use case was one example outside of the typical firmware use.  I've long
> pointed out that we no longer use the firmware API for just firmware, and the
> above is now a very good example of it. I've been suggesting uses of the
> firmware API for non-firmware had already happened and that more uses were on
> its way. Trusted boot has nothing to do with these uses as such the gains of
> systems pegged with "trusted boot" have nothing to do validation of these files
> through hardware.

No, it has nothing to do with other users wanting it.  It has to do
with extending an API to support detach signatures.

There's no reason to define a new function named
kernel_read_file_from_path_signed().  To prevent code duplication, the
existing functions would turn into wrappers.  It's not like there are
that many users.  A quick search returned:

kernel_read_file_from_fd:  2
kernel_read_file_from_path: 5
LSMs: 3 loadpin, selinux, + ima

Mimi

