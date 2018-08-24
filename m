From: Dave Young <dyoung@redhat.com>
Subject: Re: [PATCH] x86, kdump: Fix efi=noruntime NULL pointer dereference
Date: Fri, 24 Aug 2018 14:49:38 +0800
Message-ID: <20180824064938.GA5316@dhcp-128-65.nay.redhat.com>
References: <1533737025.4936.3.camel@gmx.de>
 <20180809042153.GA4377@dhcp-128-65.nay.redhat.com>
 <1533800010.5087.71.camel@gmx.de>
 <20180809091333.GA8008@dhcp-128-65.nay.redhat.com>
 <CAKv+Gu8KKwNkUdx7tSxEosRvydxmQ2yaasHRJn_LcHPs7p2UYQ@mail.gmail.com>
 <20180822102310.GA19827@dhcp-128-65.nay.redhat.com>
 <20180823035705.GA5743@dhcp-128-65.nay.redhat.com>
 <1535086138.4661.9.camel@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1535086138.4661.9.camel@gmx.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Galbraith <efault@gmx.de>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, Baoquan He <bhe@redhat.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, lkml <linux-kernel@vger.kernel.org>, Kexec Mailing List <kexec@lists.infradead.org>, linux-efi <linux-efi@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On 08/24/18 at 06:48am, Mike Galbraith wrote:
> On Thu, 2018-08-23 at 11:57 +0800, Dave Young wrote:
> > 
> > Mike, since we are going this way, I'm working on a kexec code cleanup,
> > but it needs careful testing so still need some time.
> > 
> > Can you help test below efi fix and provide you tested-by if it works?
> 
> While it averts the efi=noruntime oops on kdump kernel load, the kernel
> does not boot when kdump is triggered.  Bailing in setup_efi_state() in
> addition restores functionality.

Yes, that is expected.  Kexec code need fix and cleanup in other
patches.

Thanks
Dave
