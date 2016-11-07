From: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
Subject: Re: [PATCH v3 3/3] thunderbolt: Use Device ROM retrieved from EFI
Date: Mon, 7 Nov 2016 12:28:17 +0100
Message-ID: <20161107112817.GA6428@wunner.de>
References: <cover.1478145888.git.lukas@wunner.de>
 <776fcc302f58628d1a122ba929751760c554cbfc.1478145888.git.lukas@wunner.de>
 <CAMxnaaVfT+gxgq4q76Jz8gY_OfaBr_ToXQ8f-bYGwjcd2eS=9A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAMxnaaVfT+gxgq4q76Jz8gY_OfaBr_ToXQ8f-bYGwjcd2eS=9A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andreas Noever <andreas.noever-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, Nov 07, 2016 at 12:02:32AM +0100, Andreas Noever wrote:
> On Thu, Nov 3, 2016 at 11:18 AM, Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org> wrote:
> > +err:
> > +       kfree(sw->drom);
> 
> Please also set sw->drom to NULL here. Otherwise sw->drom will be
> freed again in the error path of tb_switch_alloc or in tb_switch_free.

Eeeeeeeeeeeek!  Thanks for spotting this, and thanks for the ack.


> btw: any success in decoding the path crumbs property?

TBH I haven't had time to look yet. :-(

Best regards,

Lukas
