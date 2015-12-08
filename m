From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH v4 01/13] mm/memblock: add MEMBLOCK_NOMAP attribute to
 memblock memory table
Date: Tue, 8 Dec 2015 14:23:41 -0800
Message-ID: <20151208142341.b91ab5728f244a68231e3b87@linux-foundation.org>
References: <1448886507-3216-1-git-send-email-ard.biesheuvel@linaro.org>
	<1448886507-3216-2-git-send-email-ard.biesheuvel@linaro.org>
	<CAKv+Gu9oboT_Lk8heJWRcM=oxRW=EWioVCvZLH7N0YCkfU5tJw@mail.gmail.com>
	<20151208120743.GG19612@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151208120743.GG19612-5wv7dgnIgG8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Alexander Kuleshov <kuleshovmail-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Ryan Harkin <ryan.harkin-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Grant Likely <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Russell King - ARM Linux <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, 8 Dec 2015 12:07:44 +0000 Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org> wrote:

> > I should note that this change should not affect any memblock users
> > that never set the MEMBLOCK_NOMAP flag, but please, if you see any
> > issues beyond 'this may conflict with other stuff we have queued for
> > 4.5', please do let me know.
> 
> Indeed, I can't see that this would cause any issues, but I would really
> like an Ack from one of the MM maintainers before taking this.
> 
> Please could somebody take a look?

It looks OK to me.  Please go ahead and merge it via an arm tree.
