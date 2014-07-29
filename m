From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [PATCH 1/3] arm64: spin-table: handle unmapped cpu-release-addrs
Date: Tue, 29 Jul 2014 17:20:46 +0200
Message-ID: <2385684.COvj9k7y2z@wuerfel>
References: <1406630950-32432-1-git-send-email-ard.biesheuvel@linaro.org> <1406630950-32432-2-git-send-email-ard.biesheuvel@linaro.org> <1406646945.753.5.camel@deneb.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1406646945.753.5.camel-PDpCo7skNiwAicBL8TP8PQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
Cc: Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, mark.rutland-5wv7dgnIgG8@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Tuesday 29 July 2014 11:15:45 Mark Salter wrote:
> > -
> > -     __flush_dcache_area(release_addr, sizeof(release_addr[0]));
> > +     writeq_relaxed(__pa(secondary_holding_pen), release_addr);
> > +     __flush_dcache_area(release_addr, sizeof(*release_addr));
> 
>        __flush_dcache_area((__force void *)release_addr, ... 
> 
> to avoid sparse warning.
> 

I think it would be cleaner to drop the __iomem annotation and use vmap()
rather than ioremap(). That requires having a 'struct page' though, which
I'm not sure you have.

	Arnd
