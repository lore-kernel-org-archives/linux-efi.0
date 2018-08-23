From: Mike Galbraith <efault-Mmb7MZpHnFY@public.gmane.org>
Subject: Re: [PATCH] x86, kdump: Fix efi=noruntime NULL pointer dereference
Date: Thu, 23 Aug 2018 06:08:01 +0200
Message-ID: <1534997281.5153.3.camel@gmx.de>
References: <1533737025.4936.3.camel@gmx.de>
 <20180809042153.GA4377@dhcp-128-65.nay.redhat.com>
 <1533800010.5087.71.camel@gmx.de>
 <20180809091333.GA8008@dhcp-128-65.nay.redhat.com>
 <CAKv+Gu8KKwNkUdx7tSxEosRvydxmQ2yaasHRJn_LcHPs7p2UYQ@mail.gmail.com>
 <20180822102310.GA19827@dhcp-128-65.nay.redhat.com>
 <20180823035705.GA5743@dhcp-128-65.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kexec-bounces+glkk-kexec=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
In-Reply-To: <20180823035705.GA5743-0VdLhd/A9Pl+NNSt+8eSiB/sF2h8X+2i0E9HWUfgJXw@public.gmane.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/kexec>,
 <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/kexec/>
List-Post: <mailto:kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Help: <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/kexec>,
 <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=subscribe>
Sender: "kexec" <kexec-bounces-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Errors-To: kexec-bounces+glkk-kexec=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
To: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, linux-efi <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kexec Mailing List <kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Baoquan He <bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, 2018-08-23 at 11:57 +0800, Dave Young wrote:
> 
> Mike, since we are going this way, I'm working on a kexec code cleanup,
> but it needs careful testing so still need some time.
> 
> Can you help test below efi fix and provide you tested-by if it works?

Sure.  I'm buried to the eyebrows atm (why no patchlet has appeared in
your inbox), but I'll get to it.

	-Mike
