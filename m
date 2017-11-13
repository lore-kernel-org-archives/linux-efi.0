From: AKASHI Takahiro <takahiro.akashi-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: arm64 crashkernel fails to boot on acpi-only machines due to
 ACPI regions being no longer mapped as NOMAP
Date: Mon, 13 Nov 2017 18:27:31 +0900
Message-ID: <20171113092730.GA29552@linaro.org>
References: <CACi5LpM_95ebYFguPTyjWk+qHT5rDJVXiYDkNWbszo6Zw41zRA@mail.gmail.com>
 <CACi5LpNV_E9pvhTwLcy6vtEj9qbL1ZEHe-5sv=iiW0k9JxPD1Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CACi5LpNV_E9pvhTwLcy6vtEj9qbL1ZEHe-5sv=iiW0k9JxPD1Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bhupesh Sharma <bhsharma-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, james.morse-5wv7dgnIgG8@public.gmane.org, Bhupesh SHARMA <bhupesh.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Hi,

On Fri, Nov 10, 2017 at 05:41:56PM +0530, Bhupesh Sharma wrote:
> Resent with Akashi's correct email address.
> 
> On Fri, Nov 10, 2017 at 5:39 PM, Bhupesh Sharma <bhsharma-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> > Hi Ard, Akashi
> >
> > I have met an issue on an arm64 board using the latest master branch from Linus.
  (snip)
> >
> > 8. Also, I think now the crashkernel handling changed by
> > e7cd190385d17790cc3eb3821b1094b00aacf325 (arm64: mark reserved
> > memblock regions explicitly in iomem), needs to be changed to handle
> > the change added by Ard to fix this issue on ACPI only machines.
> >
> > I have a dirty hack in place, but I would like to have your opinions
> > about what can be a more concrete fix to this issue (as we mark these
> > regions as System RAM now rather than NOMAP) and I don't have a DTB
> > based machine to test on currently.

I don't know much about acpi reclaim regions,
can you please tell me how your change affects your panic case?

Thanks,
-Takahiro AKASHI


> > Please share your views.
> >
> > Regards,
> > Bhupesh
