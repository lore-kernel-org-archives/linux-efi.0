From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: Firmware signing -- Re: [PATCH 00/27] security, efi: Add kernel lockdown
Date: Tue, 14 Nov 2017 12:18:54 -0800
Message-ID: <CA+55aFxeLwgwxh2iJTf6Dz0T_a_TZfTdhBw5TkcSsCmjt2N5pw@mail.gmail.com>
References: <150842463163.7923.11081723749106843698.stgit@warthog.procyon.org.uk>
 <14219.1509660259@warthog.procyon.org.uk> <1509660641.3416.24.camel@linux.vnet.ibm.com>
 <20171107230700.GJ22894@wotan.suse.de> <20171108061551.GD7859@linaro.org>
 <20171108194626.GQ22894@wotan.suse.de> <20171109014841.GF7859@linaro.org>
 <1510193857.4484.95.camel@linux.vnet.ibm.com> <20171109044619.GG7859@linaro.org>
 <20171111023240.2398ca55@alans-desktop> <20171113174250.GA22894@wotan.suse.de>
 <20171113210848.4dc344bd@alans-desktop> <454.1510609487@warthog.procyon.org.uk>
 <CA+55aFzrK29hbxoKs3GsvVUY4_uR7aBgZv2eeVyVq7MzfATY3w@mail.gmail.com>
 <1510662098.3711.139.camel@linux.vnet.ibm.com> <CA+55aFzvuvqOfsJ9arzcc1QbTGs+U-TsNmsyem9UAVVQC8YkZQ@mail.gmail.com>
 <CACdnJuvP=0AHGtfGJ5+cT+kHRy3fU4BLjwkvzP0rLO6q5ejAQQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CACdnJuvP=0AHGtfGJ5+cT+kHRy3fU4BLjwkvzP0rLO6q5ejAQQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <mjg59-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alan Cox <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, "Luis R. Rodriguez" <mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "AKASHI, Takahiro" <takahiro.akashi-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Jan Blunck <jblunck-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Julia Lawall <julia.lawall-L2FTfq7BK8M@public.gmane.org>, Marcus Meissner <meissner-l3A5Bk7waGM@public.gmane.org>, Gary Lin <GLin-IBi9RG/b67k@public.gmane.org>, LSM List <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-efi <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, Nov 14, 2017 at 11:58 AM, Matthew Garrett <mjg59-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>
> Our ability to determine that userland hasn't been tampered with
> depends on the kernel being trustworthy. If userland can upload
> arbitrary firmware to DMA-capable devices then we can no longer trust
> the kernel. So yes, firmware is special.

You're ignoring the whole "firmware is already signed by the hardware
manufacturer and we don't even have access to it" part.

You're also ignoring the fact that we can't trust firmware _anyway_,
as Alan pointed out.

Seriously. Some of the worst security issues have been with exactly
the fact that we can't trust the hardware to begin with, where
firmware/hardware combinations are not trusted to begin with.

This is all theoretical security masturbation. The _real_ attacks have
been elsewhere.

               Linus
