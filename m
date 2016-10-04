From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH 1/3] efi/efi_test: use memdup_user() as a cleanup
Date: Tue, 4 Oct 2016 22:37:43 +0100
Message-ID: <20161004213743.GV16071@codeblueprint.co.uk>
References: <1474859691-8574-1-git-send-email-ivan.hu@canonical.com>
 <1474859691-8574-2-git-send-email-ivan.hu@canonical.com>
 <20161003201718.GL16071@codeblueprint.co.uk>
 <3fb6d9fa-b554-509b-fc59-d75340017589@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <3fb6d9fa-b554-509b-fc59-d75340017589-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: ivanhu <ivan.hu-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, 04 Oct, at 11:04:56AM, ivanhu wrote:
> Hi Matt,
> 
> The warning message is from Kbuild test robot,
> 
> https://chromium.googlesource.com/linux-fpga-chameleon/+/fpga-chameleon-4.2/scripts/coccinelle/api/memdup_user.cocci,
> 
> 
> and  I believe it tries to persuade us to use memdup_user instead of kmalloc
> and copy_form_user,
> 
> With this new function, we don't have to write 'len' twice, which can lead
> to typos/mistakes.
> It also produces smaller code and kernel text.
> 
> http://lkml.iu.edu/hypermail/linux/kernel/0903.0/02349.html

Right, I understand all that. My question was specifically about the
following sentence from your patch,

> This is a little bit restricted to reduce false positives

What restriction that reduces false positives are you referring to?
