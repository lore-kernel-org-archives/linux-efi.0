From: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Subject: Re: Re: [PATCH v2 3/3] efi: Capsule update with user helper interface
Date: Thu, 26 Feb 2015 16:54:58 +0100
Message-ID: <20150226155458.GC3314@pd.tnic>
References: <F54AEECA5E2B9541821D670476DAE19C2B8AC95C@PGSMSX102.gar.corp.intel.com>
 <F54AEECA5E2B9541821D670476DAE19C2B8AC9DD@PGSMSX102.gar.corp.intel.com>
 <20150225114747.GC3226@pd.tnic>
 <CALCETrVk8GJSzOyRu3Jr-72Tp79XzunGg9T-_70ngTPnG4YZqQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALCETrVk8GJSzOyRu3Jr-72Tp79XzunGg9T-_70ngTPnG4YZqQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: "Kweh, Hock Leong" <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sam Protsenko <semen.protsenko-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "Ong, Boon Leong" <boon.leong.ong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, Feb 26, 2015 at 07:30:54AM -0800, Andy Lutomirski wrote:
> How can the error code be propagated?  Would that echo command fail in
> case of error?

Yeah, either that or we can put the error code in the sysfs file which
userspace can cat.

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
--
