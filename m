From: Anders Darander <anders-7UjN0b3lYz2SbKU13Z4Etw@public.gmane.org>
Subject: (unknown)
Date: Tue, 26 Aug 2014 13:45:51 +0200
Message-ID: <20140826114549.GA8332@ad.chargestorm.se>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

To: yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: 
Bcc: 
Subject: Re: Loading initrd above 4G causes freeze on boot
Reply-To: 
In-Reply-To: <CAE9FiQWOp0pGSXhnaTe62zaFe7QodS6BSCKnC8qamjm3qTRRJA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
X-Accept-Language: sv, en, de
X-GPG-Fingerprint: 5AF0 B2E9 78FE 9D75 D110  6F8F 3E31 84D7 920E 938C
X-GPG-Key-Id: 0x920E938C
X-GPG-Keyserver: hkp://keys.gnupg.net
Organization: ChargeStorm AB


> Please check if you can apply attached one. That will keep under 2G at
> first, then try any high address.

That patched solved the issue on my Dell XPS 13 9333, that failed to
unpack initrd using 3.17-rc1 and -rc2.

Thus, 
Acked-by: Anders Darander <anders-7UjN0b3lYz2SbKU13Z4Etw@public.gmane.org>

Cheers,
Anders

-- 
It looks like it's up to me to save our skins.  Get into that garbage chute,
flyboy!
		-- Princess Leia Organa
