From: Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: Firmware signing -- Re: [PATCH 00/27] security, efi: Add kernel
 lockdown
Date: Wed, 15 Nov 2017 06:49:57 -0500
Message-ID: <1510746597.3711.268.camel@linux.vnet.ibm.com>
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
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171114205014.GJ729-B4tOwbsTzaBolqkO4TVVkw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Luis R. Rodriguez" <mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Berg <johannes-cdvu00un1VgdHxzADdlk8Q@public.gmane.org>
Cc: Matthew Garrett <mjg59-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alan Cox <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, "AKASHI, Takahiro" <takahiro.akashi-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Jan Blunck <jblunck-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Julia Lawall <julia.lawall-L2FTfq7BK8M@public.gmane.org>, Marcus Meissner <meissner-l3A5Bk7waGM@public.gmane.org>, Gary Lin <GLin-IBi9RG/b67k@public.gmane.org>, LSM List <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-efi <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, 2017-11-14 at 21:50 +0100, Luis R. Rodriguez wrote:

> Johannes made cfg80211 recently just use request_firmware() now via commit on
> linux-next 90a53e4432 ("cfg80211: implement regdb signature checking") [0] as
> he got tired of waiting firmware signing, but note he implemented a signature
> checking on its own so he open codes verify_pkcs7_signature() after the
> request_firmware() call. If we are happy to live with this, then so be it.
> 
> [0] https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/commit/?id=90a53e4432b12288316efaa5f308adafb8d304b0

Johannes was tired of waiting?  Commit 5a9196d "ima: add support for
measuring and appraising firmware" has been in the kernel since linux-
3.17.

The original firmware hook for verifying firmware signatures were
replaced with the common LSM pre and post kernel_read_file() hooks
in linux-4.6.y.

Even if you wanted to support firmware signature verification without
IMA-appraisal, it should be using the LSM hooks.

Mimi
