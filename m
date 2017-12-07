From: Alan Cox <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>
Subject: Re: Firmware signing -- Re: [PATCH 00/27] security, efi: Add kernel
 lockdown
Date: Thu, 7 Dec 2017 15:32:09 +0000
Message-ID: <20171207153209.5da771a9@alans-desktop>
References: <1509660641.3416.24.camel@linux.vnet.ibm.com>
        <20171107230700.GJ22894@wotan.suse.de>
        <20171108061551.GD7859@linaro.org>
        <20171108194626.GQ22894@wotan.suse.de>
        <20171109014841.GF7859@linaro.org>
        <1510193857.4484.95.camel@linux.vnet.ibm.com>
        <20171109044619.GG7859@linaro.org>
        <20171111023240.2398ca55@alans-desktop>
        <20171113174250.GA22894@wotan.suse.de>
        <20171113210848.4dc344bd@alans-desktop>
        <20171204195155.GU729@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171204195155.GU729-B4tOwbsTzaBolqkO4TVVkw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Luis R. Rodriguez" <mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "AKASHI, Takahiro" <takahiro.akashi-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Jan Blunck <jblunck-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Julia Lawall <julia.lawall-L2FTfq7BK8M@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Marcus Meissner <meissner-l3A5Bk7waGM@public.gmane.org>, Gary Lin <GLin-IBi9RG/b67k@public.gmane.org>, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matthew Garrett <mjg59-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

> I am curious though, is the above notion of having hardware require signed
> firmware an implication brought down by UEFI? If so do you have any pointers
> to where this is stipulated? Or is it just a best practice we assume some
> manufacturers are implementing?

It's a mix of best practice and meeting the so called 'secure boot'
requirements. In the non Linux space exactly the same problems exist in
terms of trusting devices and firmware, building a root of trust and even
more so when producing 'hardened' platforms.

Some stuff isn't - USB devices for example don't get to pee on random
memory so often isn't signed.

Alan
