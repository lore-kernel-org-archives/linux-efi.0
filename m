From: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH] arm64: mm: Fix memmap to be initialized for the entire
 section
Date: Thu, 27 Oct 2016 17:01:36 +0100
Message-ID: <20161027160136.GD24290@arm.com>
References: <1475747527-32387-1-git-send-email-rrichter@cavium.com>
 <CAKv+Gu-oYzSn_eeqaX3QVFeQjBGkaX-Wh7+oPcQFcXv7J6GOFQ@mail.gmail.com>
 <20161006161114.GH22012@rric.localdomain>
 <20161017185801.GT25086@rric.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161017185801.GT25086-vWBEXY7mpu582hYKe6nXyg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Robert Richter <rric-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Robert Richter <robert.richter-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, David Daney <david.daney-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Hanjun Guo <hanjun.guo-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Hi Robert,

On Mon, Oct 17, 2016 at 08:58:01PM +0200, Robert Richter wrote:
> Mark, Will, any opinion here?

Having looking at this, I'm inclined to agree with you; pfn_valid() is
all about whether the underlying mem_map (struct page *) entry exists,
not about whether the page is mappable or not.

That said, setting the zone for pages representing NOMAP memory feels
like a slippery slope to losing information about them being NOMAP in
the first place and the whole problem getting out-of-hand. Whilst I'm
happy for pfn_valid() to return true (in the sense that we're within
bounds of mem_map etc), I'm less happy that we're also saying that the
struct page contains useful information, such as the zone and the node
information, which is then subsequently used by the NUMA code.

On top of that, pfn_valid is used in other places as a coarse "is this
memory?" check, and will cause things like ioremap to fail whereas it
wouldn't at the moment. It feels to me like NOMAP memory is a new type
of memory where there *is* a struct page, but it shouldn't be used for
anything. I don't think pfn_valid can describe that, given the way it's
currently used, and flipping the logic is just likely to move the problem
elsewhere.

What options do we have for fixing this in the NUMA code?

Will
