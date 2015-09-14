From: Ian Campbell <ian.campbell-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] efi/libstub/fdt: Standardize the names of EFI stub
 parameters
Date: Mon, 14 Sep 2015 11:25:25 +0100
Message-ID: <1442226325.3549.134.camel@citrix.com>
References: <20150910112418.GC29293@leverpostej>
	 <alpine.DEB.2.02.1509101223580.2672@kaball.uk.xensource.com>
	 <20150910121514.GE29293@leverpostej>
	 <alpine.DEB.2.02.1509101429480.2672@kaball.uk.xensource.com>
	 <20150910144938.GI29293@leverpostej>
	 <alpine.DEB.2.02.1509101655020.2672@kaball.uk.xensource.com>
	 <20150910162302.GN29293@leverpostej>
	 <20150911124643.GB4530@olila.local.net-space.pl>
	 <20150911162559.GA8726@leverpostej>
	 <20150912113655.GG4530@olila.local.net-space.pl>
	 <20150914092518.GA10307@leverpostej>
	 <CAKv+Gu9ER1cKvPHobq-wo7ggPesJj4OQ7=aTr24GVpubHvVqjQ@mail.gmail.com>
	 <1442224673.3549.131.camel@citrix.com>
	 <CAKv+Gu_Gh649EwdtodLY9Q28JhqYg8o6RShXXH1ZbxsfYRfi2Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKv+Gu_Gh649EwdtodLY9Q28JhqYg8o6RShXXH1ZbxsfYRfi2Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Daniel Kiper <daniel.kiper-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Konrad Rzeszutek Wilk <konrad.wilk-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Stefano Stabellini <stefano.stabellini-mvvWK6WmYclDPfheJLI6IQ@public.gmane.org>, "leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org" <xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org>, "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "jbeulich-IBi9RG/b67k@public.gmane.org" <jbeulich-IBi9RG/b67k@public.gmane.org>, Shannon Zhao <zhaoshenglong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "julien.grall-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org" <julien.grall-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>, "peter.huangpeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org" <peter.huangpeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, 2015-09-14 at 12:02 +0200, Ard Biesheuvel wrote:
> On 14 September 2015 at 11:57, Ian Campbell <ian.campbell-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org> wrote:
> > >  or SetVirtualAddressMap/ConvertPointer, and
> > 
> > These two are RTS, so in principal it could.
> > 
> > (I'm not sure about ConvertPointer, is it useful for OS kernels, or
> > just
> > for "UEFI components" mentioned at 
> > http://wiki.phoenix.com/wiki/index.php/E
> > FI_RUNTIME_SERVICES#ConvertPointer.28.29 ?)
> > 
> 
> No, there is no point. The stub calls SetVirtualAddressMap, so the
> kernel proper can never call it, since it can only be called once.

I see. And changing this such that it was delayed until the kernel proper
would be a _major_ shift in the policy of separation between the UEFI stub
and the kernel proper. 

> ConvertPointer has little utility outside of the UEFI runtime
> components that are invoked during SetVirtualAddressMap,

That's the impression I was getting too. Thanks for confirming.

>  so I don't see a reason to supply that either.

Ack.

Ian.
