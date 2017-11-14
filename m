From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: Firmware signing -- Re: [PATCH 00/27] security, efi: Add kernel
 lockdown
Date: Tue, 14 Nov 2017 21:50:14 +0100
Message-ID: <20171114205014.GJ729@wotan.suse.de>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CA+55aFxeLwgwxh2iJTf6Dz0T_a_TZfTdhBw5TkcSsCmjt2N5pw@mail.gmail.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>, Johannes Berg <johannes@sipsolutions.net>
Cc: Matthew Garrett <mjg59@google.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, David Howells <dhowells@redhat.com>, Alan Cox <gnomes@lxorguk.ukuu.org.uk>, "Luis R. Rodriguez" <mcgrof@kernel.org>, "AKASHI, Takahiro" <takahiro.akashi@linaro.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jan Blunck <jblunck@infradead.org>, Julia Lawall <julia.lawall@lip6.fr>, Marcus Meissner <meissner@suse.de>, Gary Lin <GLin@suse.com>, LSM List <linux-security-module@vger.kernel.org>, linux-efi <linux-efi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On Tue, Nov 14, 2017 at 12:18:54PM -0800, Linus Torvalds wrote:
> This is all theoretical security masturbation. The _real_ attacks have
> been elsewhere.

In my research on this front I'll have to agree with this, in terms of
justification and there are only *two* arguments which I've so far have found
to justify firmware signing:

a) If you want signed modules, you therefore should want signed firmware.
   This however seems to be solved by using trusted boot thing, given it
   seems trusted boot requires having firmware be signed as well. (Docs
   would be useful to get about where in the specs this is mandated,
   anyone?). Are there platforms that don't have trusted boot or for which
   they don't enforce hardware checking for signed firmware for which
   we still want to support firmware signing for? Are there platforms
   that require and use module signing but don't and won't have a trusted
   boot of some sort? Do we care?

b) Other kernel components have implemented some sort of "signing" a file
   prior to sending it to the kernel. One is wifi for the regulatory.bin,
   through CRDA, and this helped us persuade certain folks to support wifi
   with open drivers. We can easily replace CRDA with kernel fetch for a
   signed file given most of the APIs for this is available.

Originally effort a) was done for b), as it was believed we needed a).
If we are saying a) is pointless, what about b)? A simple new
kernel_read_file_from_path_pkcs7_signed() or some such would suffice.

Johannes made cfg80211 recently just use request_firmware() now via commit on
linux-next 90a53e4432 ("cfg80211: implement regdb signature checking") [0] as
he got tired of waiting firmware signing, but note he implemented a signature
checking on its own so he open codes verify_pkcs7_signature() after the
request_firmware() call. If we are happy to live with this, then so be it.

[0] https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/commit/?id=90a53e4432b12288316efaa5f308adafb8d304b0

  Luis
