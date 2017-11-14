From: Matthew Garrett <mjg59-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: Firmware signing -- Re: [PATCH 00/27] security, efi: Add kernel lockdown
Date: Tue, 14 Nov 2017 14:34:30 -0800
Message-ID: <CACdnJus1gnMQ8+fLjigZog4dcsKRFYXdScdWh7=6+RKOkmw4TA@mail.gmail.com>
References: <20171109044619.GG7859@linaro.org> <20171111023240.2398ca55@alans-desktop>
 <20171113174250.GA22894@wotan.suse.de> <20171113210848.4dc344bd@alans-desktop>
 <454.1510609487@warthog.procyon.org.uk> <CA+55aFzrK29hbxoKs3GsvVUY4_uR7aBgZv2eeVyVq7MzfATY3w@mail.gmail.com>
 <1510662098.3711.139.camel@linux.vnet.ibm.com> <CA+55aFzvuvqOfsJ9arzcc1QbTGs+U-TsNmsyem9UAVVQC8YkZQ@mail.gmail.com>
 <CACdnJuvP=0AHGtfGJ5+cT+kHRy3fU4BLjwkvzP0rLO6q5ejAQQ@mail.gmail.com>
 <CA+55aFxeLwgwxh2iJTf6Dz0T_a_TZfTdhBw5TkcSsCmjt2N5pw@mail.gmail.com>
 <20171114205014.GJ729@wotan.suse.de> <CACdnJuvzPnMwsAF4mUJXCaJWQ=nCc9Yi5u3gj1A0+BsWf1Swgw@mail.gmail.com>
 <1510697658.7703.12.camel@HansenPartnership.com> <CACdnJuuYasij2_JAvdvof-8PRgKMSAT1NOBzHG=Vr-4MN79SNg@mail.gmail.com>
 <1510698696.7703.21.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1510698696.7703.21.camel-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: "Luis R. Rodriguez" <mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Berg <johannes-cdvu00un1VgdHxzADdlk8Q@public.gmane.org>, Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alan Cox <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, "AKASHI, Takahiro" <takahiro.akashi-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Jan Blunck <jblunck-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Julia Lawall <julia.lawall-L2FTfq7BK8M@public.gmane.org>, Marcus Meissner <meissner-l3A5Bk7waGM@public.gmane.org>, Gary Lin <GLin-IBi9RG/b67k@public.gmane.org>, LSM List <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-efi <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, Nov 14, 2017 at 2:31 PM, James Bottomley
<James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org> wrote:
> On Tue, 2017-11-14 at 14:17 -0800, Matthew Garrett wrote:
>> Measured boot has a great deal of value in the sealing of private
>> material, even in the absence of attestation. The way Microsoft make
>> use of PCR7 is a good example of how signatures make this easier -
>> achieving the same goal with a full measurement of the boot chain
>> instead of relying on signature validation results in significantly
>> more fragility.
>
> OK, so I agree that if you have sealed something required for boot (and
> have the capability for resealing it on OS upgrade) you can use
> measurements locally.  However, I don't believe we have any systems
> today in Linux which can do this (we have theoretical ideas about how
> we might do it with LUKS root keys and one day we might actually have
> the infrastructure to make it viable for a standard laptop).

It's used for TPMTOTP, for instance.

> Absent that, secure boot provides a reasonable measure of security
> which works with today's infrastructure.
>
> Note: this doesn't mean I necessarily want signatures everywhere (like
> firmware).  We can sign elements in blobs that provide the effective
> security without needing more granular signatures.

To be clear - I'm arguing in favour of signatures here. Measured boot
is much easier to work with in their presence.
