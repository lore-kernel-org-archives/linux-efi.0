From: Matthew Garrett <mjg59-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: Firmware signing -- Re: [PATCH 00/27] security, efi: Add kernel lockdown
Date: Tue, 14 Nov 2017 11:58:20 -0800
Message-ID: <CACdnJuvP=0AHGtfGJ5+cT+kHRy3fU4BLjwkvzP0rLO6q5ejAQQ@mail.gmail.com>
References: <150842463163.7923.11081723749106843698.stgit@warthog.procyon.org.uk>
 <14219.1509660259@warthog.procyon.org.uk> <1509660641.3416.24.camel@linux.vnet.ibm.com>
 <20171107230700.GJ22894@wotan.suse.de> <20171108061551.GD7859@linaro.org>
 <20171108194626.GQ22894@wotan.suse.de> <20171109014841.GF7859@linaro.org>
 <1510193857.4484.95.camel@linux.vnet.ibm.com> <20171109044619.GG7859@linaro.org>
 <20171111023240.2398ca55@alans-desktop> <20171113174250.GA22894@wotan.suse.de>
 <20171113210848.4dc344bd@alans-desktop> <454.1510609487@warthog.procyon.org.uk>
 <CA+55aFzrK29hbxoKs3GsvVUY4_uR7aBgZv2eeVyVq7MzfATY3w@mail.gmail.com>
 <1510662098.3711.139.camel@linux.vnet.ibm.com> <CA+55aFzvuvqOfsJ9arzcc1QbTGs+U-TsNmsyem9UAVVQC8YkZQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CA+55aFzvuvqOfsJ9arzcc1QbTGs+U-TsNmsyem9UAVVQC8YkZQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alan Cox <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, "Luis R. Rodriguez" <mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "AKASHI, Takahiro" <takahiro.akashi-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Jan Blunck <jblunck-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Julia Lawall <julia.lawall-L2FTfq7BK8M@public.gmane.org>, Marcus Meissner <meissner-l3A5Bk7waGM@public.gmane.org>, Gary Lin <GLin-IBi9RG/b67k@public.gmane.org>, LSM List <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-efi <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, Nov 14, 2017 at 9:34 AM, Linus Torvalds
<torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:
> It's this insane "firmware is special" that I disagree with. It's not
> special at all.

Our ability to determine that userland hasn't been tampered with
depends on the kernel being trustworthy. If userland can upload
arbitrary firmware to DMA-capable devices then we can no longer trust
the kernel. So yes, firmware is special.

Here's an example: we have a signed initramfs that's loaded by a
signed bootloader. That initramfs sets up a trustworthy audit chain
and loads an LSM policy that prevents the rest of userland from
interfering with it. From that point on, we don't care about the rest
of userland being signed - we know it can't interfere with us, but we
can reliably inspect what it's doing. Even an offline attack can't do
any damage, since the audit code is still signed. However, the
LSM-imposed boundary depends on the kernel being trustworthy. If an
attacker can replace the firmware that's uploaded to a device that can
do arbitrary DMA then they can tamper with the supposedly trustworthy
audit code and provide false information. Being able to tamper with
the contents of /usr/bin/* doesn't give them that.
