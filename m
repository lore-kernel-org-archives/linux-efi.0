From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Firmware signing -- Re: [PATCH 00/27] security, efi: Add kernel
 lockdown
Date: Tue, 14 Nov 2017 14:14:18 -0800
Message-ID: <1510697658.7703.12.camel@HansenPartnership.com>
References: <20171109044619.GG7859@linaro.org>
         <20171111023240.2398ca55@alans-desktop>
         <20171113174250.GA22894@wotan.suse.de>
         <20171113210848.4dc344bd@alans-desktop>
         <454.1510609487@warthog.procyon.org.uk>
         <CA+55aFzrK29hbxoKs3GsvVUY4_uR7aBgZv2eeVyVq7MzfATY3w@mail.gmail.com>
         <1510662098.3711.139.camel@linux.vnet.ibm.com>
         <CA+55aFzvuvqOfsJ9arzcc1QbTGs+U-TsNmsyem9UAVVQC8YkZQ@mail.gmail.com>
         <CACdnJuvP=0AHGtfGJ5+cT+kHRy3fU4BLjwkvzP0rLO6q5ejAQQ@mail.gmail.com>
         <CA+55aFxeLwgwxh2iJTf6Dz0T_a_TZfTdhBw5TkcSsCmjt2N5pw@mail.gmail.com>
         <20171114205014.GJ729@wotan.suse.de>
         <CACdnJuvzPnMwsAF4mUJXCaJWQ=nCc9Yi5u3gj1A0+BsWf1Swgw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CACdnJuvzPnMwsAF4mUJXCaJWQ=nCc9Yi5u3gj1A0+BsWf1Swgw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Garrett <mjg59@google.com>, "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Johannes Berg <johannes@sipsolutions.net>, Mimi Zohar <zohar@linux.vnet.ibm.com>, David Howells <dhowells@redhat.com>, Alan Cox <gnomes@lxorguk.ukuu.org.uk>, "AKASHI, Takahiro" <takahiro.akashi@linaro.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jan Blunck <jblunck@infradead.org>, Julia Lawall <julia.lawall@lip6.fr>, Marcus Meissner <meissner@suse.de>, Gary Lin <GLin@suse.com>, LSM List <linux-security-module@vger.kernel.org>, linux-efi <linux-efi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On Tue, 2017-11-14 at 15:55 -0500, Matthew Garrett wrote:
> On Tue, Nov 14, 2017 at 3:50 PM, Luis R. Rodriguez <mcgrof@kernel.org
> > wrote:
> > 
> > On Tue, Nov 14, 2017 at 12:18:54PM -0800, Linus Torvalds wrote:
> > > 
> > > This is all theoretical security masturbation. The _real_ attacks
> > > have been elsewhere.
> > 
> > In my research on this front I'll have to agree with this, in terms
> > of justification and there are only *two* arguments which I've so 
> > far have found to justify firmware signing:
> > 
> > a) If you want signed modules, you therefore should want signed
> > firmware.
> >    This however seems to be solved by using trusted boot thing,
> > given it
> >    seems trusted boot requires having firmware be signed as well.
> > (Docs
> >    would be useful to get about where in the specs this is
> > mandated,
> >    anyone?). Are there platforms that don't have trusted boot or
> > for which
> >    they don't enforce hardware checking for signed firmware for
> > which
> >    we still want to support firmware signing for? Are there
> > platforms
> >    that require and use module signing but don't and won't have a
> > trusted
> >    boot of some sort? Do we care?
> 
> TPM-backed Trusted Boot means you don't /need/ to sign anything,
> since the measurements of what you loaded will end up in the TPM. But
> signatures make it a lot easier, since you can just assert that only
> signed material will be loaded and so you only need to measure the
> kernel and the trusted keys.

Actually, I'd disagree with that quite a lot: measured boot only works
if you're attesting to something outside of your system that has the
capability for doing something about a wrong measurement.  Absent that,
measured boot has no safety whatsoever.  Secure boot, on the other
hand, can enforce not booting with elements that fail the signature
check.

The question, really, in any system, is how you want to prove security.
 In a standalone server system, measured boot is pretty useless because
you don't have an external entity to attest to, so signatures and
secure boot are really the bulwark against breaches.  In a properly
attested server cluster whose attestation controller has the ability to
reboot you, perhaps signatures and secure boot don't add that much more
value.

James
