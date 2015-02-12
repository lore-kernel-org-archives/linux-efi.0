From: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH] efi: get_memory_map: add sufficient slack for memory
 descriptors
Date: Thu, 12 Feb 2015 15:16:07 +0000
Message-ID: <20150212151607.GH1522@leverpostej>
References: <1423718659-795-1-git-send-email-ard.biesheuvel@linaro.org>
 <20150212102226.GB1245@leverpostej>
 <CAKv+Gu88vzPpXoSEs1ZSQbO7wsqh7NRSZc=iSpC9D6vzus7f8g@mail.gmail.com>
 <20150212144727.GD4665@codeblueprint.co.uk>
 <CAKv+Gu-NAKASZc4phj5x83mB8Ak4Gy2zYq-a0CDADEOTBD4pXA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu-NAKASZc4phj5x83mB8Ak4Gy2zYq-a0CDADEOTBD4pXA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, Feb 12, 2015 at 02:56:51PM +0000, Ard Biesheuvel wrote:
> On 12 February 2015 at 22:47, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:
> > On Thu, 12 Feb, at 06:39:46PM, Ard Biesheuvel wrote:
> >>
> >> I don't see how doing a single allocation could result in a single
> >> free region to be split into more than 1 occupied region + 2 free
> >> regions.
> >> So no, I don't think it is ...
> >
> > I don't think that's a guarantee we can make, nor is it something we
> > should rely upon.
> >
> > Please explain the user-visible failure that this patch fixes. Does your
> > machine refuse to boot?
> 
> I am running UEFI under QEMU and Xen primarily at the moment, and
> experimenting with various build options in Tianocore, One of the
> options is preallocating and freeing blocks of various memory types,
> in a way that should result in the final number of distinct regions to
> be much lower. It could result however in a free memory region to be
> carved up in three instead of two, and that is a failure I have seen
> occur.

The simple answer is that the machine will fail to boot, beause the
efi_get_memory_map helper will give up after one go, and propagate the
error. The arm-stub will give up when the error is encountered.

> > Why is the 'goto again' loop insufficient in
> > handling this scenario?
> >
> 
> Yes, that should solve it as well, so if you prefer I reinstate that,
> I can respin the patch. There is a theoretical possibility that it
> would take more than just one more iteration, but that is highly
> unlikely and it should still always complete.

Please reinstate the loop. It will make this far less fragile.

Thanks,
Mark.
